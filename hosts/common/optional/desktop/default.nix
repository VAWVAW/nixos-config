{ pkgs, ... }: {
  imports = [ ./bluetooth.nix ./pipewire.nix ./fonts.nix ./xdg.nix ];

  programs.dconf.enable = true;
  # gnome pinentry support
  services.dbus.packages = [ pkgs.gcr ];

  security = {
    # enable backlight setting without password
    sudo.extraRules = [{
      groups = [ "wheel" ];
      commands = [{
        command = "${pkgs.light}/bin/light";
        options = [ "NOPASSWD" ];
      }];
    }];
    pam.services.swaylock = { };
  };
}
