
--- Key binding to show nvim plugin files
---
local builtin = require("telescope.builtin")

---vim.keymap.set("n", "<leader>npf", function()
---  builtin.find_files({
---    cwd = vim.fn.stdpath("config") .. "/lua/plugins",
---  })
---end, { desc = "Find Neovim plugin files" })

--- Key binding to allow traversal in Telescope picker
---
---vim.keymap.set("n", "<leader>bnc", function()
---  require("telescope").extensions.file_browser.file_browser({
---    path = vim.fn.stdpath("config"),
---  })
---end, { desc = "Browse Neovim config" })

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

vim.keymap.set("n", "<leader>kc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand("~/.config/kitty"),
    hidden=true,
  })
end, { desc = "Browse kitty config files" })

vim.keymap.set("n", "<leader>nc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand("~/.config/nvim"),
    hidden=true,
  })
end, { desc = "Browse nvim config files" })

vim.keymap.set("n", "<leader>yc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand("~/.config/yazi"),
    hidden=true,
  })
end, { desc = "Browse zsh config files" })

vim.keymap.set("n", "<leader>zc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand("~/.config/zsh"),
    hidden=true,
  })
end, { desc = "Browse zsh config files" })

--- vim.keymap.set("n", "gd", function()
  --- vim.lsp.buf.definition()
--- end, { desc = "Go to definition" })

vim.keymap.set("n", "K", vim.lsp.buf.hover,             { desc = "Show documentation", })
vim.keymap.set("n", "<F2>", "dp]c",                     { desc = "Push across current change and move to next one" })
vim.keymap.set("n", "<F3>", "dp",                       { desc = "Push across current change" })
vim.keymap.set("n", "<F4>", "do",                       { desc = "Pull across current change" })
vim.keymap.set("n", "<C-F3>", "<CMD>diffput!<CR>",      { desc = "Push all diff changes" })
vim.keymap.set("n", "<C-F4>", "<CMD>diffget!<CR>",      { desc = "Pull all diff changes" })

--- Misc convenience keybinds

vim.keymap.set("n", ",,", "<CMD>e#<CR>",                { desc = "Switch back to previous buffer" })
vim.keymap.set("n", "ZA", "<CMD>wa<CR>:qa<CR>",         { desc = "Save all buffers and exit nvim" })


--- Diagnostics (Pyright, Ruff, etc.)

-- Show diagnostic details for the current line
vim.keymap.set("n", "<leader>dd", function()
    vim.diagnostic.open_float({
        scope = "line",
        focusable = true,
    })
end, { desc = "Show line diagnostics" })

-- Jump to next diagnostic
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

-- Jump to previous diagnostic
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

-- Show all diagnostics in the current file
vim.keymap.set("n", "<leader>dD", function()
    vim.diagnostic.setloclist()
end, { desc = "List file diagnostics" })
