{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./alacritty.nix
    #./cinny.nix
    ./discord.nix
    ./font.nix
    ./firefox.nix
    ./keepassxc.nix
    ./mattermost.nix
    ./signal-desktop.nix
    ./spotify.nix
    ./theme.nix
    ./tor-browser.nix
    ./xdg.nix
    ./xkb.nix

    ../../cli/mail.nix
    ../../cli/iamb.nix
  ];

  home.packages = with pkgs; [ yubioath-flutter libreoffice dfeet qpdfview ];

  home.persistence."/persist/home/vawvaw".directories = [
    {
      directory = "Pictures";
      method = "symlink";
    }
    {
      directory = "Games";
      method = "symlink";
    }
  ];
}
