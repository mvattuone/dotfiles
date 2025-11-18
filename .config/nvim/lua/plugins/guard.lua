local guard = require('guard')
local ft = require('guard.filetype')
ft('typescript,javascript,typescriptreact'):fmt('prettier')
ft('python'):fmt('black'):append('isort')
