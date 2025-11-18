local oil = require("oil")

oil.setup({
  keymaps = {
    ["<C-p>"] = false,
    ["<Leader>o"] = "actions.preview",
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return oil
