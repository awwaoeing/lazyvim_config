-- nvim-treesitter 配置
-- 自动修复 vim highlights.scm 中的 "tab" 节点问题
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSUpdateSync" },
  opts = function(_, opts)
    -- 确保 ensure_installed 是一个表
    opts.ensure_installed = opts.ensure_installed or {}

    -- 添加常用语言解析器
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    })

    -- 启用自动安装
    opts.auto_install = true

    return opts
  end,
  -- 在插件安装或更新后自动执行修复脚本
  build = function()
    -- 修复脚本路径
    local fix_script = vim.fn.expand("~/.config/nvim/scripts/fix-treesitter-tab.sh")

    -- 检查脚本是否存在
    if vim.fn.filereadable(fix_script) == 1 then
      vim.notify("检测到 nvim-treesitter 更新，正在修复 vim 查询文件...", vim.log.levels.INFO)

      -- 执行修复脚本
      local result = vim.fn.system(fix_script)

      -- 显示结果
      if vim.v.shell_error == 0 then
        vim.notify("✅ Tree-sitter 查询文件修复成功", vim.log.levels.INFO)
      else
        vim.notify("⚠️ 修复脚本执行失败:\n" .. result, vim.log.levels.WARN)
      end
    else
      -- 如果脚本不存在，直接修复
      local query_file = vim.fn.expand("~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm")
      if vim.fn.filereadable(query_file) == 1 then
        -- 检查是否需要修复
        local content = vim.fn.readfile(query_file)
        local needs_fix = false
        for i, line in ipairs(content) do
          if line:match('^%s*"tab"%s*$') then
            needs_fix = true
            content[i] = '  ; "tab"  ; 注释掉：当前 Tree-sitter vim 解析器不支持此节点类型'
            break
          end
        end

        if needs_fix then
          vim.fn.writefile(content, query_file)
          vim.notify("✅ 已自动修复 Tree-sitter vim 查询文件", vim.log.levels.INFO)
        end
      end
    end
  end,
}
