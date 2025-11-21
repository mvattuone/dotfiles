-- Easier navigation of buffers
vim.keymap.set("n", ",", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", ";", ":bprevious<CR>", { desc = "Previous buffer" })

-- Use with a number to go to buffer.
-- Or on it's own to toggle previous buffer
vim.keymap.set("n", "<Leader>b", "<C-^>", { desc = "Toggle previous buffer" })

-- Copy selection to system clipboard
vim.keymap.set("v", "<Leader>c", '"+y', { desc = "Yank to system clipboard" })

-- Paste from system clipboard
vim.keymap.set("n", "<Leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Close buffer (won't close split)
vim.keymap.set("n", "<Leader>d", ":BD<CR>", { desc = "Delete buffer" })

-- Lazygit
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "LazyGit" })

-- Diagnostics navigation
vim.keymap.set("n", "gj", function() vim.diagnostic.goto_next() end)
vim.keymap.set("n", "gk", function() vim.diagnostic.goto_prev() end)

-- LSP actions
vim.keymap.set("n", "gx", vim.lsp.buf.code_action,   { silent = true })
vim.keymap.set("n", "gd", vim.lsp.buf.definition,    { silent = true })
vim.keymap.set("n", "gt", vim.lsp.buf.hover,         { silent = true })
vim.keymap.set("n", "gr", vim.lsp.buf.references,    { silent = true })
vim.keymap.set("n", "gn", vim.lsp.buf.rename,        { silent = true })

-- Make a timestamp
vim.keymap.set("n", "<Leader>ts",
  'i<C-R>=strftime("%-I:%M %p")<CR><Esc>',
  { desc = "Insert timestamp" }
)

-- Copy path of current buffer
vim.keymap.set("n", "cp", ':let @+ = expand("%")<CR>', { desc = "Copy buffer path" })

-- Copy full absolute path
vim.keymap.set(
  "n",
  "<leader>cd",
  ':call setreg("+", expand("%:p")) | echo "file path copied"<CR>',
  { desc = "Copy full file path" }
)

-- Set up better zoom
vim.keymap.set("n", "<C-z>", "<nop>", { desc = "Disable Ctrl-Z" })

-- Touchbar silliness
-- Assuming your Caps Lock has been mapped to <Esc> at the OS level
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("v", "jk", "<Esc>")

-- Open init.lua quickly
vim.keymap.set("n", "<Leader>i", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit init.vim" })

-- Run make silently
vim.keymap.set("n", "<leader>m", ":silent make | redraw!<CR>", { desc = "Run make" })

