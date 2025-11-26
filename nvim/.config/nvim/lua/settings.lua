-- Editor settings (converted from vimrc)

local opt = vim.opt

-- Indentation
opt.expandtab = false -- Use tabs (default)
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.autoindent = true
opt.smartindent = true

-- Display whitespace
opt.list = true
opt.listchars = { tab = "› ", trail = "·" }

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Word wrap
opt.wrap = true
opt.linebreak = true
opt.textwidth = 0
opt.wrapmargin = 0

-- Persistent undo
opt.undodir = vim.fn.expand("~/.vim/undo-dir")
opt.undofile = true

-- Folding
opt.foldmethod = "indent"
opt.foldlevel = 0
opt.foldlevelstart = 50

-- General
opt.compatible = false
opt.splitbelow = true
opt.splitright = true

-- Display
opt.termguicolors = false
opt.background = "dark"
opt.fillchars = ""
opt.number = true
opt.numberwidth = 4
opt.scrolloff = 3
opt.cursorline = true

-- Completion
opt.completeopt = { "noselect", "popup" }

-- Neovim specific
vim.g.NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

-- Test settings
vim.g["test#neovim#start_normal"] = 1
vim.g["test#basic#start_normal"] = 1
vim.g["test#neovim#term_position"] = "bel 20"
vim.g["test#preserve_screen"] = 0

-- LF settings
vim.g.lf_map_keys = 0
vim.g.lf_replace_netrw = 1

-- Floaterm settings
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
vim.g.floaterm_opener = "vsplit"
vim.g.floaterm_keymap_kill = "<C-x>"

-- Go syntax highlighting
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_structs = 1
vim.g.go_highlight_types = 1

-- Vimwiki settings
vim.g.vimwiki_list = {
  { path = "~/Library/Mobile Documents/com~apple~CloudDocs/vimwiki/", syntax = "markdown", ext = ".md" },
  { path = "~/wikis/work/", syntax = "markdown", ext = ".md" },
}
vim.g.vimwiki_key_mappings = {
  table_mappings = 0,
}
vim.g.vimwiki_folding = "custom"

-- Enable filetype plugins and syntax
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
