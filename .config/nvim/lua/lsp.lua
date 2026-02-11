local cmp = require('cmp')

lsp.preset('recommended')
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

lsp.ensure_installed({
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

