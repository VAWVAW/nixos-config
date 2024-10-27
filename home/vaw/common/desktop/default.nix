{ inputs, config, pkgs, lib, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.sops-nix.homeManagerModule

    ./ntfy
    ./waybar

    ./account_programs.nix
    ./accounts.nix
    ./alacritty.nix
    ./bemenu.nix
    ./desktop.nix
    ./direnv.nix
    ./discord.nix
    ./dunst.nix
    ./firefox.nix
    ./font.nix
    ./foot.nix
    ./gpg.nix
    ./hypridle.nix
    ./hyprland.nix
    ./keepassxc.nix
    ./lutris.nix
    ./mattermost.nix
    ./minecraft.nix
    ./obsidian.nix
    ./signal-desktop.nix
    ./spotify.nix
    ./statnot.nix
    ./steam.nix
    ./sway.nix
    ./swaybar.nix
    ./swayidle.nix
    ./syncthing.nix
    ./theme.nix
    ./xdg.nix
    ./xkb.nix
  ];

  options.desktop.enable = lib.mkEnableOption "desktop programs";

  config = lib.mkIf config.desktop.enable {
    sops = {
      age.keyFile = "/persist/home/vaw/.config/key.txt";
      defaultSopsFile = "${inputs.self}/secrets/desktop.yaml";
    };

    home.persistence."/persist/home/vaw" = {
      allowOther = true;
      directories = [
        {
          directory = "Pictures";
          method = "symlink";
        }
        {
          directory = "Games";
          method = "symlink";
        }
        {
          directory = "Documents";
          method = "symlink";
        }
        {
          directory = "Downloads";
          method = "symlink";
        }
        {
          directory = ".cargo";
          method = "symlink";
        }
        {
          directory = ".rustup";
          method = "symlink";
        }
      ];
    };

    home.sessionVariables."EDITOR" = "nvim";
    home.packages = with pkgs; [
      wireplumber
      noisetorch
      pavucontrol
      qpwgraph

      yazi
      wl-clipboard
      nix-tree
      jq
      units
      yubioath-flutter
      libreoffice
      d-spy
      mate.atril
      feh
      mpv
      sops
      freesweep
      libnotify
      wlr-randr
      brightnessctl
    ];

    fonts.fontconfig.enable = lib.mkDefault true;

    programs = {
      alacritty.enable = lib.mkDefault true;
      foot.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;
      discord.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
      gpg.enable = lib.mkDefault true;
      keepassxc.enable = lib.mkDefault true;
      khal.enable = lib.mkDefault true;
      khard.enable = lib.mkDefault true;
      neomutt.enable = lib.mkDefault true;
      obsidian.enable = lib.mkDefault true;
      signal-desktop.enable = lib.mkDefault true;
      spotifython-cli.enable = lib.mkDefault true;

      firejail.wrappedBinaries."tor-browser" = {
        executable =
          lib.mkDefault "${pkgs.tor-browser-bundle-bin}/bin/tor-browser";
        profile =
          lib.mkDefault "${pkgs.firejail}/etc/firejail/tor-browser.profile";
      };
    };

    services = {
      dunst.enable = lib.mkDefault true;
      statnot.enable = lib.mkDefault true;
      ntfy.enable = lib.mkDefault true;
      spotifyd.enable = lib.mkDefault true;
      syncthing.enable = lib.mkDefault true;
    };
  };
}
