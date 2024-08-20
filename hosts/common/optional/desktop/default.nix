{ pkgs, ... }: {
  imports = [ ./bluetooth.nix ./pipewire.nix ./fonts.nix ./xdg.nix ];

  programs.dconf.enable = true;
  # gnome pinentry support
  services.dbus.packages = [ pkgs.gcr ];

  security.pam.services.swaylock = { };

  programs.firejail.enable = true;
}
