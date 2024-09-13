{ config, lib, ... }: {
  options.languages.c.enable = lib.mkEnableOption "c language support";

  config.plugins = lib.mkIf config.languages.c.enable {
    lsp.enable = true;
    lsp.servers.ccls.enable = true;
  };
}
