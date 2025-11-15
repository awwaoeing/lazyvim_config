-- Snacks.nvim 配置
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- 使用函数合并配置，确保不覆盖默认值
    opts.terminal = opts.terminal or {}
    opts.terminal.win = opts.terminal.win or {}

    -- 终端窗口位置和大小配置
    opts.terminal.win.position = "right" -- 在右侧打开终端
    opts.terminal.win.width = 0.45 -- 宽度为窗口的 40%（可调整）
    opts.terminal.win.height = 0.8 -- 高度为窗口的 80%

    -- 自动调整终端大小以填充窗口
    -- 当窗口大小改变时，终端会自动调整列数和行数
    opts.terminal.win.border = "rounded" -- 圆角边框
    opts.terminal.win.relative = "editor" -- 相对于编辑器窗口

    -- 启用终端自动调整（默认已启用）
    -- Neovim 会自动根据窗口大小调整终端的 columns 和 lines

    return opts
  end,
}
