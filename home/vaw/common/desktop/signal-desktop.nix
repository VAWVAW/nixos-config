{ config, pkgs, lib, ... }:
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

    programs.firejail.wrappedBinaries = {
      signal-desktop = {
        executable = "${pkgs.signal-desktop}/bin/signal-desktop";
        profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
      };
    };
  };
}
