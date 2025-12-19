-- Plugin configuration using Neovim's built-in plugin manager (vim.pack)

vim.pack.add({
  -- Git
  "https://github.com/airblade/vim-gitgutter",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/sindrets/diffview.nvim",

  -- UI/Display
  "https://github.com/ap/vim-css-color",
  "https://github.com/nvim-tree/nvim-web-devicons",

  -- Telescope and dependencies
  "https://github.com/nvim-lua/popup.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-neotest/nvim-nio",
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "v0.2.0" },
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",

  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  -- Editing
  "https://github.com/tpope/vim-surround",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/tpope/vim-commentary",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/wellle/targets.vim",
  "https://github.com/gpanders/nvim-parinfer",

  -- File browsers
  "https://github.com/tyru/open-browser.vim",
  "https://github.com/vimwiki/vimwiki",
  "https://github.com/ptzz/lf.vim",
  "https://github.com/voldikss/vim-floaterm",

  -- Language specific
  "https://github.com/janet-lang/janet.vim",
  "https://github.com/gleam-lang/gleam.vim",
  "https://github.com/wlangstroth/vim-racket",
  -- "https://github.com/Olical/conjure",

  -- Testing
  "https://github.com/vim-test/vim-test",

  -- Navigation
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  "https://github.com/ThePrimeagen/git-worktree.nvim",

  -- Neo-tree
  "https://github.com/MunifTanjim/nui.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/VonHeikemen/lsp-zero.nvim",

  -- Completion
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",

  -- Copilot
  { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim", version = "main" },

  -- iOS development
  "https://github.com/wojciech-kulik/xcodebuild.nvim",

  -- Debugging
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/leoluz/nvim-dap-go",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-telescope/telescope-dap.nvim",

  -- Database
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-ui",

  -- Drawing
  "https://github.com/jbyuki/venn.nvim",

  -- Custom plugins
  "https://github.com/dghaehre/raja.vim",
})

-- Plugin configurations that require setup
-- These need to be called after plugins are loaded

-- Mason setup
require("mason").setup({})

-- Plugin-specific configurations
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.comment")
require("plugins.harpoon")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.copilot")
require("plugins.dap")
require("plugins.venn")
