-- Floating terminal
return {
  {
    'voldikss/vim-floaterm',
    init = function()
      vim.g.floaterm_keymap_new    = '<leader>ts'
      vim.g.floaterm_keymap_prev   = '<leader>tp'
      vim.g.floaterm_keymap_next   = '<leader>tn'
      vim.g.floaterm_keymap_toggle = '<leader>tt'
    end,
    config = function()
      vim.keymap.set("n", "<F17>", "<cmd>FloatermNew<CR>", { silent = true, desc = "New floating terminal" })
      vim.keymap.set("i", "<F17>", "<ESC><cmd>FloatermNew<CR>", { silent = true, desc = "New floating terminal" })
      -- Use Kitty's palette for shell output, independently of the editor theme.
      local theme_path = vim.fn.expand('~/.config/kitty/current-theme.conf')
      local function kitty_colors()
        local colors = {}
        if vim.fn.filereadable(theme_path) == 1 then
          for _, line in ipairs(vim.fn.readfile(theme_path)) do
            local name, value = line:match('^%s*([%w_]+)%s+(#%x+)')
            if name then colors[name] = value end
          end
        end
        return colors
      end

      local function set_terminal_highlights()
        local colors = kitty_colors()
        if colors.foreground and colors.background then
          for _, group in ipairs({ 'Floaterm', 'FloatermNC' }) do
            vim.api.nvim_set_hl(0, group, {
              fg = colors.foreground, bg = colors.background,
            })
          end
        end
      end

      local group = vim.api.nvim_create_augroup('FloatermKittyColors', { clear = true })
      vim.api.nvim_create_autocmd('TermOpen', {
        group = group,
        callback = function(event)
          if vim.bo[event.buf].filetype ~= 'floaterm' then return end
          for name, value in pairs(kitty_colors()) do
            local index = name:match('^color(%d+)$')
            if index and tonumber(index) < 16 then
              vim.b[event.buf]['terminal_color_' .. index] = value
            end
          end
          set_terminal_highlights()
        end,
      })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = set_terminal_highlights,
      })
      set_terminal_highlights()

      --vim.api.nvim_create_autocmd('FileType', {
      --  pattern = 'python',
      --  callback = function()
      --    vim.keymap.set("n", "<F17>", "<cmd>FloatermNew<CR>", { silent = true, desc = "New floating terminal" })
      --    vim.keymap.set("i", "<F17>", "<ESC><cmd>FloatermNew<CR>", { silent = true, desc = "New floating terminal" })
      --  end
      --})
    end
  },
}
