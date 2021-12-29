" ################ Plugins #################
""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'justinmk/vim-sneak'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
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
Plug 'tools-life/taskwiki'
Plug 'neovimhaskell/haskell-vim'
Plug 'bakpakin/janet.vim'
Plug 'ThePrimeagen/harpoon'
call plug#end()



" ################ Defaults #################
"""""""""""""""""""""""""""""""""""""""""""""
:set expandtab
:set shiftwidth=2
:set softtabstop=2
:set tabstop=2
:set autoindent
:set smartindent
:set lcs=tab:›\ ,trail:·

set wrap
set linebreak
set textwidth=0
set wrapmargin=0
" ^ word wrap

" Store undoes
set undodir=~/.vim/undo-dir
set undofile

set foldmethod=indent
set foldlevel=0
set foldlevelstart=20
set nocompatible
filetype plugin on
syntax on
:set number relativenumber
:set nu rnu

set splitbelow
set splitright

" tmux cursor
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1




" ################ Default keys/commands #################
"""""""""""""""""""""""""""""""""""""""""""""""
" Set leader
:let mapleader = " "

" copy/paste clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap Y y$

" enable spelling
nnoremap <leader>zu :set spell spelllang=en_us<cr>
nnoremap <leader>zn :set spell spelllang=nb<cr>
nnoremap <leader>zz :set nospell<cr>

" Change word, and press . for changing next word.
nnoremap <leader>x *``cgn
vnoremap <leader>x y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn

" Toggle indent highlight for tabs
nmap <leader>in :set invlist<cr>

" Source .vimrc
:nnoremap <leader>qs :source ~/.vimrc<cr>

" Set currentfile as current dir
nmap <Leader>cd :cd %:p:h<cr>:pwd<cr>

" Open html file in firefox
nnoremap go :silent !firefox <cfile><cr>



" ################ Snippets #################
""""""""""""""""""""""""""""""""""""""""""""
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

" ################ BROOT #################
""""""""""""""""""""""""""""""""""""""""""""
noremap  <leader>br :FloatermNew --name=broot --autoclose=2 broot<CR>

" ######### DISPLAY #############
""""""""""""""""""""""""""""""""""
" TODO: make it compatible with termguicolors
" set termguicolors
set background=dark
set t_Co=256
set fillchars=""
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set number
set numberwidth=5
:set scrolloff=6
:set cursorline

" Statusline
set statusline=
set statusline+=%#StatusBarLeft#
set statusline+=\ %f
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
highlight StatusBarWarning  ctermfg=11 ctermbg=none cterm=none
highlight StatusBarError    ctermfg=9 ctermbg=none cterm=none
highlight PMenu ctermfg=none ctermbg=Black

" highlight Special         ctermfg=110
" highlight Special         ctermfg=81

" LSP
highlight LspDiagnosticsDefaultError ctermfg=243 cterm=italic
highlight LspDiagnosticsVirtualTextHint ctermfg=243 cterm=italic
highlight LspDiagnosticsVirtualTextWarning ctermfg=243 cterm=italic
highlight LspDiagnosticsVirtualTextInformation ctermfg=243 cterm=italic
"
highlight LspDiagnosticsSignHint ctermfg=243 cterm=italic
highlight LspDiagnosticsSignWarning ctermfg=14 cterm=italic
highlight LspDiagnosticsSignInformation ctermfg=14 cterm=italic
highlight LspDiagnosticsSignError ctermfg=1 cterm=italic
"
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

" GIT
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

highlight DiffRemoved    ctermfg=1 ctermbg=none cterm=italic
highlight DiffDelete     ctermfg=1 ctermbg=none cterm=italic
highlight DiffAdd        ctermfg=none ctermbg=8
highlight DiffText       ctermfg=3 ctermbg=none cterm=italic
highlight clear DiffChange


" ################ GIT #################
""""""""""""""""""""""""""""""""""""""""""""
" Move to next/prev unstaged change
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
" Stage changes/hunk
nmap ga <Plug>(GitGutterStageHunk)
" Undo changes/hunk
nnoremap gu <Plug>(GitGutterUndoHunk)
" Open up git status
nnoremap gE :G<cr>
nnoremap gs :0G<cr>
" Open up git log for current file
nnoremap gl :0Gclog<cr>


" #################### Floatterm ########################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_keymap_new = '<C-t>'
let g:floaterm_keymap_next = '<C-n>'
" let g:floaterm_keymap_prev = '<C-p>'
let g:floaterm_keymap_kill = '<C-x>'
hi Floaterm guibg=black
hi FloatermBorder guibg=black guifg=black
highlight TermCursor ctermfg=2 guifg=#009900
noremap  <C-f>  :FloatermToggle<CR>
tnoremap <C-f> <C-\><C-n>:FloatermToggle<CR>
tnoremap ,<ESC> <C-\><C-n>

" ########## Harpoon ###########
""""""""""""""""""""""""""""""""
nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>hh :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap 'j :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap 'k :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap 'l :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap 'i :lua require("harpoon.ui").nav_file(4)<CR>

" ########## Telescope ###########
"""""""""""""""""""""""""""""
nnoremap <leader>s <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>S <cmd>lua require('telescope.builtin').find_files({ cwd = require('telescope.utils').buffer_dir(), hidden = true })<cr>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <Leader>wg <cmd>lua require('telescope.builtin').live_grep({ search_dirs = { "~/wikis/personal/" } })<cr>
nnoremap <leader>/ <cmd>lua require('telescope.builtin').grep_string()<cr>
" TODO: make grep_string also work in visual mode
nnoremap <leader>bs <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>bg <cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>
nnoremap <leader>C <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>o <cmd>lua require('telescope.builtin').oldfiles({ follow = true })<cr>
nnoremap <leader>m <cmd>lua require('telescope.builtin').marks()<cr>
nnoremap <leader>R <cmd>lua require('telescope.builtin').registers()<cr>
nnoremap <leader>= <cmd>lua require('telescope.builtin').spell_suggest()<cr>
nnoremap <leader>cb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>cl <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <Leader>ws <cmd>lua require('telescope.builtin').find_files({ search_dirs = { "~/wikis/personal/" } })<cr>

" LSP
nnoremap <leader>D <cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>
nnoremap        gd <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap        gi <cmd>lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap        gr <cmd>lua require('telescope.builtin').lsp_references()<cr>




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

" Move 1 more lines up or down in normal and visual selection modes.
nnoremap <C-u> :m .-2<CR>==
nnoremap <C-d> :m .+1<CR>==
vnoremap <C-u> :m '<-2<CR>gv=gv
vnoremap <C-d> :m '>+1<CR>gv=gv

" Make it simpler to use marks
" test
nnoremap mt mT
" start
nnoremap ms mS
" db
nnoremap md mD

nnoremap mj mJ
nnoremap mk mK
nnoremap ml mL

" NOTE: using harpoon instead for now
" nnoremap 'j 'J
" nnoremap 'k 'K
" nnoremap 'l 'L
" nnoremap 't 'T
" nnoremap 's 'S
" nnoremap 'd 'D


" ############ Resizing ############
""""""""""""""""""""""""""""""""""""
nmap <Leader>rk :resize +20<Enter>
nmap <Leader>rj :resize -20<Enter>
nmap <Leader>rh :vertical resize +20<Enter>
nmap <Leader>rl :vertical resize -20<Enter>



" ################ Language specific #################
"----------------------------------------------------"

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
let g:vimwiki_list = [
      \{'path': '~/wikis/personal/', 'syntax': 'markdown', 'ext': '.md'},
      \{'path': '~/wikis/work/', 'syntax': 'markdown', 'ext': '.md'}]
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
autocmd BufEnter *.md setlocal foldexpr=MarkdownLevel()  
autocmd BufEnter *.md setlocal foldmethod=expr   
autocmd BufEnter *.md setlocal foldlevelstart=1   

" Capture a note/idea fast for sorting later
function Capture()
  execute ":e ~/wikis/personal/Inbox/".strftime("%d-%m-%y-%H%M").expand(".md")
endfunction
nnoremap <Leader>ca :call Capture()<CR>"cpggA

" Search for todo's
function! VimwikiFindIncompleteTasks()
  lvimgrep /- \[ \]/ %:p
  lopen
endfunction

function! VimwikiFindAllIncompleteTasks()
  VimwikiSearch /- \[ \]/
  lopen
endfunction

nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>
nmap <Leader>wx :call VimwikiFindIncompleteTasks()<CR>



" ################ Bugs #################
"""""""""""""""""""""""""""""""""""""""""
" Fix crontab bug
autocmd filetype crontab setlocal nobackup nowritebackup



" ################ Delve debugger #################
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Assuming you have delve running in tmux pane 2
"
" Send filename and filenumber as a breakpoint to delve
nnoremap <silent> <leader>db :exe "!tmux send -t 2 'b %:p:" . line(".") . "' Enter"<CR><C-L>
" Send continue to delve
nnoremap <silent> <leader>dc :exe "!tmux send -t 2 'c' Enter"<CR><C-L>
" Print out selected text in delve
vnoremap <silent> <leader>dp "4y:exe "!tmux send -t 2 'p <c-r>"' Enter"<CR><C-L>
" Show status
nnoremap <silent> <leader>dl :exe "!tmux send -t 2 'ls' Enter"<CR><C-L>
" TODO
" Start a delve session in a new tmux session, from the current file
" nnoremap <silent> <leader>ds :exe "!tmux split-window -h -I -c \"%:p\" Enter"<CR><C-L>
