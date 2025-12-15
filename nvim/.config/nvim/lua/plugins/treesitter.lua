-- Treesitter configuration for main branch
-- The main branch uses a completely different API than master

-- Setup is optional and only needed for custom install directory
-- require("nvim-treesitter").setup({
--   install_dir = vim.fn.stdpath("data") .. "/site",
-- })

-- Helper function to install parsers
-- Usage: :lua InstallTreesitterParsers()
function InstallTreesitterParsers()
  require("nvim-treesitter").install({
    "lua", "vim", "vimdoc", "query", -- nvim essentials
    "javascript", "typescript", "tsx",
    "go", "rust", "zig", "c",
    "python", "bash",
    "json", "yaml", "toml",
    "markdown", "markdown_inline",
    "sql", "html", "css",
  })
end

-- Enable treesitter features for all filetypes
-- In the main branch, features are enabled via autocommands, not in setup()
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    -- Enable syntax highlighting (provided by Neovim)
    -- Only attempt if treesitter has a parser for this filetype
    local ok, _ = pcall(vim.treesitter.start, buf)
    if not ok then
      -- Silently fail - not all filetypes have treesitter parsers
      -- Use :TSInstall <language> or :lua InstallTreesitterParsers() to install parsers
    end
  end,
})

require("treesitter-context").setup({
  enable = true,
  max_lines = 1,
  trim_scope = "inner",
})
