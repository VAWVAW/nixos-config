{ config, lib, ... }: {
  options.languages.python.enable =
    lib.mkEnableOption "python language support";

  config.plugins = lib.mkIf config.languages.python.enable {
    lsp = {
      enable = true;
      servers.pyright.enable = true;
    };
    none-ls = {
      enable = true;
      sources.formatting.black.enable = true;
    };
    dap = {
      enabled = true;
      extensions.dap-python.enable = true;
    };
  };
}
