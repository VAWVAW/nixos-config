{ pkgs, lib, ... }: {
  imports = [
    ../common

    ../desktop/common/nvim

    ../desktop/common/alacritty.nix
    ../desktop/common/audio.nix
    ../desktop/common/bemenu.nix
    ../desktop/common/desktop.nix
    ../desktop/common/direnv.nix
    ../desktop/common/dunst.nix
    ../desktop/common/firefox.nix
    ../desktop/common/font.nix
    ../desktop/common/gpg.nix
    ../desktop/common/keepassxc.nix
    ../desktop/common/theme.nix
    ../desktop/common/tor-browser.nix
    ../desktop/common/xdg.nix
    ../desktop/common/xkb.nix

    ../desktop/optional/sway.nix
    ../desktop/optional/waybar
    ../desktop/optional/swayidle.nix
  ];

  # dummy impermanence config
  options.home.persistence."/persist/home/vaw".directories = lib.mkOption {
    type = lib.types.listOf lib.types.anything;
  };

  config = {
    programs.zsh.promptColor = "green";

    home.packages = with pkgs; [ age ssh-to-age ];
  };
}
