-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable Nerd Font support for icons
vim.g.have_nerd_font = true

-- ============================================================================
-- 从 .vimrc 迁移的配置
-- ============================================================================

-- 编码设置
vim.opt.encoding = "utf-8"

-- 行号设置
vim.opt.number = true -- 显示行号
vim.opt.relativenumber = false -- 不使用相对行号（显示绝对行号）
vim.opt.numberwidth = 1 -- 行号列最小宽度（1 是最紧凑）

-- 自定义状态列,移除行号后的空格
vim.opt.statuscolumn = "%s%l " -- 最少空格

-- 标记列设置（影响行号与代码之间的间距）
-- "yes" = 始终显示，占用 2 列宽度
-- "no" = 不显示（不推荐，会隐藏 LSP 诊断和 Git 标记）
-- "auto" = 仅在需要时显示（推荐，平衡空间和功能）
-- "number" = 与行号列合并（最紧凑，但行号列会变宽）
vim.opt.signcolumn = "yes" -- 仅在需要时显示标记列，减少空间占用

-- 光标和视觉效果
vim.opt.cursorline = true -- 高亮当前行
vim.opt.showmatch = true -- 显示匹配的括号

-- 鼠标支持
vim.opt.mouse = "a" -- 启用鼠标

-- 缩进设置jk
vim.opt.tabstop = 4 -- Tab 键宽度为 4 个空格
vim.opt.shiftwidth = 4 -- 自动缩进宽度为 4 个空格
vim.opt.autoindent = true -- 启用自动缩进

-- 自动读取文件变化
vim.opt.autoread = true

-- 补全设置
vim.opt.completeopt = "longest,menu" -- 补全菜单行为
vim.opt.wildmenu = true -- 命令行补全增强模式

-- 搜索设置
vim.opt.ignorecase = true -- 搜索时忽略大小写
vim.opt.smartcase = true -- 如果包含大写字母则区分大小写
vim.opt.hlsearch = true -- 高亮搜索结果

-- 状态栏设置
-- vim.opt.laststatus = 0 -- .vimrc 中设置为 0，但 LazyVim 需要状态栏，所以不迁移这个

-- 代码折叠设置
vim.opt.foldmethod = "marker" -- 使用标记折叠
vim.opt.foldmarker = "{{{,}}}" -- 折叠标记

-- 真彩色支持
vim.opt.termguicolors = true -- 启用 24 位真彩色

-- 持久化撤销
vim.opt.undofile = true -- 启用持久化撤销历史
vim.opt.undodir = vim.fn.expand("~/.undodir") -- 撤销文件存储目录

-- 注意：pastetoggle 在 Neovim 中不支持
-- 粘贴模式切换通过 F10 键位映射实现（见 keymaps.lua）

-- ============================================================================
-- Python 环境配置（用于 Jupyter-vim 等插件）
-- ============================================================================

-- 检测并设置 Python3 解释器路径
-- 优先使用 Conda 环境，否则使用系统默认
local function setup_python_host()
  -- 检查是否在 Conda 环境中
  local conda_prefix = os.getenv("CONDA_PREFIX")
  if conda_prefix then
    -- 使用 Conda 环境的 Python
    local conda_python = conda_prefix .. "/bin/python3"
    if vim.fn.executable(conda_python) == 1 then
      vim.g.python3_host_prog = conda_python
      return
    end
  end

  -- 回退到系统默认 Python3
  local system_python = vim.fn.exepath("python3")
  if system_python ~= "" then
    vim.g.python3_host_prog = system_python
  end
end

setup_python_host()
