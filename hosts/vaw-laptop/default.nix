# System configuration for my main desktop PC
{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-pc-laptop-hdd

    ../common/optional/apparmor.nix
    ../common/optional/encrypted-root-yubikey.nix
    ../common/optional/networkmanager.nix

    ../common/optional/desktop

    ../common/global
    ../common/users/vawvaw
  ];

  networking = {
    hostName = "vaw-laptop";
  };

  environment.systemPackages = with pkgs; [
  ];

  programs.firejail.enable = true;

  services.upower.enable = true;

  system.stateVersion = "22.11";

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        splashImage = null;
      };
    };
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
    enableRedistributableFirmware = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2AA8-BDEA";
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
  boot.kernelParams = [ "resume_offset=533760" ];
  boot.resumeDevice = config.fileSystems."/swap".device;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
