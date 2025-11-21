return {
  "folke/trouble.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  cmd = "Trouble",
  config = function()
    require("trouble").setup({})
  end,
}
