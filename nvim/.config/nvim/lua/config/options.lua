-- ~/.config/nvim/lua/config/options.lua
-- All general editor settings that influence look, feel, and behavior.
-- Uses vim.opt (for vim options), vim.g (global variables), vim.o (global options), vim.bo (buffer-local).

----------------------
-- Global Variables --
----------------------

vim.g.mapleader = " "       -- Set <Space> as the leader key
vim.g.maplocalleader = " "  -- Local leader also <Space> (often used in filetype plugins)

----------------
-- Appearance --
----------------

vim.opt.termguicolors = true      -- Enable 24-bit RGB color in the TUI (requires a terminal that supports it)
vim.opt.number = true             -- Show absolute line numbers
vim.opt.relativenumber = true     -- Show relative line numbers (useful for motions like 5j)
vim.opt.signcolumn = "yes"        -- Always show the sign column (prevents layout shifts when LSP signs appear)
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.scrolloff = 8             -- Keep at least 8 lines above/below the cursor when scrolling
vim.opt.sidescrolloff = 8         -- Keep at least 8 columns left/right of cursor
-- vim.opt.colorcolumn = "80"        -- Show a colored column at 80 characters (common text width guide)
-- vim.opt.guifont = "monospace:h17"  -- GUI font setting (ignored in TUI)

-------------
-- Editing --
-------------

vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.tabstop = 2               -- Number of spaces a <Tab> character counts for
vim.opt.softtabstop = 2           -- Number of spaces a <Tab> counts for during editing operations
vim.opt.shiftwidth = 2            -- Number of spaces used for each step of (auto)indent
vim.opt.smartindent = true        -- React smarter to some syntax when indenting
vim.opt.autoindent = true         -- Copy indent from current line when starting a new line
vim.opt.breakindent = true        -- Visually indent wrapped lines (keeps the text aligned)
vim.opt.wrap = true               -- Enable text wrapping when lines go outside the view
vim.opt.linebreak = true          -- When wrapping, break at characters in 'breakat' instead of cutting words
vim.opt.textwidth = 0             -- Maximum width of text that is being inserted (0 disables)
vim.opt.formatoptions = "jcroqlnt" -- See :help fo-table: j = remove comment leader when joining, c = auto-wrap comments, r = auto-insert comment leader, o = auto-insert comment leader for new line, q = allow formatting with 'gq', l = don't break long lines in insert mode, n = recognize numbered lists, t = auto-wrap using textwidth

vim.opt.backspace = "indent,eol,start"  -- Allow backspacing over everything in insert mode

----------------------
-- Search & Replace --
----------------------

vim.opt.ignorecase = true         -- Ignore case in search patterns ...
vim.opt.smartcase = true          -- ... unless an uppercase letter is used (then case-sensitive)
vim.opt.hlsearch = true           -- Highlight all search matches
vim.opt.incsearch = true          -- Show match while typing the search pattern
vim.opt.inccommand = "split"      -- Show live preview of :substitute commands

-------------------
-- Command Line & Wildmenu --
-------------------

vim.opt.wildmenu = true           -- Enhanced command-line completion (shows a menu above the cmdline)
vim.opt.wildmode = "longest:full,full"  -- Complete the longest common string then iterate through full matches
vim.opt.wildignore = "*.o,*.obj,*.pyc,__pycache__,**/node_modules/**"  -- Patterns to ignore during file/path completion

-----------------
-- Splits & Windows --
-----------------

vim.opt.splitbelow = true         -- Horizontal split opens below the current window
vim.opt.splitright = true         -- Vertical split opens to the right of the current window

---------------
-- Undo & Backup --
---------------

vim.opt.undofile = true           -- Enable persistent undo (saves undo history to a file)
-- If you want a specific undo directory (optional):
-- vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
-- vim.fn.mkdir(vim.opt.undodir:get(), "p")   -- Ensure the directory exists

vim.opt.swapfile = false          -- Disable swap files (use undo history and git instead; less I/O noise)
vim.opt.backup = false            -- Disable backup files
vim.opt.writebackup = false       -- Even during writing, no backup

-------------------
-- Performance & Responsiveness --
-------------------

vim.opt.updatetime = 300          -- Time in ms to wait before triggering CursorHold (useful for LSP diagnostics)
vim.opt.timeoutlen = 300          -- Time in ms to wait for a mapped sequence to complete
vim.opt.ttimeoutlen = 10          -- Time in ms to wait for a key code sequence (like <Esc> in terminal)

-- vim.opt.lazyredraw = true      -- Don't redraw during macros (can improve performance, but may cause visual glitches)

------------------
-- Clipboard & Mouse --
------------------

vim.opt.clipboard = "unnamedplus" -- Use the system clipboard (requires +clipboard; uses * and + registers)
vim.opt.mouse = "a"               -- Enable mouse support in all modes

--------------
-- File Handling --
--------------

vim.opt.fileencoding = "utf-8"    -- Default encoding for files
vim.opt.fileformats = "unix,dos,mac" -- Prefer Unix line endings, but accept others
vim.opt.showmode = true          -- Don't display -- INSERT -- etc. (we have a statusline plugin showing that)

----------------
-- LSP & Completion (general settings for later plugin integration) --
----------------

vim.opt.completeopt = "menu,menuone,noselect"  -- Completion settings: show popup menu, even if only one match, do not auto-select
vim.opt.pumheight = 10            -- Maximum number of items to show in the popup menu
vim.opt.pumblend = 10             -- Transparency of the popup menu (0 = opaque, 100 = fully transparent; works with termguicolors)

------------------
-- Miscellaneous --
------------------

vim.opt.confirm = true            -- Ask to save changes before quitting instead of failing
vim.opt.autoread = true           -- Automatically reload file if changed outside of Neovim
vim.opt.hidden = true             -- Allow switching buffers without saving (keeps undo history)
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"  -- What to save in a session

-- Set spellcheck language (optional)
-- vim.opt.spelllang = "en_us"
-- vim.opt.spell = false
