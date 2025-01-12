{ outputs, config, pkgs, lib, ... }:
let cfg = config.programs.discord;
in {
  options.programs.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/vaw".directories = [{
      directory = ".config/discord";
      method = "bindfs";
    }];

    xdg = {
      configFile = {
        "discord/settings.json".text = ''{ "SKIP_HOST_UPDATE": true }'';
        "firejail/discord.local".text = "ignore join-or-start";
      };
      desktopEntries."discord" = {
        type = "Application";
        name = "Discord";
        categories = [ "Network" "InstantMessaging" ];
        exec = "discord --url -- %u";
        mimeType = [ "x-scheme-handler/discord" ];
        icon = "discord";
      };
    };

    home.packages = let
      discord = (outputs.lib.wrapFirejailBinary {
        inherit pkgs lib;
        name = "discord";
        wrappedExecutable =
          "${pkgs.discord.override { nss = pkgs.nss_latest; }}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        extraArgs = [
          "--dbus-user.talk=org.freedesktop.Notifications"
          "--ignore=private-tmp"
        ];
      });
    in [
      (pkgs.writeShellScriptBin "discord" ''
        NIXOS_OZONE_WL= ${pkgs.expect}/bin/unbuffer ${discord}/bin/discord "$@"
      '')
    ];
  };
}
