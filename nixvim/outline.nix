{ config, pkgs, helpers, ... }: {
  extraPlugins = [ pkgs.vimPlugins.outline-nvim ];

  extraConfigLua = let
    icons = {
      File = "";
      Module = "";
      Namespace = "󰙅 ";
      Package = "󰜬";
      Class = "𝓒";
      Method = "󰊕";
      Property = "";
      Field = "";
      Constructor = "";
      Enum = "";
      Interface = " ";
      Function = "󰊕";
      Variable = "";
      Constant = "";
      String = "󱀍";
      Number = "";
      Boolean = "󰨙";
      Array = "";
      Object = "";
      Key = "";
      Null = "NULL";
      EnumMember = "";
      Struct = "";
      Event = "🗲";
      Operator = "+";
      TypeParameter = "𝙏";
      Component = "";
      Fragment = "";
    };
    cfg = {
      outline_window = {
        position = "left";
        width = 30;
        relative_width = false;
      };
      keymaps = {
        up_and_jump = "K";
        down_and_jump = "J";
        peek_location = "<Tab>";
        toggle_preview = "L";
        fold = "h";
        fold_toggle = "l";
        unfold = { };
        hover_symbol = "gl";
      };
      symbol_folding.autofold_depth = 3;
      symbols.icon_fetcher = helpers.mkRaw (if config.disable_nerdfonts then ''
        function(kind, bufnr)
          return string.sub(kind, 1, 1)
        end
      '' else ''
        function(kind, bufnr)
          local icons = ${helpers.toLuaObject icons}
          return icons[kind]
        end
      '');
    };
  in ''
    require('outline').setup(${helpers.toLuaObject cfg})
  '';

  keymaps = helpers.keymaps.mkKeymaps {
    mode = "n";
    options = {
      noremap = true;
      silent = true;
    };
  } [{
    key = "<leader>w";
    action = ":OutlineOpen<CR>";
  }];
}
