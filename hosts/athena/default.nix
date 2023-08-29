{ inputs, config, lib, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-pc-hdd

    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/sslh.nix

    ../common/optional/containers
    ../common/optional/containers/pihole

    ../common/global
    ../common/users/vawvaw

    ./config
  ];

  networking = {
    hostName = "athena";

    resolvconf.enable = true;
    nameservers = [ "192.168.2.11" "192.168.2.1" ];

    interfaces."enp0s31f6" = {
      wakeOnLan.enable = true;
      ipv4 = {
        addresses = [{
          address = "192.168.2.11";
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
      [ "ip=192.168.2.11::192.168.2.1:255.255.255.0::enp0s31f6:off" ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"

        # network driver
        "e1000e"
      ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 443;
          hostKeys = [ /persist/etc/ssh/ssh_initrd_host_ed25519_key ];
          authorizedKeys = [
            (lib.readFile ../common/users/vawvaw/home/pubkey_ssh.txt)
          ];
        };
      };
      luks.devices = {
        "data_partition" = {
          device = "/dev/disk/by-label/data_crypt";
          fallbackToPassword = true;
          allowDiscards = true;
        };
        "backup_partition" = {
          device = "/dev/disk/by-label/backup_crypt";
          fallbackToPassword = true;
          allowDiscards = true;
        };
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 40;
      };
    };
  };
  fileSystems = {

    "/backed_up" = {
      device = "/dev/disk/by-label/data_partition";
      fsType = "btrfs";
      options =
        [ "subvol=${config.networking.hostName}/backed_up" "compress=zstd" ];
      neededForBoot = true;
    };
    "/backup" = {
      device = "/dev/disk/by-label/backup_partition";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
