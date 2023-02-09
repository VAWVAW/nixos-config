{ config, ... }:
let hostname = config.networking.hostName;
in {
  boot.initrd = {
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
    luks.yubikeySupport = true;
    luks.devices = {
      system_partition = {
        device = "/dev/disk/by-label/system_crypt";
        yubikey = {
          slot = 2;
          twoFactor = true;
          storage = {
            device = config.fileSystems."/boot".device;
          };
        };
        fallbackToPassword = true;
      };
    };
  };
}
