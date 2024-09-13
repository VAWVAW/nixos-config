{ helpers, ... }: {
  plugins.bufferline = {
    enable = true;

    settings.options = {
      themable = true;
      indicator = {
        style = "icon";
        icon = "▎";
      };
      max_name_length = 25;
      tab_size = 20;
      show_buffer_close_icons = false;
      separator_style = "thin";
      enforce_regular_tabs = true;
    };
  };

  plugins.vim-bbye.enable = true;

  keymaps = helpers.keymaps.mkKeymaps {
    mode = "n";
    options = {
      noremap = true;
      silent = true;
    };
  } [
    {
      key = "<C-p>";
      action = ":BufferLineCycleNext<CR>";
    }
    {
      key = "<C-n>";
      action = ":BufferLineCyclePrev<CR>";
    }
    {
      key = "<A-p>";
      action = ":BufferLineMoveNext<CR>";
    }
    {
      key = "<A-n>";
      action = ":BufferLineMovePrev<CR>";
    }
    {
      key = "<C-x>";
      action = ":Bdelete! %<CR>";
    }
  ];
}
