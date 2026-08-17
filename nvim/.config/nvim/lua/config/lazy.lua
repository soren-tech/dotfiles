--[[
  ╔══════════════════════════════════════════════════════════╗
  ║               LUA/CONFIG/LAZY.LUA                        ║
  ╠══════════════════════════════════════════════════════════╣
  ║  This file does two things:                              ║
  ║  1. Bootstraps Lazy.nvim (installs itself if missing).  ║
  ║  2. Defines all plugins you want via require("lazy").setup().
  ║                                                        ║
  ║  Plugins are listed as Lua tables (plugin specs).       ║
  ║  Each spec has a short GitHub "owner/repo" string and   ║
  ║  optional settings like lazy‑loading events,            ║
  ║  dependencies, and a config function.                   ║
  ║                                                        ║
  ║  The `config` key can be:                               ║
  ║  - A function (inline configuration)                    ║
  ║  - A string module path (e.g., "plugins.telescope")    ║
  ║    which will call require("plugins.telescope").setup() ║
  ║    automatically (if that file returns a module with    ║
  ║    a setup() function).                                 ║
  ║                                                        ║
  ║  Lazy.nvim will download plugins to ~/.local/share/nvim/lazy/
  ║  and load them according to the `event` or `lazy` keys.  ║
  ╚══════════════════════════════════════════════════════════╝
--]]

-- ┌─────────────────────────────────────────────────────────────┐
-- │  1. BOOTSTRAP LAZY.NVM                                      │
-- └─────────────────────────────────────────────────────────────┘
-- This block clones Lazy.nvim if it’s not already on your system.
-- It only runs once, on the very first launch.
-- Keep it uncommented – it's essential for the plugin manager to work.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",           -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ┌─────────────────────────────────────────────────────────────┐
-- │  2. DEFAULT LAZY.NVIM SETTINGS (optional)                  │
-- └─────────────────────────────────────────────────────────────┘
-- You can pass a second argument to setup() to configure Lazy.nvim itself.
-- These are the default values. Uncomment and change if needed.
-- require("lazy").setup({
--   --[[ plugin list goes here – see step 3 ]]
-- }, {
--   defaults = {
--     lazy = true,           -- lazy‑load all plugins by default
--     version = false,       -- always use latest git commit (not tags)
--   },
--   install = {
--     colorscheme = { "onedark" },  -- install a colorscheme on init
--   },
--   checker = {
--     enabled = false,       -- automatically check for updates
--     notify = true,         -- show notification when new updates are found
--   },
--   change_detection = {
--     enabled = true,        -- automatically reload configs when changed
--     notify = true,
--   },
--   performance = {
--     cache = {
--       enabled = true,      -- enable byte‑code caching
--     },
--     rtp = {
--       disabled_plugins = {
--         "tohtml",          -- built‑in plugins you want to disable
--         "matchit",
--         "netrwPlugin",
--       },
--     },
--   },
-- })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  3. PLUGIN SPECIFICATIONS                                   │
-- └─────────────────────────────────────────────────────────────┘
-- Add your plugins inside this setup() call.

-- The active setup call below initiates the plugin manager.
require("lazy").setup({
  spec = {
    -- This is the crucial line for your modular setup.
    -- It tells lazy.nvim to automatically scan your 'lua/plugins/' directory
    -- and load any files you put inside it (like 'colorscheme.lua').
    { import = "plugins" },
  },
  -- You can add secondary configurations for the lazy UI interface here if desired:
  install = {
    -- Fallback theme to use during initialization if your primary theme isn't downloaded yet.
    colorscheme = { "habamax" },
  },
  checker = {
    -- Automatically check for plugin updates in the background.
    enabled = false, 
  },
})
