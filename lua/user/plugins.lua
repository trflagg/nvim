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
  { 'nvim-tree/nvim-web-devicons',    lazy = true }, --required for lualine

  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "smartpde/telescope-recent-files" },

  { "junegunn/goyo.vim",              event = "VeryLazy" },
  { "folke/trouble.nvim",             requires = "kyazdani43/nvim-web-devicons" },
  { "tpope/vim-eunuch" }
}
