# System configuration for my main desktop PC
{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/apparmor.nix
    ../common/optional/encrypted-root-yubikey.nix
    ../common/optional/networkmanager.nix
    ../common/optional/libvirt.nix
    ../common/optional/podman.nix

    ../common/optional/desktop

    ../common/global
    ../common/users/vawvaw
  ];

  networking = {
    hostName = "vaw-pc";
    hosts = {
      "192.168.2.101" = [ "vaw-pi" ];
    };
    networkmanager.insertNameservers = [
#      "192.168.2.101"
    ];
  };

  environment.systemPackages = with pkgs; [
    nvtop
  ];

  programs.firejail.enable = true;

  system.stateVersion = "22.11";

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" ];
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
    nvidia.modesetting.enable = true;
    nvidia.powerManagement.enable = true;
    enableRedistributableFirmware = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9949-B164";
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
  boot.kernelParams = [ "resume_offset=6328854" ];
  boot.resumeDevice = config.fileSystems."/swap".device;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
