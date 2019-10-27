set nocompatible
set pyxversion=3

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'andymass/vim-matchup'
Plug 'chaoren/vim-wordmotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fholgado/minibufexpl.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'kevinhui/vim-docker-tools'
Plug 'konfekt/fastfold'
Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'markonm/traces.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-flow.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prettier/vim-prettier'
Plug 'python/black'
Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'sickill/vim-pasta'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'

call plug#end()
filetype plugin indent on

" Resolves issues with powerline + flickering
" https://github.com/powerline/powerline/issues/1281
set showtabline=1

" Enable omni complete
set omnifunc=syntaxcomplete#Complete

let mapleader = "\<Space>"
let g:pymode_python = 'python3'

" Allow jsx syntax highlight for non `.jsx` files
let g:jsx_ext_required = 0

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set backup
set undofile
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

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Code folding
set foldmethod=syntax
set foldcolumn=1


set background=dark
colorscheme codedark


nmap <Leader>; :Buffers<CR>
nmap <C-p> :Files<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>/ :Rg 

" Easier navigation of buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" Easier copy paste from clipboard to buffer
:vmap <Leader>c "+y
:nmap <Leader>p "+p

" Use ripgrep with fzf
" for really really fast searching
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --vimgrep --hidden -l -i ""'
endif

command! -bang -nargs=* Rg call fzf#vim#grep(<q-args>, {'options': '--delimiter : --nth 4..'},

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --vimgrep --column --line-number --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '-e --delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '-e --delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

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

" brew install cquery
if executable('cquery')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'cquery',
      \ 'cmd': {server_info->['cquery']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery/cache' },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

" Register asyncomplete-file
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

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

" Enable experimental transmutation support
" from vim-match (should rename both tags)
let g:matchup_transmute_enabled = 1

" Add ability to toggle viewing existing docker containers and manipulate them
nmap <silent> <leader>dc :DockerToolsToggle<cr>

" Add ability to toggle docker stats (why can't this be part of docker ps...)
nmap <silent> <leader>ds :silent !tmux split-window -d -p 10 -v -f docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" idealist7_webpack_1 idealist7_worker_1<cr>

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

" Run black on save
autocmd BufWritePre *.py execute ':Black'

" Use quickfix window for Ale rather than location list window
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_linters = { 
\'javascript': ['flow', 'eslint'], 'python': ['pylint']
\}
let g:ale_fixers = {
\'javascript': ['eslint'], 'python': ['pylint']
\}

" FU bell
set vb t_vb=     

" Set up better zoom
nmap <C-z> <nop>

" Touchbar silliness
" Assuming your Caps Lock has been mapped to <Esc> at the OS level
imap jk <esc>
vmap jk <esc>

set wildmenu
set wildmode=longest,list
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


" Run make silently
nnoremap <leader>m :silent make\|redraw!<cr>

" Function that calls Selenium test runner for idealist app
" Either test whole class or function
function! RunTest() 
  let filepath = @%
  let lineindent = indent('.')
  let n = line('.')
  let test_function = ''
  let test_class = split(split(getline(search('class [A-Z]')))[1], '(')[0]
  let l:winview = winsaveview()

  if lineindent > 4
    while (indent(prevnonblank(n)) > 0)
      if indent(prevnonblank(n)) <= 4
        " Search for either ( or (self): since Python formatting may break the
        " line
        let test_function = substitute(split(getline(prevnonblank(n)))[1], '\v\((self\):)?', '', '')
        break
      endif
      let n = n - 1
    endwhile
  endif

  if len(test_function) <= 0
    echo 'Running test suite' . filepath . '::' . test_class
    execute 'silent !tmux -2 split-window -d ! -v -f docker-compose -f docker-compose.yml -f
    docker-compose.selenium.yml run tester python runtests.py ' . filepath .
    '::' . test_class . '-r' 
  else
    echo 'Running test ' . filepath . '::' . test_class . '::' . test_function
    execute 'silent !tmux split-window -d -p 20 -v -f docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py ' . filepath . '::' . test_class . '::' . test_function . ' --pdb'
  endif

  call winrestview(l:winview)
endfunction

command! RunTest call RunTest()

" Shamelessly lifted from https://github.com/samuelsimoes/vim-jsx-utils/blob/master/plugin/vim-jsx-utils.vim
function! JSXIsSelfCloseTag()
  let l:line_number = line(".")
  let l:line = getline(".")
  let l:tag_name = matchstr(matchstr(line, "<\\w\\+"), "\\w\\+")

  exec "normal! 0f<vat\<esc>"

  cal cursor(line_number, 1)

  let l:selected_text = join(getline(getpos("'<")[1], getpos("'>")[1]))

  let l:match_tag = matchstr(matchstr(selected_text, "</\\w\\+>*$"), "\\w\\+")

  return tag_name != match_tag
endfunction

function! JSXSelectTag()
  if JSXIsSelfCloseTag()
    exec "normal! \<esc>0f<v/\\/>$\<cr>l"
  else
    exec "normal! \<esc>0f<vat"
  end
endfunction

nnoremap vat :call JSXSelectTag()<CR>

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

