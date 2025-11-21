local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = numbertoggle,
  callback = function()
    vim.opt.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = numbertoggle,
  callback = function()
    vim.opt.relativenumber = false
  end,
})
