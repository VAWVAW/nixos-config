{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gnome3.adwaita-icon-theme
    ];
    file.".icons/default".source = "${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita";
  };
}
