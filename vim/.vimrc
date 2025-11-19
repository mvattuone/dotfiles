set nocompatible
set pyxversion=3

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
Plug 'junegunn/goyo.vim'
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

filetype plugin indent on

" Enable omni complete
set omnifunc=syntaxcomplete#Complete

let mapleader = "\<Space>"
let g:pymode_python = 'python3'

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set backup
set hidden
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo
set undofile
" should help with webpack getting triggered on save https://github.com/webpack/webpack/issues/781
set backupcopy=yes 
" Spaces whenever tab is pressed
set expandtab

" 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Enable more redraws
set ttyfast

" Enable mouse support because sometimes you just gotta use it.
set mouse=a
if has('mouse_sgr')
set ttymouse=sgr
endif
" Makes the mouse actually usable (more responsive selection)
" Easier copy paste from clipboard to buffer
set clipboard=unnamed

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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

" Easier navigation of buffers
:nnoremap , :bnext<CR>
:nnoremap ; :bprevious<CR>
" Use with a number to go to buffer.
" Or on it's own to toggle previous buffer
:nnoremap <Leader>b <C-^>
:vmap <Leader>c "+y
:nmap <Leader>p "+p

source ~/code/dotfiles/vim/.vimrc-goyo

" Close buffer (won't close split)
nnoremap <Leader>d :BD<CR>

nnoremap <silent> <leader>gg :LazyGit<CR>

nnoremap gj :lua vim.diagnostic.goto_next()<cr>
nnoremap gk :lua vim.diagnostic.goto_prev()<cr>
nnoremap <silent> gx <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gn <cmd>lua vim.lsp.buf.rename()<CR>

imap <C-s> <Plug>(fzf-complete-wordnet)

" Copy path of current buffer
:nmap cp :let @+ = expand("%")<CR>

" Make a timestamp
nmap <Leader>ts i<C-R>=strftime("%-I:%M %p")<CR><Esc>
imap <Leader>ts <C-R>=strftime("%-I:%M %p")<CR>

nnoremap <leader>cd :call setreg('+', expand('%:p')) \| echo 'file path copied'<CR>

" FU bell
set vb t_vb=     

" Set up better zoom
nmap <C-z> <nop>

" Touchbar silliness
" Assuming your Caps Lock has been mapped to <Esc> at the OS level
imap jk <esc>
vmap jk <esc>

" Open vimrc quickly
nmap <Leader>e :e ~/.vimrc<CR>

" Open init.vim quickly
nmap <Leader>i :e ~/.config/nvim/init.vim<CR>

set wildmenu
set wildmode=longest,list
" Ignore node_modules
set wildignore+=*node_modules/**

" cold folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
set foldenable

" Run make silently
nnoremap <leader>m :silent make\|redraw!<cr>

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction
 
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

