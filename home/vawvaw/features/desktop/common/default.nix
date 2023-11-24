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

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications."application/pdf" = "qpdfview.desktop";
      associations.removed."application/pdf" = "draw.desktop";
    };
    userDirs = {
      enable = true;
      createDirectories = true;

      music = null;
      publicShare = null;
      templates = null;
      videos = null;
    };
  };
}
