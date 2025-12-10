-- Jupyter-vim 配置
-- 从 ~/my-config/.vimrc 迁移
-- 用于在 Vim 中与 Jupyter Console/Kernel 交互

return {
  -- jupyter-vim: 主插件，用于与 Jupyter kernel 交互
  {
    "jupyter-vim/jupyter-vim",
    ft = { "python", "julia", "rust", "r" }, -- 仅在这些文件类型时加载
    dependencies = {
      "nvim-lua/plenary.nvim", -- 依赖库
    },
    config = function()
      -- 基本配置
      vim.g.jupyter_mapkeys = 1 -- 启用默认键位映射
      vim.g.jupyter_auto_connect = 0 -- 不自动连接到 kernel
      vim.g.jupyter_highlight_cells = 1 -- 高亮 Jupyter cells
      vim.g.jupyter_cell_separators = { "##", "#%%", "# %%", "# <codecell>" }
      vim.g.jupyter_verbose = 1 -- 启用详细日志输出（用于调试）

      -- 关键配置：启用 jupyter-vim 命令
      vim.g.jupytervim_enable_commands = 1

      -- Python 解释器路径 - 自动检测虚拟环境（支持 uv）
      -- 按优先级查找：项目 .venv -> VIRTUAL_ENV -> Conda -> 系统 Python
      local function get_python_path()
        -- 优先级 1: 项目本地虚拟环境（uv venv 创建的 .venv）
        local cwd = vim.fn.getcwd()
        local venv_names = { ".venv", "venv" }
        for _, name in ipairs(venv_names) do
          local local_python = cwd .. "/" .. name .. "/bin/python"
          if vim.fn.executable(local_python) == 1 then
            return local_python
          end
        end

        -- 优先级 2: VIRTUAL_ENV 环境变量（uv run 或手动激活虚拟环境）
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          local venv_python = venv .. "/bin/python"
          if vim.fn.executable(venv_python) == 1 then
            return venv_python
          end
        end

        -- 优先级 3: Conda 环境（如果在激活的 conda 环境中）
        local conda_env = vim.env.CONDA_PREFIX
        if conda_env then
          local conda_python = conda_env .. "/bin/python"
          if vim.fn.executable(conda_python) == 1 then
            return conda_python
          end
        end

        -- 优先级 4: 系统默认 Python
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      vim.g.jupytervim_python_path = get_python_path()

      -- Jupyter kernel 连接文件路径（可选）
      -- 如果需要连接到特定 kernel，取消下面这行的注释并设置路径
      -- vim.g.jupyter_kernel_path = "/path/to/kernel-xxxxx.json"
    end,
    keys = {
      -- 基本操作键位映射
      -- 从原配置: vmap <buffer> <silent> <localleader>w <Plug>JupyterRunVisual
      {
        "<localleader>w",
        "<Plug>JupyterRunVisual",
        mode = "v",
        ft = "python",
        desc = "运行选中的代码块到 Jupyter Console",
      },
      {
        "<localleader>e",
        "<Plug>JupyterRunFile",
        mode = "n",
        ft = "python",
        desc = "运行整个文件到 Jupyter",
      },
      {
        "<localleader>r",
        "<Plug>JupyterRunTextObj",
        mode = "n",
        ft = "python",
        desc = "运行文本对象到 Jupyter",
      },
      {
        "<localleader>c",
        "<Plug>JupyterRunCell",
        mode = "n",
        ft = "python",
        desc = "运行当前 cell",
      },
      {
        "<localleader>I",
        ":PythonImportThisFile<CR>",
        mode = "n",
        ft = "python",
        desc = "导入当前文件到 Jupyter",
        silent = true,
      },
      {
        "<localleader>b",
        ":PythonSetBreak<CR>",
        mode = "n",
        ft = "python",
        desc = "设置 Python 断点",
        silent = true,
      },
      -- 连接和管理 Jupyter kernel
      {
        "<localleader>jc",
        ":JupyterConnect<CR>",
        mode = "n",
        desc = "连接到 Jupyter kernel",
        silent = true,
      },
      {
        "<localleader>jd",
        ":JupyterDisconnect<CR>",
        mode = "n",
        desc = "断开 Jupyter kernel 连接",
        silent = true,
      },
    },
  },

  -- vim-slime: 用于发送代码到 REPL (可选，与 jupyter-vim 配合使用)
  {
    "jpalardy/vim-slime",
    ft = "python",
    config = function()
      -- 配置 slime 使用 tmux 作为目标
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = {
        socket_name = "default",
        target_pane = "{last}",
      }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_python_ipython = 1
    end,
  },

  -- vim-ipython-cell: 提供类似 Jupyter Notebook 的 cell 执行功能
  {
    "hanschen/vim-ipython-cell",
    ft = "python",
    dependencies = { "jpalardy/vim-slime" },
    config = function()
      -- cell 分隔符标记
      vim.g.ipython_cell_delimit_cells_by = "tags" -- 使用标记方式
      vim.g.ipython_cell_tag = { "##", "#%%", "# %%", "# <codecell>" }
    end,
    keys = {
      {
        "<leader>cr",
        ":IPythonCellRun<CR>",
        mode = "n",
        ft = "python",
        desc = "运行当前 cell",
        silent = true,
      },
      {
        "<leader>cR",
        ":IPythonCellRunTime<CR>",
        mode = "n",
        ft = "python",
        desc = "运行当前 cell 并计时",
        silent = true,
      },
      {
        "<leader>cc",
        ":IPythonCellExecuteCell<CR>",
        mode = "n",
        ft = "python",
        desc = "执行当前 cell",
        silent = true,
      },
      {
        "<leader>cC",
        ":IPythonCellExecuteCellJump<CR>",
        mode = "n",
        ft = "python",
        desc = "执行当前 cell 并跳转到下一个",
        silent = true,
      },
      {
        "<leader>cl",
        ":IPythonCellClear<CR>",
        mode = "n",
        ft = "python",
        desc = "清除 IPython 输出",
        silent = true,
      },
      {
        "<leader>cx",
        ":IPythonCellClose<CR>",
        mode = "n",
        ft = "python",
        desc = "关闭所有图形窗口",
        silent = true,
      },
      {
        "[c",
        ":IPythonCellPrevCell<CR>",
        mode = "n",
        ft = "python",
        desc = "跳转到上一个 cell",
        silent = true,
      },
      {
        "]c",
        ":IPythonCellNextCell<CR>",
        mode = "n",
        ft = "python",
        desc = "跳转到下一个 cell",
        silent = true,
      },
    },
  },

  -- vim-repl: 通用 REPL 支持（从原配置迁移）
  {
    "sillybun/vim-repl",
    ft = { "python", "cpp", "lua", "javascript", "julia" },
    config = function()
      -- REPL 窗口位置和大小
      vim.g.repl_position = 3 -- 0: 底部, 1: 顶部, 2: 左侧, 3: 右侧
      vim.g.repl_width = 80 -- 窗口宽度（当位置为左/右时）
      vim.g.repl_height = 15 -- 窗口高度（当位置为上/下时）

      -- 发送到 REPL 后是否自动执行
      vim.g.repl_auto_sends = { "class ", "def ", "for ", "if ", "elif " }

      -- 退出 REPL 时关闭窗口
      vim.g.repl_exit_commands = { "quit()", "exit()", ":q" }

      -- 不同语言的 REPL 程序设置
      -- Python 自动检测虚拟环境（支持 uv）
      local function get_python_repl()
        local cwd = vim.fn.getcwd()

        -- 优先级 1: 项目虚拟环境
        local venv_names = { ".venv", "venv" }
        for _, name in ipairs(venv_names) do
          local venv_python = cwd .. "/" .. name .. "/bin/python"
          if vim.fn.executable(venv_python) == 1 then
            return venv_python
          end
        end

        -- 优先级 2: VIRTUAL_ENV 环境变量
        if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
          return vim.env.VIRTUAL_ENV .. "/bin/python"
        end

        -- 优先级 3: Conda 环境
        if vim.env.CONDA_PREFIX and vim.fn.executable(vim.env.CONDA_PREFIX .. "/bin/python") == 1 then
          return vim.env.CONDA_PREFIX .. "/bin/python"
        end

        -- 优先级 4: 系统 Python
        return "python3"
      end

      vim.g.repl_program = {
        python = get_python_repl(),
        cpp = "/snap/bin/cling", -- 从原配置中的 cling REPL
        default = "bash",
      }

      -- 输出到 REPL 的选项
      vim.g.repl_cursor_down = 1 -- 发送后光标下移
      vim.g.repl_python_automerge = 1 -- Python 自动合并多行
      vim.g.repl_ipython_version = "7" -- IPython 版本
    end,
    keys = {
      -- 打开/关闭 REPL
      { "<leader>rt", ":REPLToggle<CR>", desc = "切换 REPL 窗口" },
      -- 发送当前行到 REPL
      { "<leader>rr", "<Plug>ReplSendLine", mode = "n", desc = "发送当前行到 REPL" },
      -- 发送选中内容到 REPL
      { "<leader>rs", "<Plug>ReplSendVisual", mode = "v", desc = "发送选中内容到 REPL" },
      -- 发送整个文件到 REPL
      { "<leader>rf", "ggVG<Plug>ReplSendVisual", mode = "n", desc = "发送整个文件到 REPL" },
    },
  },
}
