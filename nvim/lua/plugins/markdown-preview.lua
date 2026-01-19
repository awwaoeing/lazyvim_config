-- ============================================================================
-- Markdown 浏览器预览插件配置
-- 插件: iamcco/markdown-preview.nvim
-- 功能: 在浏览器中实时预览 Markdown，支持图表、数学公式等
-- 依赖: Node.js (需要 node 和 yarn)
-- ============================================================================

return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown", -- 仅在打开 Markdown 文件时加载
  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewStop",
    "MarkdownPreviewToggle",
  },
  keys = {
    {
      "<leader>mb",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "浏览器预览 Markdown",
      ft = "markdown",
    },
  },
  -- 自动安装依赖
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    -- 浏览器设置
    -- 可选: "chrome", "firefox", "safari", 或留空使用系统默认浏览器
    vim.g.mkdp_browser = ""

    -- 预览服务器配置
    vim.g.mkdp_port = "8765" -- 服务器端口
    vim.g.mkdp_auto_start = 0 -- 打开 md 文件时不自动启动预览
    vim.g.mkdp_auto_close = 1 -- 关闭 buffer 时自动关闭预览

    -- 刷新设置
    vim.g.mkdp_refresh_slow = 0 -- 0=实时刷新, 1=保存时刷新

    -- 预览窗口设置
    vim.g.mkdp_open_to_the_world = 0 -- 0=仅本机访问, 1=局域网可访问
    vim.g.mkdp_open_ip = "127.0.0.1" -- 绑定 IP 地址

    -- 预览主题: "dark" 或 "light"
    vim.g.mkdp_theme = "dark"

    -- Markdown 选项
    vim.g.mkdp_filetypes = { "markdown" } -- 支持的文件类型

    -- 页面标题
    -- ${name} 会被替换为文件名
    vim.g.mkdp_page_title = "${name} - Preview"

    -- 预览选项
    vim.g.mkdp_preview_options = {
      -- mermaid 图表支持
      maid = {},
      -- katex 数学公式支持
      katex = {},
      -- UML 图表支持
      uml = {},
      -- 代码高亮主题
      -- 可选: "atom-one-light", "atom-one-dark", "github", "monokai" 等
      highlight = {
        theme = "atom-one-dark",
      },
      -- 序列图支持
      sequence_diagrams = {},
      -- flowchart 支持
      flowchart = {},
      -- 禁用同步滚动: 0=启用, 1=禁用
      disable_sync_scroll = 0,
      -- 禁用文件名: 0=显示, 1=隐藏
      disable_filename = 0,
    }

    -- 自定义 Markdown 渲染器（可选）
    -- vim.g.mkdp_markdown_css = '/path/to/custom.css'
    -- vim.g.mkdp_highlight_css = '/path/to/highlight.css'

    -- 组合键功能（在预览页面中）
    -- <C-s> 切换侧边栏目录
    -- <C-f> 全文搜索
  end,
}
