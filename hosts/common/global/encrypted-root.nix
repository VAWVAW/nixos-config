{
  boot.initrd = {
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
    luks.devices = {
      system_partition = {
        device = "/dev/disk/by-label/system_crypt";
        fallbackToPassword = true;
        allowDiscards = true;
      };
    };
  };
}
