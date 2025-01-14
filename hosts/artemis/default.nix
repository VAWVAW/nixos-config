{ inputs, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.hardware.nixosModules.common-pc-ssd

    ../common
    ../common/users/vaw

    ./config
  ];

  networking.hostName = "artemis";

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" ];
    initrd.systemd.network.enable = true;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
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

  mailserver.enable = true;
  services = {
    syncthing-container.enable = true;
    tor.relay.enable = true;
    tor.settings.ORPort = [{
      addr = "[2a0a:4cc0:1:104e::1]";
      port = 9001;
    }];
  };

  nix.settings.secret-key-files =
    [ "/persist/var/lib/binary-cache/cache-key.pem" ];

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
