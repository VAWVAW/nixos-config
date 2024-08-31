{
  plugins.lsp = {
    enable = true;
    # inlayHints = true;

    servers = {
      bashls.enable = true;
      ccls.enable = true;
      digestif.enable = true;
      jsonls.enable = true;
      # nil-ls.enable = true;
      nixd.enable = true;
      marksman.enable = true;
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
      };
      diagnostic = {
        "<leader>p" = "goto_prev";
        "<leader>n" = "goto_next";
        "gl" = "open_float";
      };
    };
  };
}
