{ config, lib, ... }: {
  options.languages.python.enable =
    lib.mkEnableOption "python language support";

  config = lib.mkIf config.languages.python.enable {
    plugins = {
      lsp = {
        enable = true;
        servers.pyright.enable = true;
      };
      none-ls = {
        enable = true;
        sources.formatting.black.enable = true;
      };
    };
  };
}
