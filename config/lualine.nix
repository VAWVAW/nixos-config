{ helpers, ... }: {
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    ignoreFocus = [ "NvimTree" "aerial" ];
    extensions = [ "quickfix" "toggleterm" "fugitive" ];

    componentSeparators = {
      left = "";
      right = "";
    };
    sectionSeparators = {
      left = "";
      right = "";
    };

    sections = let
      branch = {
        name = "b:gitsigns_head";
        icon = "";
      };
      diagnostics = {
        name = "diagnostics";
        extraConfig = {
          sources = [ "nvim_diagnostic" ];
          sections = [ "error" "warn" ];
          symbols = {
            error = " ";
            warn = " ";
          };
          colored = false;
          update_in_insert = false;
          always_visible = true;
        };
      };
      filename = {
        name = "filename";
        extraConfig = {
          path = 1;
          newfile_status = true;
          symbols = {
            modified = "";
            readonly = "";
            unnamed = "[]";
            newfile = "";
          };
        };
      };
      diff = {
        name = "diff";
        extraConfig = {
          colored = false;
          symbols = {
            added = " ";
            modified = " ";
            removed = " ";
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
      };
      filetype = {
        name = "filetype";
        icons_enabled = false;
        icon = null;
      };
    in {
      lualine_a = [ branch diagnostics ];
      lualine_b = [ filename ];
      lualine_c = [ "" ];

      lualine_x = [ "lsp_progress" ];
      lualine_y = [ diff "encoding" "fileformat" filetype "progress" ];
      lualine_z = [ "" ];
    };
  };
}
