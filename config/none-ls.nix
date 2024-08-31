{
  plugins.none-ls = {
    enable = true;
    sources = {
      code_actions = {
        gitsigns.enable = true;
        statix.enable = true;
      };
      diagnostics = {
        deadnix.enable = true;
        pylint.enable = true;
        statix.enable = true;
        yamllint.enable = true;
      };
      formatting = {
        black.enable = true;
        nixfmt.enable = true;
        prettier.enable = true;
      };
    };
  };
}
