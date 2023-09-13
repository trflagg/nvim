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
	"emmet_ls",
}

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
						goto_next_start = {
							["]m"] = "@function.outer",
							["]c"] = "@codechunk.inner",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[c"] = "@codechunk.inner",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
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
				buf_set_keymap("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
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
	{
		"hrsh7th/nvim-cmp",
		branch = "main",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-emoji" },
			-- { "saadparwaiz1/cmp_luasnip" },
			{ "f3fora/cmp-spell" },
			{ "ray-x/cmp-treesitter" },
			{ "kdheepak/cmp-latex-symbols" },
			{ "jmbuhr/cmp-pandoc-references" },
			-- { "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "onsails/lspkind-nvim" },

			-- optional
			-- more things to try:
			-- {
			--   "zbirenbaum/copilot-cmp",
			--   after = { "copilot.lua" },
			--   dependencies = { "zbirenbaum/copilot.lua" },
			--   config = function()
			--     require("copilot").setup({
			--       suggestion = { enabled = false },
			--       panel = { enabled = false },
			--     })
			--     require("copilot_cmp").setup()
			--   end
			-- },
		},
		config = function()
			local cmp = require("cmp")
			-- local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			lspkind.init()

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						-- luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-f>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping(function(fallback)
						-- if luasnip.expand_or_jumpable() then
						-- 	luasnip.expand_or_jump()
						-- 	fallback()
						-- end
					end, { "i", "s" }),
					["<C-p>"] = cmp.mapping(function(fallback)
						-- if luasnip.jumpable(-1) then
						-- 	luasnip.jump(-1)
						-- else
						fallback()
					end, { "i", "s" }),
					-- ['<c-e>'] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				autocomplete = false,
				formatting = {
					format = lspkind.cmp_format({
						with_text = true,
						menu = {
							otter = "[🦦]",
							copilot = "[]",
							-- luasnip = "[snip]",
							nvim_lsp = "[LSP]",
							buffer = "[buf]",
							path = "[path]",
							spell = "[spell]",
							pandoc_references = "[ref]",
							tags = "[tag]",
							treesitter = "[TS]",
							calc = "[calc]",
							latex_symbols = "[tex]",
							emoji = "[emoji]",
						},
					}),
				},
				sources = {
					-- { name = 'copilot',                keyword_length = 0, max_item_count = 3 },
					{ name = "otter" }, -- for code chunks in quarto
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- { name = "luasnip", keyword_length = 3, max_item_count = 3 },
					{ name = "pandoc_references" },
					{ name = "buffer", keyword_length = 5, max_item_count = 3 },
					{ name = "spell" },
					{ name = "treesitter", keyword_length = 5, max_item_count = 3 },
					{ name = "calc" },
					{ name = "latex_symbols" },
					{ name = "emoji" },
				},
				view = {
					entries = "native",
				},
				window = {
					documentation = {
						border = require("user.misc.style").border,
					},
				},
			})
			-- for friendly snippets
			-- require("luasnip.loaders.from_vscode").lazy_load()
			-- for custom snippets
			-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
			-- link quarto and rmarkdown to markdown snippets
			-- 	luasnip.filetype_extend("quarto", { "markdown" })
			-- 	luasnip.filetype_extend("rmarkdown", { "markdown" })
		end,
	},
}
