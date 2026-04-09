-- Comment.nvim configuration

local ok, comment = pcall(require, "Comment")
if not ok then return end

comment.setup({
  toggler = {
    line = "gcl",
  },
  extra = {
    above = "gcO",
    below = "gco",
    eol = "gcA",
  },
})
