{ config, lib, ... }: {
  options.languages.rust.enable = lib.mkEnableOption "rust language support";

  config.plugins = lib.mkIf config.languages.rust.enable {
    lsp.enable = true;
    lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
    };

    dap.enabled = true;
    dap.extensions.dap-lldb.enable = true;
  };
}
