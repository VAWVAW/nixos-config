{ lib, config, ... }: {
  boot.initrd = let hasSystemd = config.boot.initrd.systemd.enable;
  in {
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
    luks.devices = {
      "system_partition" = {
        device = "/dev/disk/by-label/system_crypt";
        fallbackToPassword = lib.mkDefault (!hasSystemd);
        allowDiscards = true;

        crypttabExtraOpts = lib.mkIf hasSystemd [ "password-echo=no" ];
      };
    };
  };
}
