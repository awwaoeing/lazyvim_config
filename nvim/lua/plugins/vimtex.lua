return {
  "lervag/vimtex",
  lazy = false, -- 不延迟加载，确保 VimTeX 能正确检测 .tex 文件
  ft = { "tex", "plaintex", "bib" }, -- 在这些文件类型中启用
  init = function()
    -- VimTeX 配置变量需要在插件加载前设置

    -- PDF 查看器配置 (macOS 使用 Skim)
    vim.g.vimtex_view_method = "skim" -- macOS: 'skim', Linux: 'zathura', Windows: 'sumatrapdf'

    -- 编译器设置
    vim.g.vimtex_compiler_method = "latexmk" -- 使用 latexmk 编译
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "", -- 编译输出目录，空字符串表示与源文件相同目录
      callback = 1,
      continuous = 1, -- 持续编译模式
      executable = "latexmk",
      options = {
        "-pdf", -- 生成 PDF
        "-verbose",
        "-file-line-error",
        "-synctex=1", -- 启用同步（用于正反向搜索）
        "-interaction=nonstopmode",
      },
    }

    -- 折叠设置
    vim.g.vimtex_fold_enabled = 1 -- 启用代码折叠

    -- 快速修复自动打开设置
    vim.g.vimtex_quickfix_mode = 0 -- 禁用自动打开 quickfix 窗口（编译错误时）

    -- 语法高亮
    vim.g.vimtex_syntax_enabled = 1

    -- TOC（目录）设置
    vim.g.vimtex_toc_config = {
      name = "TOC",
      layers = { "content", "todo", "include" },
      split_width = 30,
      todo_sorted = 0,
      show_help = 1,
      show_numbers = 1,
    }

    -- 隐藏语法隐藏（例如将 \textbf{text} 中的命令隐藏）
    vim.g.vimtex_syntax_conceal_disable = 0

    -- 完成功能
    vim.g.vimtex_complete_enabled = 1

    -- 错误抑制（根据需要调整）
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull",
      "Overfull",
    }
  end,
  config = function()
    -- 自定义键位映射（可选）
    local map = vim.keymap.set

    -- 编译相关
    map("n", "<leader>ll", "<cmd>VimtexCompile<cr>", { desc = "VimTeX: 切换编译" })
    map("n", "<leader>lc", "<cmd>VimtexClean<cr>", { desc = "VimTeX: 清理辅助文件" })
    map("n", "<leader>lC", "<cmd>VimtexClean!<cr>", { desc = "VimTeX: 清理所有文件" })

    -- 查看相关
    map("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "VimTeX: 查看 PDF" })
    map("n", "<leader>lr", "<cmd>VimtexReverseSearch<cr>", { desc = "VimTeX: 反向搜索" })

    -- TOC 和信息
    map("n", "<leader>lt", "<cmd>VimtexTocOpen<cr>", { desc = "VimTeX: 打开目录" })
    map("n", "<leader>li", "<cmd>VimtexInfo<cr>", { desc = "VimTeX: 显示信息" })

    -- 错误和日志
    map("n", "<leader>le", "<cmd>VimtexErrors<cr>", { desc = "VimTeX: 显示错误" })
    map("n", "<leader>lo", "<cmd>VimtexLog<cr>", { desc = "VimTeX: 查看编译日志" })

    -- 停止编译
    map("n", "<leader>lk", "<cmd>VimtexStop<cr>", { desc = "VimTeX: 停止编译" })
    map("n", "<leader>lK", "<cmd>VimtexStopAll<cr>", { desc = "VimTeX: 停止所有编译" })
  end,
}
