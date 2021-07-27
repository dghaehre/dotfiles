" ################ Plugins #################
""""""""""""""""""""""""""""""""""""""""""""
let g:polyglot_disabled = ['sensible']
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tyru/open-browser.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'voldikss/vim-floaterm'
Plug 'wellle/targets.vim'
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

" toggles between buffers
nnoremap <leader><leader> <c-^>

" enable spelling
nnoremap <leader>zu :set spell spelllang=en_us<cr>
nnoremap <leader>zn :set spell spelllang=nb<cr>
nnoremap <leader>zz :set nospell<cr>

" Change word, and press . for changing next word.
nnoremap <leader>x *``cgn
vnoremap <leader>x y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn

" Toggle indent highlight for tabs
nmap <leader>in :set invlist<cr>

" Used by capture.
let @c = "#\ncaptured: " . strftime("%d/%m/%y %H:%M")

" Edit .vimrc
:nnoremap <leader>qv :vsplit ~/.vimrc<cr>
:nnoremap <leader>qs :source ~/.vimrc<cr>

" Set currentfile as current dir
nmap <Leader>cd :cd %:p:h<cr>:pwd<cr>

" write dts to insert date and time
:iab <expr> dts strftime("%d/%m/%y %H:%M:%S")

nmap ga <Plug>(GitGutterStageHunk)
" ^ Stage changes/hunk
nmap gu <Plug>(GitGutterUndoHunk)
" ^ Undo changes/hunk

nmap gE :G<cr>
nmap gs :0G<cr>
" ^ Open up git status
nnoremap gl :0Glog<cr>
" ^ Open up git log for current file

" Helpers:
"
" Search for text in file:
" 1. yank text
" 2. q/p
"
" Search in file for hover over word: #


" ################ Snippets #################
""""""""""""""""""""""""""""""""""""""""""""
abbr newp new Promise((resolve, reject) => {<CR><CR><esc>0i})<esc>0k
abbr iferr if err != nil {<CR><CR>}<esc>kddko



" ################ NERDTree #################
""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let NERDTreeMinimalUI=1
let NERDTreeIgnore = ['^node_modules$']
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeToggle<CR>




" ######### DISPLAY #############
""""""""""""""""""""""""""""""""""
set background=dark
set t_Co=256
let g:airline_powerline_fonts = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = ' !'
let g:airline_theme='lucius'
set fillchars=""
highlight VertSplit cterm=NONE
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set number
set numberwidth=5
:set scrolloff=6
:set cursorline
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight CursorLine cterm=NONE ctermbg=Black ctermfg=NONE guibg=NONE guifg=NONE
highlight clear SignColumn
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
highlight CocFloating ctermfg=White ctermbg=Black
highlight PMenu ctermfg=11 ctermbg=Black


" #################### Floatterm ########################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_keymap_new = '<C-t>'
let g:floaterm_keymap_next = '<C-n>'
let g:floaterm_keymap_prev = '<C-p>'
let g:floaterm_keymap_kill = '<C-x>'
hi Floaterm guibg=black
hi FloatermBorder guibg=black guifg=black
highlight TermCursor ctermfg=2 guifg=#009900
noremap  <C-f>  :FloatermToggle<CR>
tnoremap <C-f> <C-\><C-n>:FloatermToggle<CR>
tnoremap ,<ESC> <C-\><C-n>
" Broot
noremap  <leader>fb :FloatermNew --name=broot --autoclose=2 broot<CR>


" ################ Coc language server #################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:check_back_space() abort
  let col = col('.') - 1
   return !col || getline('.')[col - 1]  =~ '\s'
   endfunction

inoremap <silent><expr> <Tab>
     \ pumvisible() ? "\<C-n>" :
     \ <SID>check_back_space() ? "\<Tab>" :
     \ coc#refresh()

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" ########## FZF ###########
"""""""""""""""""""""""""""""
nmap <Leader>b :Buffers<Enter>
nmap <Leader>s :Files<Enter>
nmap <Leader>m :Marks<Enter>
nmap <Leader>o :History<Enter>
nmap <Leader>g :Rg<Enter>
nmap <Leader>ws :Files ~/wikis/personal<cr>
" Let you enter <Leader>g to search higlighted text in whole project
" A quick and dirty trick if tags or coc is missing
nmap <Leader>/ viwy:Rg <C-R>=escape(@",'/\')<CR><CR>



" ############# NAVIGATION ##########
"""""""""""""""""""""""""""""""""""""
set splitbelow
set splitright

" Disabled for others usecase.
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nmap <Leader>e :vsp<Enter>
nmap <Leader>E :sp<Enter>
nnoremap <Leader>O :on<Enter>

nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
" ^ Move to next/prev unstaged change

" Move 1 more lines up or down in normal and visual selection modes.
nnoremap <C-u> :m .-2<CR>==
nnoremap <C-d> :m .+1<CR>==
vnoremap <C-u> :m '<-2<CR>gv=gv
vnoremap <C-d> :m '>+1<CR>gv=gv




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
autocmd FileType go setlocal invlist
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" ################ Vimwiki #################
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

" fuzzy find personal files
command! -bang -nargs=? -complete=dir PersonalFiles
    \ call fzf#vim#files('~/wikis/personal', fzf#vim#with_preview(), <bang>0)
:map <Leader>wp :PersonalFiles<Enter>

" fuzzy find work files
command! -bang WorkFiles call fzf#vim#files('~/wikis/work', fzf#vim#with_preview(), <bang>0)
:map <Leader>wW :WorkFiles<Enter>

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



" ################ Vue #################
""""""""""""""""""""""""""""""""""""""""
let g:vue_pre_processors = []


" ################ Bugs #################
"""""""""""""""""""""""""""""""""""""""""
" Fix crontab bug
autocmd filetype crontab setlocal nobackup nowritebackup
