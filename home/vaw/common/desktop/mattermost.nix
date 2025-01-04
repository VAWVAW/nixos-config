{ outputs, config, pkgs, lib, ... }: {
  options.programs.mattermost-desktop.enable =
    lib.mkEnableOption "mattermost-desktop";

  config = lib.mkIf config.programs.mattermost-desktop.enable {
    home.persistence."/persist/home/vaw".directories = [{
      directory = ".config/Mattermost";
      method = "symlink";
    }];

    home.packages = [
      (outputs.lib.wrapFirejailBinary {
        inherit pkgs lib;
        name = "mattermost-desktop";
        wrappedExecutable =
          "${pkgs.mattermost-desktop}/bin/mattermost-desktop --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
        profile = "${pkgs.firejail}/etc/firejail/mattermost-desktop.profile";
        extraArgs = [ "--dbus-user.talk=org.freedesktop.Notifications" ];
      })
    ];
  };
}
