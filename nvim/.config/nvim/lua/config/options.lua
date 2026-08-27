local opt = vim.opt

-----------------------------------------------------------------------------
--- Misc options
-----------------------------------------------------------------------------

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.autoindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.encoding = "utf-8"
opt.visualbell = true
opt.scrolloff = 5
opt.fillchars = { eob = " " }

opt.laststatus = 3  -- for avante

-----------------------------------------------------------------------------
--- Color scheme stuff
-----------------------------------------------------------------------------

if vim.fn.has("termguicolors") == 1 then
  opt.termguicolors = true
end

local scheme_a = "catppuccin-mocha"
local scheme_b = "gvim"

local function set_colorscheme(name)
    vim.o.background = "dark"  -- ensure catppuccin resolves to mocha, not latte

    local ok = pcall(vim.cmd.colorscheme, name)
    if not ok then
        print("Colorscheme '" .. name .. "' not found")
    end
end

local function toggle_colorscheme()
    if vim.g.colors_name == scheme_a then
        set_colorscheme(scheme_b)
    else
        set_colorscheme(scheme_a)
    end
end

-- Set initial colorscheme
set_colorscheme(scheme_a)

-- Bind it to a key
vim.keymap.set("n", "<leader>gv", toggle_colorscheme, { desc = "Toggle colorscheme" })
