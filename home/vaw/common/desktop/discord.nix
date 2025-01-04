{ outputs, config, pkgs, lib, ... }:
let cfg = config.programs.discord;
in {
  options.programs.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/vaw".directories = [{
      directory = ".config/discord";
      method = "bindfs";
    }];

    xdg.configFile."discord/settings.json".text =
      ''{ "SKIP_HOST_UPDATE": true }'';

    home.packages = [
      (outputs.lib.wrapFirejailBinary {
        inherit pkgs lib;
        name = "discord";
        wrappedExecutable =
          "${pkgs.discord.override { nss = pkgs.nss_latest; }}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        extraArgs = [ "--dbus-user.talk=org.freedesktop.Notifications" ];
      })
    ];
  };
}
