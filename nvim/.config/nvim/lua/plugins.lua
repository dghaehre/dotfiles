-- Plugin configuration using Neovim's built-in plugin manager (vim.pack)

vim.pack.add({
  -- Git
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",
  "sindrets/diffview.nvim",

  -- UI/Display
  "ap/vim-css-color",
  "nvim-tree/nvim-web-devicons",

  -- Telescope and dependencies
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-neotest/nvim-nio",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-fzf-native.nvim",
  "nvim-telescope/telescope-ui-select.nvim",

  -- Treesitter
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-context",

  -- Editing
  "tpope/vim-surround",
  "numToStr/Comment.nvim",
  "tpope/vim-commentary",
  "tpope/vim-unimpaired",
  "wellle/targets.vim",
  "gpanders/nvim-parinfer",

  -- File browsers
  "tyru/open-browser.vim",
  "vimwiki/vimwiki",
  "ptzz/lf.vim",
  "voldikss/vim-floaterm",

  -- Language specific
  "janet-lang/janet.vim",
  "gleam-lang/gleam.vim",
  "wlangstroth/vim-racket",
  -- "Olical/conjure",

  -- Testing
  "vim-test/vim-test",

  -- Navigation
  "ThePrimeagen/harpoon",
  "ThePrimeagen/git-worktree.nvim",

  -- Neo-tree
  "MunifTanjim/nui.nvim",
  "nvim-neo-tree/neo-tree.nvim",

  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "VonHeikemen/lsp-zero.nvim",

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",

  -- Copilot
  "CopilotC-Nvim/CopilotChat.nvim",

  -- iOS development
  "wojciech-kulik/xcodebuild.nvim",

  -- Debugging
  "mfussenegger/nvim-dap",
  "leoluz/nvim-dap-go",
  "rcarriga/nvim-dap-ui",
  "nvim-telescope/telescope-dap.nvim",

  -- Database
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",

  -- Drawing
  "jbyuki/venn.nvim",

  -- Custom plugins
  "dghaehre/raja.vim",
})

-- Plugin configurations that require setup
-- These are called after plugins are loaded by vim.pack.add()

-- Mason setup
local ok, mason = pcall(require, "mason")
if ok then
  mason.setup({})
end

-- Plugin-specific configurations
pcall(require, "plugins.telescope")
pcall(require, "plugins.treesitter")
pcall(require, "plugins.comment")
pcall(require, "plugins.harpoon")
pcall(require, "plugins.lsp")
pcall(require, "plugins.cmp")
pcall(require, "plugins.copilot")
pcall(require, "plugins.dap")
pcall(require, "plugins.venn")
