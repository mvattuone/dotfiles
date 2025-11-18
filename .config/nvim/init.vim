set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
  local lsp = require('lsp-zero')
  local guard = require('guard')
  local ft = require('guard.filetype')
  local ts = require('nvim-treesitter.configs')



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

  -- Decode custom chars from wezterm (see your utf8 chars)
  vim.keymap.set({ 'n', 't' }, '<Char-0xAA>', '<C-\\><C-N><C-w>h', { noremap = true })
  vim.keymap.set({ 'n', 't' }, '<Char-0xAB>', '<C-\\><C-N><C-w>j', { noremap = true })
  vim.keymap.set({ 'n', 't' }, '<Char-0xAC>', '<C-\\><C-N><C-w>k', { noremap = true })
  vim.keymap.set({ 'n', 't' }, '<Char-0xAD>', '<C-\\><C-N><C-w>l', { noremap = true })


  require('plugins.smart-splits')
  require('plugins.oil')
  require('wiki')

  require('tsc').setup()

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

  lsp.preset('recommended')

  lsp.ensure_installed({
    'html',
    'cssls',
    'ts_ls',
    'eslint',
    'pyright',
    'rust_analyzer',
  })

  require('lspconfig').ts_ls.setup({
    on_attach = function(client, bufnr)
    end,
    settings = {
      defaultMaximumTruncationLength = 800
    },
  })

  vim.keymap.set('n', '<leader>r', function()
    local file = vim.fn.expand('%:p')
    local cmd = string.format('tsrepl.sh "%s"', file)

    print('⏳ Launching TypeScript REPL for ' .. vim.fn.fnamemodify(file, ':t') .. '...')

    vim.fn.jobstart({ 'fish', '-c', cmd }, { detach = true })
  end, { desc = 'Run current TS file in Node REPL (WezTerm pane)' })

  lsp.nvim_workspace()
  lsp.setup()

  -- multiple files register
  ft('typescript,javascript,typescriptreact'):fmt('prettier')
  ft('python'):fmt('black'):append('isort')

  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
  })

  ts.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript", "typescript", "json", "python" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      disable = {},
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  require('neoscroll').setup()
  }
EOF
