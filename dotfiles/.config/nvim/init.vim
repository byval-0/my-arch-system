set number
set nocompatible
set autoindent
set encoding=UTF-8
set termguicolors

call plug#begin('~/.config/nvim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'folke/tokyonight.nvim'
Plug 'itchyny/lightline.vim'
Plug 'sheerun/vim-polyglot'
Plug 'kien/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-tree/nvim-web-devicons'
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug '/f-person/git-blame.nvim'
call plug#end()

syntax on
colorscheme tokyonight
let g:lightline = { 'colorscheme': 'onedark'}

