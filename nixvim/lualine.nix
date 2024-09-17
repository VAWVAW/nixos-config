{ config, pkgs, helpers, ... }: {
  extraPlugins = [ pkgs.vimPlugins.lualine-lsp-progress ];
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        ignore_focus = [ "NvimTree" "Outline" ];
        extensions = [ "quickfix" "toggleterm" "fugitive" ];

        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };

      sections = let
        branch = {
          __unkeyed = "b:gitsigns_head";
          icon = if config.disable_nerdfonts then "" else "";
        };
        diagnostics = {
          __unkeyed = "diagnostics";
          sources = [ "nvim_diagnostic" ];
          sections = [ "error" "warn" ];
          symbols = {
            error = if config.disable_nerdfonts then "E:" else " ";
            warn = if config.disable_nerdfonts then "W:" else " ";
          };
          colored = false;
          update_in_insert = false;
          always_visible = true;
        };
        filename = {
          __unkeyed = "filename";
          path = 1;
          newfile_status = true;
          symbols = {
            modified = "";
            readonly = if config.disable_nerdfonts then "[L]" else "";
            unnamed = if config.disable_nerdfonts then "[?]" else "[]";
            newfile = if config.disable_nerdfonts then "[+]" else "";
          };
        };
        diff = {
          __unkeyed = "diff";
          colored = false;
          symbols = {
            added = if config.disable_nerdfonts then "+" else " ";
            modified = if config.disable_nerdfonts then "~" else " ";
            removed = if config.disable_nerdfonts then "-" else " ";
          };
          source = helpers.mkRaw ''
            function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end'';
        };
        fileformat = {
          __unkeyed = "fileformat";
          symbols = {
            unix = "\\n";
            dos = "\\r\\n";
            mac = "\\r";
          };
        };
        filetype = {
          __unkeyed = "filetype";
          icons_enabled = false;
          icon = null;
        };
      in {
        lualine_a = [ branch diagnostics ];
        lualine_b = [ filename ];
        lualine_c = [ "" ];

        lualine_x = [ "lsp_progress" ];
        lualine_y = [ diff "encoding" fileformat filetype "progress" ];
        lualine_z = [ "" ];
      };
    };
  };
}
