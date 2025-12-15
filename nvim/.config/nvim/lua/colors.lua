-- Colors and highlights (converted from vimrc)

-- Set colorscheme
vim.cmd("colorscheme vim")

-- Helper function for setting highlights
local function hi(group, opts)
  local cmd = "highlight " .. group
  if opts.ctermfg then cmd = cmd .. " ctermfg=" .. opts.ctermfg end
  if opts.ctermbg then cmd = cmd .. " ctermbg=" .. opts.ctermbg end
  if opts.cterm then cmd = cmd .. " cterm=" .. opts.cterm end
  if opts.guifg then cmd = cmd .. " guifg=" .. opts.guifg end
  if opts.guibg then cmd = cmd .. " guibg=" .. opts.guibg end
  if opts.gui then cmd = cmd .. " gui=" .. opts.gui end
  vim.cmd(cmd)
end

-- CODE
hi("Type", { ctermfg = "151" })
hi("Function", { ctermfg = "12" })
hi("PreProc", { ctermfg = "117" })
hi("Statement", { ctermfg = "12" })
hi("Keyword", { ctermfg = "11" })
hi("Special", { ctermfg = "13" })
hi("Delimiter", { ctermfg = "224" })
vim.cmd("highlight link @keyword.type Keyword")
-- vim.cmd("highlight link @lsp.type.identifier.swift Identifier")

hi("TreesitterContext", { ctermbg = "Black", ctermfg = "none" })

-- Comments and misc
hi("Comment", { ctermfg = "243", guifg = "Grey" })
hi("TODO", { ctermfg = "211", ctermbg = "none", cterm = "italic" })
hi("Title", { ctermfg = "224" })
hi("VimwikiLink", { ctermfg = "12", cterm = "italic" })
hi("TaskWikiTaskPriority", { ctermbg = "none", ctermfg = "9", cterm = "italic" })
hi("Search", { ctermfg = "none", ctermbg = "242", cterm = "none" })

-- Statusline
hi("StatusBarLeft", { ctermfg = "none", ctermbg = "none", cterm = "none" })
hi("StatusBarRight", { ctermfg = "12", ctermbg = "none", cterm = "italic" })
hi("StatusBarGit", { ctermfg = "14", ctermbg = "none", cterm = "none" })
hi("StatusBarWarning", { ctermfg = "11", ctermbg = "none", cterm = "none" })
hi("StatusBarError", { ctermfg = "9", ctermbg = "none", cterm = "none" })
hi("StatusLine", { ctermfg = "White", ctermbg = "none", cterm = "bold", guibg = "none" })
hi("StatusLineNC", { ctermfg = "White", ctermbg = "none", cterm = "bold", guibg = "none" })

-- Popup menu
hi("PMenu", { ctermfg = "none", ctermbg = "none" })
hi("PMenuSel", { ctermfg = "224", ctermbg = "Black" })

-- Hunk (jujutsu)
hi("Red", { ctermfg = "9" })
hi("Green", { ctermfg = "151" })
hi("HunkDiffDeleteDim", { guifg = "Grey", ctermfg = "9" })
hi("HunkSignSelected", { ctermbg = "151" })
hi("HunkSignDeselected", { ctermbg = "9" })

-- Markdown
hi("Title", { ctermfg = "223", ctermbg = "none" })
hi("Folded", { ctermfg = "243", ctermbg = "none" })

-- LSP Diagnostics
hi("LspDiagnosticsDefaultError", { ctermfg = "243", cterm = "italic" })
hi("LspDiagnosticsVirtualTextHint", { ctermfg = "243", cterm = "italic" })
hi("LspDiagnosticsVirtualTextWarning", { ctermfg = "243", cterm = "italic" })
hi("LspDiagnosticsVirtualTextInformation", { ctermfg = "243", cterm = "italic" })

hi("LspDiagnosticsSignHint", { ctermfg = "243", cterm = "italic" })
hi("LspDiagnosticsSignWarning", { ctermfg = "14", cterm = "italic" })
hi("LspDiagnosticsSignInformation", { ctermfg = "14", cterm = "italic" })
hi("LspDiagnosticsSignError", { ctermfg = "1", cterm = "italic" })

hi("LspDiagnosticsErrorHint", { ctermfg = "1", cterm = "italic" })
hi("LspDiagnosticsFloatingWarning", { ctermfg = "9", cterm = "none" })
hi("LspDiagnosticsFloatingHint", { ctermfg = "243", cterm = "none" })
hi("LspDiagnosticsFloatingError", { ctermfg = "9", cterm = "none" })

-- Misc UI elements
vim.cmd("highlight VertSplit cterm=NONE guibg=NONE")
vim.cmd("highlight clear SignColumn")
hi("LineNr", { cterm = "none", ctermfg = "DarkGrey", ctermbg = "none", guibg = "none", guifg = "DarkGrey" })
hi("CursorLineNr", { cterm = "none", ctermfg = "249", guifg = "Grey" })
hi("CursorLine", { cterm = "none", ctermbg = "235", ctermfg = "none" })
hi("SpellBad", { ctermfg = "none", ctermbg = "none", cterm = "underline" })
vim.cmd("highlight clear SpellCap")
vim.cmd("highlight clear TabLineFill")
vim.cmd("highlight clear TabLine")
hi("TabLine", { ctermfg = "8" })
hi("TabLineSel", { ctermfg = "white" })
hi("CopilotSuggestion", { ctermfg = "102" })

-- Git
hi("GitGutterAdd", { guifg = "#009900", ctermfg = "2" })
hi("GitGutterChange", { guifg = "#bbbb00", ctermfg = "3" })
hi("GitGutterDelete", { guifg = "#ff2222", ctermfg = "1" })

hi("DiffRemoved", { ctermfg = "1", ctermbg = "none", cterm = "italic" })
hi("DiffDelete", { ctermfg = "1", ctermbg = "none", cterm = "italic" })
hi("DiffAdd", { ctermfg = "none", ctermbg = "Black", cterm = "none" })
hi("DiffText", { ctermfg = "none", ctermbg = "8", cterm = "italic" })
vim.cmd("highlight clear DiffChange")

-- Telescope
hi("TelescopeNormal", { guibg = "Black" })

-- Floaterm
hi("Floaterm", { guibg = "black" })
hi("FloatermBorder", { guibg = "black", guifg = "black" })
hi("TermCursor", { ctermfg = "2", guifg = "#009900" })

-- Statusline setup
vim.cmd([[
function! GitStatusLine()
  return '[' . FugitiveStatusline()[5:-3] . ']'
endfunction
]])

vim.opt.statusline = table.concat({
  "%#StatusBarLeft#",
  " %f",
  "%#StatusBarGit#",
  " %{GitStatusLine()}",
  "%#StatusBarWarning#",
  " %m",
  "%#StatusBarError#",
  " %r",
  "%=",
  "%#StatusBarRight#",
  " %y",
  " %{&fileencoding?&fileencoding:&encoding}",
  "[%{&fileformat}]",
  " %p%%",
  " %l:%c",
  " ",
})
