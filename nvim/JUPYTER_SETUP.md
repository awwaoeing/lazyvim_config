# Jupyter-Vim 配置说明

## 已迁移的配置

从 `~/my-config/.vimrc` 迁移到 LazyVim 的 Jupyter 相关配置。

## 安装的插件

1. **jupyter-vim** - 主插件，用于与 Jupyter kernel 交互
2. **vim-slime** - 发送代码到 REPL
3. **vim-ipython-cell** - 类似 Jupyter Notebook 的 cell 执行
4. **vim-repl** - 通用 REPL 支持

## Python 环境配置

配置文件已自动检测你的 Python 环境：
- 当前使用: `~/conda/envs/myenv/bin/python3` (Python 3.12.12)
- 如果在激活的 conda 环境中，会自动使用 `$CONDA_PREFIX/bin/python3`

## 使用方法

### 1. 启动 Jupyter Console

在终端中启动 Jupyter console（在 conda 环境中）：

```bash
conda activate myenv
jupyter console
```

启动后会显示连接文件路径，例如：
```
Jupyter console 6.6.3
kernel-12345.json
```

### 2. 在 Neovim 中连接到 Jupyter

打开 Python 文件后：

1. **连接到 Jupyter kernel**:
   - 按 `<localleader>jc`（通常是 `\jc`）
   - 或运行 `:JupyterConnect`
   - 输入 kernel 文件路径（例如：`/Users/你的用户名/.local/share/jupyter/runtime/kernel-12345.json`）

2. **发送代码到 Jupyter**:
   - 可视模式选中代码后按 `<localleader>w`（原配置中的快捷键）
   - 或按 `<localleader>e` 运行整个文件

### 3. 常用快捷键

#### Jupyter-vim 快捷键

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<localleader>w` | 可视 | 运行选中代码块到 Jupyter |
| `<localleader>e` | 普通 | 运行整个文件到 Jupyter |
| `<localleader>r` | 普通 | 运行文本对象到 Jupyter |
| `<localleader>c` | 普通 | 运行当前 cell |
| `<localleader>jc` | 普通 | 连接到 Jupyter kernel |
| `<localleader>jd` | 普通 | 断开 Jupyter 连接 |

#### IPython Cell 快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>cr` | 运行当前 cell |
| `<leader>cc` | 执行当前 cell |
| `<leader>cC` | 执行当前 cell 并跳转到下一个 |
| `[c` | 跳转到上一个 cell |
| `]c` | 跳转到下一个 cell |
| `<leader>cl` | 清除 IPython 输出 |

#### REPL 快捷键

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>rt` | 普通 | 切换 REPL 窗口 |
| `<leader>rr` | 普通 | 发送当前行到 REPL |
| `<leader>rs` | 可视 | 发送选中内容到 REPL |
| `<leader>rf` | 普通 | 发送整个文件到 REPL |

### 4. Cell 分隔符

在 Python 文件中使用以下标记来定义 cell：

```python
# %%
# 这是一个 cell

##
# 这也是一个 cell

# <codecell>
# 这也是一个 cell
```

## 与原配置的差异

### 保持一致的部分
- ✅ `<localleader>w` 发送可视模式代码到 Jupyter（原配置第 204 行）
- ✅ Python 解释器路径自动检测
- ✅ vim-slime 和 vim-ipython-cell 集成
- ✅ vim-repl 支持多语言 REPL

### 改进的部分
- ✨ 使用 LazyVim 的懒加载机制，只在 Python 文件中加载插件
- ✨ 更完善的快捷键映射
- ✨ 自动检测 conda 环境
- ✨ 更好的错误处理

## 故障排除

### 问题 1: 无法连接到 Jupyter kernel

**解决方案**:
1. 确保 Jupyter console 正在运行
2. 检查 kernel 文件路径是否正确
3. 在 Neovim 中运行 `:messages` 查看错误信息

### 问题 2: Python 环境不正确

**解决方案**:
编辑 `~/.config/nvim/lua/plugins/jupyter.lua`，手动设置：
```lua
vim.g.jupytervim_python_path = "/path/to/your/python3"
```

### 问题 3: 插件没有加载

**解决方案**:
1. 运行 `:Lazy sync` 安装插件
2. 重启 Neovim
3. 检查 `:Lazy` 界面确认插件已安装

## 测试配置

创建一个测试文件 `test.py`:

```python
# %%
import numpy as np
print("Hello from Jupyter!")

# %%
x = np.array([1, 2, 3, 4, 5])
print(f"Sum: {x.sum()}")
```

然后：
1. 启动 jupyter console
2. 在 Neovim 中打开 `test.py`
3. 按 `<localleader>jc` 连接到 kernel
4. 选中第一个 cell 的代码，按 `<localleader>w` 运行
5. 在 Jupyter console 中查看输出

## 更多资源

- [jupyter-vim 文档](https://github.com/jupyter-vim/jupyter-vim)
- [vim-ipython-cell 文档](https://github.com/hanschen/vim-ipython-cell)
- [vim-slime 文档](https://github.com/jpalardy/vim-slime)
- [vim-repl 文档](https://github.com/sillybun/vim-repl)
