let mapleader = "\<Space>"
set pyxversion=3 
let g:pymode_python = 'python3'

" Allow jsx syntax highlight for non `.jsx` files
let g:jsx_ext_required = 0

set nocompatible
set number
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Spaces whenever tab is pressed
:set expandtab

" 2 spaces
:set tabstop=2
:set shiftwidth=2

" @See https://github.com/lifepillar/vim-solarized8#troubleshooting
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:solarized_termcolors=256
set background=dark
colorscheme solarized

nmap <Leader>; :Buffers<CR>
nmap <C-p> :Files<CR>
nmap <Leader>r :Tags<CR>

" Easier navigation of buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" Easier copy paste from clipboard to buffer
:vmap <Leader>c "+y
:nmap <Leader>p "+p

" Use ripgrep with ack
" for really really fast searching
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif

" If installed using Homebrew
set runtimepath+=/usr/local/opt/fzf

filetype indent on 
syntax enable
let g:deoplete#enable_at_startup = 1

" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction


" various bits of Powerline related config
set rtp+=$HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
set guifont=Fira\ Code:h12
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" Attempt to import a file programmatically using `universal-ctags`. YMMV
nmap <leader>i :JsFileImport<cr>

" Move through linting errors more conveniently
nmap <silent> <leader>j :ALENext<cr>
nmap <silent> <leader>k :ALEPrevious<cr>

" FU bell
set vb t_vb=     

" Touchbar silliness
" Assuming your Caps Lock has been mapped to <Esc> at the OS level
imap jk <esc>
vmap jk <esc>

set wildignore+=*node_modules/**
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

