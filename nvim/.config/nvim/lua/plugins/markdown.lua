return {
  -- 1. Treesitter configuration (Updated for the new 'main' branch architecture)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()
      ts.install({ "markdown", "markdown_inline", "lua", "vim", "vimdoc" })
      
      -- Native Neovim tree-sitter highlighting must be manually enabled per filetype on main
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "lua", "vim", "vimdoc" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },

  -- 2. Inline Markdown Renderer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      enabled = true,
      render_modes = { "n", "c", "t" },
      anti_conceal = {
        enabled = true,
      },
    },
  }
}
