require("toggleterm").setup {
  open_mapping = [[<C-t>]],
  insert_mappings = true,

  shade_terminals = false,

  shell = vim.o.shell,
  close_on_exit = true,
  hide_numbers = true,
  start_in_insert = true,

  size = 20,
  direction = "float",
  persist_size = true,
}

function _G.set_terminal_keymaps()
  local opts = { buffer = 0, noremap = true }
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-space>", "<C-\\><C-n>", opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
