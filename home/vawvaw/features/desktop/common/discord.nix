{ pkgs, ... }:
{
  programs.firejail.wrappedBinaries = {
    discord = {
      executable = "${pkgs.discord.override { nss = pkgs.nss_latest; }}/bin/discord --use-gl=desktop";
      profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      extraArgs = [
        "--dbus-user.talk=org.freedesktop.Notifications"
      ];
    };
  };

  home.persistence."/local_persist/home/vawvaw" = {
    directories = [
      ".config/discord"
    ];
  };
}
