{ config, lib, ... }: {
  options.languages.c.enable = lib.mkEnableOption "c language support";

  config = lib.mkIf config.languages.c.enable {
    plugins.lsp.enable = true;
    plugins.lsp.servers.ccls.enable = true;
  };
}
