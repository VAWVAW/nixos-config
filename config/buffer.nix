{ helpers, ... }: {
  plugins.bufferline = {
    enable = true;

    themable = true;
    indicator = {
      style = "icon";
      icon = "▎";
    };
    maxNameLength = 25;
    tabSize = 20;
    showBufferCloseIcons = false;
    separatorStyle = "thin";
    enforceRegularTabs = true;
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
      action = ":bdelete! %<CR>";
    }
  ];
}
