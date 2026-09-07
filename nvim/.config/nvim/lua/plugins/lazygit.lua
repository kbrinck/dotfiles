return {
	'kdheepak/lazygit.nvim',
	lazy = true,
	cmd = {
		'LazyGit',
		'LazyGitConfig',
		'LazyGitCurrentFile',
		'LazyGitFilter',
		'LazyGitFilterCurrentFile',
	},
	depedencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		local keymap = vim.keymap

        keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", {
            desc = "Open LazyGit",
        })

        keymap.set("n", "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", {
            desc = "LazyGit current file",
        })
	end,
}

