-- Plugin management using vim.pack (Neovim 0.12+)

vim.pack.add({
	-- Git
	{ src = "airblade/vim-gitgutter" },
	{ src = "tpope/vim-fugitive" },
	{ src = "sindrets/diffview.nvim" },

	-- UI/Display
	{ src = "nvim-tree/nvim-web-devicons" },

	-- Telescope and dependencies
	{ src = "nvim-lua/popup.nvim" },
	{ src = "nvim-lua/plenary.nvim" },
	{ src = "nvim-neotest/nvim-nio" },
	{ src = "nvim-telescope/telescope.nvim" },
	{ src = "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ src = "nvim-telescope/telescope-ui-select.nvim" },
	{ src = "nvim-telescope/telescope-dap.nvim" },

	-- Treesitter
	{ src = "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ src = "nvim-treesitter/nvim-treesitter-context" },

	-- Editing
	{ src = "tpope/vim-surround" },
	{ src = "numToStr/Comment.nvim" },
	{ src = "tpope/vim-commentary" },
	{ src = "tpope/vim-unimpaired" },
	{ src = "wellle/targets.vim" },
	{ src = "gpanders/nvim-parinfer" },

	-- File browsers
	{ src = "tyru/open-browser.vim" },
	{ src = "vimwiki/vimwiki" },
	{ src = "ptzz/lf.vim" },
	{ src = "voldikss/vim-floaterm" },

	-- Language specific
	{ src = "janet-lang/janet.vim" },
	{ src = "gleam-lang/gleam.vim" },
	{ src = "wlangstroth/vim-racket" },

	-- Testing
	{ src = "vim-test/vim-test" },

	-- Navigation
	{ src = "ThePrimeagen/harpoon", version = "harpoon2" },

	-- Neo-tree
	{ src = "MunifTanjim/nui.nvim" },
	{ src = "nvim-neo-tree/neo-tree.nvim", version = "v3.x" },

	-- LSP
	{ src = "williamboman/mason.nvim" },
	{ src = "neovim/nvim-lspconfig" },

	-- Completion
	{ src = "hrsh7th/nvim-cmp" },
	{ src = "hrsh7th/cmp-nvim-lsp" },
	{ src = "hrsh7th/cmp-buffer" },

	-- Copilot
	{ src = "CopilotC-Nvim/CopilotChat.nvim" },
	{ src = "ThePrimeagen/99" },

	-- iOS development
	{ src = "wojciech-kulik/xcodebuild.nvim" },

	-- Debugging
	{ src = "mfussenegger/nvim-dap" },
	{ src = "leoluz/nvim-dap-go" },
	{ src = "rcarriga/nvim-dap-ui" },

	-- Database
	{ src = "tpope/vim-dadbod" },
	{ src = "kristijanhusak/vim-dadbod-ui" },

	-- Custom plugins
	{ src = "dghaehre/raja.vim" },
})

-- Plugin configurations
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.comment")
require("plugins.harpoon")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.copilot")
require("plugins._99")
require("plugins.dap")
