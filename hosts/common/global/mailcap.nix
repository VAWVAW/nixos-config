{ pkgs, ... }:
{
  environment.etc.mailcap.text = ''
    application/*; ${pkgs.xdg-utils}/bin/xdg-open %s
    audio/*; ${pkgs.xdg-utils}/bin/xdg-open %s
    image/*; ${pkgs.xdg-utils}/bin/xdg-open %s
    text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
  '';
}
