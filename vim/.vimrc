set nocompatible
set pyxversion=3

call plug#begin()

Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-flow.vim'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'lifepillar/vim-solarized8'
Plug 'ludovicchabant/vim-gutentags'
Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
Plug 'sickill/vim-pasta'
Plug 'pangloss/vim-javascript'
Plug 'mindriot101/vim-yapf'
Plug 'mxw/vim-jsx'
Plug 'prettier/vim-prettier'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/goyo.vim'

call plug#end()
filetype plugin indent on

let mapleader = "\<Space>"
let g:pymode_python = 'python3'

" Allow jsx syntax highlight for non `.jsx` files
let g:jsx_ext_required = 0

set number
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
" should help with webpack getting triggered on save https://github.com/webpack/webpack/issues/781
set backupcopy=yes 
" Spaces whenever tab is pressed
set expandtab

" 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" @See https://github.com/lifepillar/vim-solarized8#troubleshooting
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Code folding
set foldmethod=syntax
set foldcolumn=1


set background=dark
colorscheme solarized8_high

nmap <Leader>; :Buffers<CR>
nmap <C-p> :Files<CR>
nmap <Leader>r :Tags<CR>

" Easier navigation of buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" Easier copy paste from clipboard to buffer
:vmap <Leader>c "+y
:nmap <Leader>p "+p

" Use ripgrep with ack + fzf
" for really really fast searching
if executable('rg')
  let g:ackprg = 'rg --vimgrep --hidden'
  let $FZF_DEFAULT_COMMAND = 'rg --vimgrep --hidden -l -i ""'
endif

set undodir=~/.vim/undo-dir
set undofile

" If installed using Homebrew
set rtp+=/usr/local/opt/fzf

syntax enable
let g:asyncomplete_smart_completion = 0
let g:asyncomplete_auto_popup = 1
let g:lsp_diagnostics_enabled = 0   

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('flow')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif

let g:javascript_plugin_flow = 1

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
set rtp+=$HOME/Library/Python/3.7/lib/python/site-packages/powerline/bindings/vim/
set laststatus=2
set guifont=Fira\ Code:h12
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set term=xterm
set termencoding=utf-8

" Attempt to import a file programmatically using `universal-ctags`. YMMV
nmap <leader>i :JsFileImport<cr>

" Move through linting errors more conveniently
nmap <silent> <leader>j :ALENext<cr>
nmap <silent> <leader>k :ALEPrevious<cr>

" Run yapf on save
autocmd BufWritePre *.py :Yapf

" Use quickfix window for Ale rather than location list window
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" FU bell
set vb t_vb=     

" Set up better zoom
nmap <C-z> <nop>

" Touchbar silliness
" Assuming your Caps Lock has been mapped to <Esc> at the OS level
imap jk <esc>
vmap jk <esc>

" Ignore node_modules
set wildignore+=*node_modules/**

" Disable auto formatting of files that have "@format" tag
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
let g:prettier#config#parser = 'babylon'

" Code folding
set foldmethod=syntax
set foldcolumn=1
set foldlevelstart=0

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" Function that calls Selenium test runner for idealist app
" Either test whole class or function
function! RunTest() 
  let filepath = expand('%:p')
  let lineindent = indent('.')
  let n = line('.')
  let test_function = ''
  let test_class = split(split(getline(search('class [A-Z]')))[1], '(')[0]

  if lineindent > 2
    while (indent(prevnonblank(n)) > 0)
      if indent(prevnonblank(n)) <= 2
        let test_function = trim(split(getline(prevnonblank(n)))[1], '(self):')
        break
      endif
      let n = n - 1
    endwhile
  endif

  if len(test_function) <= 0
    echo 'here it is: ' . filepath . '::' . test_class
    " execute '!docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py ' . filepath . '::' . test_class 
  else
    echo 'here it is 2: ' . filepath . '::' . test_class . '::' . test_function
    " execute '!docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py' . filepath . '::' . test_class . '::' . test_function
  endif
endfunction

command! RunTest call RunTest()

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

highlight Folded cterm=italic term=italic
highlight Comment cterm=italic term=italic
 
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

