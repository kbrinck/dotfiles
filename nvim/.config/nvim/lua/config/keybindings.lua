
--- Key binding to show nvim plugin files
---
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fp", function()
  builtin.find_files({
    cwd = vim.fn.stdpath("config") .. "/lua/plugins",
  })
end, { desc = "Find Neovim plugin files" })

--- Key binding to allow traversal in Telescope picker
---
vim.keymap.set("n", "<leader>fu", function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.stdpath("config"),
  })
end, { desc = "Browse Neovim config" })

--- Key binding to move to definitions et al using Telescope
---
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions()
end, { desc = "Go to definition" })

vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Find references" })

vim.keymap.set("n", "gi", function()
  require("telescope.builtin").lsp_implementations()
end, { desc = "Go to implementation" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, {
  desc = "Show documentation",
})
--- vim.keymap.set("n", "gd", function()
  --- vim.lsp.buf.definition()
--- end, { desc = "Go to definition" })
