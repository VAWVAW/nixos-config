{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.desktop.enable {
    xdg = {
      portal = {
        enable = true;
        config.common.default = [ "gtk" "*" ];
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        xdgOpenUsePortal = true;
      };
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

      desktopEntries = {
        "alacritty-file" = {
          type = "Application";
          name = "Alacritty file";
          noDisplay = true;
          exec = "${pkgs.alacritty}/bin/alacritty --working-directory %f";
          terminal = false;
          mimeType = [ "inode/directory" ];
        };
        "alacritty-nvim" = {
          type = "Application";
          name = "Alacritty Nvim";
          icon = "neovim";
          noDisplay = true;
          exec =
            "${pkgs.alacritty}/bin/alacritty --command ${pkgs.neovim}/bin/nvim %f";
          terminal = false;
          mimeType = [
            "text/plain"
            "text/english"
            "text/markdown"
            "text/rust"
            "text/x-makefile"
            "text/x-c++hdr"
            "text/x-c++src"
            "text/x-chdr"
            "text/x-csrc"
            "text/x-java"
            "text/x-scala"
            "text/x-moc"
            "text/x-pascal"
            "text/x-tcl"
            "text/x-tex"
            "text/x-c"
            "text/x-c++"
            "text/x-python"
            "application/x-shellscript"
            "application/toml"
          ];
        };
      };
    };
  };
}
