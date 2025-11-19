set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
  require('lsp')
  require('wezterm')
  require('plugins.fzf')
  require('plugins.smart-splits')
  require('plugins.neoscroll')
  require('plugins.oil')
  require('wiki')

  require('tsc').setup()
  vim.keymap.set('n', '<leader>r', function()
    local file = vim.fn.expand('%:p')
    local cmd = string.format('tsrepl.sh "%s"', file)

    print('⏳ Launching TypeScript REPL for ' .. vim.fn.fnamemodify(file, ':t') .. '...')

    vim.fn.jobstart({ 'fish', '-c', cmd }, { detach = true })
  end, { desc = 'Run current TS file in Node REPL (WezTerm pane)' })

  lsp.nvim_workspace()
  lsp.setup()


  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
  })

  require('plugins.wiki')
EOF
