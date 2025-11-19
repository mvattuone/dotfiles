local function configure_goyo()
  local grp = vim.api.nvim_create_augroup("vimwiki_goyo", { clear = true })
  local diary_glob = vim.fn.expand("~/Dropbox/vimwiki/markdown/diary") .. "/*.md"

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = diary_glob,
    command = "Goyo",
  })
end

return {
  "junegunn/goyo.vim",
  lazy = false,
  keys = {
    { "<leader>g", "<cmd>Goyo<CR>", desc = "Toggle Goyo" },
  },
  config = configure_goyo,
}
