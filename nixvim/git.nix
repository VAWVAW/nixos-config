{ helpers, ... }: {
  plugins.fugitive.enable = true;
  plugins.gitsigns = {
    enable = true;

    settings.signs = {
      add.text = "▎";
      change.text = "▎";
      changedelete.text = "▎";
    };
  };

  keymaps = helpers.keymaps.mkKeymaps {
    mode = "n";
    options = {
      noremap = true;
      silent = true;
    };
  } (let gs = "package.loaded.gitsigns";
  in [
    {
      key = "<leader>gn";
      action = helpers.mkRaw "${gs}.next_hunk";
    }
    {
      key = "<leader>gp";
      action = helpers.mkRaw "${gs}.prev_hunk";
    }

    {
      key = "<leader>gs";
      action = helpers.mkRaw "${gs}.stage_hunk";
    }
    {
      key = "<leader>gr";
      action = helpers.mkRaw "${gs}.reset_hunk";
    }
    {
      key = "<leader>gS";
      action = helpers.mkRaw "${gs}.stage_buffer";
    }
    {
      key = "<leader>gR";
      action = helpers.mkRaw "${gs}.reset_buffer";
    }
    {
      mode = "v";
      key = "<leader>gs";
      action = helpers.mkRaw ''
        function() ${gs}.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end'';
    }
    {
      mode = "v";
      key = "<leader>gr";
      action = helpers.mkRaw ''
        function() ${gs}.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end'';
    }

    {
      key = "<leader>gu";
      action = helpers.mkRaw "${gs}.undo_stage_hunk";
    }
    {
      key = "<leader>gl";
      action = helpers.mkRaw "${gs}.preview_hunk";
    }
    {
      key = "<leader>gb";
      action = helpers.mkRaw "function() ${gs}.blame_line { full = true} end";
    }
    {
      key = "<leader>gt";
      action = helpers.mkRaw "${gs}.toggle_deleted";
    }

    {
      key = "<leader>gc";
      action = ":tab :Git commit <CR>";
    }
  ]);
}
