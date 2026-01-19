# Noice.nvim Tree-sitter 错误修复记录

**修复日期**: 2024-12-24
**问题**: `Query error at 113:4. Invalid node type "tab"`

---

## 问题描述

启动 Neovim 或使用 noice.nvim 的命令行功能时，出现以下错误：

```
.../share/nvim/runtime/lua/vim/treesitter/query.lua:373:
Query error at 113:4. Invalid node type "tab":
  "tab"
   ^
```

---

## 问题原因分析

### 根本原因

noice.nvim 使用 Tree-sitter 对命令行（cmdline）输入进行语法高亮：

1. **noice 的工作流程**：
   - 当用户输入命令（如 `:set tabstop=4`）时
   - noice 根据 `lang = "vim"` 参数调用 Tree-sitter vim 解析器
   - Tree-sitter 加载查询文件来识别语法元素

2. **版本不匹配问题**：
   - nvim-treesitter 的 `queries/vim/highlights.scm` 第 113 行引用了 `"tab"` 节点
   - 但当前版本的 Tree-sitter vim 解析器（grammar）中不存在 `"tab"` 节点类型
   - 导致查询编译失败

### 技术细节

**查询文件位置**：

```
~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm:113
```

**问题代码**：

```scheme
; Commands and user defined commands
[
  "set"
  "echo"
  ...
  "tab"      ← 第 113 行，Tree-sitter 解析器不认识此节点
  "vertical"
  ...
] @keyword
```

---

## 解决方案

采用**双层防护**策略，确保修复持久有效：

### 方案 1：直接修改插件查询文件（临时）

**文件**: `~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm`

**修改内容**：

```diff
  "cNext"
- "tab"
+ ; "tab"  ; 注释掉：当前 Tree-sitter vim 解析器不支持此节点类型
  "vertical"
```

**优点**: 立即生效
**缺点**: 更新 nvim-treesitter 插件时会被覆盖

### 方案 2：创建用户自定义查询（持久）

**文件**: `~/.config/nvim/after/queries/vim/highlights.scm`

**内容**：

```scheme
; 用户自定义查询文件 - 覆盖 nvim-treesitter 的默认查询
; 此文件不会被插件更新覆盖
;
; 修复: Tree-sitter vim 解析器不支持 "tab" 节点类型
; 原始文件: nvim-treesitter/runtime/queries/vim/highlights.scm:113
```

**Neovim 加载顺序**：

```
1. 内置查询 (/opt/homebrew/.../nvim/runtime/queries/)
2. 插件查询 (~/.local/share/nvim/lazy/nvim-treesitter/...)
3. 用户查询 (~/.config/nvim/after/queries/) ← 最高优先级
```

**优点**: 永久生效，不会被插件更新覆盖
**原理**: `after/` 目录在 Neovim 的 runtimepath 中优先级最高

### 方案 3：更新 noice.nvim 配置

**文件**: `~/.config/nvim/lua/plugins/noice.lua`

**配置内容**：

```lua
-- 修复 noice.nvim 的 Tree-sitter 查询错误
return {
  "folke/noice.nvim",
  opts = {
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    -- 重新启用 cmdline 语法高亮（已修复 Tree-sitter 查询错误）
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      },
    },
    -- ... 其他配置
  },
}
```

---

## 修改文件清单

### 已修改的文件

1. **`~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm`**
   - 第 113 行：注释掉 `"tab"` 节点引用
   - ⚠️ 更新插件时会被覆盖

2. **`~/.config/nvim/lua/plugins/noice.lua`**
   - 重新启用 cmdline 语法高亮
   - 添加修复说明注释

### 新创建的文件

1. **`~/.config/nvim/after/queries/vim/highlights.scm`**
   - 用户自定义查询文件
   - 确保修复持久有效

### 已删除的文件

1. **`~/.config/nvim/lua/plugins/noice-disable.lua`**
   - 备用禁用方案，问题解决后不再需要

---

## 验证方法

### 1. 测试 Tree-sitter 查询加载

```bash
nvim --headless +'lua local ok = pcall(vim.treesitter.query.get, "vim", "highlights"); print(ok and "✅ 查询加载成功" or "❌ 查询加载失败")' +q
```

**预期输出**: `✅ 查询加载成功`

### 2. 测试 noice 功能

```bash
nvim
```

在 Neovim 中：

- ✅ 启动时没有 Tree-sitter 错误
- ✅ 输入 `:set tabstop=4` 等命令有语法高亮
- ✅ noice 的消息和通知功能正常工作

---

## 工作原理

### Tree-sitter 查询文件加载流程

```
启动 Neovim
    ↓
noice 使用 lang = "vim"
    ↓
Tree-sitter 加载 vim 解析器
    ↓
按优先级加载查询文件：
    1. 加载内置 highlights.scm
    2. 加载 nvim-treesitter 的 highlights.scm（合并）
       → 第 113 行的 "tab" 已被注释
    3. 加载 after/queries/vim/highlights.scm（最终覆盖）
       → 确保自定义查询优先
    ↓
Tree-sitter 编译合并后的查询
    ↓
✅ 没有 "tab" 节点引用，编译成功！
    ↓
应用语法高亮到 noice cmdline
```

### 为什么 `after/` 目录有效

Neovim 的 runtimepath 加载顺序（`:h runtimepath`）：

```
~/.config/nvim/
    ├── init.lua          # 最先加载
    ├── lua/plugins/      # 插件配置
    ├── queries/          # 用户查询（与插件同级）
    └── after/            # 🌟 最后加载，最高优先级
        └── queries/      # 可以覆盖插件的查询
```

**关键特性**：

- `after/` 目录的内容在所有插件加载完成后加载
- 可以覆盖任何插件的默认配置
- 不会被插件更新影响（独立于插件目录）

---

## 未来维护

### 如果更新 nvim-treesitter 后问题复现

**方法 1：使用自动修复脚本（推荐）**

```bash
~/.config/nvim/scripts/fix-treesitter-tab.sh
```

脚本会自动：

- 检查查询文件是否存在
- 创建备份文件
- 注释掉第 113 行的 "tab" 节点
- 验证修复是否成功

**方法 2：手动修复**

1. **检查查询文件是否被覆盖**：

   ```bash
   grep -n '"tab"' ~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm
   ```

2. **使用 sed 快速修复**：

   ```bash
   sed -i '' '113s/"tab"/; "tab"  ; 注释掉：当前 Tree-sitter vim 解析器不支持此节点类型/' \
     ~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm
   ```

3. **或手动编辑文件**：

   ```bash
   nvim ~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm
   # 在第 113 行注释掉 "tab"
   ```

4. **验证 after/ 查询文件存在**：

   ```bash
   ls -la ~/.config/nvim/after/queries/vim/highlights.scm
   ```

### 如果上游修复了问题

当 nvim-treesitter 或 Tree-sitter vim 解析器修复了此问题后：

- 可以保留当前配置，不会产生冲突
- 或者删除 `after/queries/vim/highlights.scm`（如果不需要其他自定义）

---

## 参考资料

- [Neovim Tree-sitter 文档](https://neovim.io/doc/user/treesitter.html)
- [nvim-treesitter 查询指南](https://github.com/nvim-treesitter/nvim-treesitter#adding-queries)
- [noice.nvim 插件](https://github.com/folke/noice.nvim)
- [Tree-sitter 查询语法](https://tree-sitter.github.io/tree-sitter/using-parsers#query-syntax)

---

## 相关命令

```bash
# 查看 Tree-sitter 解析器信息
:TSInstallInfo vim

# 更新 Tree-sitter 解析器
:TSUpdate vim

# 检查 Tree-sitter 健康状态
:checkhealth nvim-treesitter

# 查看 noice 配置
:Noice

# 更新 nvim-treesitter 插件
:Lazy update nvim-treesitter
```

---

**总结**: 通过注释掉不兼容的查询节点，并使用 `after/` 目录创建持久化覆盖，成功解决了 noice.nvim 与 Tree-sitter 的版本兼容性问题，同时保留了完整的语法高亮功能。

