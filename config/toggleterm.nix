{ helpers, ... }: {
  plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<C-t>]]";

      shade_terminals = false;
      size = 20;
      direction = "float";
    };
  };

  autoCmd = [{
    event = "TermOpen";
    pattern = "term://*";
    callback = helpers.mkRaw ''
      function()
        local opts = { buffer = 0, noremap = true }
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-space>", "<C-\\><C-n>", opts)
      end'';
  }];
}
