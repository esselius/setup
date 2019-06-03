set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

Plug 'gmarik/vundle'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'sjl/gundo.vim'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-endwise'
Plug 'ekalinin/Dockerfile.vim'
Plug 'othree/xml.vim'
Plug 'derekwyatt/vim-scala'
Plug 'editorconfig/editorconfig-vim'

call plug#end()

filetype plugin indent on

let mapleader = ','

let g:gundo_preview_bottom = 1
nnoremap <silent> <Leader>u :silent GundoToggle<CR>

if has('persistent_undo')
  set undofile
  if !isdirectory(expand('~/.vimundo'))
    silent !mkdir ~/.vimundo > /dev/null 2>&1
  endif
  set undodir=~/.vimundo
endif


set laststatus=2
syn on
set number

set wildmenu wildmode=longest,list:longest

colorscheme slate

set tabstop=2 softtabstop=2 shiftwidth=2
set shiftround
set expandtab
set autoindent
set smarttab

set listchars=tab:>-,trail:-
set list

" Auto format
nnoremap === mmgg=G`m^zz

" Toggle paste mode
set pastetoggle=<Leader>P

autocmd BufRead,BufNewFile *.json setlocal ft=javascript

set textwidth=200
set colorcolumn=+1


function! CleanTrailingSpace()
  let save_cursor = getpos('.')
  :%s/\s\+$//e
  :call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
  unlet save_cursor
endfunction

set shell=/bin/bash
set hlsearch
