  -- Smart Splits
  require('smart-splits').setup()

  -- traverse splits, using CMD to match wezterm pane switching
  vim.keymap.set('n', '<Char-0xAA>', require('smart-splits').move_cursor_left, {
    desc = 'N: Save current file by <command-s>',
  })

  vim.keymap.set('n', '<Char-0xAB>', require('smart-splits').move_cursor_down, {
    desc = 'N: Save current file by <command-s>',
  })

  vim.keymap.set('n', '<Char-0xAC>', require('smart-splits').move_cursor_up, {
    desc = 'N: Save current file by <command-s>',
  })

  vim.keymap.set('n', '<Char-0xAD>', require('smart-splits').move_cursor_right, {
    desc = 'N: Save current file by <command-s>',
  })

  -- resize splits
  vim.keymap.set('n', '<C-h>', require('smart-splits').resize_left)
  vim.keymap.set('n', '<C-j>', require('smart-splits').resize_down)
  vim.keymap.set('n', '<C-k>', require('smart-splits').resize_up)
  vim.keymap.set('n', '<C-l>', require('smart-splits').resize_right)

  -- swap buffers between windows
  vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
  vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
  vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
  vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)

