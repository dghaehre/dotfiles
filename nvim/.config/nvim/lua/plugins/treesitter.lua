-- Treesitter configuration

require("nvim-treesitter.configs").setup({
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "ipkg" }, -- parsers to not install
  highlight = {
    enable = true,
  },
  indentation = {
    enable = false,
	},
  folding = {
    enable = true,
  },
})

require("treesitter-context").setup({
  enable = true,
  max_lines = 1,
  trim_scope = "inner",
})
