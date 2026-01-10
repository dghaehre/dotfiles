-- Main Neovim configuration entry point
-- All configuration is done in Lua

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
