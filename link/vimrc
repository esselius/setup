set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'sjl/gundo.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-endwise'
Bundle "ekalinin/Dockerfile.vim"

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

" Auto format
nnoremap === mmgg=G`m^zz

" Toggle paste mode
set pastetoggle=<Leader>P

autocmd BufRead,BufNewFile *.json setlocal ft=javascript

set textwidth=80
set colorcolumn=+1


function! CleanTrailingSpace()
  let save_cursor = getpos('.')
  :%s/\s\+$//e
  :call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
  unlet save_cursor
endfunction
