if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'vimwiki/vimwiki'
Plug 'andymass/vim-matchup'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tomasiser/vim-code-dark'
Plug 'chaoren/vim-wordmotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua'
Plug 'junegunn/goyo.vim'
Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'markonm/traces.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'sickill/vim-pasta'
Plug 'kdheepak/lazygit.nvim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'stevearc/vim-arduino'

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'nvimdev/guard-collection'
Plug 'nvimdev/guard.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'dmmulroy/tsc.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'

" Diagnostics
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'petertriho/cmp-git'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" Misc
Plug 'mrjones2014/smart-splits.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'stevearc/oil.nvim'

Plug 'VonHeikemen/lsp-zero.nvim'

call plug#end()

" QoL improvements to cursor 
set guicursor=i:ver25,v:ver25,n:ver25
set cursorline
" Enable omni complete
set omnifunc=syntaxcomplete#Complete

let g:pymode_python = 'python3'

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
" Enable mouse support because sometimes you just gotta use it.
set mouse=a
if exists('+termguicolors')
  set termguicolors
endif

" Light mode during the day, dark mode otherwise
" This is not very accurate but is probably sufficient
if strftime("%H") >= 8 && strftime("%H") < 20
  set background=light
  colorscheme PaperColor
else
  set background=dark
  colorscheme codedark
endif


source ~/code/dotfiles/vim/.vimrc-goyo

set wildmenu
set wildmode=longest,list
" Ignore node_modules
set wildignore+=*node_modules/**

" cold folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
set foldenable
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

