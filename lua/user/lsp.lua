-- add servers here
local servers = {
	"tsserver",
  "tailwindcss",
	"cssls",
	"html",
	"lua_ls",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
  "solargraph"
}

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

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


-- add anything needed for on_attach
local on_attach = function(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

-- set up each server
for _, server in pairs(servers) do
	opts = {
		on_attach = on_attach,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
