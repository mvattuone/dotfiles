:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Light mode during the day, dark mode otherwise
" This is not very accurate but is probably sufficient
if strftime("%H") >= 8 && strftime("%H") < 20
  set background=light
  colorscheme PaperColor
else
  set background=dark
  colorscheme codedark
endif
