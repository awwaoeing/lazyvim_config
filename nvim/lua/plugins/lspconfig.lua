-- ~/.config/nvim/lua/plugins/lspconfig.lua
-- LSP (Language Server Protocol) 配置文件
-- 作用：配置 Python 语言服务器 (Pyright)，提供代码补全、跳转、诊断等功能

-- 禁用全局 inlay hints（内联类型提示）
-- 注释掉是因为下面通过 settings 更细粒度控制
--vim.lsp.handlers["textDocument/inlayHint"] = function() end

-- ============================================================================
-- 自动检测 Python 虚拟环境
-- ============================================================================
-- 功能：按优先级自动查找并返回当前应该使用的 Python 解释器路径
-- 重要性：确保 LSP 能找到项目中安装的第三方库（torch, transformers 等）
-- 使用场景：shell 默认激活 conda，但项目中优先使用 uv 虚拟环境
local function get_python_path()
  -- 优先级 1: 项目本地虚拟环境（uv venv 创建的 .venv）
  -- 检查当前项目目录下的虚拟环境（未激活但存在）
  -- 适用场景：uv venv 创建的 .venv，即使 shell 中有 conda 环境也优先使用项目环境
  local cwd = vim.fn.getcwd()
  local venv_names = { ".venv", "venv" } -- uv 默认使用 .venv
  for _, name in ipairs(venv_names) do
    local local_python = cwd .. "/" .. name .. "/bin/python"
    if vim.fn.executable(local_python) == 1 then
      return local_python
    end
  end

  -- 优先级 2: VIRTUAL_ENV 环境变量
  -- 检查 VIRTUAL_ENV 环境变量（uv run 或手动激活虚拟环境后设置）
  -- 适用场景：uv run python 或 source .venv/bin/activate
  local venv = vim.env.VIRTUAL_ENV
  if venv then
    local venv_python = venv .. "/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end

  -- 优先级 3: Conda 环境（回退到 shell 默认环境）
  -- 检查 CONDA_PREFIX 环境变量（conda activate 后会设置）
  -- 适用场景：shell 自动激活的 conda 环境，作为后备
  local conda_prefix = vim.env.CONDA_PREFIX
  if conda_prefix then
    local conda_python = conda_prefix .. "/bin/python"
    -- vim.fn.executable() 返回 1 表示可执行文件存在
    if vim.fn.executable(conda_python) == 1 then
      return conda_python
    end
  end

  -- 优先级 4: 系统 Python（最终回退方案）
  -- vim.fn.exepath() 在 PATH 中查找可执行文件
  -- 如果所有虚拟环境都找不到，使用系统默认 Python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- 配置各语言服务器
      servers = {
        pyright = {
          -- 开启 Pyright
          enabled = true,
          -- 配置 LSP 设置
          settings = {
            python = {
              -- 自动检测并使用虚拟环境的 Python
              pythonPath = get_python_path(),

              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,

                -- ML 库友好：减少误报
                diagnosticSeverityOverrides = {
                  reportMissingTypeStubs = "none", -- 忽略缺失类型存根
                  reportUnknownMemberType = "none", -- 忽略未知成员类型
                  reportUnknownVariableType = "none", -- 忽略未知变量类型
                },

                -- 关闭所有 inlay hints
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = false,
                  callArgumentNames = true,
                  pytestParameters = true,
                },
              },
            },
          },
          --          -- 安全关闭 inlay hints
          --          on_attach = function(client, bufnr)
          --            if vim.lsp.buf.inlay_hint then
          --              vim.lsp.buf.inlay_hint(bufnr, false)
          --            end
          --          end,
        },
        --        -- 如果有其他 Python LSP，可按需添加
        pyre = false,
        pyrefly = false,
      },
      --      -- LSP 服务器的通用设置
      --      setup = {
      --        -- 为所有服务器配置函数签名处理器
      --        ["*"] = function(server, opts)
      --          opts.handlers = opts.handlers or {}
      --          -- 禁用自动显示函数签名提示
      --          opts.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { silent = true })
      --        end,
      --      },
    },
  },
}
