set nocompatible
" Function that calls Selenium test runner for idealist app
set pyxversion=3
syntax on

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'vimwiki/vimwiki'
Plug 'airblade/vim-gitgutter'
Plug 'andymass/vim-matchup'
Plug 'vim-scripts/Zenburn'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tomasiser/vim-code-dark'
Plug 'chaoren/vim-wordmotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Avi-D-coder/fzf-wordnet.vim'
Plug 'junegunn/goyo.vim'
Plug 'kevinhui/vim-docker-tools'
Plug 'konfekt/fastfold'
Plug 'ayu-theme/ayu-vim'
Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'markonm/traces.vim'
Plug 'pangloss/vim-javascript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-flow.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'sickill/vim-pasta'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'puremourning/vimspector'
Plug 'junegunn/goyo.vim'
Plug 'stevearc/vim-arduino'

call plug#end()

filetype plugin indent on

let g:vimspector_enable_mappings = 'HUMAN'

" Resolves issues with powerline + flickering
" https://github.com/powerline/powerline/issues/1281
set showtabline=2



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

nmap <Leader>; :Buffers<CR>
nmap <C-p> :Files<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>/ :Rg 

" Easier navigation of buffers
:nnoremap <Tab> :bn<CR>
:nnoremap <S-Tab> :bp<CR>
" Use with a number to go to buffer.
" Or on it's own to toggle previous buffer
:nnoremap <Leader>b <C-^>
:vmap <Leader>c "+y
:nmap <Leader>p "+p

source ~/code/dotfiles/vim/.vimrc-goyo

" Replace default grep 
"set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" Use ripgrep with fzf
" for really really fast searching
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --vimgrep --hidden -l -i ""'
endif
command! -bang -nargs=* Rg call fzf#vim#grep(<q-args>, {'options': '--delimiter : --nth 4..'},

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --vimgrep --column --line-number --multiline --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '-e --delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '-e --delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column G-multiline --line-number --no-heading --color=always --smart-case ".<q-args>, 1, <bang>0)
"
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)


" Close buffer (won't close split)
nnoremap <Leader>d :BD<CR>

" Settings for Vimwiki
let wiki_1 = {}
let wiki_1.path = '~/Dropbox/vimwiki/markdown/'
let wiki_1.ext = '.md'
let wiki_1.syntax = 'markdown'

let wiki_2 = {}
let wiki_2.path = '~/Dropbox/vimwiki/vattuonet'
let wiki_2.ext = '.md'
let wiki_2.index = '_index'
let wiki_2.syntax = 'markdown'
let wiki_2.custom_wiki2html='~/code/dotfiles/wiki2html.sh'
let wiki_2.path_html='~/code/vattuonet/public'
let wiki_2.path='~/Dropbox/vimwiki/vattuonet'

let g:vimwiki_list = [wiki_1, wiki_2]
let g:vimwiki_auto_chdir = 1


" If installed using Homebrew
set rtp+=/usr/local/opt/fzf

syntax enable
let g:asyncomplete_auto_popup = 1
let g:lsp_diagnostics_enabled = 0   
imap <C-l> <Plug>(asyncomplete_force_refresh)

imap <C-s> <Plug>(fzf-complete-wordnet)

" Make a timestamp
nmap <Leader>ts i<C-R>=strftime("%-I:%M %p")<CR><Esc>
imap <Leader>ts <C-R>=strftime("%-I:%M %p")<CR>

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

au User lsp_setup call lsp#register_server({
  \ 'name': 'javascript support using typescript-language-server',
  \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
  \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
  \ 'allowlist': ['javascript', 'javascript.jsx'],
  \ })

if executable('flow')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'allowlist': ['javascript', 'javascript.jsx'],
        \ })
endif

" brew install cquery
if executable('cquery')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'cquery',
      \ 'cmd': {server_info->['cquery']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery/cache' },
      \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

" Register asyncomplete-omni
call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni',
\ 'allowlist': ['*'],
\ 'priority': 10,
\ 'completor': function('asyncomplete#sources#omni#completor')
\  }))

" Register asyncomplete-file
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 20,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

" Syntax highlight for flow (through vim-javascript)
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

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

" Include jsx in Javascript filetype
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.js set filetype=javascript.jsx
    au BufNewFile,BufRead ~/Dropbox/vimwiki/markdown set filetype=vimwiki
augroup END

" Move through linting errors more conveniently
nmap <silent> <leader>j :ALENext<cr>
nmap <silent> <leader>k :ALEPrevious<cr>

autocmd BufReadPost * call ale#balloon#Enable()

let g:ale_set_highlights = 0
let g:ale_lint_on_enter = 0
let g:ale_linters_explicit = 1

let g:ale_linters = { 
\'javascript': ['flow-language-server', 'eslint', 'stylelint'], 'python': ['pylint'], 'css': ['stylelint', 'prettier']
\}
let g:ale_fixers = {
\'javascript': ['eslint', 'prettier'], 'python': ['black'], 'css': ['prettier']
\}
let g:ale_linter_aliases = {'jsx': 'css'}
let g:ale_fix_on_save = 1

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

" Code folding
set foldmethod=syntax
set foldcolumn=1
set foldlevelstart=0

" hi Folded guibg=#95467c
" hi Folded guifg=#cfcfcf

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

nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" Run make silently
nnoremap <leader>m :silent make\|redraw!<cr>

" Function that calls Selenium test runner for idealist app
"
" Either test whole class or function
function! RunTest() 
  let b:view = winsaveview()
  let filepath = @%
  let lineindent = indent('.')
  let n = line('.')
  let test_function = ''
  let test_class = split(split(getline(search('class [A-Z]')))[1], '(')[0]

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
    execute 'silent !tmux -2 split-window -d ! -v -f docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py ' . filepath . '::' . test_class . '-r' 
  else
    echo 'Running test ' . filepath . '::' . test_class . '::' . test_function
    execute 'silent !tmux split-window -d -p 20 -v docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py ' . filepath . '::' . test_class . '::' . test_function . ' --pdb'
  endif

  call winrestview(b:view)
endfunction

let g:vim_jsx_pretty_colorful_config = 1 

command! RunTest call RunTest()

" Run Test
nmap <Leader>r :RunTest<CR> 

" Make a timestamp
nmap <Leader>t <C-R>=strftime("%-I:%M %p")<CR>

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

