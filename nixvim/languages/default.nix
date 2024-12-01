{ config, lib, ... }: {
  imports = [ ./c.nix ./markdown.nix ./nix.nix ./python.nix ./rust.nix ./zig.nix ];
  options.languages.all.enable = lib.mkEnableOption "support for all languages";

  config.languages = lib.mkIf config.languages.all.enable {
    c.enable = true;
    nix.enable = true;
    python.enable = true;
    rust.enable = true;
    markdown.enable = true;
    zig.enable = true;
  };
}
