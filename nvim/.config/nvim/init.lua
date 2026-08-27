-- Nvim plugins configuration, managed by lazy plugin manager.
--

--
require("config.lazy")		    -- Bootstrap lazy itself
require("config.options")	    -- Miscellaneous options
require("config.keybindings")	-- Miscellaneous options

vim.lsp.enable("pyright")

