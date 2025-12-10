# Molten.nvim 快速开始指南

## 🚀 什么是 Molten.nvim?

Molten.nvim 是一个强大的 Neovim 插件，允许你在 Neovim 中直接编辑和运行 Jupyter Notebook (.ipynb) 文件，并在编辑器内**实时查看输出结果**（包括文本、图表、图片等）。

## 📦 已安装的内容

1. **molten-nvim** - 核心插件，提供 Jupyter kernel 集成
2. **image.nvim** - 在终端中显示图片输出
3. **quarto-nvim** - 可选，提供更好的 notebook 支持
4. **Python 依赖包**:
   - jupyter_client
   - nbformat
   - cairosvg, plotly, kaleido
   - pyperclip, pillow

## 🎯 使用步骤

### 方法 1: 编辑 .ipynb 文件（推荐）

#### 步骤 1: 打开 notebook 文件

```bash
cd ~/
nvim my_notebook.ipynb
```

#### 步骤 2: 初始化 Molten kernel

在 Neovim 中，按 `<Space>mi` 或 `<Space>mI`:

- `<Space>mi` - 手动选择 kernel（会显示可用的 kernel 列表）
- `<Space>mI` - 自动检测并初始化（推荐，会自动使用当前虚拟环境）

如果提示选择 kernel，选择 `python3` 或你的 conda 环境名称。

#### 步骤 3: 运行代码

**运行单个 cell**:
- 将光标移动到 cell 中
- 按 `<Space>mr` 重新运行当前 cell

**运行选中的代码**:
1. 进入可视模式（按 `v`）
2. 选中要运行的代码
3. 按 `<Space>mc`

**运行当前行**:
- 按 `<Space>ml`

#### 步骤 4: 查看输出

- 输出会自动显示在代码下方的**虚拟文本**中
- 按 `<Space>ms` 显示输出
- 按 `<Space>mh` 隐藏输出
- 按 `<Space>mo` 进入输出窗口（可以滚动查看）

### 方法 2: 在 .py 文件中使用

你也可以在普通的 Python 文件中使用 Molten！

1. 创建或打开 `.py` 文件
2. 使用 `# %%` 标记 cell 边界:

```python
# %%
import numpy as np
import matplotlib.pyplot as plt

print("Hello from Molten!")

# %%
x = np.linspace(0, 10, 100)
y = np.sin(x)

plt.plot(x, y)
plt.title("Sine Wave")
plt.show()

# %%
print(f"Max value: {y.max()}")
```

3. 初始化 Molten: `<Space>mI`
4. 运行 cell: `<Space>mr`
5. 在 cell 之间导航: `]c` (下一个) / `[c` (上一个)

## 📝 完整的快捷键列表

### 初始化和管理

| 快捷键 | 功能 |
|--------|------|
| `<Space>mi` | 手动初始化 Molten (选择 kernel) |
| `<Space>mI` | **自动初始化** (检测虚拟环境) ⭐ 推荐 |
| `<Space>mq` | 关闭 Molten (停止 kernel) |
| `<Space>mx` | 中断正在执行的代码 |

### 运行代码

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<Space>mr` | 普通 | **重新运行当前 cell** ⭐ 最常用 |
| `<Space>ml` | 普通 | 运行当前行 |
| `<Space>mc` | 可视 | 运行选中的代码 |
| `<Space>me` | 普通 | 评估操作符 |
| `<Space>mR` | 普通 | 运行文本对象 |

### 输出管理

| 快捷键 | 功能 |
|--------|------|
| `<Space>ms` | 显示输出 |
| `<Space>mh` | 隐藏输出 |
| `<Space>mo` | 进入输出窗口 |
| `<Space>mp` | 显示图片弹窗 |
| `<Space>md` | 删除 cell |

### Cell 导航

| 快捷键 | 功能 |
|--------|------|
| `]c` | 跳到下一个 cell |
| `[c` | 跳到上一个 cell |

### Quarto 文档（可选）

| 快捷键 | 功能 |
|--------|------|
| `<Space>qp` | 预览 Quarto 文档 |
| `<Space>qq` | 关闭 Quarto 预览 |

## 💡 实用技巧

### 技巧 1: 快速工作流

```
1. 打开 .ipynb 文件
2. 按 <Space>mI 自动初始化
3. 按 <Space>mr 运行当前 cell
4. 输出自动显示在代码下方！
```

### 技巧 2: 查看图表

当你运行生成图表的代码（如 matplotlib）时：
- 图表会自动显示在输出区域
- 按 `<Space>mp` 可以放大查看图片
- 支持 PNG、SVG 等多种格式

### 技巧 3: 与现有 Jupyter 配置配合使用

Molten.nvim 可以和你现有的 `jupyter-vim` 配置**同时使用**：

- **编辑 .ipynb 文件**: 使用 Molten (`<Space>m*` 快捷键)
- **编辑 .py 文件**: 使用 jupyter-vim (`\j*` 和 `\w` 快捷键)

两者互不干扰！

### 技巧 4: 在 conda 环境中使用

```bash
# 激活 conda 环境
conda activate myenv

# 确保 kernel 已安装
python -m ipykernel install --user --name myenv

# 打开 Neovim
nvim notebook.ipynb

# 在 Neovim 中按 <Space>mi，然后选择 myenv
```

### 技巧 5: 转换已有的 .ipynb 文件

如果你已经有 `.ipynb` 文件，直接用 Neovim 打开即可：

```bash
nvim existing_notebook.ipynb
```

Molten 会自动识别并允许你编辑和运行！

## 🔧 常见问题

### Q1: 按 `<Space>mI` 后显示 "No kernel available"？

**解决方案**:

```bash
# 安装 Python kernel
python -m pip install ipykernel
python -m ipykernel install --user

# 或在 conda 环境中
conda activate myenv
conda install ipykernel
python -m ipykernel install --user --name myenv
```

然后重启 Neovim，再按 `<Space>mi` 手动选择 kernel。

### Q2: 输出不显示？

**解决方案**:

1. 确认 kernel 已初始化（状态栏应该显示 kernel 名称）
2. 按 `<Space>ms` 显示输出
3. 运行 `:messages` 查看错误信息
4. 尝试重启 kernel: `<Space>mq` 然后 `<Space>mI`

### Q3: 图片不显示？

**解决方案**:

1. 确认你的终端支持图片显示（推荐使用 **Kitty** 或 **iTerm2**）
2. 检查 `image.nvim` 的 backend 设置
3. 如果使用 tmux，确保 tmux 配置正确

如果终端不支持图片，输出会显示为文本描述。

### Q4: 如何安装 Jupyter kernel？

**解决方案**:

```bash
# Python
pip install ipykernel
python -m ipykernel install --user

# Julia
julia -e 'using Pkg; Pkg.add("IJulia")'

# R
R -e 'install.packages("IRkernel"); IRkernel::installspec()'
```

### Q5: 运行代码很慢？

**解决方案**:

- 降低更新频率：编辑 `~/.config/nvim/lua/plugins/molten.lua`
- 修改 `vim.g.molten_tick_rate = 500` (默认是 150)

### Q6: 与 jupyter-vim 快捷键冲突？

**不会冲突！** 两者使用不同的快捷键前缀：

- **Molten**: `<Space>m*` 和 `<Space>q*`
- **jupyter-vim**: `\j*` 和 `\w` (localleader)

你可以同时使用两者。

## 🎯 快速测试

创建一个测试 notebook：

```bash
cat > test_molten.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Cell 1: 基础测试\n",
    "print('Hello from Molten!')\n",
    "import sys\n",
    "print(f'Python: {sys.version}')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Cell 2: 数学计算\n",
    "import numpy as np\n",
    "x = np.array([1, 2, 3, 4, 5])\n",
    "print(f'Array: {x}')\n",
    "print(f'Sum: {x.sum()}')\n",
    "print(f'Mean: {x.mean()}')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Cell 3: 绘图\n",
    "import matplotlib.pyplot as plt\n",
    "y = x ** 2\n",
    "plt.plot(x, y)\n",
    "plt.title('Square Function')\n",
    "plt.xlabel('x')\n",
    "plt.ylabel('y')\n",
    "plt.show()"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

nvim test_molten.ipynb
```

然后：

1. 按 `<Space>mI` 初始化
2. 按 `<Space>mr` 运行第一个 cell
3. 按 `]c` 跳到下一个 cell
4. 继续按 `<Space>mr` 运行
5. 查看输出显示在代码下方！

## 📚 更多资源

- [Molten.nvim GitHub](https://github.com/benlubas/molten-nvim)
- [Image.nvim GitHub](https://github.com/3rd/image.nvim)
- [Quarto.nvim GitHub](https://github.com/quarto-dev/quarto-nvim)
- 查看配置文件：`nvim ~/.config/nvim/lua/plugins/molten.lua`

## 🆚 Molten vs Jupyter-vim

| 特性 | Molten | jupyter-vim |
|------|--------|-------------|
| 文件类型 | .ipynb, .py | .py |
| 输出显示 | ✅ 在编辑器内 | ❌ 仅在外部 console |
| 图片支持 | ✅ 是 | ❌ 否 |
| 即时反馈 | ✅ 是 | 🔶 需要切换窗口 |
| 复杂度 | 🔶 中等 | ✅ 简单 |
| 适用场景 | 交互式数据分析 | 脚本开发 |

**建议**: 两者配合使用效果最佳！

- 数据探索和分析 → 使用 **Molten** + .ipynb 文件
- 生产代码和脚本 → 使用 **jupyter-vim** + .py 文件

## 🎉 开始使用！

现在你已经准备好使用 Molten.nvim 了！

```bash
# 创建一个新 notebook
nvim my_analysis.ipynb

# 或打开现有的
nvim ~/Documents/data_analysis.ipynb
```

按 `<Space>mI` 开始你的数据科学之旅！🚀
