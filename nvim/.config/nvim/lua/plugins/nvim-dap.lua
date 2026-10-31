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
      vim.keymap.set("n", "<F6>", function()
        require("dap").toggle_breakpoint()
      end, { noremap = true, silent = true, desc = "DAP: Toggle breakpoint" })
      local function toggle_dapui()
        require("dapui").toggle()
      end
      vim.keymap.set("n", "<C-F5>", toggle_dapui, { noremap = true, silent = true, desc = "DAP: Toggle UI" })
      vim.keymap.set("n", "<F29>", toggle_dapui, { noremap = true, silent = true, desc = "DAP: Toggle UI (terminal Ctrl-F5)" })

      local dapui = require("dapui")
      local dap_python = require("dap-python")

      -- Keep launch arguments in the project directory and expose them through fzf.
      local function args_history_file(run_dir)
        return vim.fs.joinpath(run_dir or vim.fn.getcwd(), "nvdap-history")
      end

      local function read_args_history(run_dir)
        local path = args_history_file(run_dir)
        return vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}
      end

      local function remember_args(value, run_dir)
        local path = args_history_file(run_dir)
        local history = read_args_history(run_dir)
        for _, previous in ipairs(history) do
          if previous == value then return end
        end
        table.insert(history, 1, value)
        vim.fn.writefile(history, path)
      end

      local function promote_args(value, run_dir)
        local path = args_history_file(run_dir)
        local history = read_args_history(run_dir)
        for i = #history, 1, -1 do
          if history[i] == value then table.remove(history, i) end
        end
        table.insert(history, 1, value)
        vim.fn.writefile(history, path)
      end

      local enter_new_args = "Enter new arguments..."

      local function split_args(value)
        return vim.split(vim.trim(value), "%s+", { trimempty = true })
      end

      local function history_args()
        return coroutine.create(function(dap_co)
          local run_dir = vim.fn.getcwd()
          local choices = read_args_history(run_dir)
          table.insert(choices, enter_new_args)

          local function finish(args)
            vim.schedule(function()
              local ok, err = coroutine.resume(dap_co, args)
              if not ok then vim.notify(err, vim.log.levels.ERROR) end
            end)
          end

          require("fzf-lua").fzf_exec(choices, {
            prompt = "Run arguments> ",
            actions = {
              ["default"] = function(selected)
                if not selected or not selected[1] then
                  finish(dap.ABORT)
                  return
                end

                local value = selected[1]
                if value == enter_new_args then
                  value = vim.trim(vim.fn.input("Program arguments: "))
                  if value ~= "" then remember_args(value, run_dir) end
                else
                  promote_args(value, run_dir)
                end
                finish(split_args(value))
              end,
              ["esc"] = function()
                finish(dap.ABORT)
              end,
            },
          })
          coroutine.yield()
        end)
      end

      --- Set Key bindings
      local function continue_debug()
        if vim.bo.filetype == "NvimTree" then
          local tree_api = require("nvim-tree.api")
          local node = tree_api.tree.get_node_under_cursor()
          if not node or node.type ~= "file" or vim.filetype.match({ filename = node.absolute_path }) ~= "python" then
            vim.notify("Select a Python file in NvimTree before starting the debugger", vim.log.levels.INFO)
            return
          end
          tree_api.node.open.edit(node, { focus = false })
          vim.schedule(function() dap.continue() end)
          return
        end
        dap.continue()
      end

      vim.keymap.set("n", "<F5>", continue_debug)
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

      dapui.setup({
        layouts = {
          {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40,
            position = "right",
          },
          {
            elements = { "console" },
            size = 100,
            position = "right",
          },
          {
            elements = { "repl" },
            size = 10,
            position = "bottom",
          },
        },
      })
      require("nvim-dap-virtual-text").setup({
        commented = true, -- Show virtual text alongside comment
      })

      local python, project_root = find_venv()

      -- Rebuild the Python list so repeated setup/reloads do not leave stale entries.
      dap.configurations.python = {}

      -- Start the adapter with system Python, where debugpy is installed;
      -- the project interpreter is used only for the program being debugged.
      dap_python.setup("python3")

      local history_run_root = "/home/keith/Dev/injuries/main"

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Select from history",
        module = "main",
        cwd = history_run_root,
        pythonPath = vim.fs.joinpath(history_run_root, ".venv", "bin", "python"),
        env = { PYTHONPATH = vim.fs.joinpath(history_run_root, "src") },
        console = "integratedTerminal",
        args = history_args,
      })

      local launch_json_configs = dap.providers.configs["dap.launch.json"]
      dap.providers.configs["dap.launch.json"] = function(bufnr)
        local configs = launch_json_configs(bufnr)
        return vim.tbl_filter(function(config)
          return config.type ~= "python" and config.type ~= "debugpy"
        end, configs)
      end

      for _, config in ipairs(dap.configurations.python or {}) do
        -- The history config owns its async picker; other built-ins use the shared prompt.
        if config.name ~= "Select from history" then config.args = nil end
        if project_root and config.name ~= "Select from history" then
          config.cwd = project_root
          config.pythonPath = python
          config.env = config.env or {}
          config.env.PYTHONPATH = project_root .. "/src"
        end

      end

      -- Also cover Python launch configs selected from project launch.json files.
      dap.listeners.on_config["nvdap_prompt_args"] = function(config)
        if (config.type == "python" or config.type == "debugpy") and config.request == "launch" then
          if config.args == nil then
            local input = vim.trim(vim.fn.input("Program arguments: "))
            if input ~= "" then remember_args(input, vim.fn.getcwd()) end
            config.args = split_args(input)
          elseif type(config.args) == "string" then
            config.args = split_args(config.args)
          end

          -- Files under src/ must run as modules for relative imports to work.
          local program = config.program
          if program == "${file}" then program = vim.api.nvim_buf_get_name(0) end
          if type(program) == "string" and program:sub(-3) == ".py" then
            local run_root = config.cwd or project_root or vim.fn.getcwd()
            local src_prefix = vim.fs.joinpath(run_root, "src") .. "/"
            if vim.startswith(program, src_prefix) then
              config.module = program:sub(#src_prefix + 1):gsub("%.py$", ""):gsub("[/\\]", ".")
              config.program = nil
            end
          end
        end
        return config
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
      vim.keymap.set("n", "<leader>dc", continue_debug, opts)

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

