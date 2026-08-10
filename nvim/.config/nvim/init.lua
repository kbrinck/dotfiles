-- Nvim plugins configuration, managed by lazy plugin manager.
--

--
require("config.lazy")		-- Bootstrap lazy itself
require("config.options")	-- Miscellaneous options

vim.opt.termguicolors = true
vim.cmd.colorscheme("gvim")
