{ pkgs, ... }:
{
  imports = [
    ./spotify.nix
    ./audio.nix
    ./font.nix
    ./firefox.nix
    ./theme.nix
    ./gtk.nix
  ];

  xdg.mimeApps.enable = true;
}
