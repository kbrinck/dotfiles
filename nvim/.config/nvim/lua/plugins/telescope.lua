-- Fuzzy search
return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim', { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	config = function()
		local telescope = require('telescope')

		telescope.setup({
			defaults = {
				path_display = { 'smart' },
			},
		})

		telescope.load_extension('fzf') -- Load fuzzy finder extension

		local opts = { noremap = true, silent = true }

		local keymap = vim.keymap
		local builtin = require('telescope.builtin')

		keymap.set('n', '<leader>tf', builtin.find_files, opts)
		keymap.set('n', '<leader>tg', builtin.live_grep, opts)
		keymap.set('n', '<leader>tgs', builtin.grep_string, opts)
		keymap.set('n', '<leader>tb', builtin.buffers, opts)
		keymap.set('n', '<leader>to', builtin.oldfiles, opts)
		keymap.set('n', '<leader>th', builtin.help_tags, opts)
	end,
}
