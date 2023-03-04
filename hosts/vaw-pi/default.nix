# System configuration for my raspberry pi 3b acting as server
{ pkgs, inputs, config, lib, ... }: {
  imports = [
    ../common/global
    ../common/users/vawvaw

    ../common/optional/containers/netcup-ddns

    ./backup-repo.nix
    ./nginx.nix
    ./sslh.nix
  ];

  networking = {
    hostName = "vaw-pi";
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
    ];
    hosts = {
      "192.168.2.100" = [ "vaw-pc" ];
    };
    interfaces.eth0 = {
      useDHCP = false;
      ipv4 = {
        addresses = [{
          address = "192.168.2.101";
          prefixLength = 24;
        }];
        routes = [{
          address = "0.0.0.0";
          prefixLength = 0;
          via = "192.168.2.1";
        }];
      };
    };
  };

  system.stateVersion = "22.11";

  boot = {
    kernelParams = [
      "console=ttyS0,115200n8"
      "console=ttyAMA0,115200n8"
      "console=tty0"
      "ip=192.168.2.101::192.168.2.1:255.255.255.0::eth0:off"
    ];
    initrd = {
      availableKernelModules = [
        "usbhid"
        "usb_storage"
        # network driver
        "lan78xx"
      ];
      kernelModules = [  ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 443;
          hostKeys = [
            /local_persist/etc/ssh/ssh_initrd_host_ed25519_key
          ];
          authorizedKeys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfE4SmPSqUtzlIwhHIamwYVkinxYNYFZ9QPD+3/FJRpZSHHOBtKkLo3iZsHNttH75/zLaZV/ARS69FPJ3IMd+i2WTk0ZcDxOFeT71Aser+OJphyruruB6/VxCRq2eWezRI2Z1KnCh5vxpc4mNXEkFStuS/AebKB2oNG18WZJcUnamELA7WzxUBkT1aQKEhRIiIKyaEOEoF7u0RB1/0rhnOx7g+Zisj95507zhLHsHzPqJXjqYRMa3+u2k72nRUc5QTjLbc0aqKjfrjAF/24IAOjlCPs/yQWPfe6LGoRK5K7LHQnuI4+wnBCL4pyicnsMB433mNxyYYfhrX7B1A5HcMqewLYXUIb1dcmOzZK2jZVHZs831Wh+0s2hWtZYcjFDgmVne3sGK8/mYKPbgKw+9li7An05OatMSWbXsAqWawIap5JWrYlMXLRwfx764JxWaZadhlKTWvhRU2jnkMHG5MQUKt7MIMdj87fVN4rWZ6PD1MLe6VDdsEiSt/v7uwy9fFJOKJV2kdRKKZCYbUeF//aaUG89cF6sSgZTht/RL9y8W9+cqm8GoXnd/9fPfx1xsCPF2bwKVvneW4UMspHrRIHTgxqpDunsQMZ7A2C5DJW+iXnAduLw6xx6v0Qu88MCCaeThudqqYVSoWF4b27rOTJ0btw0Nwf/5wodrPghgvHQ== (none)"
          ];
        };
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 3;
      };
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/mmcblk0p1";
      fsType = "vfat";
    };

    "/data" = {
      device = "/dev/mapper/data";
      fsType = "ext4";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-label/data_crypt";
        keyFile = "/mnt-root/local_persist/etc/hdd_crypt.key";
        label = "data";
      };
    };
    "/".options = lib.mkForce [ "subvol=vaw-pi/root" "compress-force=zstd:5" ];
    "/nix".options = lib.mkForce [ "subvol=vaw-pi/nix" "compress-force=zstd:5" "noatime" ];
    "/persist".options = lib.mkForce [ "subvol=vaw-pi/persist" "compress-force=zstd:5" ];
    "/local_persist" = {
      options = lib.mkForce [ "subvol=vaw-pi/local_persist" "compress-force=zstd:5" ];
      neededForBoot = true;
    };
    "/swap" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options = [ "subvol=${config.networking.hostName}/swap" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
  }];

  nixpkgs.hostPlatform = "aarch64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";
}
