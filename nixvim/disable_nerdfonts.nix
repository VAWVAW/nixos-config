{ config, lib, ... }: {
  options.disable_nerdfonts =
    lib.mkEnableOption "disable use of nerdfonts icons";

  config = lib.mkIf config.disable_nerdfonts {
    extraConfigLuaPost = ''
      vim.api.nvim_set_hl(0, "Visual", { ctermfg = 0, ctermbg = 244, })
    '';

    plugins.bufferline.settings.options = {
      indicator.icon = lib.mkForce "│";
      separator_style = lib.mkForce [ "│" "│" ];
      left_trunc_marker = "←";
      right_trunc_marker = "→";
      show_buffer_icons = false;
    };

    plugins.nvim-tree.renderer.icons = lib.mkForce {
      symlinkArrow = "→";
      show = {
        file = false;
        folder = false;
      };
      glyphs = {
        folder = {
          arrowOpen = "v";
          arrowClosed = ">";
        };
        git = {
          renamed = "→";
          unmerged = "=";
          deleted = "-";
          unstaged = "?";
          untracked = "?";
          staged = "";
          ignored = "";
        };
      };
    };

    plugins.telescope = {
      keymaps."<leader>t".action = lib.mkForce
        "find_files previewer=false theme=dropdown disable_devicons=true";
      settings.defaults = {
        prompt_prefix = lib.mkForce "";
        selection_caret = lib.mkForce ">";
      };
    };

    plugins.dap.signs.dapBreakpoint.text = lib.mkForce "B";
    plugins.dap.extensions.dap-ui.icons = lib.mkForce {
      collapsed = ">";
      current_frame = ">";
      expanded = "v";
    };

    plugins.cmp.settings.formatting.fields = lib.mkForce [ "abbr" "menu" ];

    plugins.gitsigns.settings.signs = lib.mkForce {
      add.text = "│";
      change.text = "│";
      changedelete.text = "│";
      delete.text = "_";
      topdelete.text = "~";
    };
  };
}
