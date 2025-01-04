{ outputs, config, pkgs, lib, ... }:
let cfg = config.programs.signal-desktop;
in {
  options.programs.signal-desktop.enable = lib.mkEnableOption "signal-desktop";

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/vaw" = {
      directories = [{
        directory = ".config/Signal";
        method = "symlink";
      }];
    };

    home.packages = let
      signal-desktop = (outputs.lib.wrapFirejailBinary {
        inherit pkgs lib;
        name = "signal-desktop";
        wrappedExecutable = "${pkgs.signal-desktop}/bin/signal-desktop";
        profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
      });
    in [
      (pkgs.writeShellScriptBin "signal-desktop" ''
        NIXOS_OZONE_WL= ${pkgs.expect}/bin/unbuffer ${signal-desktop}/bin/signal-desktop
      '')
    ];
  };
}
