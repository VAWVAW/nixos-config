{ inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-pc-hdd

    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/sslh.nix

    ../common/global
    ../common/users/vawvaw
  ];

  networking = {
    hostName = "athena";
    nameservers = [ "192.168.2.1" ];
    interfaces."enp0s31f6" = {
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
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfE4SmPSqUtzlIwhHIamwYVkinxYNYFZ9QPD+3/FJRpZSHHOBtKkLo3iZsHNttH75/zLaZV/ARS69FPJ3IMd+i2WTk0ZcDxOFeT71Aser+OJphyruruB6/VxCRq2eWezRI2Z1KnCh5vxpc4mNXEkFStuS/AebKB2oNG18WZJcUnamELA7WzxUBkT1aQKEhRIiIKyaEOEoF7u0RB1/0rhnOx7g+Zisj95507zhLHsHzPqJXjqYRMa3+u2k72nRUc5QTjLbc0aqKjfrjAF/24IAOjlCPs/yQWPfe6LGoRK5K7LHQnuI4+wnBCL4pyicnsMB433mNxyYYfhrX7B1A5HcMqewLYXUIb1dcmOzZK2jZVHZs831Wh+0s2hWtZYcjFDgmVne3sGK8/mYKPbgKw+9li7An05OatMSWbXsAqWawIap5JWrYlMXLRwfx764JxWaZadhlKTWvhRU2jnkMHG5MQUKt7MIMdj87fVN4rWZ6PD1MLe6VDdsEiSt/v7uwy9fFJOKJV2kdRKKZCYbUeF//aaUG89cF6sSgZTht/RL9y8W9+cqm8GoXnd/9fPfx1xsCPF2bwKVvneW4UMspHrRIHTgxqpDunsQMZ7A2C5DJW+iXnAduLw6xx6v0Qu88MCCaeThudqqYVSoWF4b27rOTJ0btw0Nwf/5wodrPghgvHQ== (none)"
          ];
        };
      };
      luks.devices."data_partition" = {
        device = "/dev/disk/by-label/data_crypt";
        fallbackToPassword = true;
        allowDiscards = true;
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

  fileSystems."/backed_up" = {
    device = "/dev/disk/by-label/data_partition";
    fsType = "btrfs";
    options =
      [ "subvol=${config.networking.hostName}/backed_up" "compress=zstd" ];
    neededForBoot = true;
  };

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
