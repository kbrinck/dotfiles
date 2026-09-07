return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
	  "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      --- Set Key bindings
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)

      --- Find the python environment to use
      
      local function find_venv()
        local file = vim.api.nvim_buf_get_name(0)
  
        if file == "" then
          return nil, nil
        end
  
        local dir = vim.fs.dirname(file)
  
        while dir do
          local python = dir .. "/.venv/bin/python"
  
          if vim.fn.executable(python) == 1 then
            return python, dir
          end
  
          local parent = vim.fs.dirname(dir)
          if parent == dir then
            break
          end
          dir = parent
        end
  
        return nil, nil
      end

      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({
        commented = true, -- Show virtual text alongside comment
      })

      local python, project_root = find_venv()

      if python then
        dap_python.setup(python)
  
        for _, config in ipairs(dap.configurations.python) do
          config.cwd = project_root
          --- KB delete? config.pythonPath = python
  
          config.env = config.env or {}
          config.env.PYTHONPATH = project_root .. "/src"
        end
      end

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "", -- or "❌"
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "", -- or "→"
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      local opts = { noremap = true, silent = true }

      -- Toggle breakpoint
      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, opts)

      -- Continue / Start
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, opts)

      -- Step Over
      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, opts)

      -- Step Into
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, opts)

      -- Step Out
      vim.keymap.set("n", "<leader>dO", function()
        dap.step_out()
      end, opts)
			
      -- Keymap to terminate debugging
	  vim.keymap.set("n", "<leader>dq", function()
	      require("dap").terminate()
      end, opts)

      -- Toggle DAP UI
      vim.keymap.set("n", "<leader>du", function()
        dapui.toggle()
      end, opts)
    end,
  },
}

