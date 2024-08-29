{ config, pkgs, lib, ... }: {
  xdg.portal = lib.mkIf config.xdg.portal.enable {
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

    config.common.default = "*";
  };
}
