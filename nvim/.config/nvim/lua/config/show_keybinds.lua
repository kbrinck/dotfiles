local M = {}

local keybinds_file = vim.fn.expand("~/.config/nvim/keybinds.txt")

function M.show()
    if vim.fn.filereadable(keybinds_file) == 0 then
        vim.notify("Keybinds file not found: " .. keybinds_file, vim.log.levels.ERROR)
        return
    end

    local lines = vim.fn.readfile(keybinds_file)

    local width = math.floor(vim.o.columns * 0.85)
    local height = math.floor(vim.o.lines * 0.85)

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "text"

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Keybindings ",
        title_pos = "center",
    })

    vim.wo[win].wrap = false
    vim.wo[win].cursorline = true

    vim.keymap.set("n", "q", "<cmd>close<CR>", {
        buffer = buf,
        silent = true,
    })

    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", {
        buffer = buf,
        silent = true,
    })
end

vim.keymap.set("n", "<leader>kb", M.show, {
    desc = "Show keybindings",
})

return M
