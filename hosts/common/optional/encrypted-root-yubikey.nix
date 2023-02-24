{ config, ... }:
let hostname = config.networking.hostName;
in {
  boot.initrd = {
    luks.yubikeySupport = true;
    luks.devices = {
      system_partition = {
        yubikey = {
          slot = 2;
          twoFactor = true;
          storage = {
            device = config.fileSystems."/boot".device;
          };
        };
      };
    };
  };
}
