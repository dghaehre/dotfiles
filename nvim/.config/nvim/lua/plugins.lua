-- Plugin management using vim.pack (Neovim 0.12+)

vim.pack.add({
	-- Git
	{ src = "https://github.com/airblade/vim-gitgutter" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/sindrets/diffview.nvim" },

	-- UI/Display
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- Telescope and dependencies
	-- { src = "https://github.com/nvim-lua/popup.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- { src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
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

	-- Navigation
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

	-- Neo-tree
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },

	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- Completion
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },

	-- Copilot
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
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

require("plugins.telescope")
require("plugins.treesitter")
require("plugins.comment")
require("plugins.harpoon")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.copilot")
-- require("plugins._99")
-- require("plugins.dap")
