# System configuration for my main desktop PC
{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/apparmor.nix
    ../common/optional/android.nix
    ../common/optional/encrypted-root-yubikey.nix
    ../common/optional/libvirt.nix
    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix

    ../common/optional/containers
    ../common/optional/nixos-containers

    ../common/optional/desktop
    ../common/optional/desktop/hyprland.nix

    ../common/global
    ../common/users/vawvaw

    ./config
  ];

  networking = {
    hostName = "hades";
    hosts = { "192.168.2.11" = [ "athena" ]; };

    resolvconf.enable = true;
    nameservers = [ "192.168.2.11" "192.168.2.1" ];

    nat.externalInterface = "eno1";
    interfaces."eno1" = {
      wakeOnLan.enable = true;
      ipv4 = {
        addresses = [{
          address = "192.168.2.10";
          prefixLength = 24;
        }];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "192.168.2.1";
          }
          {
            address = "192.168.2.0";
            prefixLength = 24;
          }
        ];
      };
    };
    dhcpcd.enable = false;
  };

  environment.systemPackages = with pkgs; [ nvtop ];

  programs.firejail.enable = true;

  system.stateVersion = "22.11";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" ];
    };
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
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ libvdpau-va-gl ];
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia.modesetting.enable = true;
    nvidia.powerManagement.enable = true;
  };

  boot.kernelParams = [ "resume_offset=6328854" ];
  boot.resumeDevice = config.fileSystems."/swap".device;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
