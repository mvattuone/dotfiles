set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
  local lsp = require('lsp-zero')
  local guard = require('guard')
  local ft = require('guard.filetype')
  local ts = require('nvim-treesitter.configs')

  require("oil").setup({
  keymaps = {
    ["<C-p>"] = false,
    ["<Leader>o"] = "actions.preview",
  },
  })
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

  require('smart-splits').setup()

  vim.keymap.set('n', '<Char-0xAA>', require('smart-splits').move_cursor_left, {
    desc = 'N: Save current file by <command-s>',
  })

  vim.keymap.set('n', '<Char-0xAB>', require('smart-splits').move_cursor_down, {
    desc = 'N: Save current file by <command-s>',
  })

  vim.keymap.set('n', '<Char-0xAC>', require('smart-splits').move_cursor_up, {
    desc = 'N: Save current file by <command-s>',
  })

  vim.keymap.set('n', '<Char-0xAD>', require('smart-splits').move_cursor_right, {
    desc = 'N: Save current file by <command-s>',
  })

  -- recommended mappings
  -- resizing splits
  -- these keymaps will also accept a range,
  -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
  vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
  vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
  vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
  vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
  -- moving between splits
  -- vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
  -- vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
  -- vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
  -- vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
  -- vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
  -- swapping buffers between windows
  vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
  vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
  vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
  vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)

  require('lspconfig').ts_ls.setup({
    on_attach = function(client, bufnr)
    end,
    settings = {
      defaultMaximumTruncationLength = 800
    },
  })

  local iron = require("iron.core")

  iron.setup {
    config = {
      repl_definition = {
        typescript = { command = { "npx", "tsx" } },
        javascript = { command = { "npx", "tsx" } },
        ["javascript.jsx"] = { command = { "npx", "tsx" } },
      },
      repl_open_cmd = require("iron.view").bottom(20),
    },
    keymaps = {
      toggle_repl = "<space>rr",
      send_motion = "<leader>sc",
      visual_send = "<leader>sv",
      send_file = "<leader>sf",
      send_line = "<leader>sl",
      exit = "<leader>sq",
      clear = "<leader>sx",
    },
  }


  lsp.nvim_workspace()
  lsp.setup()

  -- multiple files register
  ft('typescript,javascript,typescriptreact'):fmt('prettier')
  ft('python'):fmt('black'):append('isort')

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

  vim.diagnostic.config({
    virtual_text = true
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
