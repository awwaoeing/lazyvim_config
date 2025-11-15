-- Mason 插件配置 - 自动安装 LSP/DAP/Formatter/Linter
-- 确保在新机器上自动安装所有必要的工具

return {
  -- Mason 核心插件
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python 工具链
        "pyright", -- Python LSP
        "debugpy", -- Python debugger
        "black", -- Python formatter
        "isort", -- Python import formatter
        "ruff", -- Python linter & formatter
        "flake8", -- Python linter

        -- Lua 工具链
        "lua-language-server", -- Lua LSP
        "stylua", -- Lua formatter

        -- Markdown 工具链
        "marksman", -- Markdown LSP
        "markdownlint-cli2", -- Markdown linter
        "markdown-toc", -- Markdown TOC generator

        -- Shell 工具链
        "shellcheck", -- Shell linter
        "shfmt", -- Shell formatter

        -- 其他
        "vscode-json-language-server", -- JSON LSP
      },
    },
  },
}
