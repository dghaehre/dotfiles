-- Plugin management using vim.pack (Neovim 0.12+)

vim.pack.add({
	-- Git
	{ src = "https://github.com/airblade/vim-gitgutter" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	-- { src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/dnaaun/diffview-jj.nvim" },

	-- UI/Display
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- Telescope and dependencies
	-- { src = "https://github.com/nvim-lua/popup.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- { src = "https://github.com/nvim-neotest/nvim-nio" },
	-- { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- should try to make this work..
	-- { src = "https://github.com/nvim-telescope/telescope-dap.nvim" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },

	-- Editing
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	-- { src = "https://github.com/tpope/vim-commentary" },
	{ src = "https://github.com/tpope/vim-unimpaired" },
	{ src = "https://github.com/wellle/targets.vim" },
	{ src = "https://github.com/gpanders/nvim-parinfer" },

	-- File browsers
	{ src = "https://github.com/tyru/open-browser.vim" },
	{ src = "https://github.com/vimwiki/vimwiki" },
	{ src = "https://github.com/ptzz/lf.vim" },
	{ src = "https://github.com/voldikss/vim-floaterm" },

	-- Language specific
	{ src = "https://github.com/janet-lang/janet.vim" },
	{ src = "https://github.com/gleam-lang/gleam.vim" },
	{ src = "https://github.com/wlangstroth/vim-racket" },

	-- Testing
	{ src = "https://github.com/vim-test/vim-test" },

	-- Neo-tree
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },

	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- Telescope, harpoon and completion are deferred:
	-- see the second vim.pack.add() below.
	-- { src = "https://github.com/ThePrimeagen/99" },

	-- iOS development
	{ src = "https://github.com/wojciech-kulik/xcodebuild.nvim" },

	-- Debugging, Dont use this enough..
	-- { src = "https://github.com/mfussenegger/nvim-dap" },
	-- { src = "https://github.com/leoluz/nvim-dap-go" },
	-- { src = "https://github.com/rcarriga/nvim-dap-ui" },

	-- Database
	-- { src = "https://github.com/tpope/vim-dadbod" }, -- dont use this anymore..
	-- { src = "https://github.com/kristijanhusak/vim-dadbod-ui" }, -- dont use this anymore..

	-- Custom plugins
	{ src = "https://github.com/dghaehre/raja.vim" },
})

-- Deferred plugins.
--
-- `load = function() end` makes vim.pack install and register these but skip
-- :packadd entirely (vim/pack.lua:800), so they stay off 'runtimepath' and
-- their plugin/ files are never sourced at startup. lua/lazyload.lua packadds
-- them on first use.
--
-- `{ load = false }` would be a no-op here -- that is already the default while
-- init.lua is sourcing (vim/pack.lua:1006), so these would still land on
-- 'runtimepath' and be sourced by the normal startup pass.
vim.pack.add({
	-- Telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Navigation
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

	-- Completion
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },

}, { load = function() end })

local lazyload = require("lazyload")

require("plugins.treesitter")
require("plugins.comment")
require("plugins.lsp")

-- These two are cheap now: they only define keymaps. The plugin behind them is
-- packadd'ed and configured the first time a mapping is actually pressed.
require("plugins.telescope")
require("plugins.harpoon")

-- cmp is insert mode only.
vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		lazyload.ensure("plugins.cmp", { "nvim-cmp", "cmp-nvim-lsp", "cmp-buffer" })

		-- cmp and cmp_nvim_lsp register their own InsertEnter handlers, which
		-- have just missed the event that triggered this one (cmp_nvim_lsp
		-- attaches LSP sources from it). Replay it so the first insert session
		-- behaves like every later one. Safe: this autocmd is `once`, and
		-- nothing else in the config listens for InsertEnter.
		vim.api.nvim_exec_autocmds("InsertEnter", {})
	end,
})

-- require("plugins._99")
-- require("plugins.dap")
