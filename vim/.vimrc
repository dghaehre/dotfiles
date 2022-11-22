" ################ Plugins #################
""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tyru/open-browser.vim'
Plug 'vimwiki/vimwiki'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'wellle/targets.vim'
" Plug 'tools-life/taskwiki'
Plug 'ThePrimeagen/harpoon'
Plug 'neovimhaskell/haskell-vim'
Plug 'bakpakin/janet.vim'
Plug 'chentoast/marks.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'vim-test/vim-test'
Plug 'Olical/conjure'
Plug 'sindrets/diffview.nvim'
Plug 'tpope/vim-unimpaired'
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim' " Run :PlantumlOpen
" Debugging

Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-telescope/telescope-dap.nvim'

call plug#end()


" ################ Defaults #################
"""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent
set smartindent
set lcs=tab:›\ ,trail:·

" NOTE: Needed once to fix bug in fish
" set shell=/usr/bin/bash

set wrap
set linebreak
set textwidth=0
set wrapmargin=0
" ^ word wrap

" Store undoes
set undodir=~/.vim/undo-dir
set undofile

set foldmethod=syntax
set foldlevel=0
set foldlevelstart=50
set nocompatible
filetype plugin on
syntax on

set splitbelow
set splitright

" tmux cursor
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Paste in visual mode without fucking up the yank register
vnoremap P "_dP
" Delete in visual mode without fucking up the yank register
vnoremap D "_d

" ################ Default keys/commands #################
"""""""""""""""""""""""""""""""""""""""""""""""
" Set leader
:let mapleader = " "
:let maplocalleader = ","

" copy/paste clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap Y y$

" enable spelling
nnoremap <leader>zu :set spell spelllang=en_us<CR>
nnoremap <leader>zn :set spell spelllang=nb<CR>
nnoremap <leader>zz :set nospell<CR>
" use zg and zug to add and remove from spellfile

" Change word, and press . for changing next word.
nnoremap <leader>x *``cgn
vnoremap <leader>x y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn

" Toggle indent highlight for tabs
nmap <leader>in :set invlist<cr>

" Edit vimrc
:nnoremap <leader>qe :e ~/.vimrc<cr>
" Source .vimrc
:nnoremap <leader>qs :source ~/.vimrc<cr>

" Set current file as current dir
nmap <Leader>cd :cd %:p:h<cr>:pwd<cr>

" Open html file in firefox
nnoremap go :silent !firefox <cfile><cr>

nnoremap <Leader>wp :let @" = expand("%")<CR>


" ################ Tests #################
""""""""""""""""""""""""""""""""""""""""""""
let g:test#neovim#start_normal = 1
let g:test#basic#start_normal = 1
nmap <silent> <leader>gt :TestNearest -strategy=neovim<cr>
nmap <silent> <leader>gT :TestFile -strategy=neovim<cr>



" ################ Snippets #################
""""""""""""""""""""""""""""""""""""""""""""
" TODO: move this to luasnips
abbr newp new Promise((resolve, reject) => {<CR><CR><esc>0i})<esc>0k
abbr iferr if err != nil {<CR><CR>}<esc>kddko
:iab <expr> dts strftime("%d/%m/%y %H:%M:%S")
:iab <expr> plantoday printf("## TODO(s) today \| status:pending sch:%s \n\n\n## DONE today \| status:completed end:%s", strftime("%Y-%m-%d"), strftime("%Y-%m-%d"))
let @c = "#\ncaptured: " . strftime("%d/%m/%y %H:%M")
" ^ Used by capture.


" ################ LF #################
""""""""""""""""""""""""""""""""""""""""""""
let g:lf_map_keys = 0
let g:lf_replace_netrw = 1 " Open lf when vim opens a directory
nnoremap <leader>n :LfWorkingDirectory<CR>
nnoremap <leader>N :LfCurrentFile<CR>

" ######### DISPLAY #############
""""""""""""""""""""""""""""""""""
" TODO: make it compatible with termguicolors
" set termguicolors
set background=dark
set t_Co=256
set fillchars=""
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set signcolumn=number
set nonumber
set nu rnu
set number
set numberwidth=4
:set scrolloff=3
:set cursorline

function! GitStatusLine()
  return '[' . FugitiveStatusline()[5:-3] . ']'
endfunction

" Statusline
set statusline=
set statusline+=%#StatusBarLeft#
set statusline+=\ %f
set statusline+=%#StatusBarGit#
set statusline+=\ %{GitStatusLine()}
set statusline+=%#StatusBarWarning#
set statusline+=\ %m
set statusline+=%#StatusBarError#
set statusline+=\ %r
set statusline+=%=
set statusline+=%#StatusBarRight#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" Colors
"
" CODE
highlight Type              ctermfg=151
highlight Statement         ctermfg=12
highlight PreProc           ctermfg=12
highlight Keyword           ctermfg=11
highlight Special           ctermfg=12
highlight Delimiter         ctermfg=224
highlight Comment           ctermfg=243 guifg=Grey
highlight TODO              ctermfg=211 ctermbg=none cterm=italic
highlight Title             ctermfg=224
highlight VimwikiLink       ctermfg=12 cterm=italic
highlight TaskWikiTaskPriority ctermbg=none ctermfg=9 cterm=italic
highlight Search            ctermfg=none ctermbg=242 cterm=none
highlight StatusBarLeft     ctermfg=none ctermbg=none cterm=none
highlight StatusBarRight    ctermfg=12 ctermbg=none cterm=italic
highlight StatusBarGit      ctermfg=223 ctermbg=none cterm=none
highlight StatusBarWarning  ctermfg=11 ctermbg=none cterm=none
highlight StatusBarError    ctermfg=9 ctermbg=none cterm=none
highlight PMenu ctermfg=none ctermbg=Black

" Markdown
highlight Title ctermfg=223 ctermbg=none
highlight Folded ctermfg=14 ctermbg=none


" LSP
highlight LspDiagnosticsDefaultError ctermfg=243 cterm=italic
highlight LspDiagnosticsVirtualTextHint ctermfg=243 cterm=italic
highlight LspDiagnosticsVirtualTextWarning ctermfg=243 cterm=italic
highlight LspDiagnosticsVirtualTextInformation ctermfg=243 cterm=italic

highlight LspDiagnosticsSignHint ctermfg=243 cterm=italic
highlight LspDiagnosticsSignWarning ctermfg=14 cterm=italic
highlight LspDiagnosticsSignInformation ctermfg=14 cterm=italic
highlight LspDiagnosticsSignError ctermfg=1 cterm=italic

highlight LspDiagnosticsErrorHint ctermfg=1 cterm=italic
highlight LspDiagnosticsFloatingWarning ctermfg=9 cterm=none
highlight LspDiagnosticsFloatingHint ctermfg=243 cterm=none
highlight LspDiagnosticsFloatingError ctermfg=9 cterm=none

" MISC
highlight VertSplit cterm=NONE guibg=NONE
highlight clear SignColumn
highlight LineNr cterm=none ctermfg=DarkGrey ctermbg=none guibg=none guifg=DarkGrey
highlight CursorLineNr cterm=none ctermfg=249 guifg=Grey
highlight CursorLine cterm=none ctermbg=Black ctermfg=none
highlight SpellBad ctermfg=none ctermbg=none cterm=underline
highlight clear SpellCap
highlight clear TabLineFill
highlight clear TabLine
highlight TabLine ctermfg=8
highlight TabLineSel ctermfg=white
:highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" GIT
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

highlight DiffRemoved    ctermfg=1 ctermbg=none cterm=italic
highlight DiffDelete     ctermfg=1 ctermbg=none cterm=italic
highlight DiffAdd        ctermfg=none ctermbg=23
highlight DiffText       ctermfg=none ctermbg=8 cterm=italic
highlight clear DiffChange

highlight TelescopeNormal guibg=Black


" ################ GIT #################
""""""""""""""""""""""""""""""""""""""""""""
" Move to next/prev unstaged change
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
" Stage changes/hunk
nnoremap ga <Plug>(GitGutterStageHunk)
vnoremap ga <Plug>(GitGutterStageHunk)
" Undo changes/hunk
nnoremap gu <Plug>(GitGutterUndoHunk)

" Open up git status
nnoremap <leader>gs :G<cr>
nnoremap <leader>gS :0G<cr>
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>gp :! git push -u origin (git rev-parse --abbrev-ref HEAD)<cr>
" Open up git log for current file
nnoremap <leader>gl :0Gclog<cr>

" Diffview
nnoremap <leader>gdo :DiffviewOpen 
nnoremap <leader>gdt :DiffviewToggleFiles<CR>


" Lets try to use terminal instead of floatterm
nnoremap <C-t> :b term:<cr>

" setup mapping to call :LazyGit
nnoremap <silent> <leader>G :LazyGit<CR>

" #################### Floatterm ########################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_opener = 'vsplit'
let g:floaterm_keymap_new = '<C-t>'
let g:floaterm_keymap_next = '<C-n>'
let g:floaterm_keymap_prev = '<C-p>'
let g:floaterm_keymap_kill = '<C-x>'
hi Floaterm guibg=black
hi FloatermBorder guibg=black guifg=black
highlight TermCursor ctermfg=2 guifg=#009900
noremap  <C-f>  :FloatermToggle<CR>
tnoremap <C-f> <C-\><C-n>:FloatermToggle<CR>
tnoremap <C-o> <C-\><C-n>


" ########## Harpoon ###########
""""""""""""""""""""""""""""""""
nnoremap <leader>hh :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>ho :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>ha :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>hs :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>hd :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>hf :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>hg :lua require("harpoon.ui").nav_file(5)<CR>

" Terminal
nnoremap 'q :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap 'w :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap 'e :lua require("harpoon.term").gotoTerminal(3)<CR>
nnoremap 'r :lua require("harpoon.term").gotoTerminal(4)<CR>
nnoremap 't :lua require("harpoon.term").gotoTerminal(5)<CR>

" ########## Telescope ###########
"""""""""""""""""""""""""""""
nnoremap <leader>sf <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>scf <cmd>lua require('telescope.builtin').find_files({ cwd = require('telescope.utils').buffer_dir(), hidden = true, no_ignore = true })<cr>
nnoremap <leader>scg <cmd>lua require('telescope.builtin').live_grep({ cwd = require('telescope.utils').buffer_dir(), hidden = true, no_ignore = true })<cr>
nnoremap <leader>sg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>/ <cmd>lua require('telescope.builtin').grep_string()<cr>
" TODO: make grep_string also work in visual mode
nnoremap <leader>sbf <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>sbg <cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>
nnoremap <leader>sc <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>so <cmd>lua require('telescope.builtin').oldfiles({ follow = true })<cr>
nnoremap <leader>sm <cmd>lua require('telescope.builtin').marks()<cr>
nnoremap <leader>sr <cmd>lua require('telescope.builtin').registers()<cr>
nnoremap <leader>= <cmd>lua require('telescope.builtin').spell_suggest()<cr>
nnoremap <leader>cb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>cl <cmd>lua require('telescope.builtin').git_commits()<cr>
" vimwiki
nnoremap <Leader>swf <cmd>lua require('telescope.builtin').find_files({ search_dirs = { "~/wikis/vimwiki/" }, no_ignore = true })<cr>
" The no_ignore doesnt work with live_grep
nnoremap <Leader>swg <cmd>lua require('telescope.builtin').live_grep({ search_dirs = { "~/wikis/vimwiki/" }})<cr>
" vimwiki work (jobb)
nnoremap <Leader>sjf <cmd>lua require('telescope.builtin').find_files({ search_dirs = { "~/wikis/work/" }, no_ignore = true })<cr>
nnoremap <Leader>sjg <cmd>lua require('telescope.builtin').live_grep({ search_dirs = { "~/wikis/work/" }})<cr>
" dotfiles
nnoremap <Leader>sdf <cmd>lua require('telescope.builtin').find_files({ search_dirs = { "~/dotfiles" }, hidden = true, no_ignore = true })<cr>
nnoremap <Leader>sdg <cmd>lua require('telescope.builtin').live_grep({ search_dirs = { "~/dotfiles" }, hidden = true, no_ignore = true })<cr>
" Go to a zoxide dir
nnoremap <leader>scd :Telescope zoxide list<cr>


" LSP
nnoremap <Leader>D   <cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>
nnoremap         gd  <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap         gtd  <cmd>lua require('telescope.builtin').lsp_definitions({jump_type="tab"})<cr>
nnoremap         gi  <cmd>lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap         gI  <cmd>lua require('telescope.builtin').lsp_implementations({jump_type="tab"})<cr>
nnoremap         gr  <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap         gR  <cmd>lua require('telescope.builtin').lsp_references({jump_type="tabs"})<cr>
nnoremap <Leader>ga  <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>


" #################### Zen Mode ########################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>Z :ZenMode<cr>



" ############# NAVIGATION ##########
"""""""""""""""""""""""""""""""""""""
" toggles between buffers
nnoremap <leader><leader> <c-^>

" Disabled for others usecase.
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nmap <Leader>e :vsp<Enter>
nmap <Leader>E :sp<Enter>

" Move between tabs
nnoremap <Leader><C-l> :tabnext<cr>
nnoremap <Leader><C-h> :tabprev<cr>

" Move 1 more lines up or down in normal and visual selection modes.
nnoremap <C-u> :m .-2<CR>==
nnoremap <C-d> :m .+1<CR>==
vnoremap <C-u> :m '<-2<CR>gv=gv
vnoremap <C-d> :m '>+1<CR>gv=gv

" Make it simpler to use marks
" nnoremap ma mA
" nnoremap ms mS
" nnoremap md mD
" nnoremap mf mF
" nnoremap mt mT

" NOTE: using harpoon instead for now
" nnoremap 'j 'J
" nnoremap 'k 'K
" nnoremap 'l 'L
" nnoremap 't 'T
" nnoremap 'a 'A
" nnoremap 's 'S
" nnoremap 'd 'D
" nnoremap 'f 'F
" nnoremap 't 'T


" ############ Resizing ############
""""""""""""""""""""""""""""""""""""
nmap <Leader>rk :resize +20<Enter>
nmap <Leader>rj :resize -20<Enter>
nmap <Leader>rh :vertical resize +20<Enter>
nmap <Leader>rl :vertical resize -20<Enter>



" ################ Language specific #################
"----------------------------------------------------"
"
"
" ################ Terminal #################
""""""""""""""""""""""""""""""""""""""""""""
autocmd TermOpen * setlocal nonu nornu


" ################ Haskell #################
""""""""""""""""""""""""""""""""""""""""""""
" uses haskell-vim plugin
autocmd FileType haskell setlocal shiftwidth=2 tabstop=2 expandtab
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
" https://github.com/chrisdone/hindent#vim
" Using Hindent in V mode: gq


" ################ Golang #################
" autocmd FileType go setlocal invlist
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1




" ################ Vimwiki/markdown #################
""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [{'path': '~/wikis/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}, {'path': '~/wikis/work/', 'syntax': 'markdown', 'ext': '.md'}]

" Create link
:vmap <Leader>l di[](<Esc>pa)<Esc>f[,a
" Handle lists
:map <Leader>tt <Plug>VimwikiToggleListItem
:nmap <Leader>tj <Plug>VimwikiIncrementListItem
:vmap <Leader>tj <Plug>VimwikiIncrementListItem
:nmap <Leader>tk <Plug>VimwikiDecrementListItem
:vmap <Leader>tk <Plug>VimwikiDecrementListItem
" Create table
:map <Leader>ta :VimwikiTable<Enter>

" Folding for vimwiki and markdown files
let g:vimwiki_folding = 'custom' " let folding to be set by another plugin
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "="
endfunction
autocmd FileType markdown setlocal foldexpr=MarkdownLevel()
autocmd FileType markdown setlocal foldmethod=expr
autocmd FileType markdown setlocal foldlevelstart=50

" Capture a note/idea fast for sorting later
function CaptureVimwiki()
  execute ":e ~/wikis/vimwiki/Inbox/".strftime("%d-%m-%y-%H%M").expand(".md")
endfunction
function CaptureWork()
  execute ":e ~/wikis/work/Inbox/".strftime("%d-%m-%y-%H%M").expand(".md")
endfunction
nnoremap <Leader>ca :call CaptureVimwiki()<CR>"cpggA
nnoremap <Leader>cja :call CaptureWork()<CR>"cpggA

" Search for todo's
" function VimwikiFindIncompleteTasks()
"   lvimgrep /- \[ \]/ %:p
"   lopen
" endfunction
"
" function VimwikiFindAllIncompleteTasks()
"   VimwikiSearch /- \[ \]/
"   lopen
" endfunction

" There are multiple things I want to improve here:
" - Add 'commands' that let me easily toggle them!
" - include - [.], - [o] in search
nnoremap <Leader>swt <cmd>lua require('telescope.builtin').grep_string({ search_dirs = { "~/wikis/vimwiki/" }, search = "- [ ]" })<cr>
nnoremap <Leader>swx <cmd>lua require('telescope.builtin').grep_string({ search_dirs = { "~/wikis/vimwiki/" }, search = "- [X]" })<cr>

" Check for backlinks
nnoremap <Leader>wb :VWB<CR>

function CreateWikilink()
  let header = trim(substitute(join(getline(1, 1), ""), "#\*", "", ""))
  let list = split(expand("%:p"), "/")
  return "[" . header . "](/" . join(list[4:],"/") . ")"
endfunction
nnoremap <Leader>wy :let @" = CreateWikilink()<CR>

nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>
nmap <Leader>wx :call VimwikiFindIncompleteTasks()<CR>



" Usage: :Diff <branch>
"
" Create a split with a diff for the given buffer towards a given branch
"
" Example: :Diff master
function! Diff(spec)
    vertical new
    setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
    let cmd = "++edit #"
    if len(a:spec)
        let cmd = "!git -C " . shellescape(fnamemodify(finddir('.git', '.;'), ':p:h:h')) . " show " . a:spec . ":#"
    endif
    execute "read " . cmd
    silent 0d_
    diffthis
    wincmd p
    diffthis
endfunction
command! -nargs=? Diff call Diff(<q-args>)

" ################ Bugs #################
"""""""""""""""""""""""""""""""""""""""""
" Fix crontab bug
autocmd filetype crontab setlocal nobackup nowritebackup
