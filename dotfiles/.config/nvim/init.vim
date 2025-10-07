set number
set hlsearch
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
Plug 'nvim-tree/nvim-web-devicons'
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug '/f-person/git-blame.nvim'
Plug 'wurli/visimatch.nvim'
Plug 'winston0410/range-highlight.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'} " Run :COQdeps after this
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'phaazon/hop.nvim'
Plug 'neovim/nvim-lspconfig'      " LSP client
Plug 'nvimdev/lspsaga.nvim'       " lspsaga for UI

call plug#end()

syntax on
colorscheme tokyonight
let g:lightline = { 'colorscheme': 'onedark'}


lua << EOF

-- hop
local hop = require('hop')
require'hop'.setup()

vim.keymap.set('', 'f', function()
	hop.hint_words()
end, {remap=true})




vim.g.coq_settings = {['auto_start'] = true}

-- coq
local coq = require "coq"

-- lsp
vim.lsp.config("tsserver", coq.lsp_ensure_capabilities())
vim.lsp.config("gopls", coq.lsp_ensure_capabilities())
vim.lsp.config("rust_analyzer", coq.lsp_ensure_capabilities())

-- uifloatup for lsp
require("lspsaga").setup({
  ui = {
    border = "rounded"
  }
})

EOF

" Keymap for hover (uses lspsaga hover_doc)
nnoremap K <cmd>Lspsaga hover_doc<CR>
