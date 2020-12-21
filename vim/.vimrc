" ################ Plugins #################
""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'rust-lang/rust.vim'
Plug 'vimwiki/vimwiki'
Plug 'neovimhaskell/haskell-vim'
Plug 'raichoo/purescript-vim'
Plug 'frigoeu/psc-ide-vim'
Plug 'posva/vim-vue'
Plug 'elmcast/elm-vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ianks/vim-tsx'
Plug 'elixir-editors/vim-elixir'
Plug 'mcchrish/nnn.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'LnL7/vim-nix'
Plug 'mhinz/vim-startify'
Plug 'ap/vim-css-color'
call plug#end()



" ################ Defaults #################
"""""""""""""""""""""""""""""""""""""""""""""

:set expandtab
:set shiftwidth=2
:set softtabstop=2
:set autoindent
:set smartindent

set wrap
set linebreak
set textwidth=0
set wrapmargin=0
" ^ word wrap

" Store undoes
set undodir=~/.vim/undo-dir
set undofile

set foldmethod=manual
set foldlevel=0
set foldlevelstart=20
set nocompatible
filetype plugin on
syntax on
:set number relativenumber
:set nu rnu


" ################ Default keys/commands #################
"""""""""""""""""""""""""""""""""""""""""""""""
" Set leader
:let mapleader = " "

"== Copy to clipboard
let @y = "\"+y"

" close all folds
nmap <Leader>fj zM
" open all folds
nmap <Leader>fk zR
" toggle fold from cursor
nmap <Leader>ff zA
" start to make a manual fold
nmap <Leader>fm zf

" toggles between buffers
nnoremap <leader><leader> <c-^>

" enable spelling
command! SpellUs execute "set spell spelllang=en_us"
command! SpellNb execute "set spell spelllang=nb"
" disable: :set nospell

" Change word, and press . for changing next word.
nnoremap <leader>x *``cgn
vnoremap <leader>x y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn

 " TODO: make filename nice
let @d = ""
  \ . "+++\ntitle = \"" . expand('%:r') . "\"\n"
  \ . "date = " . strftime('%Y-%m-%d') . "\n"
  \ . "[taxonomies]\n"
  \ . "tags = []\n"
  \ . "+++\n\n# " . expand('%:r')

" Edit .vimrc
:nnoremap <leader>qv :vsplit ~/.vimrc<cr>
:nnoremap <leader>qs :source ~/.vimrc<cr>

" Set currentfile as current dir
nmap <Leader>cd :cd %:p:h<cr>

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



" ################ File manager #################
""""""""""""""""""""""""""""""""""""""""""""
" nnn
let g:nnn#action = { '<c-e>': 'vsplit' }




" ######### DISPLAY #############
""""""""""""""""""""""""""""""""""
set background=dark
set t_Co=256
let g:airline_powerline_fonts = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = ' !'
let g:airline_theme='atomic'
set fillchars=""
highlight VertSplit cterm=NONE
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set number
set numberwidth=5
:set cursorline
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight CursorLine cterm=NONE ctermbg=Black ctermfg=NONE guibg=NONE guifg=NONE



" #################### Startify ########################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_bookmarks = [ {'c': '~/.vimrc'}, {'z': '~/.zshrc'}, {'s': '~/.ssh/config'}, {'g': '~/.gitconfig'} ]



" ################ Coc language server #################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bug: higlight only takes effect after sourcing .vimrc
highlight CocFloating ctermfg=NONE
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
nmap <Leader>g :Rg<Enter>
" Let you enter <Leader>g to search higlighted text in whole project
" A quick and dirty trick if tags or coc is missing
nmap <Leader>/ viwy:Rg <C-R>=escape(@",'/\')<CR><CR>





" ############# NAVIGATION ##########
"""""""""""""""""""""""""""""""""""""
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nmap <Leader>e :vsp<Enter>
nmap <Leader>E :sp<Enter>





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



" ################ Vimwiki #################
""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [
      \{'path': '~/wikis/work/', 'syntax': 'markdown', 'ext': '.md'},
      \{'path': '~/wikis/personal/', 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_folding='expr'
:nmap <Leader>wsp <Plug>VimwikiSplitLink
" Create link
:vmap <Leader>l di[](<Esc>pa)<Esc>f[,a
" Handle lists
:map <Leader>tt <Plug>VimwikiToggleListItem
:nmap <Leader>tj <Plug>VimwikiIncrementListItem
:vmap <Leader>tj <Plug>VimwikiIncrementListItem
:nmap <Leader>tk <Plug>VimwikiDecrementListItem
:vmap <Leader>tk <Plug>VimwikiDecrementListItem
" Table
:map <Leader>ta :VimwikiTable<Enter>

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

