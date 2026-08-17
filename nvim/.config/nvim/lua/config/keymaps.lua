--[[
  ╔══════════════════════════════════════════════════════════╗
  ║                 LUA/CONFIG/KEYMAPS.LUA                   ║
  ╠══════════════════════════════════════════════════════════╣
  ║  This file defines your custom keyboard shortcuts.       ║
  ║  All mappings use our shorthand alias 'map' which points ║
  ║  directly to the modern vim.keymap.set() engine.         ║
  ╚══════════════════════════════════════════════════════════╝
--]]

-- ┌─────────────────────────────────────────────────────────────┐
-- │  0.  LEADER KEY SETTINGS & ALIASES                          │
-- └─────────────────────────────────────────────────────────────┘
-- Assigns your primary shortcut modifier to the Spacebar.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shortcut nickname to make mapping cleaner and easier to read.
local map = vim.keymap.set

-- ┌─────────────────────────────────────────────────────────────┐
-- │  1.  GENERAL UTILITY MAPPINGS                               │
-- └─────────────────────────────────────────────────────────────┘

-- Clear Search Highlights:
-- [ESCAPE] key (in Normal Mode) clears the colored search text highlights left behind by '/'.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Save File:
-- [Spacebar] followed by [f] then [s] saves your file. 
-- (Changed from <leader>w to prevent clashing with your Neo-tree sidebar!)
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })

-- Alternative Global Save:
-- [Control + s] key combination will save your file inside Normal, Insert, or Visual modes.
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file with Ctrl-s" })

-- Quit Window:
-- [Spacebar] followed by [q] safely closes your current window pane split.
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })

-- Reload Configuration:
-- [Spacebar] followed by [Spacebar] then [x] instantly reloads/sources your current active file.
map("n", "<leader><leader>x", "<cmd>source %<cr>", { desc = "Source current file" })

-- Toggle Spellcheck:
-- [Spacebar] followed by [s] then [p] turns spellcheck lines on/off (ideal for markdown files).
map("n", "<leader>sp", "<cmd>setlocal spell!<cr>", { desc = "Toggle spell check" })

-- copy
map('n', '<leader>ya', ':%y+<CR>', { desc = 'Yank entire file to system clipboard' })
map('n', '<C-a>', 'ggVG', { desc = 'Select all text' })
--
-- 
-- ┌─────────────────────────────────────────────────────────────┐
-- │  2.  WINDOW / SPLIT NAVIGATION & LAYOUTS                    │
-- └─────────────────────────────────────────────────────────────┘

-- Move Focus Between Splits:
-- Hold [Control] and press [h], [j], [k], or [l] to instantly hop between window splits.
-- This makes jumping out of your Neo-tree sidebar back into your code perfectly seamless!
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize Window Splits:
-- Hold [Alternate(Alt) / Option] and use your keyboard's directional Arrow Keys to resize layouts.
map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<A-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })

-- Balance Splits:
-- [Spacebar] followed by [=] equalizes all active open windows to identical sizes.
map("n", "<leader>=", "<C-w>=", { desc = "Equalize window sizes" })

-- Create New Split Windows:
-- [Spacebar] followed by [-] splits horizontally. [Spacebar] followed by [ \ ] splits vertically.
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split horizontally" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split vertically" })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  3.  BUFFER / FILE TAB NAVIGATION                           │
-- └─────────────────────────────────────────────────────────────┘

-- Cycle Open File Tabs:
-- Press [Tab] to cycle forward to the next file buffer, or [Shift + Tab] to cycle backward.
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Close Current File Tab:
-- [Spacebar] followed by [b] then [d] drops/deletes the current file buffer without closing the split layout.
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  4.  TEXT EDITING & VIEWPORTS                               │
-- └─────────────────────────────────────────────────────────────┘

-- Slide Highlighted Blocks:
-- Highlight text lines in Visual Mode, then hold [Shift] and press [j] or [k] to slide them down or up.
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

-- Persistent Code Indentation:
-- Highlight lines in Visual Mode, then press [<] or [>] to indent. Keeps the block highlighted for repeated adjustments.
map("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
map("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Safe Clipboard Pasting:
-- In Visual Mode, [Spacebar] followed by [p] pastes over highlighted text without losing your original copied text.
map("x", "<leader>p", '"_dP', { desc = "Paste without overriding register" })

-- Static Line Joining:
-- Pressing [Shift + j] joins the line below to the current line, but locks your cursor location in place.
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Centered Scrolling:
-- Holding [Control] and pressing [d] or [u] scrolls up or down while forcing your cursor to stay perfectly centered.
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half-page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half-page up and center" })

-- Centered Search Skipping:
-- Pressing [n] or [Shift + n] jumps across search results while forcing the viewport to stay centered on the match.
map("n", "n", "nzzzv", { desc = "Next search match and center" })
map("n", "N", "Nzzzv", { desc = "Previous search match and center" })

-- Centered History Jumping:
-- Holding [Control] and pressing [o] or [i] jumps backward/forward through your jump history while staying centered.
map("n", "<C-o>", "<C-o>zz", { desc = "Go to older cursor position and center" })
map("n", "<C-i>", "<C-i>zz", { desc = "Go to newer cursor position and center" })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  5.  QUICKFIX LISTS                                         │
-- └─────────────────────────────────────────────────────────────┘

-- Quickfix Skipping:
-- [Spacebar] followed by [j] or [k] jumps to the next or previous error item listed inside your Quickfix menu.
map("n", "<leader>j", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "<leader>k", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

-- Quickfix Toggling:
-- [Spacebar] + [c] + [o] opens the error list panel. [Spacebar] + [c] + [c] shuts it down.
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix window" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix window" })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  6.  SEARCH UTILE                                           │
-- └─────────────────────────────────────────────────────────────┘

-- Static Word Search:
-- Pressing [*] or [#] highlights every instance of the word under your cursor without jumping away to the next match.
map("n", "*", "<cmd>keepjumps normal! mi*`i<cr>", { desc = "Search word under cursor without moving" })
map("n", "#", "<cmd>keepjumps normal! mi#`i<cr>", { desc = "Search word under cursor backwards without moving" })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  7.  TERMINAL MODE WORKFLOWS                                │
-- └─────────────────────────────────────────────────────────────┘

-- Quick Terminal Exit:
-- Inside an active Neovim built-in terminal window, hitting [ESCAPE] instantly drops you back into Normal Mode navigation.
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Direct Terminal Window Hopping:
-- Hold [Control] and press [h], [j], [k], or [l] to exit a terminal session and jump directly into a separate window split.
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: go to right window" })

-- ┌─────────────────────────────────────────────────────────────┐
-- │  8.  MISC COMFORT                                           │
-- └─────────────────────────────────────────────────────────────┘

-- Disable Annoying Ex Mode:
-- Pressing [Shift + q] is completely disabled so you don't accidentally get trapped in command-line mode.
map("n", "Q", "<Nop>", { desc = "Disable Ex mode" })
