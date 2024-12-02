{ config, lib, ... }: {
  options.languages.zig.enable = lib.mkEnableOption "zig language support";

  config.plugins = lib.mkIf config.languages.zig.enable {
    lsp.enable = true;
    lsp.servers.zls.enable = true;

    rainbow-delimiters.enable = lib.mkForce false; # extremly slow to parse
  };
}
