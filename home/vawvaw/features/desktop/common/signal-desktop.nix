{ pkgs, ... }:
{
  programs.firejail.wrappedBinaries = {
    signal-desktop = {
      executable = "${pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
      profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
    };
  };

  home.persistence."/local_persist/home/vawvaw" = {
    directories = [
      ".config/Signal"
    ];
  };
}