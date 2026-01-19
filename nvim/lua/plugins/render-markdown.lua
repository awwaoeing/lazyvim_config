-- ============================================================================
-- Markdown 实时渲染插件配置
-- 插件: MeanderingProgrammer/render-markdown.nvim
-- 功能: 在 Neovim buffer 中直接渲染 Markdown，边写边预览
-- 优势: 无需外部工具，纯 Neovim 实现
-- ============================================================================

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- 语法解析
    "nvim-tree/nvim-web-devicons", -- 图标支持（可选）
  },
  ft = "markdown", -- 仅在打开 Markdown 文件时加载
  keys = {
    {
      "<leader>mr",
      "<cmd>RenderMarkdown toggle<cr>",
      desc = "切换 Markdown 渲染",
      ft = "markdown",
    },
  },
  opts = {
    -- 启用状态
    enabled = true,

    -- 最大文件大小（MB），超过则不自动渲染
    max_file_size = 10.0,

    -- 渲染模式: "none", "normal", "full"
    -- normal: 仅渲染可见区域（性能好）
    -- full: 渲染整个文件
    render_modes = { "n", "c" }, -- 在 normal 和 command 模式下渲染

    -- 标题样式
    headings = {
      "󰲡 ", -- H1
      "󰲣 ", -- H2
      "󰲥 ", -- H3
      "󰲧 ", -- H4
      "󰲩 ", -- H5
      "󰲫 ", -- H6
    },

    -- 代码块配置
    code = {
      -- 代码块样式: "full", "normal", "language", "none"
      style = "full",
      -- 左侧图标
      left_pad = 2,
      right_pad = 2,
      -- 是否显示语言名称
      language_name = true,
      -- 高亮背景
      highlight = "RenderarkdownCode",
    },

    -- 列表符号
    bullet = {
      -- 不同层级的列表符号
      icons = { "●", "○", "◆", "◇" },
    },

    -- 复选框样式
    checkbox = {
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
      },
    },

    -- 引用块
    quote = {
      icon = "▋",
      highlight = "RenderMarkdownQuote",
    },

    -- 分隔线
    dash = {
      icon = "─",
      width = "full", -- "full" 或数字
    },

    -- 表格边框
    pipe_table = {
      style = "full", -- "full", "normal", "none"
      cell = "padded", -- "padded", "raw"
    },

    -- LaTeX 支持
    latex = {
      enabled = true,
      -- 行内公式
      inline = { icon = "$ " },
      -- 块级公式
      block = { icon = "$$ " },
    },

    -- 链接样式
    link = {
      -- 是否高亮链接
      highlight = "RenderMarkdownLink",
    },

    -- 行内代码
    inline_code = {
      highlight = "RenderMarkdownCodeInline",
    },

    -- 在插入模式下的行为
    anti_conceal = {
      -- 插入模式下是否显示原始文本
      enabled = true,
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
  end,
}

