set nocompatible
syntax on

" Vundle magic
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/mru.vim'
Plugin 'rbgrouleff/bclose.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'nvie/vim-flake8'
call vundle#end()

filetype plugin indent on

" Line & column numbers
set number
set ruler

" Indentation & co.
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set colorcolumn=80
set so=8

" UTF8 or die
set encoding=utf8

" Show trailing whitespaces and tabs
set list lcs=trail:·,tab:»·

" Color scheme & font
set background=dark
colorscheme material-theme
set gfn=Inconsolata:h14

" Automatically show NERDTree, close vim if NERDTree is the only buffer left
autocmd VimEnter * if &filetype !=# 'gitcommit' | NERDTree | endif
autocmd VimEnter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Close buffer using Cmd+W
macmenu &File.Close key=<nop>
nmap <D-w> :CommandW<CR>
imap <D-w> <Esc>:CommandW<CR>
nmap <C-w> <Esc>:Bclose<CR>

" Key bindings
nmap <C-a> :BufExplorer<CR>
nmap <C-l> :vs<CR>
nmap <C-p> :CtrlP .<CR>

cabbrev cp CtrlP
cabbrev cws %s/\s\+$//e " Clear whitespace
command W w

" Misc
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabLongestHighlight = 1
set updatetime=250 " GitGutter update time
autocmd FileType python setlocal completeopt-=preview
command Flake8 call Flake8()

set wildignore+=__pycache__,env,.git

if has("gui_macvim")
  let macvim_hig_shift_movement = 0
endif
