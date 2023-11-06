return {
	{ "nvim-lua/plenary.nvim" },

	-- colors!
	{
		"olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme onedark]])
		end,
	},

	-- handle conflicts when messing around in .config/nvim
	-- {
	-- 	"folke/neodev.nvim",
	-- 	opts = {},
	-- 	config = function()
	-- 		require("neodev").setup({})
	-- 	end,
	-- },
	-- { "L3MON4D3/LuaSnip", lazy = false, version = "1.*",  build = "make install_jsregexp"  },
	-- { "saadparwaiz1/cmp_luasnip", lazy = false },

	-- mason, masonlspconfig, lspconfig
	-- these are set up in  user/lsp
	-- { "williamboman/mason.nvim" },
	-- { "williamboman/mason-lspconfig.nvim" },
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	config = function()
	-- 		vim.diagnostic.config({
	-- 			virtual_text = false,
	-- 			signs = true,
	-- 			underline = true,
	-- 			update_in_insert = true,
	-- 		})
	-- 	end,
	-- },

	-- formatting
	{
		"sbdchd/neoformat",
		config = function()
			vim.cmd([[
			        augroup fmt
			          autocmd!
			          autocmd BufWritePre * undojoin | Neoformat
			        augroup END
			      ]])
		end,
	},

	-- autocompletion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = { "InsertEnter" },
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		config = function()
			vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", "smartpde/telescope-recent-files" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.load_extension("recent_files")
			telescope.setup({
				defaults = {

					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "smart" },
					file_ignore_patterns = { ".git/", "node_modules" },

					mappings = {
						i = {
							["<Down>"] = actions.cycle_history_next,
							["<Up>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.smart_send_to_qflist,
						},
					},
				},
			})
		end,
	},

	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({
				-- create_mappings = false,
				-- line_mapping = "<leader>/",
				-- operator_mapping = "<leader>c",
				-- comment_chunk_text_object = "ic"
			})
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			diagnostics = {
				enable = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
		},
	},

	{ "nvim-lualine/lualine.nvim", lazy = false },
	-- { "nvim-tree/nvim-web-devicons", lazy = false }, --required for lualine

	{ "junegunn/goyo.vim", event = "VeryLazy" },
	{ "folke/trouble.nvim" },
	{ "tpope/vim-eunuch" },

	{ "prisma/vim-prisma" },
	{ "tpope/vim-unimpaired", lazy = false },
}
