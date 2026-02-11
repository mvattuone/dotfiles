local lspkind = require('lspkind')
local cmp = require('cmp')

cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },
  window = {
    completion = {
      border = 'rounded',
      scrollbar = false,
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    },
    documentation = {
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  experimental = {
    ghost_text = {
      hl_group = "Comment",
    },
  },
  formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      expandable_indicator = true,
      format = lspkind.cmp_format({
        maxwidth = {
          -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- menu = function() return math.floor(0.45 * vim.o.columns) end,
          menu = 50, -- leading text (labelDetails)
          abbr = 50, -- actual suggestion item
        },
        mode = 'symbol',
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function (entry, vim_item)
          local menu_icon = {
            nvim_lsp = '[LSP]',
            buffer = '[Buf]',
            path = '[Path]',
          }
          vim_item.menu = menu_icon[entry.source.name] or entry.source.name
          return vim_item
        end
      })
    }
}

cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup()

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  'html',
  'cssls',
  'ts_ls',
  'eslint',
  'pyright',
  'rust_analyzer',
  'lua_ls',
}

local function with_capabilities(opts)
  return vim.tbl_deep_extend('force', { capabilities = cmp_capabilities }, opts or {})
end

for _, server in ipairs(servers) do
  if server ~= 'ts_ls' and server ~= 'lua_ls' then
    vim.lsp.config(server, with_capabilities())
  end
end

vim.lsp.config('ts_ls', with_capabilities({
  settings = {
    defaultMaximumTruncationLength = 800,
  },
}))

vim.lsp.config("lua_ls", with_capabilities({
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
    },
  },
}))

