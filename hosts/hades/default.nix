# System configuration for my main desktop PC
{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-ssd

    ../common
    ../common/users/vaw

    ./config
  ];

  networking = {
    hostName = "hades";
    hosts = {
      "192.168.2.11" = [ "athena" ];
      "192.168.2.20" = [ "nyx" ];
    };
  };

  desktop.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages;

    kernelParams = [ "resume_offset=6328854" ];
    resumeDevice = config.fileSystems."/swap".device;

    kernelModules = [ "kvm-amd" ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "r8169" # network driver
    ];
    initrd.systemd.network.enable = true;

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 1;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        splashImage = null;
        configurationLimit = 25;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware.steam-hardware.enable = true;
  hardware.graphics = {
    enable32Bit = true;
    extraPackages = with pkgs; [ libvdpau-va-gl ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;

  nix.settings.secret-key-files =
    [ "/persist/var/lib/binary-cache/cache-key.pem" ];

  system.stateVersion = "22.11";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
