# Jupyter-Vim 快速开始指南

## 🚀 使用步骤

### 第 1 步：启动 Jupyter Console

打开终端，激活 conda 环境并启动 Jupyter console：

```bash
conda activate myenv
jupyter console
```

你会看到类似这样的输出：

```
Jupyter console 6.6.3

Python 3.12.12 (main, Sep 11 2024, 06:58:41) [Clang 15.0.0 (clang-1500.0.40.1)]
Type 'copyright', 'credits' or 'license' for more information
IPython 8.18.1 -- An enhanced Interactive Python. Type '?' for help.

In [1]:
```

**重要**：记下连接文件的位置。你可以运行以下命令查看：

```python
In [1]: %connect_info
```

输出类似：

```
{
  "shell_port": 54321,
  "iopub_port": 54322,
  ...
  "kernel_name": "python3",
  "signature_scheme": "hmac-sha256",
  "key": "xxxxx"
}

Paste the above JSON into a file, and connect with:
    $> jupyter <app> --existing <file>
or, if you are local, you can connect with just:
    $> jupyter <app> --existing kernel-12345.json
try:
    $> jupyter console --existing kernel-12345.json
```

kernel 文件通常在：`~/.local/share/jupyter/runtime/kernel-xxxxx.json`

### 第 2 步：创建测试 Python 文件

打开另一个终端，创建测试文件：

```bash
cd ~
cat > test_jupyter.py << 'EOF'
# %%
# 这是第一个 cell
import numpy as np
print("Hello from Jupyter!")
print(f"NumPy version: {np.__version__}")

# %%
# 这是第二个 cell
x = np.array([1, 2, 3, 4, 5])
print(f"Array: {x}")
print(f"Sum: {x.sum()}")
print(f"Mean: {x.mean()}")

# %%
# 这是第三个 cell
import matplotlib.pyplot as plt
y = x ** 2
print(f"Squared: {y}")
EOF

nvim test_jupyter.py
```

### 第 3 步：在 Neovim 中连接到 Jupyter

在 Neovim 中（已打开 `test_jupyter.py`）：

1. **连接到 Jupyter kernel**：
   - 按 `\` + `j` + `c`（即 `<localleader>jc`）
   - 或输入命令：`:JupyterConnect`

2. **输入 kernel 文件路径**：
   - 如果提示输入路径，输入类似：

     ```
     ~/.local/share/jupyter/runtime/kernel-12345.json
     ```

   - 或者直接输入 kernel 名称（如果在同一台机器上）

3. **连接成功提示**：
   - 你应该看到类似 "Connected to kernel" 的消息

### 第 4 步：运行代码

现在你可以运行代码了！

#### 方法 1：运行选中的代码（最常用）

1. 进入**可视模式**（按 `v`）
2. 选中你想运行的代码（例如第一个 cell 的所有行）
3. 按 `\` + `w`（即 `<localleader>w`）

代码会发送到 Jupyter console，你可以在 console 中看到输出！

#### 方法 2：运行整个文件

- 按 `\` + `e`（即 `<localleader>e`）

#### 方法 3：运行当前 cell

- 按 `\` + `c`（即 `<localleader>c`）

#### 方法 4：使用 IPython Cell 功能

- `<leader>cr` （即 `Space` + `c` + `r`）- 运行当前 cell
- `[c` - 跳转到上一个 cell
- `]c` - 跳转到下一个 cell

## 📝 完整的快捷键列表

### 连接管理

- `\jc` - 连接到 Jupyter kernel
- `\jd` - 断开连接

### 运行代码（jupyter-vim）

- `\w` (可视模式) - **运行选中的代码** ⭐ 最常用
- `\e` - 运行整个文件
- `\r` - 运行当前行/文本对象
- `\c` - 运行当前 cell

### Cell 操作（vim-ipython-cell）

- `<Space>cr` - 运行当前 cell
- `<Space>cc` - 执行当前 cell
- `<Space>cC` - 执行 cell 并跳转到下一个
- `[c` - 跳到上一个 cell
- `]c` - 跳到下一个 cell
- `<Space>cl` - 清除 IPython 输出

### REPL 操作（vim-repl）

- `<Space>rt` - 打开/关闭 REPL 窗口
- `<Space>rr` - 发送当前行到 REPL
- `<Space>rs` (可视模式) - 发送选中内容到 REPL

## 💡 实用技巧

### 技巧 1：快速工作流

```
1. 启动 Jupyter console (终端 1)
2. 打开 Python 文件 (终端 2 的 nvim)
3. 连接 kernel (\jc)
4. 选中代码 → 按 \w → 查看 console 输出
```

### 技巧 2：调试代码

在代码中想调试的地方按 `\b` 可以设置断点（会插入 `import pdb; pdb.set_trace()`）

### 技巧 3：使用 Cell 分隔符

在代码中使用 `# %%` 来分隔不同的代码块，这样可以：

- 用 `[c` 和 `]c` 快速在 cell 之间跳转
- 用 `<Space>cr` 运行单个 cell

### 技巧 4：查看变量

在 Jupyter console 中可以查看变量：

```python
In [2]: x
Out[2]: array([1, 2, 3, 4, 5])

In [3]: type(x)
Out[3]: numpy.ndarray
```

## 🔧 常见问题

### Q1: 按 `\jc` 没反应？

**A**: 检查：

1. 文件是否是 `.py` 结尾？
2. 运行 `:messages` 查看错误信息
3. 确认插件已安装：`:Lazy` 界面中查看 `jupyter-vim`

### Q2: 连接失败？

**A**:

1. 确保 Jupyter console 正在运行
2. 检查 kernel 文件路径是否正确
3. 尝试在 Jupyter console 中运行 `%connect_info`

### Q3: 代码运行后没输出？

**A**:

1. 检查 Jupyter console 窗口
2. 输出会在 console 中显示，不是在 Neovim 中
3. 如果想在 Neovim 中看到输出，使用 vim-repl

### Q4: 如何找到 kernel 文件？

**A**:

```bash
# 方法 1: 在 Jupyter console 中
%connect_info

# 方法 2: 在终端中查找
ls ~/.local/share/jupyter/runtime/kernel-*.json

# 方法 3: 使用最新的 kernel
ls -lt ~/.local/share/jupyter/runtime/kernel-*.json | head -1
```

## 🎯 快速测试

运行这个快速测试确认一切正常：

```bash
# 终端 1：启动 Jupyter
conda activate myenv
jupyter console

# 终端 2：测试
cd ~
echo '# %%
print("Hello from Jupyter-Vim!")
import sys
print(f"Python: {sys.version}")
' > quick_test.py

nvim quick_test.py
```

在 Neovim 中：

1. 按 `\jc` 连接
2. 按 `V` 选中第一行
3. 按 `jjj` 选中多行
4. 按 `\w` 运行
5. 查看 Jupyter console 的输出！

## 📚 更多帮助

- 查看详细文档：`cat ~/.config/nvim/JUPYTER_SETUP.md`
- Jupyter-vim GitHub: <https://github.com/jupyter-vim/jupyter-vim>
- 如有问题，运行 `:messages` 查看错误日志
