{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./discord.nix
    ./font.nix
    ./firefox.nix
    ./jetbrains.nix
    ./keepassxc.nix
    ./signal-desktop.nix
    ./spotify.nix
    ./theme.nix
    ./tor-browser.nix
  ];

  home.packages = with pkgs; [
    yubioath-flutter
  ];

  home.persistence = {
    "/persist/home/vawvaw" = {
      directories = [
        "Pictures"
      ];
    };
    "/local_persist/home/vawvaw" = {
      directories = [
        "Games"
        "Maildir"
      ];
    };
  };

  xdg.mimeApps.enable = true;
}
