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
    ];

    home.packages = [ pkgs.keepassxc ];
  };
}
