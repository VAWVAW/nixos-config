local opts = { noremap = true, silent = true }

-- Shorten function name
local map = vim.api.nvim_set_keymap

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts)
map("n", "<leader>w", ":AerialToggle<CR>", opts)
map("n", "<leader>r", ":Telescope find_files previewer=false theme=dropdown<CR>", opts)
map("n", "<C-f>", ":Telescope live_grep<CR>", opts)

-- Resize
map("n", "<A-k>", ":resize +2<CR>", opts)
map("n", "<A-j>", ":resize -2<CR>", opts)
map("n", "<A-h>", ":vertical resize -2<CR>", opts)
map("n", "<A-l>", ":vertical resize +2<CR>", opts)

-- Navigate buffers (using bufferline)
map("n", "<C-p>", ":BufferLineCycleNext<CR>", opts)
map("n", "<C-n>", ":BufferLineCyclePrev<CR>", opts)
map("n", "<A-p>", ":BufferLineMoveNext<CR>", opts)
map("n", "<A-n>", ":BufferLineMovePrev<CR>", opts)
map("n", "<C-x>", ":Bdelete! %<CR>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

require("Comment").setup {}
