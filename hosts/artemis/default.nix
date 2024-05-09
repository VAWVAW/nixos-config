{ inputs, config, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/sslh.nix
    ../common/optional/systemd-initrd.nix
    ../common/optional/borgbackup.nix

    ../common/optional/containers

    ../common/global
    ../common/users/vaw

    ./config
  ];

  networking.hostName = "artemis";

  boot = {
    kernelParams =
      [ "ip=152.53.18.121::152.53.16.1:255.255.252.0::enp3s0:off" ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
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
