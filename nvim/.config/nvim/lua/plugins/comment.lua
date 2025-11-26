-- Comment.nvim configuration

require("Comment").setup({
  toggler = {
    line = "gcl",
  },
  extra = {
    above = "gcO",
    below = "gco",
    eol = "gcA",
  },
})
