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
      disks_filter = "exclude=/swap /var/lib/containers /var/lib/systemd/timers /var/lib/libvirt /etc/NetworkManager/system-connections /var/lib/NetworkManager/seen-bssids /etc/nixos /var/log /nix/store /nix /persist /local_persist";
      use_fstab = false;
      net_upload = 5;
      net_auto = false;
    };
  };
}
