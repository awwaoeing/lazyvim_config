# iTerm2 图片显示配置

## ✅ 已完成的配置

Molten.nvim 已配置为使用 iTerm2 的图片协议。

## 🎯 使用步骤

### 1. 在 iTerm2 应用中运行

**重要**：必须在 iTerm2 应用中，不是其他终端或 IDE 的内置终端。

```bash
# 打开 iTerm2 应用
# 在 iTerm2 中运行：
cd ~
nvim test_molten.ipynb
```

### 2. 初始化并运行

```
<Space>mI     # 初始化 kernel
<Space>mr     # 运行当前 cell
```

### 3. 图片应该显示在输出区域

当你运行包含 matplotlib/plotly 等的代码时：
- ✅ 图片会直接渲染在 Neovim 的输出窗口
- ✅ 可以按 `<Space>mo` 进入输出窗口查看
- ✅ 可以按 `<Space>mp` 放大图片

## 🔧 iTerm2 设置检查

如果图片不显示，检查以下设置：

### 检查 1: iTerm2 版本

需要 iTerm2 3.0+ 版本。

```bash
# 在 iTerm2 中运行
# 查看版本: iTerm2 → About iTerm2
```

### 检查 2: 内联图片设置

1. 打开 iTerm2 偏好设置（⌘ + ,）
2. 进入 **Profiles → Terminal**
3. 确保 **Enable inline images** 已勾选

### 检查 3: 测试 iTerm2 图片支持

在 iTerm2 终端中运行这个测试：

```bash
# 创建测试图片
python3 << 'EOF'
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 10, 100)
y = np.sin(x)

plt.figure(figsize=(8, 6))
plt.plot(x, y, 'b-', linewidth=2)
plt.title('Sin Wave Test')
plt.savefig('/tmp/test_iterm.png', dpi=150)
plt.close()
print('图片已保存到: /tmp/test_iterm.png')
EOF

# 使用 iTerm2 的 imgcat 查看图片
# 如果没有 imgcat，安装它：
# curl -L https://iterm2.com/utilities/imgcat -o /usr/local/bin/imgcat
# chmod +x /usr/local/bin/imgcat

# 或者直接用内置方法：
printf '\033]1337;File=inline=1:'$(base64 < /tmp/test_iterm.png)'\a\n'
```

如果上面的命令能显示图片，说明 iTerm2 支持正常。

## 🎨 image.nvim 的工作原理

在 iTerm2 中，`image.nvim` 使用 iTerm2 的内联图片协议：

```
1. Molten 运行代码生成图片
2. image.nvim 检测到图片输出
3. 使用 iTerm2 协议将图片编码并发送
4. iTerm2 在终端内渲染图片
5. 你在 Neovim 中直接看到图片！
```

## 🐛 故障排除

### 问题 1: 图片不显示，只显示文本

**可能原因**：
- 不在真正的 iTerm2 应用中
- iTerm2 版本太旧
- 内联图片未启用

**解决方案**：
1. 确保在 iTerm2 应用中运行
2. 更新 iTerm2 到最新版本
3. 检查设置中的 "Enable inline images"

### 问题 2: 图片显示位置错误

**解决方案**：
- 按 `<Space>mo` 进入输出窗口
- 使用 `j/k` 滚动查看

### 问题 3: 图片太大或太小

**解决方案**：

修改 `~/.config/nvim/lua/plugins/molten.lua` 中的设置：

```lua
vim.g.molten_output_win_max_height = 30  -- 增加输出窗口高度
```

或在 Python 代码中控制图片大小：

```python
plt.figure(figsize=(10, 6))  # 调整图片尺寸
```

## 📝 推荐的 matplotlib 配置

在 notebook 开头添加：

```python
# Cell 1: 配置
import matplotlib.pyplot as plt
import numpy as np

# 设置默认图片大小
plt.rcParams['figure.figsize'] = (10, 6)
plt.rcParams['figure.dpi'] = 100

# 设置样式
plt.style.use('default')  # 或 'seaborn', 'ggplot' 等

print('✅ Matplotlib 配置完成')
```

## 🎯 完整的测试示例

创建这个 notebook 并在 iTerm2 中测试：

```python
# Cell 1: 导入库
import matplotlib.pyplot as plt
import numpy as np
print('✅ 库导入成功')

# Cell 2: 简单绘图
x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)

plt.figure(figsize=(10, 6))
plt.plot(x, y, 'b-', linewidth=2, label='sin(x)')
plt.plot(x, np.cos(x), 'r--', linewidth=2, label='cos(x)')
plt.title('三角函数', fontsize=16)
plt.xlabel('x', fontsize=12)
plt.ylabel('y', fontsize=12)
plt.legend(fontsize=12)
plt.grid(True, alpha=0.3)
plt.show()

print('📊 图片应该显示在上方')

# Cell 3: 多子图
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# 子图 1
axes[0, 0].plot(x, x**2, 'g-')
axes[0, 0].set_title('y = x²')
axes[0, 0].grid(True, alpha=0.3)

# 子图 2
axes[0, 1].scatter(x, np.random.randn(len(x)), alpha=0.5)
axes[0, 1].set_title('随机散点')
axes[0, 1].grid(True, alpha=0.3)

# 子图 3
categories = ['A', 'B', 'C', 'D', 'E']
values = [23, 45, 56, 78, 32]
axes[1, 0].bar(categories, values, color='skyblue')
axes[1, 0].set_title('柱状图')

# 子图 4
data = np.random.randn(1000)
axes[1, 1].hist(data, bins=30, color='orange', alpha=0.7)
axes[1, 1].set_title('正态分布')

plt.tight_layout()
plt.show()

print('📊 4 个子图应该显示在上方')
```

## 🚀 快速测试命令

在 iTerm2 中运行：

```bash
# 1. 启动 Neovim
nvim ~/test_molten.ipynb

# 2. 在 Neovim 中:
# <Space>mI  - 初始化
# <Space>mr  - 运行
#
# 图片应该直接显示！
```

## 📚 相关资源

- [iTerm2 Inline Images Documentation](https://iterm2.com/documentation-images.html)
- [image.nvim GitHub](https://github.com/3rd/image.nvim)
- [Molten.nvim GitHub](https://github.com/benlubas/molten-nvim)

## 💡 提示

如果 iTerm2 中图片显示工作正常，你就可以：
- 实时看到数据可视化
- 调试绘图代码更方便
- 享受类似 Jupyter Notebook 的体验
- 但仍然在 Vim 中编辑！