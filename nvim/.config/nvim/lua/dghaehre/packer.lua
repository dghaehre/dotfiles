print("hello from packer")

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = "make" },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'mfussenegger/nvim-dap' },
      { 'nvim-telescope/telescope-dap.nvim' },
    }
  }

  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("tpope/vim-surround")
  use("numToStr/Comment.nvim")
  use("tpope/vim-commentary")
  use("tpope/vim-fugitive")
  use("tyru/open-browser.vim")
  use("vimwiki/vimwiki")
  use("ptzz/lf.vim")
  use("voldikss/vim-floaterm")
  use("wellle/targets.vim")
  use("tools-life/taskwiki")
  use("neovimhaskell/haskell-vim")
  use("bakpakin/janet.vim")
  use("vim-test/vim-test")
  use("sindrets/diffview.nvim")
  use("tpope/vim-unimpaired")
  use("aklt/plantuml-syntax")
  use("dghaehre/raja.vim")
  -- use("Olical/conjure")
  -- use('weirongxu/plantuml-previewer.vim")

  -- LSP:
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }

end)
