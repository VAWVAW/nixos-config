{ lib, config, ... }: {
  imports = [
    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/systemd-initrd.nix
    ../common/optional/borgbackup.nix

    ../common/optional/nixos-containers

    ../common/global
    ../common/users/vaw

    ./config
  ];

  networking = {
    hostName = "nyx";
    hosts = {
      "192.168.2.10" = [ "hades" ];
      "192.168.2.11" = [ "athena" ];
    };

    resolvconf.enable = true;
    nameservers = [ "127.0.0.1" ];

    nat.externalInterface = "enu1u1u1";
    interfaces."enu1u1u1" = {
      ipv4 = {
        addresses = [{
          address = "192.168.2.20";
          prefixLength = 24;
        }];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "192.168.2.1";
          }
          {
            address = "192.168.2.0";
            prefixLength = 24;
          }
        ];
      };
    };
  };

  boot = {
    kernelParams =
      [ "ip=192.168.2.20::192.168.2.1:255.255.255.0::enp0s31f6:off" ];
    blacklistedKernelModules = [ "onboard_usb_hub" ];
    initrd = {
      availableKernelModules = [
        "usbhid"
        "usb_storage"

        # network driver
        "lan78xx"
      ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 443;
          hostKeys = [ /persist/etc/ssh/ssh_initrd_host_ed25519_key ];
          authorizedKeys =
            [ (lib.readFile ../common/users/vaw/home/pubkey_ssh.txt) ];
        };
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = true;
        configurationLimit = 40;
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

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
