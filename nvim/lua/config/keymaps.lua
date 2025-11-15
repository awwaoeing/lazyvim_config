-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================================================
-- 从 .vimrc 迁移的键位映射
-- ============================================================================

local map = vim.keymap.set

-- ============================================================================
-- 模式切换快捷键
-- ============================================================================

-- 插入模式快速退出: jk -> <Esc>
map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- 可视模式快速退出: nn -> <Esc>
map("v", "nn", "<Esc>", { desc = "Exit visual mode with nn" })
-- ============================================================================

-- normal 模式下 Ctrl+n 翻页向下
vim.api.nvim_set_keymap("n", "<C-n>", "<C-d>", { noremap = true, silent = true })

-- 高亮光标下词
vim.keymap.set(
  "n",
  "<leader>#",
  [[:let @/ = '\<' .. expand('<cword>') .. '\>'<CR>:set hlsearch<CR>]],
  { noremap = true, silent = true }
)

-- ============================================================================
-- 光标移动增强
-- ============================================================================

-- Normal 模式：H 跳转到行首，L 跳转到行尾
map("n", "H", "0", { desc = "Go to beginning of line" })
map("n", "L", "$", { desc = "Go to end of line" })

-- Visual 模式：Shift+H 跳转到行首，Shift+L 跳转到行尾
map("v", "<S-h>", "0", { desc = "Go to beginning of line (visual)" })
map("v", "<S-l>", "$", { desc = "Go to end of line (visual)" })

-- ============================================================================
-- 代码折叠快捷键
-- ============================================================================

-- fo: 切换当前折叠的打开/关闭
map("n", "fo", "za", { desc = "Toggle fold under cursor" })

-- ff: 打开所有折叠
map("n", "ff", "zR", { desc = "Open all folds" })

-- FF: 关闭所有折叠
map("n", "FF", "zM", { desc = "Close all folds" })

-- ============================================================================
-- 快速保存和退出
-- ============================================================================

-- Space Space: 保存并退出
map("n", "<Space><Space>", ":wq<CR>", { desc = "Save and quit" })

-- ============================================================================
-- 粘贴模式切换
-- ============================================================================

-- F10: 切换粘贴模式（方便从系统剪贴板粘贴）
map("n", "<F10>", ":set paste!<CR>", { desc = "Toggle paste mode" })
map("i", "<F10>", "<C-o>:set paste!<CR>", { desc = "Toggle paste mode (insert)" })

-- ============================================================================
-- 窗口切换（LazyVim 已经有 <C-h/j/k/l>，这里保留兼容性）
-- ============================================================================

-- 注意：LazyVim 默认已经配置了 <C-h/j/k/l> 用于窗口切换
-- 这里只是确保与 .vimrc 的行为一致
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ============================================================================
-- 终端快捷键
-- ============================================================================

-- 在底部打开终端（作为替代方案）
map("n", "<leader>tb", function()
  vim.cmd("split")
  vim.cmd("wincmd j") -- 移动到底部窗口
  -- 设置高度为总高度的 30%
  local height = math.floor(vim.o.lines * 0.2)
  vim.cmd("resize " .. height)
  vim.cmd("terminal")
  -- 不自动进入插入模式，让 TermOpen 自动命令处理
end, { desc = "Open terminal at bottom" })

-- 终端模式下快速退出到 normal 模式
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode with jk" })

-- ============================================================================
-- 插件相关快捷键（将在插件配置中设置）
-- ============================================================================

-- <C-t>: NERDTree/Neo-tree 切换 - 在 neo-tree.lua 中配置
-- tt: Undotree 切换 - 在 undotree.lua 中配置
-- K, gd, gr: LSP 快捷键 - 在 lsp.lua 中配置
