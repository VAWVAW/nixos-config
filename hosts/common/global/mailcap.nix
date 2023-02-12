{ pkgs, ... }:
{
  environment.etc.mailcap.text = ''
    application/*; ${pkgs.xdg-utils}/bin/xdg-open %s
    audio/*; ${pkgs.xdg-utils}/bin/xdg-open %s
    image/*; ${pkgs.xdg-utils}/bin/xdg-open %s
    text/html; ${pkgs.xdg-utils}/bin/xdg-open %s
  '';
}
