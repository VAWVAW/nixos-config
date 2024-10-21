{ config, pkgs, lib, nvim, ... }: {
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
        defaultApplications."application/pdf" = "atril.desktop";
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
        "terminal-file" = {
          type = "Application";
          name = "terminal file";
          noDisplay = true;
          exec = "${config.desktop.terminal} --working-directory %f";
          terminal = false;
          mimeType = [ "inode/directory" ];
        };
        "terminal-nvim" = {
          type = "Application";
          name = "terminal Nvim";
          icon = "neovim";
          noDisplay = true;
          exec =
            "${config.desktop.terminal} --command ${nvim}/bin/nvim %f";
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
