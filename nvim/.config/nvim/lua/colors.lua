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

-- All custom highlights live in one function because :colorscheme and any
-- change to 'background' reset every highlight group back to the scheme's
-- defaults. Re-applying on ColorScheme (which fires *after* that reset --
-- verified) keeps them alive. Previously only the background-dependent subset
-- was re-applied, via an OptionSet autocmd, so a live `:set background=light`
-- silently dropped Comment, Search, LineNr, GitGutter*, the StatusBar groups
-- and the Diagnostic* groups back to defaults.
local function apply_highlights()
	-- CODE (Type/Function/PreProc/Statement/Keyword/Special/Delimiter are set
	-- by apply_bg_highlights() below so they adapt to light vs dark background)
	vim.cmd("highlight link @keyword.type Keyword")
	-- gopls marks nil as a built-in variable, overriding Treesitter's purple.
	vim.cmd("highlight! link @lsp.typemod.variable.defaultLibrary.go Special")
	-- vim.cmd("highlight link @lsp.type.identifier.swift Identifier")

	hi("TreesitterContext", { ctermbg = "Black", ctermfg = "none" })

	-- Comments and misc
	hi("Comment", { ctermfg = "243", guifg = "Grey" })
	hi("TODO", { ctermfg = "211", ctermbg = "none", cterm = "italic" })
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
	--
	-- These use the Diagnostic* groups (Neovim 0.6+). The config previously set
	-- LspDiagnostics* -- the pre-0.6 names -- which no longer exist, so none of it
	-- applied and diagnostics fell back to the defaults (bright red / yellow).
	--
	-- Intent preserved from the old values: inline text muted grey, gutter signs
	-- coloured. DiagnosticVirtualText*/Sign*/Floating* link to the Diagnostic*
	-- base groups by default, so setting the base is what colours the inline text.
	hi("DiagnosticError", { ctermfg = "243", cterm = "italic" })
	hi("DiagnosticVirtualTextHint", { ctermfg = "243", cterm = "italic" })
	hi("DiagnosticVirtualTextWarn", { ctermfg = "243", cterm = "italic" })
	hi("DiagnosticVirtualTextInfo", { ctermfg = "243", cterm = "italic" })

	hi("DiagnosticSignHint", { ctermfg = "243", cterm = "italic" })
	-- SignWarn / SignInfo / FloatingWarn / FloatingError are set by
	-- apply_bg_highlights() so they adapt to light vs dark background.
	hi("DiagnosticSignError", { ctermfg = "1", cterm = "italic" })

	hi("DiagnosticFloatingHint", { ctermfg = "243", cterm = "none" })

	-- Misc UI elements
	vim.cmd("highlight VertSplit cterm=NONE guibg=NONE")
	vim.cmd("highlight clear SignColumn")
	hi("LineNr", { cterm = "none", ctermfg = "DarkGrey", ctermbg = "none", guibg = "none", guifg = "DarkGrey" })
	-- Highlights that depend on light vs dark background.
	-- Dark values match the original config; light values pick darker/softer
	-- 256-color cterm equivalents that stay readable on a white-ish background.
	local function apply_bg_highlights()
		if vim.o.background == "light" then
			hi("CursorLine", { cterm = "none", ctermbg = "254", ctermfg = "none" })
			-- CODE (treesitter cascades from these)
			hi("Type", { ctermfg = "28" })                                            -- was 151 light-green
			hi("Function", { ctermfg = "25" })                                        -- was 12 bright-blue
			hi("PreProc", { ctermfg = "30" })                                         -- was 117 light-cyan
			hi("Statement", { ctermfg = "25" })                                       -- was 12
			hi("Keyword", { ctermfg = "90" })                                         -- was 11 yellow (unreadable on white)
			hi("Special", { ctermfg = "90" })                                         -- was 13 bright-magenta
			hi("Delimiter", { ctermfg = "240" })                                      -- was 224 light-pink
			hi("Identifier", { ctermfg = "NONE" })                                    -- inherit Normal (black) on light bg
			hi("CursorLineNr", { cterm = "none", ctermfg = "240", guifg = "DarkGrey" }) -- was 249 (washed out on white)
			hi("DiffAdd", { ctermfg = "none", ctermbg = "194", cterm = "none" })      -- was Black (unreadable on light)
			hi("DiffText", { ctermfg = "none", ctermbg = "156", cterm = "italic" })   -- was 8 (bright black)
			-- LSP signs / floats
			hi("DiagnosticSignWarn", { ctermfg = "130", cterm = "italic" })           -- was 14
			hi("DiagnosticSignInfo", { ctermfg = "25", cterm = "italic" })            -- was 14
			hi("DiagnosticFloatingWarn", { ctermfg = "130", cterm = "none" })         -- was 9
			hi("DiagnosticFloatingError", { ctermfg = "124", cterm = "none" })        -- was 9

			-- terminal is in: Dark theme
		else
			hi("CursorLine", { cterm = "none", ctermbg = "235", ctermfg = "none" })
			-- CODE
			hi("Type", { ctermfg = "151" })
			hi("Function", { ctermfg = "12" })
			hi("PreProc", { ctermfg = "117" })
			hi("Statement", { ctermfg = "12" })
			hi("Keyword", { ctermfg = "11" })
			hi("Special", { ctermfg = "13" })
			hi("Delimiter", { ctermfg = "224" })
			-- LSP signs / floats
			hi("DiagnosticSignWarn", { ctermfg = "14", cterm = "italic" })
			hi("DiagnosticSignInfo", { ctermfg = "14", cterm = "italic" })
			hi("DiagnosticFloatingWarn", { ctermfg = "9", cterm = "none" })
			hi("DiagnosticFloatingError", { ctermfg = "9", cterm = "none" })
			hi("Identifier", { ctermfg = "14" }) -- vim colorscheme default
			hi("CursorLineNr", { cterm = "none", ctermfg = "249", guifg = "Grey" })
			hi("DiffAdd", { ctermfg = "none", ctermbg = "Black", cterm = "none" })
			hi("DiffText", { ctermfg = "none", ctermbg = "8", cterm = "italic" })
		end
	end
	apply_bg_highlights()
	hi("SpellBad", { ctermfg = "none", ctermbg = "none", cterm = "underline" })
	vim.cmd("highlight clear SpellCap")
	vim.cmd("highlight clear TabLineFill")
	vim.cmd("highlight clear TabLine")
	hi("TabLine", { ctermfg = "8" })
	hi("TabLineSel", { ctermfg = "white" })

	-- Git
	hi("GitGutterAdd", { guifg = "#009900", ctermfg = "2" })
	hi("GitGutterChange", { guifg = "#bbbb00", ctermfg = "3" })
	hi("GitGutterDelete", { guifg = "#ff2222", ctermfg = "1" })

	hi("DiffRemoved", { ctermfg = "1", ctermbg = "none", cterm = "italic" })
	hi("DiffDelete", { ctermfg = "1", ctermbg = "none", cterm = "italic" })
	-- DiffAdd and DiffText set by apply_bg_highlights()
	vim.cmd("highlight clear DiffChange")

	-- Floaterm
	-- NOTE: TelescopeNormal / Floaterm / FloatermBorder used to be set here with
	-- guibg only. 'termguicolors' is false (see settings.lua), so gui* values are
	-- ignored entirely and those three did nothing -- removed. If you ever want
	-- them back, they need ctermbg.
	hi("TermCursor", { ctermfg = "2", guifg = "#009900" })
end

apply_highlights()

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

-- Statusline setup
vim.cmd([[
function! GitStatusLine()
  if exists('*FugitiveStatusline')
    return '[' . FugitiveStatusline()[5:-3] . ']'
  endif
  return ''
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
