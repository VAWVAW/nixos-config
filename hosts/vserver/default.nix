{ pkgs, inputs, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../common/optional/networkmanager.nix

    ../common/global
    ../common/users/vawvaw
  ];

  networking = {
    hostName = "vserver";
  };

  system.stateVersion = "22.11";

  boot = {
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
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
      systemd-boot = {
        enable = true;
        configurationLimit = 25;
      };
    };
  };


  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A23D-7237";
    fsType = "vfat";
    options = [ "ro" ];
  };

  fileSystems."/swap" = 
  let
    hostname = config.networking.hostName;
  in {
    device = "/dev/disk/by-label/system_partition";
    fsType = "btrfs";
    options = [ "subvol=${hostname}/swap" "noatime" "compress=zstd" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
  }];

  nixpkgs.hostPlatform.system = "x86_64-linux";
}