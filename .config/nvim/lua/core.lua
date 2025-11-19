-----------------------------------------------------------
-- Diagnostics (LSP)
-- Controls how Neovim displays LSP errors/warnings/hints.
-----------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,       -- inline diagnostics
  update_in_insert = false,  -- don’t distract while typing
  severity_sort = true,      -- show errors > warnings > info > hints
})

