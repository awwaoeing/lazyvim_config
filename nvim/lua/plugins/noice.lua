-- 修复 noice.nvim 的 Tree-sitter 查询错误
-- 问题：nvim-treesitter 的 vim highlights.scm 引用了不存在的 "tab" 节点
-- 解决方案：
--   1. 修改了 highlights.scm 注释掉 "tab" 节点（会被更新覆盖）
--   2. 创建了 ~/.config/nvim/after/queries/vim/highlights.scm（持久化）
-- 现在可以安全启用 cmdline 语法高亮
return {
  "folke/noice.nvim",
  opts = {
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    -- 重新启用 cmdline 语法高亮（已修复 Tree-sitter 查询错误）
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      },
    },
    messages = {
      enabled = true,
    },
    notify = {
      enabled = true,
    },
    lsp = {
      progress = {
        enabled = true,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  },
}
