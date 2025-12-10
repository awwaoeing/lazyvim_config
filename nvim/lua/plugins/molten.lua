-- Molten.nvim 配置
-- 用于在 Neovim 中直接编辑和运行 Jupyter Notebook (.ipynb) 文件

return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- 使用稳定版本
    -- 注意: image.nvim 暂时禁用（不支持 iTerm2）
    -- dependencies = {
    --   "3rd/image.nvim",
    -- },
    build = ":UpdateRemotePlugins",
    ft = { "python", "julia", "r" }, -- 支持的文件类型
    init = function()
      -- 基础设置
      vim.g.molten_auto_open_output = false -- 不自动打开输出窗口
      vim.g.molten_image_provider = "none" -- 不使用图片显示（改为文本输出）
      vim.g.molten_output_win_max_height = 20 -- 输出窗口最大高度
      vim.g.molten_wrap_output = true -- 自动换行
      vim.g.molten_virt_text_output = true -- 在虚拟文本中显示输出
      vim.g.molten_virt_lines_off_by_1 = true -- 虚拟文本偏移修正

      -- 显示设置
      vim.g.molten_output_show_more = true -- 显示 "show more" 按钮
      vim.g.molten_auto_image_popup = true -- 自动弹出图片

      -- 覆盖默认行为
      vim.g.molten_cover_empty_lines = false -- 不覆盖空行
      vim.g.molten_cover_lines_starting_with = {} -- 不覆盖以特定字符开头的行

      -- 输出行为
      vim.g.molten_output_virt_lines = true -- 在虚拟行中显示输出
      vim.g.molten_virt_text_max_lines = 12 -- 虚拟文本最大行数

      -- 是否在启动时自动导入 Jupyter notebook
      vim.g.molten_auto_init_behavior = "init" -- 自动初始化 kernel

      -- Kernel 显示设置
      vim.g.molten_tick_rate = 150 -- 更新频率(毫秒)
      vim.g.molten_use_border_highlights = true -- 使用边框高亮
    end,
    keys = {
      -- 初始化和管理
      {
        "<leader>mi",
        ":MoltenInit<CR>",
        desc = "初始化 Molten (选择 kernel)",
        silent = true,
      },
      {
        "<leader>mI",
        function()
          local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
          if venv ~= nil then
            -- 在虚拟环境中，使用 venv 的 Python
            venv = string.match(venv, "/.+/(.+)")
            vim.cmd(("MoltenInit %s"):format(venv))
          else
            -- 否则使用默认的 Python3
            vim.cmd("MoltenInit python3")
          end
        end,
        desc = "自动初始化 Molten (检测虚拟环境)",
        silent = true,
      },
      {
        "<leader>me",
        ":MoltenEvaluateOperator<CR>",
        desc = "评估操作符",
        silent = true,
      },
      {
        "<leader>mr",
        ":MoltenReevaluateCell<CR>",
        desc = "重新运行当前 cell",
        silent = true,
      },
      {
        "<leader>md",
        ":MoltenDelete<CR>",
        desc = "删除 Molten cell",
        silent = true,
      },

      -- 运行代码
      {
        "<leader>ml",
        ":MoltenEvaluateLine<CR>",
        desc = "运行当前行",
        mode = "n",
        silent = true,
      },
      {
        "<leader>mc",
        ":<C-u>MoltenEvaluateVisual<CR>",
        desc = "运行选中的代码",
        mode = "v",
        silent = true,
      },
      {
        "<leader>mR",
        ":MoltenEvaluateArgument<CR>",
        desc = "运行参数(文本对象)",
        mode = "n",
        silent = true,
      },

      -- 输出管理
      {
        "<leader>mo",
        ":noautocmd MoltenEnterOutput<CR>",
        desc = "进入输出窗口",
        silent = true,
      },
      {
        "<leader>mh",
        ":MoltenHideOutput<CR>",
        desc = "隐藏输出",
        silent = true,
      },
      {
        "<leader>ms",
        ":MoltenShowOutput<CR>",
        desc = "显示输出",
        silent = true,
      },

      -- Kernel 管理
      {
        "<leader>mx",
        ":MoltenInterrupt<CR>",
        desc = "中断 Kernel 执行",
        silent = true,
      },
      {
        "<leader>mq",
        ":MoltenDeinit<CR>",
        desc = "关闭 Molten (停止 kernel)",
        silent = true,
      },

      -- 图片输出
      {
        "<leader>mp",
        ":MoltenImagePopup<CR>",
        desc = "显示图片弹窗",
        silent = true,
      },

      -- Cell 导航（与 vim-ipython-cell 兼容）
      {
        "[c",
        ":MoltenPrev<CR>",
        desc = "跳到上一个 Molten cell",
        ft = "python",
        silent = true,
      },
      {
        "]c",
        ":MoltenNext<CR>",
        desc = "跳到下一个 Molten cell",
        ft = "python",
        silent = true,
      },
    },
  },

  -- image.nvim: 用于在终端中显示图片
  -- 注意: image.nvim 目前只支持 kitty 和 ueberzug backend
  -- iTerm2 用户: 暂时禁用此插件，Molten 会显示文本输出
  -- 如果使用 Kitty 终端，可以启用并设置 backend = "kitty"
  {
    "3rd/image.nvim",
    enabled = false, -- 暂时禁用（image.nvim 不支持 iTerm2）
    opts = {
      backend = "kitty", -- 仅支持 kitty 或 ueberzug
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = false, -- 如果不使用 neorg 可以禁用
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
    },
  },

  -- quarto-nvim: 可选，提供更好的 notebook 支持
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown", "python" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { "python", "r", "julia" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "K",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
      },
    },
    keys = {
      {
        "<leader>qp",
        ":QuartoPreview<CR>",
        desc = "预览 Quarto 文档",
        silent = true,
      },
      {
        "<leader>qq",
        ":QuartoClosePreview<CR>",
        desc = "关闭 Quarto 预览",
        silent = true,
      },
    },
  },
}
