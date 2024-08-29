{ config, ... }: {
  imports = [
    ../common
    ../common/users/vaw

    ./config
  ];

  networking = {
    hostName = "nyx";
    hosts = {
      "192.168.2.10" = [ "hades" ];
      "192.168.2.11" = [ "athena" ];
    };
  };

  boot = {
    blacklistedKernelModules = [ "onboard_usb_hub" ];

    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "lan78xx" # network driver
    ];
    initrd.systemd.network.enable = true;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
      };
    };
  };

  fileSystems = {
    "/backed_up" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options =
        [ "subvol=${config.networking.hostName}/backed_up" "compress=zstd" ];
      neededForBoot = true;
    };
    "/backup" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options =
        [ "subvol=${config.networking.hostName}/backup" "compress=zstd" ];
      neededForBoot = true;
    };
  };

  services.syncthing-container.enable = true;
  services.borgbackup.repos."system".authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDW8KqMDzTeIuvDoPa/8JnQMpIkN/7W/w3k5CInO8u/4 artemis-nyx-borg"
  ];

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
