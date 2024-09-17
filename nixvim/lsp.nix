{ config, lib, helpers, ... }: {
  plugins.lsp = {
    enable = true;
    inlayHints = true;

    servers = {
      bashls.enable = lib.mkDefault true;
      jsonls.enable = lib.mkDefault true;
      yamlls.enable = lib.mkDefault true;
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
        {
          mode = "n";
          key = "<leader>q";
          action = ":Telescope diagnostics<CR>";
        }
      ];
    };
  };

  extraConfigLua = let
    signs = helpers.toLuaObject (if config.disable_nerdfonts then {
      "DiagnosticSignError" = "E";
      "DiagnosticSignWarn" = "W";
      "DiagnosticSignHint" = "I";
      "DiagnosticSignInfo" = "H";
    } else {
      "DiagnosticSignError" = "";
      "DiagnosticSignWarn" = "";
      "DiagnosticSignHint" = "";
      "DiagnosticSignInfo" = "";
    });
  in lib.mkIf config.plugins.lsp.enable ''
    local signs = ${signs}
    for name, text in pairs(signs) do
      vim.fn.sign_define(name, { texthl = name, text = text, numhl = "" })
    end
  '';
}
