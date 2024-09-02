{ config, lib, helpers, ... }: {
  plugins.lsp = {
    enable = true;
    # inlayHints = true;

    servers = {
      bashls.enable = true;
      ccls.enable = true;
      digestif.enable = true;
      jsonls.enable = true;
      nil-ls.enable = true;
      # nixd.enable = true;
      pyright.enable = true;
      yamlls.enable = true;
    };

    keymaps = {
      silent = true;

      lspBuf = {
        "K" = "hover";
        "<leader>k" = "signature_help";
        "<leader>a" = "code_action";
        "<leader>f" = "format";
        "<F6>" = "rename";
      } // (if !config.plugins.telescope.enable then {
        gd = "definition";
        gD = "references";
        gi = "implementation";
        gt = "type_definition";
      } else
        { });
      diagnostic = {
        "<leader>p" = "goto_prev";
        "<leader>n" = "goto_next";
        "gl" = "open_float";
      };

      extra = [{
        mode = "i";
        key = "<C-k>";
        action = helpers.mkRaw "vim.lsp.buf.signature_help";
      }] ++ lib.optionals config.plugins.telescope.enable [
        {
          mode = "n";
          key = "gd";
          action = ":Telescope lsp_definitions<CR>";
        }
        {
          mode = "n";
          key = "gD";
          action = ":Telescope lsp_references<CR>";
        }
        {
          mode = "n";
          key = "gi";
          action = ":Telescope lsp_implementation<CR>";
        }
        {
          mode = "n";
          key = "gt";
          action = ":Telescope lsp_type_definitions<CR>";
        }
      ];
    };
  };
}
