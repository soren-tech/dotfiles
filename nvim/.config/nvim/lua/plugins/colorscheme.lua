return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Make sure this loads before all other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- Set to true if you want your Hyprland wallpaper to show through!
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope = true,
          },
        },
      })

      -- Setup mustache loading
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
