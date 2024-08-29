# System configuration for my main desktop PC
{ pkgs, pkgs-unstable, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/apparmor.nix
    ../common/optional/android.nix
    ../common/optional/libvirt.nix

    ../common/optional/containers

    ../common/optional/desktop

    ../common/global
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

  boot = {
    kernelPackages = pkgs-unstable.linuxPackages;

    kernelParams = [ "resume_offset=6328854" ];
    resumeDevice = config.fileSystems."/swap".device;

    kernelModules = [ "kvm-amd" ];

    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" ];

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 1;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        splashImage = null;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware.steam-hardware.enable = true;
  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = with pkgs; [ libvdpau-va-gl ];
  };

  nix.settings.secret-key-files =
    [ "/persist/var/lib/binary-cache/cache-key.pem" ];

  system.stateVersion = "22.11";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
