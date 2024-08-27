{ config, pkgs, lib, ... }:
let cfg = config.programs.discord;
in {
  options.programs.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/vaw".directories = [{
      directory = ".config/discord";
      method = "symlink";
    }];

    programs.firejail.wrappedBinaries."discord" = {
      executable =
        "${pkgs.discord.override { nss = pkgs.nss_latest; }}/bin/discord";
      profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      extraArgs = [ "--dbus-user.talk=org.freedesktop.Notifications" ];
    };
  };
}
