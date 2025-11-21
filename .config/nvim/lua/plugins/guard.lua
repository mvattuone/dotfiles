return {
  "nvimdev/guard.nvim",
  dependencies = { "nvimdev/guard-collection" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local ok, guard = pcall(require, 'guard')
    if not ok then
      vim.notify_once('guard.nvim is not available. Run :Lazy sync?', vim.log.levels.WARN)
      return
    end

    local ft = require('guard.filetype')
    ft('typescript,javascript,typescriptreact'):fmt('prettier')
    ft('python'):fmt('black'):append('isort')
    guard.setup({})
  end,
}
