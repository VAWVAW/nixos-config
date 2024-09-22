{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.desktop.enable {
    home.file = {
      ".icons/default".source =
        "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
