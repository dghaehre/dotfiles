-- Treesitter configuration

require("nvim-treesitter.configs").setup({
  -- Note: "all" and "maintained" are no longer supported in main branch
  -- Install parsers as needed, or specify a list of languages
  auto_install = true, -- Automatically install parsers when entering a buffer
  ignore_install = { "ipkg" }, -- parsers to not install
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
})

require("treesitter-context").setup({
  enable = true,
  max_lines = 1,
  trim_scope = "inner",
})
