if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'altercation/vim-colors-solarized'

call plug#end()

syntax on
filetype on
filetype plugin on
filetype indent on

set clipboard=unnamedplus
set showmatch
set cursorline
set wildmenu
set backspace=indent,eol,start
set breakindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set number
set breakindent
set tabstop=4
set shiftwidth=4
set expandtab
set noswapfile
set nobackup

set rnu
set ruler

set laststatus=0

set list
set fillchars=vert:│,fold:┄,diff:╱
set listchars=tab:⋮\ ,trail:⎵
set showbreak=↪

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1

set mouse=a
set undofile

au VimResized * wincmd=
au BufWritePre * %s/\s\+$//e
au StdinReadPre * let s:std_in=1
au WinEnter,BufEnter * call matchadd('ColorColumn', &ft == 'python' ? '\%73v' : '\%81v', 100)
au WinLeave,BufLeave * call clearmatches()

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
map <C-n> :Lexplore<CR>
vmap <BS> <gv
vmap <TAB> >gv
map <C-s> :vert ter<CR>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-h> :ALEHover<CR>
nnoremap <silent> gt :ALEGoToDefinition<CR>
nnoremap <silent> gr :ALEFindReferences<CR>
map <C-Tab> :noh<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <Tab> :bn<CR>
tnoremap <Esc> <C-\><C-n>

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
