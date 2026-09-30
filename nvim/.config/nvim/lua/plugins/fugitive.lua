return {
    "tpope/vim-fugitive",

    cmd = {
        "Git",
        "G",
        "Gdiffsplit",
        "Gvdiffsplit",
        "Gread",
        "Gwrite",
        "Gblame",
    },
    
    keys = {
        { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
        { "<leader>dg", "<cmd>Gdiffsplit<CR>", desc = "Git diff current file" },
        { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    },
}
