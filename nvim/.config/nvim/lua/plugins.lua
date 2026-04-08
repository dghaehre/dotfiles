-- Plugin management using vim.pack (Neovim 0.12+)
-- confirm = false: auto-install plugins without prompting on first startup

vim.pack.add({
	-- Git
	{ src = "airblade/vim-gitgutter", confirm = false },
	{ src = "tpope/vim-fugitive", confirm = false },
	{ src = "sindrets/diffview.nvim", confirm = false },

	-- UI/Display
	{ src = "nvim-tree/nvim-web-devicons", confirm = false },

	-- Telescope and dependencies
	{ src = "nvim-lua/popup.nvim", confirm = false },
	{ src = "nvim-lua/plenary.nvim", confirm = false },
	{ src = "nvim-neotest/nvim-nio", confirm = false },
	{ src = "nvim-telescope/telescope.nvim", confirm = false },
	{ src = "nvim-telescope/telescope-fzf-native.nvim", build = "make", confirm = false },
	{ src = "nvim-telescope/telescope-ui-select.nvim", confirm = false },
	{ src = "nvim-telescope/telescope-dap.nvim", confirm = false },

	-- Treesitter
	{ src = "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", confirm = false },
	{ src = "nvim-treesitter/nvim-treesitter-context", confirm = false },

	-- Editing
	{ src = "tpope/vim-surround", confirm = false },
	{ src = "numToStr/Comment.nvim", confirm = false },
	{ src = "tpope/vim-commentary", confirm = false },
	{ src = "tpope/vim-unimpaired", confirm = false },
	{ src = "wellle/targets.vim", confirm = false },
	{ src = "gpanders/nvim-parinfer", confirm = false },

	-- File browsers
	{ src = "tyru/open-browser.vim", confirm = false },
	{ src = "vimwiki/vimwiki", confirm = false },
	{ src = "ptzz/lf.vim", confirm = false },
	{ src = "voldikss/vim-floaterm", confirm = false },

	-- Language specific
	{ src = "janet-lang/janet.vim", confirm = false },
	{ src = "gleam-lang/gleam.vim", confirm = false },
	{ src = "wlangstroth/vim-racket", confirm = false },

	-- Testing
	{ src = "vim-test/vim-test", confirm = false },

	-- Navigation
	{ src = "ThePrimeagen/harpoon", version = "harpoon2", confirm = false },

	-- Neo-tree
	{ src = "MunifTanjim/nui.nvim", confirm = false },
	{ src = "nvim-neo-tree/neo-tree.nvim", version = "v3.x", confirm = false },

	-- LSP
	{ src = "williamboman/mason.nvim", confirm = false },
	{ src = "neovim/nvim-lspconfig", confirm = false },

	-- Completion
	{ src = "hrsh7th/nvim-cmp", confirm = false },
	{ src = "hrsh7th/cmp-nvim-lsp", confirm = false },
	{ src = "hrsh7th/cmp-buffer", confirm = false },

	-- Copilot
	{ src = "CopilotC-Nvim/CopilotChat.nvim", confirm = false },
	{ src = "ThePrimeagen/99", confirm = false },

	-- iOS development
	{ src = "wojciech-kulik/xcodebuild.nvim", confirm = false },

	-- Debugging
	{ src = "mfussenegger/nvim-dap", confirm = false },
	{ src = "leoluz/nvim-dap-go", confirm = false },
	{ src = "rcarriga/nvim-dap-ui", confirm = false },

	-- Database
	{ src = "tpope/vim-dadbod", confirm = false },
	{ src = "kristijanhusak/vim-dadbod-ui", confirm = false },

	-- Custom plugins
	{ src = "dghaehre/raja.vim", confirm = false },
})

-- Plugin configurations (pcall to handle first install when plugins are not yet available)
local function safe_require(mod)
	local ok, err = pcall(require, mod)
	if not ok then
		vim.notify("Plugin config not loaded: " .. mod .. " (run :Pack install)", vim.log.levels.WARN)
	end
end

safe_require("plugins.telescope")
safe_require("plugins.treesitter")
safe_require("plugins.comment")
safe_require("plugins.harpoon")
safe_require("plugins.lsp")
safe_require("plugins.cmp")
safe_require("plugins.copilot")
safe_require("plugins._99")
safe_require("plugins.dap")
