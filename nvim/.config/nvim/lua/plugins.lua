-- Plugin configuration using lazy.nvim

require("lazy").setup({
	-- Git
	{ "airblade/vim-gitgutter" },
	{ "tpope/vim-fugitive" },
	{ "sindrets/diffview.nvim" },

	-- UI/Display
	{ "nvim-tree/nvim-web-devicons" },

	-- Telescope and dependencies
	{ "nvim-lua/popup.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-neotest/nvim-nio" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.telescope")
		end,
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-ui-select.nvim" },

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "master",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },

	-- Editing
	{ "tpope/vim-surround" },
	{
		"numToStr/Comment.nvim",
		config = function()
			require("plugins.comment")
		end,
	},
	{ "tpope/vim-commentary" },
	{ "tpope/vim-unimpaired" },
	{ "wellle/targets.vim" },
	{ "gpanders/nvim-parinfer" },

	-- File browsers
	{ "tyru/open-browser.vim" },
	{ "vimwiki/vimwiki" },
	{ "ptzz/lf.vim" },
	{ "voldikss/vim-floaterm" },

	-- Language specific
	{ "janet-lang/janet.vim" },
	{ "gleam-lang/gleam.vim" },
	{ "wlangstroth/vim-racket" },
	-- { "Olical/conjure" },

	-- Testing
	{ "vim-test/vim-test" },

	-- Navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.harpoon")
		end,
	},
	{ "ThePrimeagen/git-worktree.nvim" },

	-- Neo-tree
	{ "MunifTanjim/nui.nvim" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	-- LSP
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("plugins.lsp")
		end,
	},
	{ "VonHeikemen/lsp-zero.nvim" },

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.cmp")
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },

	-- Copilot
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		config = function()
			require("plugins.copilot")
		end,
	},

	-- iOS development
	{ "wojciech-kulik/xcodebuild.nvim" },

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("plugins.dap")
		end,
	},
	{ "leoluz/nvim-dap-go" },
	{ "rcarriga/nvim-dap-ui" },
	{ "nvim-telescope/telescope-dap.nvim" },

	-- Database
	{ "tpope/vim-dadbod" },
	{ "kristijanhusak/vim-dadbod-ui" },

	-- Custom plugins
	{ "dghaehre/raja.vim" },
}, {
	-- Lazy.nvim options
	install = {
		colorscheme = { "vim" },
	},
})
