set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
  local lsp = require('lsp-zero')
  local null_ls = require('null-ls')

  lsp.preset('recommended')

  lsp.ensure_installed({
    'html',
    'cssls',
    'tsserver',
    'eslint',
    'pyright',
  })

  lsp.nvim_workspace()

  local null_opts = lsp.build_options('null-ls', {
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
      end
    end
  })

  null_ls.setup({
    on_attach = null_opts.on_attach,
    sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.eslint_d,
    }
  })

  lsp.setup()

  vim.diagnostic.config({
    virtual_text = true
  })
EOF
