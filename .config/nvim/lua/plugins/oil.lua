return {
  "stevearc/oil.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local oil = require("oil")

    oil.setup({
      keymaps = {
        ["<C-p>"] = false,
        ["<Leader>o"] = "actions.preview",
      },
      view_options = {
        show_hidden = true,
      }
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
