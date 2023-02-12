{ pkgs, ... }:
{
  imports = [
    ./spotify.nix
    ./audio.nix
    ./font.nix
    ./firejail.nix
    ./firefox.nix
    ./theme.nix
    ./gtk.nix
  ];

  xdg.mimeApps.enable = true;
}
