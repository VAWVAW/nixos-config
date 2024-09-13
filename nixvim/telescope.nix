{ pkgs, helpers, ... }: {
  extraPackages = [ pkgs.ripgrep ];
  extraPlugins = [ pkgs.vimPlugins.telescope-symbols-nvim ];

  plugins.telescope = {
    enable = true;

    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    settings = {
      pickers = {
        find_files.initial_mode = "insert";
        live_grep.initial_mode = "insert";
      };
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display.truncate = 1;
        initial_mode = "normal";
        mappings = {
          i = {
            "<C-c>" = helpers.mkRaw "require('telescope.actions').close";

            "<C-j>" =
              helpers.mkRaw "require('telescope.actions').move_selection_next";
            "<C-k>" = helpers.mkRaw
              "require('telescope.actions').move_selection_previous";
            "<Down>" =
              helpers.mkRaw "require('telescope.actions').move_selection_next";
            "<Up>" = helpers.mkRaw
              "require('telescope.actions').move_selection_previous";

            "<CR>" =
              helpers.mkRaw "require('telescope.actions').select_default";
            "<C-o>" =
              helpers.mkRaw "require('telescope.actions').select_horizontal";
            "<C-v>" =
              helpers.mkRaw "require('telescope.actions').select_vertical";
            "<C-t>" = helpers.mkRaw "require('telescope.actions').select_tab";

            "<C-p>" =
              helpers.mkRaw "require('telescope.actions').preview_scrolling_up";
            "<C-n>" = helpers.mkRaw
              "require('telescope.actions').preview_scrolling_down";

            "<PageUp>" =
              helpers.mkRaw "require('telescope.actions').results_scrolling_up";
            "<PageDown>" = helpers.mkRaw
              "require('telescope.actions').results_scrolling_down";

            "<Tab>" = helpers.mkRaw
              "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse";
            "<S-Tab>" = helpers.mkRaw
              "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better";

            "<C-l>" = helpers.mkRaw "require('telescope.actions').complete_tag";
          };
          n = {
            "<Esc>" = helpers.mkRaw "require('telescope.actions').close";
            "q" = helpers.mkRaw "require('telescope.actions').close";
            "?" = helpers.mkRaw "require('telescope.actions').which_key";
            "/" = helpers.mkRaw "{ '<cmd>startinsert<CR>', type = 'command' }";

            "j" =
              helpers.mkRaw "require('telescope.actions').move_selection_next";
            "k" = helpers.mkRaw
              "require('telescope.actions').move_selection_previous";
            "H" = helpers.mkRaw "require('telescope.actions').move_to_top";
            "M" = helpers.mkRaw "require('telescope.actions').move_to_middle";
            "L" = helpers.mkRaw "require('telescope.actions').move_to_bottom";
            "gg" = helpers.mkRaw "require('telescope.actions').move_to_top";
            "G" = helpers.mkRaw "require('telescope.actions').move_to_bottom";

            "<CR>" =
              helpers.mkRaw "require('telescope.actions').select_default";
            "<C-o>" =
              helpers.mkRaw "require('telescope.actions').select_horizontal";
            "<C-v>" =
              helpers.mkRaw "require('telescope.actions').select_vertical";
            "<C-t>" = helpers.mkRaw "require('telescope.actions').select_tab";

            "<C-p>" =
              helpers.mkRaw "require('telescope.actions').preview_scrolling_up";
            "<C-n>" = helpers.mkRaw
              "require('telescope.actions').preview_scrolling_down";

            "<PageUp>" =
              helpers.mkRaw "require('telescope.actions').results_scrolling_up";
            "<PageDown>" = helpers.mkRaw
              "require('telescope.actions').results_scrolling_down";

            "<Tab>" = helpers.mkRaw
              "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse";
            "<S-Tab>" = helpers.mkRaw
              "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better";
          };
        };
      };
    };
    keymaps = {
      "<leader>t".action = "find_files previewer=false theme=dropdown";
      "<leader>r".action = "resume";
      "<C-f>".action = "live_grep";
    };
  };
}
