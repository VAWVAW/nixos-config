{ pkgs, ... }: {
  home.persistence."/persist/home/vawvaw" = {
    directories = [{
      directory = ".config/Signal";
      method = "symlink";
    }];
  };

  programs.firejail.wrappedBinaries = {
    signal-desktop = {
      executable =
        "${pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
      profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
    };
  };

}
