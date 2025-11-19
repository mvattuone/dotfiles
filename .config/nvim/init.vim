set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
  require('keymap')
  require('plugins.nvim-treesitter')
  require('lsp')
  require('repl')
  require('wezterm')
  require('plugins.fzf')
  require('plugins.smart-splits')
  require('plugins.neoscroll')
  require('plugins.oil')
  require('wiki')

  lsp.nvim_workspace()
  lsp.setup()


  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
  })

  require('plugins.wiki')
EOF
