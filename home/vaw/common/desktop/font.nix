{ config, pkgs, lib, ... }: {
  home.packages = lib.mkIf config.fonts.fontconfig.enable
    (with pkgs; [ nerd-fonts.dejavu-sans-mono ]);
}
