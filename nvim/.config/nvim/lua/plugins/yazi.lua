return {
  {
    "mikavilpas/yazi.nvim",
    -- This ensures the plugin only loads when you actually need it (lazy-loading)
    event = "VeryLazy",
    
    -- Define your keyboard shortcuts (keymaps) here
    keys = {
      {
        -- Pressing 'Space' followed by '-' opens Yazi targeting your current open file
        "<leader>e",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Pressing 'Space' then 'c' then 'w' opens Yazi in Neovim's current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi in nvim's working directory",
      },
      {
        -- Pressing 'Space' then 'c' then 'y' brings back your last active Yazi session window
        "<leader>cy",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    
    -- The internal options and configurations for Yazi inside Neovim
    opts = {
      -- This setting replaces Neovim's default file browser (netrw) with Yazi
      -- when you attempt to open a directory link/folder path
      open_for_directories = true,
      
      -- Internal keymaps when inside the Yazi terminal floating window
      keymaps = {
        show_help = "<f1>", -- Press F1 inside Yazi to see available keymaps
      },
    },
  },
}
