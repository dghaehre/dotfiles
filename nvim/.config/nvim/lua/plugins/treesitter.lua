-- Treesitter configuration

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  indentation = {
    enable = true,
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
