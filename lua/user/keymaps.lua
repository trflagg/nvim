-- Shorten functon name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }
local silent = { silent = true }
local noremap = { noremap = true }
local noremapAndSilent = { silent = true, noremap = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- remap escape to jk
keymap("i", "jk", "<ESC>", noremap)

keymap("n", "B", "^", noremap)
keymap("n", "E", "$", noremap)

-- tmux movement
keymap("n", "<c-j>", "<c-w>j", noremap)
keymap("n", "<c-h>", "<c-w>h", noremap)
keymap("n", "<c-k>", "<c-w>k", noremap)
keymap("n", "<c-l>", "<c-w>l", noremap)
--
-- handy rename
keymap("n", "<leader>rn", '"zye:%s/<C-R>z/')

-- console log
keymap("n", "<leader>cl", "zyeoconsole.log(`taylor  <esc>Pa: ${JSON.stringify(<esc>pa, null, ' ')}`);<esc>")
keymap("n", "<leader>cc", "zyeoconsole.log(`taylor <esc>pa `);<esc>F`i")

-- edit and source prefs files
keymap("n", "<leader>ei", ":e ~/.config/nvim/lua/user<CR>")
keymap("n", "<leader>ek", ":e ~/.config/nvim/lua/user/keymaps.lua<CR>")
keymap("n", "<leader>ep", ":e ~/.config/nvim/lua/user/plugins.lua<CR>")
keymap("n", "<leader>ec", ":e ~/.config/nvim/lua/user/colorscheme.lua<CR>")
keymap("n", "<leader>el", ":e ~/.config/nvim/lua/user/plugins/lsp.lua<CR>")
keymap("n", "<leader>s", ":source %<CR>")

-- Remove highlights
keymap("n", "<ESC>", ":noh<CR><CR>", silent)

-- Buffers
keymap("n", "<Tab>", ":b#<CR>", silent)

-- Toggle quicklist
keymap("n", "<leader>q", "<cmd>lua require('utils').toggle_quicklist()<CR>", silent)

-- change background
keymap("n", "<leader>ll", ":colorscheme onelight<CR>")
keymap("n", "<leader>dd", ":colorscheme onedark<CR>")

-- keymap("n", "<C-p>", "<CMD>lua require('telescope.builtin').git_files()<CR>")
keymap("n", "<C-p>", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", "<CMD>lua require('telescope.builtin').live_grep()<CR>")
keymap("n", "<leader>fs", "<CMD>lua require('telescope.builtin').grep_string()<CR>")
keymap("n", "<Leader>*", '<Cmd>lua require("telescope.builtin").grep_string()<CR>')
keymap("n", "<leader>fr", "<CMD>lua require('telescope').extensions.recent_files.pick()<CR>")
keymap("n", "<leader>fd", "<CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>")
keymap("n", "<leader>fi", "<CMD>lua require('telescope.builtin').lsp_implementation()<CR>")
keymap("n", "<leader>fe", "<CMD>lua require('telescope.builtin').diagnostics()<CR>")
keymap("n", "<leader>ft", "<CMD>lua require('telescope.builtin').treesitter()<CR>")
keymap("n", "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>")
keymap("n", "<leader><leader>", "<CMD>lua require('telescope.builtin').buffers()<CR>")
keymap("n", "<leader>fo", "<CMD>lua require('telescope.builtin').oldfiles()<CR>")
keymap("n", "<leader>fq", "<CMD>lua require('telescope.builtin').quickfix()<CR>")
keymap("n", "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>")
keymap("n", "<leader>f<leader>", [[<Cmd>lua require('telescope.builtin').resume()<CR>]], noremapAndSilent)
keymap("i", "<C-q>", "<CMD>lua actions.smart_add_to_qflist + actions.open_qflist<CR>")

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", silent)
keymap("x", "J", ":move '>+1<CR>gv-gv", silent)

-- lsp bindings in ./lsp.lua

-- navigate prev/next lsp issue
-- keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded' }})<CR>", silent)
-- keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded' }})<CR>", silent)

-- comment

keymap("n", "]q", ":cn<CR>", noremapAndSilent)
keymap("n", "[q", ":cp<CR>", noremapAndSilent)

-- because I have a hard time hitting %
keymap("n", "<c-s>", "%", silent)

keymap("n", "<leader>nt", ":NvimTreeOpen<cr>", silent)

-- try and toggle diagnostics
--keymap("n", "<leader>do", "<CMD>lua vim.diagnostic.config({ underline = false })<CR>")
