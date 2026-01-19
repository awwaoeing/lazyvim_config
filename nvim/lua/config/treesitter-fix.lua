-- Tree-sitter vim 查询文件自动修复
-- 在 Neovim 启动时进行轻量级检查

local M = {}

-- 轻量级检查：只验证不修复
function M.check()
  local query_file = vim.fn.expand("~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm")

  -- 如果文件不存在，跳过检查
  if vim.fn.filereadable(query_file) ~= 1 then
    return
  end

  -- 快速检查：只读第 113 行
  local handle = io.open(query_file, "r")
  if not handle then
    return
  end

  local line_num = 0
  for line in handle:lines() do
    line_num = line_num + 1
    if line_num == 113 then
      -- 检查是否包含未注释的 "tab"
      if line:match('^%s*"tab"%s*$') then
        vim.notify(
          '⚠️ 检测到 Tree-sitter vim 查询文件需要修复\n运行 :Lazy build nvim-treesitter 以自动修复',
          vim.log.levels.WARN
        )
      end
      break
    end
  end
  handle:close()
end

-- 延迟执行检查，避免影响启动速度
function M.lazy_check()
  vim.defer_fn(function()
    M.check()
  end, 1000) -- 启动 1 秒后执行
end

return M