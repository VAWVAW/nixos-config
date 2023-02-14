{ pkgs, ... }:
{
  imports = [
    ./pipewire.nix
    ./fonts.nix
    ./xdg.nix
  ];

  # gnome pinentry support
  services.dbus.packages = [ pkgs.gcr ];
}
