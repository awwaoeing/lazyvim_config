-- Mason 插件配置 - 自动安装 DAP/Formatter/Linter 等非 LSP 工具
-- 确保在新机器上自动安装所有必要的工具
--
-- 注意：LSP 服务器的安装由 mason-lspconfig.lua 管理，不要在这里添加

return {
  -- Mason 核心插件
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python 工具链（非 LSP）
        "debugpy", -- Python debugger (由 Mason 统一管理)
        "black", -- Python formatter
        "isort", -- Python import formatter
        "ruff", -- Python linter & formatter
        "flake8", -- Python linter

        -- Lua 工具链（非 LSP）
        "stylua", -- Lua formatter

        -- Markdown 工具链（非 LSP）
        "markdownlint-cli2", -- Markdown linter
        "markdown-toc", -- Markdown TOC generator

        -- Shell 工具链（非 LSP）
        "shellcheck", -- Shell linter
        "shfmt", -- Shell formatter

        -- 注意：
        -- - LSP 服务器(pyright, lua_ls, marksman, jsonls 等)
        --   应该在 mason-lspconfig.lua 中配置
        -- - 这里只配置非 LSP 工具(formatter, linter, debugger 等)
      },
    },
  },
}
