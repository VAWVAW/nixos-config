{ config, pkgs, lib, ... }: {
  home.packages = lib.mkIf config.fonts.fontconfig.enable
    (with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) ]);
}
