return {
  "nvim-telescope/telescope-file-browser.nvim",

  dependencies = {
    "nvim-telescope/telescope.nvim",
  },

  config = function()
    local telescope = require("telescope")

    telescope.setup({
      extensions = {
        file_browser = {
          -- Start in ~/.config/nvim
          path = vim.fn.stdpath("config"),

          -- Show hidden files
          hidden = true,

          -- Allow browsing directories
          grouped = true,

          -- Respect gitignore
          respect_gitignore = false,
        },
      },
    })

    telescope.load_extension("file_browser")
  end,
}
