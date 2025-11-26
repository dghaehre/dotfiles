-- nvim-cmp configuration

local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item()),
    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item()),
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
  }),
})
