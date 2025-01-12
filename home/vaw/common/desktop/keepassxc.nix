{ config, pkgs, lib, ... }:
let cfg = config.programs.keepassxc;
in {
  options.programs.keepassxc.enable = lib.mkEnableOption "keepassxc";

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/vaw".directories = [
      {
        directory = ".config/keepassxc";
        method = "symlink";
      }
      {
        directory = ".cache/keepassxc";
        method = "symlink";
      }
    ] ++ lib.optionals config.programs.firefox.enable [{
      directory = ".mozilla/native-messaging-hosts";
      method = "bindfs";
    }];

    home.packages = [ pkgs.keepassxc ];
  };
}
