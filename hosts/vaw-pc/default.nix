# System configuration for my main desktop PC
{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/encrypted-root.nix
    ../common/optional/yubikey.nix

    ../common/optional/desktop

    ../common/global
    ../common/users/vawvaw
  ];

  networking.hostName = "vaw-pc";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  system.stateVersion = "22.11";

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ "dm-snapshot" ];
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

  #swapDevices = [{
  #  device = "/swap/swapfile";
  #  size = 8196;
  #}];

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
