-- ============================================================================
-- 撤销树插件配置
-- 插件: mbbill/undotree
-- 功能: 可视化撤销历史树，方便查看和恢复到任意历史状态
-- ============================================================================

return {
    "mbbill/undotree",
    cmd = "UndotreeToggle", -- 懒加载：仅在调用命令时加载
    keys = {
        {
            "tt",
            "<cmd>UndotreeToggle<cr>",
            desc = "切换撤销树",
        },
    },
    config = function()
        -- 撤销树窗口配置
        vim.g.undotree_WindowLayout = 2 -- 窗口布局样式 2（左侧树，右侧 diff）
        vim.g.undotree_ShortIndicators = 1 -- 使用短时间指示器
        vim.g.undotree_SplitWidth = 30 -- 撤销树窗口宽度
        vim.g.undotree_DiffpanelHeight = 10 -- diff 面板高度
        vim.g.undotree_SetFocusWhenToggle = 1 -- 打开时自动聚焦到撤销树窗口

        -- 自动打开 diff 窗口
        vim.g.undotree_DiffAutoOpen = 1

        -- 高亮显示变化
        vim.g.undotree_HighlightChangedText = 1
        vim.g.undotree_HighlightSyntaxAdd = "DiffAdd"
        vim.g.undotree_HighlightSyntaxChange = "DiffChange"
    end,
}
