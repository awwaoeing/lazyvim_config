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
  -- 确保这个配置在 LazyVim Python extras 之后加载
  {
    "neovim/nvim-lspconfig",
    -- 设置高优先级,确保在 LazyVim extras 之后执行
    priority = 1,
    -- 🔧 在插件加载前设置全局诊断配置
    init = function()
      -- 让诊断浮动窗口可以聚焦，方便复制内容
      vim.diagnostic.config({
        float = {
          focusable = true,
          border = "rounded",
          source = "always",
        },
      })
    end,
    opts = function(_, opts)
      -- 确保 servers 表存在
      opts.servers = opts.servers or {}

      -- 我们的自定义 Pyright 配置
      local my_pyright_config = {
        -- 🔧 设置项目根路径检测规则
        root_dir = function(fname)
          -- 确保 fname 是有效的字符串
          if not fname or type(fname) ~= "string" or fname == "" then
            return nil -- 返回 nil 让 lspconfig 使用默认逻辑
          end

          local util = require("lspconfig.util")
          -- 优先查找配置文件，如果没有配置文件，使用 git 根路径或当前目录
          return util.root_pattern("pyrightconfig.json", "pyproject.toml", "setup.py", "requirements.txt", ".git")(
            fname
          ) or vim.fs.dirname(fname)
        end,
        -- 配置 LSP 设置
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- 🔧 增强自定义类解析
              autoImportCompletions = true, -- 自动导入补全
              diagnosticMode = "openFilesOnly", -- 只分析打开的文件，提升性能
              stubPath = "typings", -- 自定义 stub 文件路径
              -- 🔧 添加额外的类型检查路径（解决同目录跳转问题）
              extraPaths = { "." }, -- 将项目根目录添加到搜索路径

              -- ML 库友好：减少误报
              diagnosticSeverityOverrides = {
                reportMissingTypeStubs = "none", -- 忽略缺失类型存根
                reportUnknownMemberType = "none", -- 忽略未知成员类型
                reportUnknownVariableType = "none", -- 忽略未知变量类型
                reportUnknownArgumentType = "none", -- 忽略未知参数类型
                reportUnknownParameterType = "none", -- 忽略未知参数类型
                reportOptionalMemberAccess = "none", -- 忽略访问可能为 None 的对象属性
                reportOptionalCall = "none", -- 忽略调用可能为 None 的对象
                reportArgumentType = "none", -- 忽略参数类型不匹配（PyTorch Tensor 类型转换）
                reportMissingImports = "warning", -- 导入缺失显示警告
                reportUndefinedVariable = "warning", -- 未定义变量显示警告
              },

              inlayHints = {
                variableTypes = false,
                functionReturnTypes = true,
                callArgumentNames = true,
                pytestParameters = true,
              },
            },
          },
        },
        -- 🔧 动态设置 Python 路径（支持切换项目和虚拟环境）
        before_init = function(_, config)
          -- 每次初始化 LSP 时重新检测 Python 路径
          config.settings.python.pythonPath = get_python_path()
        end,
        -- 🔧 增强 LSP 客户端能力
        on_attach = function(client, bufnr)
          -- 启用语义高亮（可选）
          if client.server_capabilities.documentSymbolProvider then
            -- 安全地尝试加载 nvim-navic，如果不存在则跳过
            local has_navic, navic = pcall(require, "nvim-navic")
            if has_navic then
              navic.attach(client, bufnr)
            end
          end

          -- 🟢 新增：确保 Inlay Hints 在 UI 上启用 (仅支持 Neovim 0.10+)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          -- 🔧 键位映射：<leader>cd 打开可聚焦的诊断窗口，方便复制错误信息
          vim.keymap.set("n", "<leader>cd", function()
            vim.diagnostic.open_float({ focusable = true, border = "rounded", source = "always" })
          end, { buffer = bufnr, desc = "显示诊断信息（可复制）" })

          -- 🔧 键位映射：<leader>le 切换 LSP 启用/禁用（刷题时临时禁用）
          vim.keymap.set("n", "<leader>le", function()
            vim.cmd("LspStop")
            vim.notify("LSP 已禁用", vim.log.levels.INFO)
          end, { buffer = bufnr, desc = "禁用 LSP" })

          -- 🔧 键位映射：<leader>ls 启用 LSP
          vim.keymap.set("n", "<leader>ls", function()
            vim.cmd("LspStart")
            vim.notify("LSP 已启用", vim.log.levels.INFO)
          end, { buffer = bufnr, desc = "启用 LSP" })
        end,
      }

      -- 使用深度合并,我们的配置在后面,会覆盖 LazyVim 的配置
      opts.servers.pyright = vim.tbl_deep_extend(
        "force",
        opts.servers.pyright or {}, -- LazyVim 的基础配置
        my_pyright_config -- 我们的自定义配置(优先)
      )

      -- 禁用其他 Python LSP
      opts.servers.pyre = false
      opts.servers.pyrefly = false

      -- 确保 setup 表存在
      opts.setup = opts.setup or {}

      -- 添加 setup 回调来确保配置生效
      opts.setup.pyright = function(_, server_opts)
        -- 在这里强制设置我们的配置
        require("lspconfig").pyright.setup(server_opts)
      end

      -- 返回修改后的 opts
      return opts
    end,
  },
}
