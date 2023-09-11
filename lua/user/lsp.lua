-- autoformat w/ lsp on save
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ name = {"nvim/lua/user"} })]]

-- typescript
require 'lspconfig'.tsserver.setup {}

-- lua
require 'lspconfig'.lua_ls.setup {}

-- ruby
require 'lspconfig'.solargraph.setup {}
