vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand('%:p')
  local cmd = string.format('tsrepl.sh "%s"', file)

  print('⏳ Launching TypeScript REPL for ' .. vim.fn.fnamemodify(file, ':t') .. '...')

  vim.fn.jobstart({ 'fish', '-c', cmd }, { detach = true })
end, { desc = 'Run current TS file in Node REPL (WezTerm pane)' })
