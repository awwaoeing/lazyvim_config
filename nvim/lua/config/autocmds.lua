-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ============================================================================
-- 从 .vimrc 迁移的自动命令
-- ============================================================================

local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- 终端模式自动切换配置
-- ============================================================================

-- 检测并返回虚拟环境激活脚本路径
local function get_venv_activate_path()
  local cwd = vim.fn.getcwd()
  local venv_names = { ".venv", "venv" } -- uv 默认使用 .venv

  for _, name in ipairs(venv_names) do
    local activate_path = cwd .. "/" .. name .. "/bin/activate"
    if vim.fn.filereadable(activate_path) == 1 then
      return activate_path
    end
  end

  return nil
end

-- 1. 终端打开时自动激活虚拟环境并停留在 normal 模式
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- 检测虚拟环境
    local activate_path = get_venv_activate_path()

    if activate_path then
      -- 自动发送激活命令到终端
      local cmd = "source " .. activate_path .. "\n"
      vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd)
    end

    -- 先停留在 normal 模式
    vim.schedule(function()
      vim.cmd("stopinsert") -- 退出插入模式，进入 normal 模式
    end)
  end,
  desc = "Auto-activate venv and enter terminal in normal mode when opened",
})

-- 2. 切换到终端缓冲区时保持 normal 模式，不自动进入 terminal 模式
-- 注意：此事件会与输入法切换的 BufEnter 冲突，已移除
-- 输入法切换的 BufEnter 会在后面的输入法自动切换部分定义

-- ============================================================================

-- ============================================================================
-- 重新打开文件时恢复光标位置
-- ============================================================================

autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("restore_cursor_position", { clear = true }),
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Restore cursor position when reopening file",
})

-- ============================================================================
-- 禁用自动注释
-- ============================================================================

autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable_auto_comment", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
  desc = "Disable automatic comment continuation",
})

-- ============================================================================
-- 输入法自动切换（终端和编辑模式）- 使用 im-select 工具
-- ============================================================================

-- 仅在 macOS 上启用
if vim.fn.has("mac") == 1 then
  -- im-select 工具路径
  local im_select = vim.fn.expand("~/.local/bin/im-select")

  -- 检查 im-select 是否存在
  if vim.fn.executable(im_select) == 1 then
    -- 输入法标识符（运行 im-select 查看当前输入法）
    local en_im = "com.apple.keylayout.ABC" -- ABC 英文输入法
    local zh_im = "com.apple.inputmethod.SCIM.ITABC" -- 简体拼音

    -- 切换到英文输入法
    local function switch_to_english()
      vim.fn.system({ im_select, en_im })
    end

    -- 切换到中文输入法
    local function switch_to_chinese()
      vim.fn.system({ im_select, zh_im })
    end

    -- 创建输入法切换的 autocmd 组
    local terminal_im_group = vim.api.nvim_create_augroup("terminal_input_method", { clear = true })

    -- 进入终端缓冲区时切换到中文输入法，并保持 normal 模式
    autocmd("BufEnter", {
      group = terminal_im_group,
      pattern = "term://*",
      callback = function()
        -- 确保是终端缓冲区
        if vim.bo.buftype == "terminal" then
          -- 如果当前在 terminal 模式，则退出到 normal 模式
          if vim.fn.mode() == "t" then
            vim.cmd("stopinsert")
          end
          -- 切换到中文输入法
          switch_to_chinese()
        end
      end,
      desc = "Switch to Chinese input method and normal mode when entering terminal",
    })

    -- 离开终端缓冲区时切换回英文输入法
    autocmd("BufLeave", {
      group = terminal_im_group,
      pattern = "term://*",
      callback = function()
        if vim.bo.buftype == "terminal" then
          switch_to_english()
        end
      end,
      desc = "Switch to English input method when leaving terminal buffer",
    })

    -- 离开插入模式时切换到英文输入法（在编辑文件时）
    autocmd("InsertLeave", {
      group = vim.api.nvim_create_augroup("insert_input_method", { clear = true }),
      pattern = "*",
      callback = function()
        -- 仅在非终端缓冲区中切换
        if vim.bo.buftype ~= "terminal" then
          switch_to_english()
        end
      end,
      desc = "Switch to English input method when leaving insert mode",
    })
  else
    vim.notify("im-select 未安装，输入法自动切换功能已禁用", vim.log.levels.WARN)
  end
end
