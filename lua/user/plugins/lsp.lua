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
	"solargraph",
	"graphql",
	-- "emmet_ls",
}

-- for cmp
local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local function organize_imports()
	local params = { command = "_typescript.organizeImports", arguments = { vim.api.nvim_buf_get_name(0) }, title = "" }
	vim.lsp.buf.execute_command(params)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		tag = nil,
		branch = "master",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"html",
					"css",
					"typescript",
					"tsx",
					"javascript",
					"python",
					"markdown",
					"markdown_inline",
					"bash",
					"yaml",
					"lua",
					"vim",
					"graphql",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
					-- optional (with quarto-vim extension and pandoc-syntax)
					-- additional_vim_regex_highlighting = { 'markdown' },

					-- note: the vim regex based highlighting from
					-- quarto-vim / vim-pandoc sets the wrong comment character
					-- for some sections where there is `$` math.
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ao"] = "@codechunk.outer",
							["io"] = "@codechunk.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_previous_start = {
							["[m"] = "@function.outer",
							["]q"] = "@function.inner",
							["[c"] = "@codechunk.inner",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
						goto_next_start = {
							["]m"] = "@function.outer",
							["]w"] = "@function.inner",
							["]c"] = "@codechunk.inner",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"neovim/nvim-lspconfig",
		tag = nil,
		version = nil,
		branch = "master",
		event = "BufReadPre",
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim" },
			{ "williamboman/mason.nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local util = require("lspconfig.util")

			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end
				local function buf_set_option(...)
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
				local opts = { noremap = true, silent = true }

				buf_set_keymap("n", "gD", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
				buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
				buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
				buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
				buf_set_keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
				buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				client.server_capabilities.document_formatting = true
			end

			local lsp_flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 150,
			}

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = true,
					signs = true,
					underline = true,
					update_in_insert = false,
				})
			vim.lsp.handlers["textDocument/hover"] =
				vim.lsp.with(vim.lsp.handlers.hover, { border = require("user.misc.style").border })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = require("user.misc.style").border })

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			for _, server in pairs(servers) do
				setup_opts = {
					on_attach = on_attach,
					capabilities = capabilities,
					flags = lsp_flags,
					commands = {
						OrganizeImports = { organize_imports, description = "Organize Imports" },
					},
				}
				server = vim.split(server, "@")[1]
				lspconfig[server].setup(setup_opts)
			end

			-- lspconfig.emmet_ls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	flags = lsp_flags,
			-- })
			--
			-- lspconfig.cssls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	flags = lsp_flags,
			-- })
			--
			-- lspconfig.html.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	flags = lsp_flags,
			-- })
			--
			-- lspconfig.emmet_ls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	flags = lsp_flags,
			-- })

			local function strsplit(s, delimiter)
				local result = {}
				for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
					table.insert(result, match)
				end
				return result
			end

			local function get_quarto_resource_path()
				local f = assert(io.popen("quarto --paths", "r"))
				local s = assert(f:read("*a"))
				f:close()
				return strsplit(s, "\n")[2]
			end

			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				flags = lsp_flags,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "require" },
						},
					},
				},
			})
		end,
	},

	-- completion

	cmp.setup({
		snippet = {
			expand = function()
				-- luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},

		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			-- Accept currently selected item. If none selected, `select` first item.
			-- Set `select` to `false` to only confirm explicitly selected items.
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if not entry then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					else
						cmp.confirm()
					end
				else
					fallback()
				end
			end, { "i", "s", "c" }),
			-- 	if cmp.visible() then
			-- 		cmp.select_next_item()
			-- 	-- elseif luasnip.expandable() then
			-- 	-- 	luasnip.expand()
			-- 	-- elseif luasnip.expand_or_jumpable() then
			-- 	-- 	luasnip.expand_or_jump()
			-- 	elseif check_backspace() then
			-- 		fallback()
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, {
			-- 	"i",
			-- 	"s",
			-- }),
			-- ["<S-Tab>"] = cmp.mapping(function(fallback)
			-- 	if cmp.visible() then
			-- 		cmp.select_prev_item()
			-- 	-- elseif luasnip.jumpable(-1) then
			-- 	-- 	luasnip.jump(-1)
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, {
			-- 	"i",
			-- 	"s",
			-- }),
		}),
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				vim_item.kind = kind_icons[vim_item.kind]
				vim_item.menu = ({
					nvim_lsp = "",
					nvim_lua = "",
					luasnip = "",
					buffer = "",
					path = "",
					emoji = "",
				})[entry.source.name]
				return vim_item
			end,
		},
		sources = {
			{ name = "path" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lua" },
			{ name = "nvim_lsp_document_symbol" },
			{ name = "buffer" },
		},
		confirm_opts = {
			-- behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		experimental = {
			ghost_text = true,
		},
	}),
}
