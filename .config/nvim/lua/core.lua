-----------------------------------------------------------
-- Core UI behavior
-- Basic visuals every user expects immediately
-----------------------------------------------------------
vim.opt.clipboard = "unnamedplus"
-----------------------------------------------------------
-- File persistence (backup, swap, undo)
-----------------------------------------------------------
local state = vim.fn.stdpath("state")

vim.opt.backup = true
vim.opt.hidden = true  -- Always true in Neovim, but explicit for clarity

vim.opt.backupdir = state .. "/backup//"
vim.opt.directory = state .. "/swap//"
vim.opt.undodir   = state .. "/undo//"
vim.opt.undofile  = true

-- Prevent unnecessary rebuilds in tools like webpack
-- https://github.com/webpack/webpack/issues/781
vim.opt.backupcopy = "yes"


-----------------------------------------------------------
-- Diagnostics (LSP)
-- Controls how Neovim displays LSP errors/warnings/hints.
-----------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,       -- inline diagnostics
  update_in_insert = false,  -- don’t distract while typing
  severity_sort = true,      -- show errors > warnings > info > hints
})

