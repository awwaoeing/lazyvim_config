# Molten.nvim 图片显示说明

## 📊 当前环境的图片支持情况

你当前使用的终端环境**不支持直接在终端内显示图片**。但这不影响 Molten 的使用！

## ✅ 推荐的图片处理方案

### 方案 1: 保存图片到文件（最简单）

在你的 Python 代码中使用这种模式：

```python
import matplotlib
matplotlib.use('Agg')  # 使用非交互式后端
import matplotlib.pyplot as plt

# 你的绘图代码
plt.plot([1, 2, 3], [1, 4, 9])
plt.title('示例图表')

# 保存到文件
plt.savefig('output.png', dpi=150, bbox_inches='tight')
plt.close()

print('✅ 图片已保存到: output.png')
print('运行命令查看: open output.png')
```

**优点**:
- ✅ 在任何终端都能工作
- ✅ 可以保存高质量图片
- ✅ 可以分享和复用图片
- ✅ Molten 会在输出中显示保存路径

### 方案 2: 在 Molten 中查看文本输出

即使不能显示图片，Molten 会显示:
- ✅ 打印的文本输出
- ✅ 数据统计信息
- ✅ 图片保存的确认信息
- ✅ 错误信息和警告

**示例**:

```python
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 10, 100)
y = np.sin(x)

plt.figure(figsize=(10, 6))
plt.plot(x, y)
plt.savefig('sine_wave.png')
plt.close()

# Molten 会显示这些输出:
print(f'✅ 图片已保存')
print(f'📊 数据点数: {len(x)}')
print(f'📈 最大值: {y.max():.3f}')
print(f'📉 最小值: {y.min():.3f}')
```

### 方案 3: 使用支持图片的终端（高级用户）

如果你需要在终端内直接看到图片，可以安装以下终端之一：

#### 选项 A: Kitty (推荐)

```bash
# macOS 安装
brew install kitty

# 启动 Kitty
kitty

# 在 Kitty 中打开 Neovim
nvim
```

然后修改配置文件 `~/.config/nvim/lua/plugins/molten.lua`:
```lua
{
  "3rd/image.nvim",
  enabled = true,  -- 改为 true
  opts = {
    backend = "kitty",  -- 使用 kitty backend
    -- ...
  }
}
```

#### 选项 B: iTerm2 (macOS)

```bash
# 下载并安装 iTerm2
# https://iterm2.com/

# 安装 imgcat 工具
brew install imgcat
```

修改配置使用 iTerm2:
```lua
{
  "3rd/image.nvim",
  enabled = true,
  opts = {
    backend = "iterm2",
    -- ...
  }
}
```

#### 选项 C: WezTerm

```bash
# macOS 安装
brew install wezterm

# 启动 WezTerm
wezterm
```

## 🎯 推荐工作流

### 数据分析工作流（使用方案 1）

1. **探索数据**:
```python
import pandas as pd
df = pd.read_csv('data.csv')
print(df.head())       # ← Molten 显示数据
print(df.describe())   # ← Molten 显示统计
```

2. **可视化并保存**:
```python
import matplotlib.pyplot as plt

df.plot(kind='hist')
plt.savefig('histogram.png')
plt.close()
print('✅ 图表已保存')  # ← Molten 显示确认
```

3. **查看图片**:
```bash
# 在终端中运行
open histogram.png
# 或
qlmanage -p histogram.png
```

### 快速查看多个图表

创建一个辅助函数：

```python
import matplotlib.pyplot as plt
from pathlib import Path
import subprocess

def save_and_show(filename, dpi=150):
    """保存图片并用系统默认程序打开"""
    output = Path(filename)
    plt.savefig(output, dpi=dpi, bbox_inches='tight')
    plt.close()

    print(f'✅ 图片已保存: {output}')

    # 自动打开图片
    subprocess.run(['open', str(output)])

    return str(output)

# 使用示例
plt.plot([1, 2, 3], [1, 4, 9])
plt.title('示例')
save_and_show('my_plot.png')  # 自动保存并打开！
```

## 💡 实用技巧

### 技巧 1: 使用子图节省文件

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

axes[0, 0].plot(x1, y1)
axes[0, 1].scatter(x2, y2)
axes[1, 0].bar(categories, values)
axes[1, 1].hist(data)

plt.tight_layout()
plt.savefig('all_plots.png', dpi=200)
plt.close()

print('✅ 4 个图表保存在一个文件中')
```

### 技巧 2: 使用环境变量配置输出路径

```python
import os
from pathlib import Path

# 设置输出目录
OUTPUT_DIR = Path(os.getenv('PLOT_DIR', '~/plots')).expanduser()
OUTPUT_DIR.mkdir(exist_ok=True)

# 保存图片
output_file = OUTPUT_DIR / 'my_analysis.png'
plt.savefig(output_file)
print(f'✅ 保存到: {output_file}')
```

### 技巧 3: 查看 Molten 的文本输出

Molten 会显示:
- `print()` 输出
- 变量值
- 数据框的表格形式
- 错误信息
- 警告信息

**示例**:
```python
import pandas as pd
import numpy as np

# 创建数据
df = pd.DataFrame({
    'A': np.random.randn(5),
    'B': np.random.randn(5)
})

# Molten 会显示这个表格！
print(df)

# Molten 会显示统计信息！
print(df.describe())
```

## 📋 快速参考

### Molten 快捷键
| 按键 | 功能 |
|------|------|
| `<Space>mI` | 初始化 kernel |
| `<Space>mr` | 运行当前 cell |
| `<Space>ms` | 显示输出 |
| `<Space>mo` | 进入输出窗口 |

### macOS 图片查看命令
```bash
open image.png              # 用默认程序打开
qlmanage -p image.png       # 快速预览
open -a Preview image.png   # 用预览打开
```

## 🎯 测试文件

我已经为你创建了测试文件:

```bash
# 使用保存图片的 notebook
nvim ~/test_molten_save_images.ipynb
```

运行步骤:
1. `<Space>mI` - 初始化
2. `<Space>mr` - 运行 cell 1（设置 matplotlib）
3. `]c` 然后 `<Space>mr` - 运行 cell 2（创建并保存图片）
4. 输出会告诉你图片保存的位置
5. 在终端运行 `open ~/plot_output.png` 查看图片！

## 🎨 总结

虽然当前终端不能**直接显示**图片，但你仍然可以：

✅ 在 Molten 中交互式运行代码
✅ 看到所有文本输出（数据、统计、确认信息）
✅ 保存高质量图片到文件
✅ 用系统程序查看图片
✅ 享受 Jupyter notebook 的便利性

这种工作流实际上在很多场景下**更实用**，因为你得到的是可以保存、分享的图片文件！
