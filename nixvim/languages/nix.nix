{ config, lib, ... }: {
  options.languages.nix.enable = lib.mkEnableOption "nix language support";

  config.plugins = lib.mkIf config.languages.nix.enable {
    lsp = {
      enable = true;
      servers.nil_ls.enable = true;
    };
    none-ls = {
      enable = true;
      sources.formatting.nixfmt.enable = true;
      sources.diagnostics.deadnix.enable = true;
    };
  };
}
