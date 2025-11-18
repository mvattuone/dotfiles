local wezterm = vim.fn.has('nvim') == 1 and vim.fn.executable('wezterm') == 1

if wezterm then
  local function set_user_var(name, value)
    vim.fn.chansend(vim.v.stderr, string.format("\x1b]1337;SetUserVar=%s=%s\x07", name, vim.base64.encode(value)))
  end

  vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
    callback = function() set_user_var("IS_NVIM", "true") end,
  })

  vim.api.nvim_create_autocmd("TermEnter", {
    callback = function() set_user_var("NVIM_MODE", "terminal") end,
  })

  vim.api.nvim_create_autocmd("TermLeave", {
    callback = function() set_user_var("NVIM_MODE", "normal") end,
  })
end

-- WezTerm sends private-use characters (0xAA–0xAD) for Cmd-H/J/K/L.
-- Mapping them here allows pane navigation to work in both normal and
-- terminal mode.
local CMD_H = "<Char-0xAA>"
local CMD_J = "<Char-0xAB>"
local CMD_K = "<Char-0xAC>"
local CMD_L = "<Char-0xAD>"

vim.keymap.set({ 'n', 't' }, CMD_H, '<C-\\><C-N><C-w>h', { noremap = true })
vim.keymap.set({ 'n', 't' }, CMD_J, '<C-\\><C-N><C-w>j', { noremap = true })
vim.keymap.set({ 'n', 't' }, CMD_K, '<C-\\><C-N><C-w>k', { noremap = true })
vim.keymap.set({ 'n', 't' }, CMD_L, '<C-\\><C-N><C-w>l', { noremap = true })
