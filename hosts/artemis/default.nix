{ inputs, config, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/systemd-initrd.nix
    ../common/optional/borgbackup.nix

    ../common/optional/containers

    ../common/global
    ../common/users/vaw

    ./config
  ];

  networking.hostName = "artemis";

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" ];

      systemd.network = config.systemd.network;
      network = {
        enable = false;
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
        editor = false;
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
