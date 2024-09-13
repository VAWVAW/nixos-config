{ helpers, ... }: {
  globals = {
    # use space as leader
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps = helpers.keymaps.mkKeymaps {
    mode = "n";
    options = {
      noremap = true;
      silent = true;
    };
  } [
    # Normal
    # Better window navigation
    {
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      key = "<C-l>";
      action = "<C-w>l";
    }

    # Resize
    {
      key = "<A-k>";
      action = ":resize +2<CR>";
    }
    {
      key = "<A-j>";
      action = ":resize -2<CR>";
    }
    {
      key = "<A-h>";
      action = ":vertical resize -2<CR>";
    }
    {
      key = "<A-l>";
      action = ":vertical resize +2<CR>";
    }

    # Visual
    # Stay in indent mode
    {
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }

    # Visual Block
    # Move text up and down
    {
      mode = "x";
      key = "J";
      action = ":move '>+1<CR>gv-gv";
    }
    {
      mode = "x";
      key = "K";
      action = ":move '<-2<CR>gv-gv";
    }
  ];
}
