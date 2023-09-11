-- autoformat w/ lsp on save
require("lsp-format").setup {
  name = "/nvim/lua/user"
}

local on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
end

-- typescript
require 'lspconfig'.tsserver.setup {on_attach = on_attach}

-- lua
require 'lspconfig'.lua_ls.setup {on_attach = on_attach}

-- ruby
require 'lspconfig'.solargraph.setup {on_attach = on_attach}

--html
require 'lspconfig'.html.setup {on_attach = on_attach}
