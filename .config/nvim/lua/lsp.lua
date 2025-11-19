local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'html',
  'cssls',
  'ts_ls',
  'eslint',
  'pyright',
  'rust_analyzer',
})

require('lspconfig').ts_ls.setup({
  on_attach = function(client, bufnr)
  end,
  settings = {
    defaultMaximumTruncationLength = 800
  },
})

lsp.nvim_workspace()
lsp.setup()
