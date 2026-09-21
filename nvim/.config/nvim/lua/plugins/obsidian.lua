return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    opts = {
        legacy_commands = false,

        workspaces = {
            {
                name = "notes",
                path = "~/Notes",
            },
        },

        picker = {
            name = "fzf-lua",
        },
    },

    keys = {
        {
            "<leader>on",
            "<cmd>Obsidian quick_switch<cr>",
            desc = "Open notes",
        },
        {
            "<leader>nn",
            "<cmd>Obsidian new<cr>",
            desc = "New note",
        },
    },
}
