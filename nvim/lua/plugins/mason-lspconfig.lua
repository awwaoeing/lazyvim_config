-- Mason-LSPConfig 插件配置
-- 作用：桥接 mason.nvim 和 nvim-lspconfig，自动安装和配置 LSP 服务器
-- 重要性：确保 Mason 安装的 LSP 服务器能被 lspconfig 正确识别和启动

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- 自动安装的 LSP 服务器列表
      -- 这些服务器会通过 Mason 自动安装，并由 lspconfig 配置
      ensure_installed = {
        "pyright", -- Python LSP
        "lua_ls", -- Lua LSP (对应 mason 中的 lua-language-server)
        -- 其他 LSP 服务器可以在这里添加
      },
    },
    -- 配置自动设置处理器
    -- 这样可以让 lspconfig.lua 中的自定义配置生效
    config = function(_, opts)
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup(opts)

      -- 不使用 automatic_setup，让 LazyVim 和我们的 lspconfig.lua 来处理
      -- 这样可以保留我们在 lspconfig.lua 中的自定义配置
    end,
  },
}
