set nocompatible
filetype off
syntax on
filetype plugin indent on

set number
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

call plug#begin()

Plug 'kovisoft/slimv'
Plug 'preservim/vim-pencil'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

colorscheme default

let g:airline_section_x = '%{PencilMode()}'
let g:pencil#wrapModeDefault = 'soft'
