-- Main Neovim configuration entry point
-- All configuration is done in Lua

-- Byte-compile + index the runtimepath. Must come before any require().
-- This machine runs under sustained memory pressure, so the file cache holding
-- the ~148 MB runtime + plugin tree is evicted regularly; a cold start is then
-- ~10,000 directory probes and is I/O-bound (measured 2026-08-31: 1.60 s wall,
-- only 0.49 s CPU). vim.loader collapses those probes to ~300 targeted stats.
vim.loader.enable()

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Load configuration modules
require("settings")
require("keymaps")
require("colors")
require("autocmds")
require("snippets")
require("plugins")
require("functions")
require("format")
