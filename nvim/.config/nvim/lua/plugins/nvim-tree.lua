return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvim_tree = require("nvim-tree")
    local api = require("nvim-tree.api")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function is_dap_ui_filetype(filetype)
      return vim.startswith(filetype, "dapui_") or filetype == "dap-repl" or filetype == "dap-terminal"
    end

    local function dap_ui_is_open()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
        if is_dap_ui_filetype(filetype) then
          return true
        end
      end
      return false
    end

    local function window_next_to_tree(tree_win)
      local tree_pos = vim.api.nvim_win_get_position(tree_win)
      local tree_col = tree_pos[2]
      local tree_right = tree_col + vim.api.nvim_win_get_width(tree_win)
      local tree_top = tree_pos[1]
      local tree_bottom = tree_top + vim.api.nvim_win_get_height(tree_win)
      local left_win, left_gap
      local right_win, right_gap

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
        if win ~= tree_win and filetype ~= "NvimTree" and not is_dap_ui_filetype(filetype)
            and vim.api.nvim_win_get_config(win).relative == "" then
          local pos = vim.api.nvim_win_get_position(win)
          local right = pos[2] + vim.api.nvim_win_get_width(win)
          local bottom = pos[1] + vim.api.nvim_win_get_height(win)
          local overlaps_tree = math.min(bottom, tree_bottom) > math.max(pos[1], tree_top)

          if overlaps_tree and right <= tree_col and tree_col - right <= 2
              and (not left_gap or tree_col - right < left_gap) then
            left_win, left_gap = win, tree_col - right
          end

          local gap = pos[2] - tree_right
          if overlaps_tree and gap >= 0 and gap <= 2 and (not right_gap or gap < right_gap) then
            right_win, right_gap = win, gap
          end
        end
      end

      -- Prefer the pane on the tree's left; if the tree is at the left edge,
      -- use its adjacent editor pane on the right.
      return left_win or right_win
    end

    nvim_tree.setup({
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_cwd = true,
        update_root = true,
      },
      on_attach = function(bufnr)
        api.map.on_attach.default(bufnr)
        vim.keymap.set("n", "<2-LeftMouse>", function()
          local node = api.tree.get_node_under_cursor()
          if not node then
            return
          end
          if node.type ~= "file" or not dap_ui_is_open() then
            api.node.open.edit(node)
            return
          end

          local target_win = window_next_to_tree(vim.api.nvim_get_current_win())
          if not target_win then
            vim.notify("No editor pane next to NvimTree is available", vim.log.levels.WARN)
            return
          end

          local path = node.link_to or node.absolute_path
          vim.api.nvim_win_call(target_win, function()
            vim.cmd("keepalt edit " .. vim.fn.fnameescape(path))
          end)
        end, { buffer = bufnr, noremap = true, silent = true, desc = "Open file in pane left of NvimTree during DAP" })
      end,
    })

    -- Toggle the tree with <leader>e
    vim.keymap.set("n", "<leader>e", function()
      api.tree.toggle({ find_file = true, update_root = true, focus = true })
    end, { noremap = true, silent = true })

    -- Open file in a vertical split with <leader>v
    vim.keymap.set("n", "<leader>v", function()
      api.node.open.vertical()
    end, { noremap = true, silent = true })

    -- Open file in a horizontal split with <leader>h
    vim.keymap.set("n", "<leader>h", function()
      api.node.open.horizontal()
    end, { noremap = true, silent = true })
  end,
}

