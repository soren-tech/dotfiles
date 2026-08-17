return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", 
      "MunifTanjim/nui.nvim",
      
      -- 1. ADDED THE WINDOW PICKER HERE TO FIX THE ERROR
      {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one_win = true, -- If you only have 1 file window open, pick it automatically!
              bo = {
                -- Ignore technical sidebars/popups when choosing where to open files
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    keys = {
      {
        -- Pressing Space + w will toggle the sidebar open and closed
        "<leader>w",
        "<cmd>Neotree toggle left<cr>",
        desc = "Toggle File Explorer (Left Sidebar)",
      },
    },
    opts = {
      close_if_last_window = true, 
      window = {
        width = 30, 
        mappings = {
          -- ─────────────────────────────────────────────────────────────
          -- 2. NAVIGATION & WINDOW MANIPULATION
          -- ─────────────────────────────────────────────────────────────
          ["<cr>"] = "open",             -- [ENTER / RETURN] key: Opens a file or expands/collapses a folder
          ["<space>"] = "toggle_node",   -- [SPACEBAR] key: Expands or collapses a folder without opening files
          ["<BS>"] = "close_node",       -- [BACKSPACE] key: Collapses a folder, or jumps up to the parent folder
          ["C"] = "close_node",          -- [Shift + c] key: Alternative quick way to collapse a folder
          ["z"] = "close_all_nodes",     -- [z] key: Instantly collapses every open folder in the whole tree
          ["R"] = "refresh",             -- [Shift + r] key: Manually re-scans and reloads your file structure
          ["q"] = "close_window",        -- [q] key: Closes the sidebar panel window completely
          ["?"] = "show_help",           -- [Shift + /] (Question Mark) key: Opens the built-in help overlay

          -- ─────────────────────────────────────────────────────────────
          -- 3. MULTI-TASKING (SPLITS & TABS)
          -- ─────────────────────────────────────────────────────────────
          ["s"] = "open_split",          -- [s] key: Splits editor horizontally and opens the selected file
          ["v"] = "open_vsplit",         -- [v] key: Splits editor vertically side-by-side and opens the file
          ["t"] = "open_tabnew",         -- [t] key: Opens the selected file in a brand new Neovim tab

          -- ─────────────────────────────────────────────────────────────
          -- 4. FILE OPERATIONS (CREATING, DELETING, RENAMING)
          -- ─────────────────────────────────────────────────────────────
          ["a"] = "add",                 -- [a] key: Creates a new file (or a folder if you end the name with a '/')
          ["d"] = "delete",              -- [d] key: Deletes the selected file or folder (asks for confirmation first)
          ["r"] = "rename",              -- [r] key: Renames the selected file or folder in-place
          ["c"] = "copy",                -- [c] key: Copies the file or folder locally within your project
          ["m"] = "move",                -- [m] key: Cuts and moves the file or folder locally
          ["y"] = "copy_to_clipboard",   -- [y] key: Copies the item reference into Neo-tree's internal clipboard
          ["x"] = "cut_to_clipboard",    -- [x] key: Cuts the item reference into Neo-tree's internal clipboard
          ["p"] = "paste_from_clipboard",-- [p] key: Pastes whatever items are staged in your Neo-tree clipboard
        },
      },
      filesystem = {
        filtered_items = {
          visible = false, 
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true, 
        },
      },
    },
  },
}
