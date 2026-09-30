return {
    "stevearc/aerial.nvim",

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },

    opts = {},

    keys = {
        {
            "<leader>so", "<cmd>AerialToggle!<CR>", desc = "Toggle symbols outline",
        },
    },
}
