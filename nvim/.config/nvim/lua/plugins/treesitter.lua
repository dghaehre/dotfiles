-- Treesitter configuration

require("nvim-treesitter.configs").setup({
  ensure_installed = { "janet", "lua", "vim", "vimdoc", "query" }, -- core parsers and Janet
  auto_install = true, -- automatically install other parsers when entering buffer
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
