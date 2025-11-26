-- Autocommands (converted from vimrc)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- File type specific indentation
local filetype_group = augroup("FileTypeSettings", { clear = true })

autocmd("FileType", {
  group = filetype_group,
  pattern = { "sql", "janet", "roc", "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.expandtab = true
  end,
})

-- Janet specific highlighting
autocmd("FileType", {
  group = filetype_group,
  pattern = "janet",
  callback = function()
    vim.cmd("highlight link @symbol Keyword")
    vim.cmd("highlight link @string.special Keyword")
    vim.cmd("highlight Identifier ctermfg=15")
  end,
})

-- Automatically reload file if changed outside of Vim
autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-- Terminal settings
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Markdown folding
local function markdown_level()
  local line = vim.fn.getline(vim.v.lnum)
  if line:match("^# .*$") then return ">1" end
  if line:match("^## .*$") then return ">2" end
  if line:match("^### .*$") then return ">3" end
  if line:match("^#### .*$") then return ">4" end
  if line:match("^##### .*$") then return ">5" end
  if line:match("^###### .*$") then return ">6" end
  return "="
end

-- Make markdown_level available globally
_G.markdown_level = markdown_level

autocmd("FileType", {
  group = filetype_group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldexpr = "v:lua.markdown_level()"
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldlevelstart = 50
  end,
})

-- Fix crontab bug
autocmd("FileType", {
  group = filetype_group,
  pattern = "crontab",
  callback = function()
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
  end,
})
