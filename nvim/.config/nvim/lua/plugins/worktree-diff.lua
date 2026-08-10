
return {
  {
    dir = vim.fn.stdpath("config"),
    name = "worktree-diff",

    config = function()
      -- Find the root of the current worktree.
      local function current_worktree()
        local file = vim.fn.expand("%:p")

        if file == "" then
          return nil
        end

        local result = vim.fn.systemlist({
          "git",
          "-C",
          vim.fn.fnamemodify(file, ":h"),
          "rev-parse",
          "--show-toplevel",
        })

        if vim.v.shell_error ~= 0 or #result == 0 then
          return nil
        end

        return result[1]
      end

      -- Return:
      --
      --   branch name -> worktree path
      --
      local function get_worktrees(root)
        local lines = vim.fn.systemlist({
          "git",
          "-C",
          root,
          "worktree",
          "list",
          "--porcelain",
        })

        if vim.v.shell_error ~= 0 then
          return {}
        end

        local trees = {}
        local path = nil

        for _, line in ipairs(lines) do
          local worktree = line:match("^worktree (.+)$")

          if worktree then
            path = worktree
          end

          local branch = line:match("^branch refs/heads/(.+)$")

          if branch and path then
            trees[branch] = path
            path = nil
          end
        end

        return trees
      end

      vim.api.nvim_create_user_command("WorktreeDiff", function(opts)
        local current = vim.fn.expand("%:p")
        local root = current_worktree()

        if not root then
          vim.notify(
            "Current file is not in a Git worktree",
            vim.log.levels.ERROR
          )
          return
        end

        local trees = get_worktrees(root)
        local target_root = trees[opts.args]

        if not target_root then
          local names = {}

          for name in pairs(trees) do
            table.insert(names, name)
          end

          table.sort(names)

          vim.notify(
            "Worktree not found: " .. opts.args
              .. "\nAvailable: " .. table.concat(names, ", "),
            vim.log.levels.ERROR
          )
          return
        end

        -- Path relative to the current worktree.
        local relative = current:sub(#root + 2)

        -- Corresponding file in the target worktree.
        local target = target_root .. "/" .. relative

        if vim.fn.filereadable(target) == 0 then
          vim.notify(
            "File does not exist in " .. opts.args .. ":\n" .. target,
            vim.log.levels.ERROR
          )
          return
        end

        vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(target))
      end, {
        nargs = 1,
        desc = "Diff current file against another Git worktree",

        complete = function()
          local root = current_worktree()

          if not root then
            return {}
          end

          local result = {}

          for name in pairs(get_worktrees(root)) do
            table.insert(result, name)
          end

          table.sort(result)

          return result
        end,
      })

      -- <leader>wd = Diff against another Git worktree.
      vim.keymap.set("n", "<leader>wd", ":WorktreeDiff ", {
        desc = "Diff against Git worktree",
      })
    end,
  },
}
