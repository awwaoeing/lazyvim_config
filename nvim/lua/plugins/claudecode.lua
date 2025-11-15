-- Claude Code 右侧边栏配置
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        -- 右侧边栏配置
        split_side = "right", -- 在右侧显示
        split_width_percentage = 0.45, -- 占 45% 宽度
      },
    },
  },
}
