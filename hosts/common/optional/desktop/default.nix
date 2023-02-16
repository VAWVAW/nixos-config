{ pkgs, ... }:
{
  imports = [
    ./pipewire.nix
    ./fonts.nix
    ./xdg.nix
  ];

  programs.dconf.enable = true;
  # gnome pinentry support
  services.dbus.packages = [ pkgs.gcr ];
}
