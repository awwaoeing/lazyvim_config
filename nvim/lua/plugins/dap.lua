-- DAP (Debug Adapter Protocol) 调试配置
-- 提供强大的代码调试功能，支持断点、单步执行、变量查看等

return {
  -- DAP 核心插件
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI - 提供友好的调试界面
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          -- 仅自动打开 DAP UI，不自动关闭
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
        end,
      },

      -- 虚拟文本 - 在代码中直接显示变量值
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          only_first_definition = true,
          all_references = false,
          filter_references_pattern = "<module",
          virt_text_pos = "eol", -- 显示在行尾
          all_frames = false,
          virt_lines = false,
          virt_text_win_col = nil,
        },
      },

      -- Mason 集成 - 自动安装调试器
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason-org/mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = {
            "python", -- debugpy adapter (由 Mason 管理)
          },
        },
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function()
      local dap = require("dap")

      -- 设置断点图标
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "⚫", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "▶️", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
      )

      -- Python 调试配置
      -- Mason 会自动安装 debugpy adapter，不需要在项目中安装

      -- 🔧 辅助函数：自动检测虚拟环境的 Python 路径（支持 uv/venv/conda）
      -- 这个函数会被 adapter 和 configuration 复用
      local function get_python_path()
        local cwd = vim.fn.getcwd()

        -- 优先级 1: 项目本地虚拟环境 (.venv 或 venv)
        local venv_names = { ".venv", "venv" }
        for _, name in ipairs(venv_names) do
          local local_python = cwd .. "/" .. name .. "/bin/python"
          if vim.fn.executable(local_python) == 1 then
            return local_python
          end
        end

        -- 优先级 2: VIRTUAL_ENV 环境变量 (uv run 或手动激活)
        local venv = vim.env.VIRTUAL_ENV
        if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
          return venv .. "/bin/python"
        end

        -- 优先级 3: Conda 环境
        local conda = vim.env.CONDA_PREFIX
        if conda and vim.fn.executable(conda .. "/bin/python") == 1 then
          return conda .. "/bin/python"
        end

        -- 优先级 4: 系统 Python (最终回退)
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      -- debugpy adapter 配置
      -- Mason 会自动配置，但如果失败则使用下面的配置
      dap.adapters.python = dap.adapters.python
        or function(cb, config)
          if config.request == "attach" then
            -- Attach 模式：连接到已运行的 Python 进程
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or "127.0.0.1"
            cb({
              type = "server",
              port = assert(port, "`connect.port` is required for a python `attach` configuration"),
              host = host,
              options = {
                source_filetype = "python",
              },
            })
          else
            -- Launch 模式：使用 Mason 安装的 debugpy adapter
            cb({
              type = "executable",
              command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
              args = { "-m", "debugpy.adapter" },
            })
          end
        end

      -- Python 调试配置（被调试的程序使用项目虚拟环境）
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}", -- 当前文件
          pythonPath = get_python_path, -- 复用上面定义的函数
        },
      }
    end,
  },

  -- Python 专用调试扩展（用于调试 pytest 测试）
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Test Method", ft = "python" },
      { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Test Class", ft = "python" },
    },
    config = function()
      -- 复用虚拟环境检测逻辑（与上面的 nvim-dap 保持一致）
      local function get_python_path()
        local cwd = vim.fn.getcwd()
        local venv_names = { ".venv", "venv" }

        for _, name in ipairs(venv_names) do
          local local_python = cwd .. "/" .. name .. "/bin/python"
          if vim.fn.executable(local_python) == 1 then
            return local_python
          end
        end

        local venv = vim.env.VIRTUAL_ENV
        if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
          return venv .. "/bin/python"
        end

        local conda = vim.env.CONDA_PREFIX
        if conda and vim.fn.executable(conda .. "/bin/python") == 1 then
          return conda .. "/bin/python"
        end

        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      require("dap-python").setup(get_python_path())
    end,
  },
}
