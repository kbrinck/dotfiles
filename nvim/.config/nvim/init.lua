-- Nvim plugins configuration, managed by lazy plugin manager.
--

--
require("config.lazy")		    -- Bootstrap lazy itself
require("config.options")	    -- Miscellaneous options
require("config.keybindings")	-- Misc keybinds
require("config.show_keybinds")	-- Pop up a window showing keybindings

vim.lsp.enable("pyright")

