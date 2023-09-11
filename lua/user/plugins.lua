return {
    { "nvim-lua/plenary.nvim" },
    {
      "olimorris/onedarkpro.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme onedark]])
      end,
    },
    { "folke/neodev.nvim", opts = {} },
    { 'neovim/nvim-lspconfig',
    config = function ()
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true
      })
    end
  },

  {"lukas-reineke/lsp-format.nvim"},

  { 'hrsh7th/cmp-nvim-lsp', config = function()
      vim.cmd [[cabbrev wq execute "Format sync" <bar> wq]]
    end
  },
  {
    'hrsh7th/nvim-cmp',
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

  {
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'smartpde/telescope-recent-files' },
    config = function ()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.load_extension("recent_files")
      telescope.setup {
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
            },
          },
        },
      }
    end
  },

  { "nvim-lualine/lualine.nvim" },
  { 'nvim-tree/nvim-web-devicons',    lazy = true }, --required for lualine

  { "junegunn/goyo.vim",              event = "VeryLazy" },
  { "folke/trouble.nvim",             requires = "kyazdani43/nvim-web-devicons" },
  { "tpope/vim-eunuch" }
}
