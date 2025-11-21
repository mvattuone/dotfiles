return {
  "mrjones2014/smart-splits.nvim",
  config = function()
    local ss = require('smart-splits')
    ss.setup()

    -- traverse splits, using CMD to match wezterm pane switching
    vim.keymap.set('n', '<Char-0xAA>', ss.move_cursor_left, {
      desc = 'N: Save current file by <command-s>',
    })

    vim.keymap.set('n', '<Char-0xAB>', ss.move_cursor_down, {
      desc = 'N: Save current file by <command-s>',
    })

    vim.keymap.set('n', '<Char-0xAC>', ss.move_cursor_up, {
      desc = 'N: Save current file by <command-s>',
    })

    vim.keymap.set('n', '<Char-0xAD>', ss.move_cursor_right, {
      desc = 'N: Save current file by <command-s>',
    })

    -- resize splits
    vim.keymap.set('n', '<C-h>', ss.resize_left)
    vim.keymap.set('n', '<C-j>', ss.resize_down)
    vim.keymap.set('n', '<C-k>', ss.resize_up)
    vim.keymap.set('n', '<C-l>', ss.resize_right)

    -- swap buffers between windows
    vim.keymap.set('n', '<leader><leader>h', ss.swap_buf_left)
    vim.keymap.set('n', '<leader><leader>j', ss.swap_buf_down)
    vim.keymap.set('n', '<leader><leader>k', ss.swap_buf_up)
    vim.keymap.set('n', '<leader><leader>l', ss.swap_buf_right)
  end,
}
