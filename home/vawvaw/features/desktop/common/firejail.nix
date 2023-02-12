{ pkgs, ... }:
{
  programs.firejail.wrappedBinaries = {
    keepassxc = {
      executable = "${pkgs.keepassxc}/bin/keepassxc";
      profile = "${pkgs.firejail}/etc/firejail/keepassxc.profile";
      extraArgs = [
        # U2F USB stick
        "--ignore=private-dev"
        "--ignore=nou2f"
        "--protocol=netlink,unix"
      ];
    };
    discord = {
      executable = "${pkgs.discord.override { nss = pkgs.nss_latest; }}/bin/discord --use-gl=desktop";
      profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      extraArgs = [
        "--dbus-user.talk=org.freedesktop.Notifications"
      ];
    };
    signal-desktop = {
      executable = "${pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
      profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
    };
    tor-browser = {
      executable = "${pkgs.tor-browser-bundle-bin}/bin/tor-browser";
      profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
    };
  };
}
