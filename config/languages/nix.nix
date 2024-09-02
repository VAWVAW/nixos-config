{ config, lib, ... }: {
  options.languages.nix.enable = lib.mkEnableOption "nix language support";

  config = lib.mkIf config.languages.nix.enable {
    plugins = {
      lsp = {
        enable = true;
        servers.nil-ls.enable = true;
      };
      none-ls = {
        enable = true;
        sources.formatting.nixfmt.enable = true;
        sources.diagnostics.deadnix.enable = true;
      };
    };
  };
}
