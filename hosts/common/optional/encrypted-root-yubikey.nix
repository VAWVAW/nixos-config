{ config, ... }: {
  boot.initrd.luks = {
    yubikeySupport = true;
    reusePassphrases = false;
    devices = {
      system_partition = {
        yubikey = {
          slot = 2;
          twoFactor = true;
          storage = { inherit (config.fileSystems."/boot") device; };
        };
      };
    };
  };

}
