require("neodev").setup({})

-- autoformat w/ lsp on save
require("lsp-format").setup {
  name = "lua/user",
  format_options = {
    tab_width = 2,
    tabSize = 2,
    insertSpaces = true,
    trimTrailingWhitespace = true,
  },
}

vim.cmd [[autocmd BufRead,BufNewFile */nvim\/lua\/user/* :FormatDisable]]

local on_attach = function(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end

-- typescript
require 'lspconfig'.tsserver.setup { on_attach = on_attach }

-- lua
require 'lspconfig'.lua_ls.setup { on_attach = on_attach }

-- ruby
require 'lspconfig'.solargraph.setup { on_attach = on_attach }

--html
require 'lspconfig'.html.setup { on_attach = on_attach }
