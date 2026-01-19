#!/bin/bash
# 自动修复 nvim-treesitter vim highlights.scm 中的 "tab" 节点问题
# 用法：./fix-treesitter-tab.sh

QUERY_FILE="$HOME/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm"

if [ ! -f "$QUERY_FILE" ]; then
    echo "❌ 错误：找不到查询文件"
    echo "   文件路径: $QUERY_FILE"
    exit 1
fi

# 检查文件是否已经修复
if grep -q '; "tab"' "$QUERY_FILE"; then
    echo "✅ 查询文件已经修复过了"
    exit 0
fi

# 检查是否存在 "tab" 节点
if ! grep -q '"tab"' "$QUERY_FILE"; then
    echo "✅ 查询文件中没有 \"tab\" 节点，无需修复"
    exit 0
fi

# 创建备份
cp "$QUERY_FILE" "$QUERY_FILE.bak"

# 修复文件（注释掉第 113 行的 "tab"）
sed -i '' '113s/"tab"/; "tab"  ; 注释掉：当前 Tree-sitter vim 解析器不支持此节点类型/' "$QUERY_FILE"

# 验证修复
if grep -q '; "tab"' "$QUERY_FILE"; then
    echo "✅ 修复成功！"
    echo "   备份文件: $QUERY_FILE.bak"

    # 验证 Tree-sitter 查询是否能加载
    if nvim --headless +'lua local ok = pcall(vim.treesitter.query.get, "vim", "highlights"); vim.cmd("cquit " .. (ok and 0 or 1))' 2>/dev/null; then
        echo "✅ Tree-sitter 查询加载成功"
    else
        echo "⚠️  Tree-sitter 查询加载失败，可能需要重启 Neovim"
    fi
else
    echo "❌ 修复失败，请手动编辑文件"
    echo "   文件: $QUERY_FILE"
    echo "   需要注释第 113 行的 \"tab\""
    exit 1
fi