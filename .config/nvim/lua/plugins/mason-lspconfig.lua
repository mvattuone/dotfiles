return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      -- Mason >=1.6 defaults to automatically enabling servers via vim.lsp.enable(),
      -- but that function only exists on Neovim 0.10+. Turn it off to stay compatible
      -- with stable releases.
      automatic_enable = false,
    })
  end,
}
