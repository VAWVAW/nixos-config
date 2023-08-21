{ pkgs, ... }: {
  programs.btop = {
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
      disks_filter = builtins.replaceStrings [ "\n" ] [ " " ] ''
        exclude=
        /backed_up
        /etc/NetworkManager/system-connections
        /nix
        /nix/store
        /persist
        /persist/var/lib/containers/storage/overlay
        /swap
        /var/lib/containers
        /var/lib/containers/storage/overlay
        /var/lib/libvirt
        /var/lib/NetworkManager/seen-bssids
        /var/lib/syncthing/config
        /var/lib/systemd/timers
        /var/log
      '';
      use_fstab = false;
      net_upload = 5;
      net_auto = false;
    };
  };
}
