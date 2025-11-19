set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
  require('core')
  require('keymap')
  require('plugins.nvim-treesitter')
  require('lsp')
  require('repl')
  require('wezterm')
  require('plugins.fzf')
  require('plugins.smart-splits')
  require('plugins.guard')
  require('plugins.gitsigns')
  require('plugins.neoscroll')
  require('plugins.oil')
  require('wiki')


  require('plugins.matchup')
  require('plugins.tsc')
  require('plugins.wiki')
EOF
