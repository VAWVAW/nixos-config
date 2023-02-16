{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./discord.nix
    ./font.nix
    ./firefox.nix
    ./keepassxc.nix
    ./signal-desktop.nix
    ./spotify.nix
    ./theme.nix
    ./tor-browser.nix
  ];

  home.packages = with pkgs; [
    yubioath-flutter
  ];

  xdg.mimeApps.enable = true;
}
