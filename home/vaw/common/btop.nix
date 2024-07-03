{ pkgs, outputs, ... }: {
  programs.btop = let
    persisted_paths = builtins.concatMap (config:
      builtins.concatMap (dir:
        builtins.concatLists [
          (map (d: d.directory) dir.directories)
          (map (f: f.file) dir.files)
        ]) (builtins.attrValues config.config.environment.persistence or { }))
      (builtins.attrValues outputs.nixosConfigurations);
    extra_excluded = [
      "/nix"
      "/nix/store"
      "/persist"
      "/backed_up/var/lib/syncthing/.config/syncthing"
    ];
  in {
    enable = true;
    settings = {
      color_theme = "${pkgs.btop}/share/btop/themes/adapta.theme";
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
      update_ms = 1000;
      proc_sorting = "memory";
      proc_per_core = true;
      cpu_single_graph = true;
      disks_filter = "exclude="
        + (builtins.concatStringsSep " " (persisted_paths ++ extra_excluded));
      use_fstab = false;
      net_upload = 5;
      net_auto = false;
    };
  };
}
