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

return oil
