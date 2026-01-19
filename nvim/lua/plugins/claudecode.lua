-- Claude Code 配置
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = true,
    config = function(_, opts)
      require("claudecode").setup(opts)

      -- 窗口大小变化时自动调整终端内容
      vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
        group = vim.api.nvim_create_augroup("claudecode_resize", { clear = true }),
        callback = function()
          -- 遍历所有终端 buffer，发送 SIGWINCH 信号
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "terminal" then
              local chan = vim.bo[buf].channel
              if chan and chan > 0 then
                -- 触发终端重新计算大小
                pcall(vim.api.nvim_chan_send, chan, "\x1b[8t")
              end
            end
          end
        end,
      })
    end,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeSelectModel",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeStatus",
    },
    keys = {
      -- 基础操作
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Connection status" },

      -- 对话管理
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume conversation" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue conversation" },

      -- 发送内容
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add from file tree" },

      -- Diff 操作
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    opts = {
      -- 终端配置
      terminal = {
        split_side = "right",
        split_width_percentage = 0.32,
        provider = "snacks",
        auto_close = true,
        git_repo_cwd = true, -- 自动使用 git 项目根目录
      },

      -- 选择追踪（方便发送选中代码）
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- 发送后行为
      focus_after_send = true, -- 发送后自动聚焦到 Claude

      -- Diff 集成
      diff_opts = {
        auto_close_on_accept = true, -- 接受后自动关闭 diff
        vertical_split = true, -- 垂直分割显示 diff
        open_in_current_tab = true, -- 在当前 tab 打开
        context_lines = 15, -- 显示的上下文行数（默认3行,增加到15行以查看更多代码）
        scrolloff = 5, -- diff 窗口滚动时保持的上下文行数
      },
    },
  },
}
