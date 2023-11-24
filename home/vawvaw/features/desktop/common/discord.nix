{ pkgs, ... }: {
  home.persistence."/persist/home/vawvaw".directories = [{
    directory = ".config/discord";
    method = "symlink";
  }];

  programs.firejail.wrappedBinaries = {
    discord = {
      executable = "${
          pkgs.discord.override { nss = pkgs.nss_latest; }
        }/bin/discord --use-gl=desktop";
      profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      extraArgs = [ "--dbus-user.talk=org.freedesktop.Notifications" ];
    };
  };
}
