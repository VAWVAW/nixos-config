{ pkgs, helpers, ... }: {
  extraPlugins = [ pkgs.vimPlugins.lualine-lsp-progress ];
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        ignore_focus = [ "NvimTree" "aerial" ];
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
          icon = "";
        };
        diagnostics = {
          __unkeyed = "diagnostics";
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
        filename = {
          __unkeyed = "filename";
          path = 1;
          newfile_status = true;
          symbols = {
            modified = "";
            readonly = "";
            unnamed = "[]";
            newfile = "";
          };
        };
        diff = {
          __unkeyed = "diff";
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
        lualine_y = [ diff "encoding" "fileformat" filetype "progress" ];
        lualine_z = [ "" ];
      };
    };
  };
}
