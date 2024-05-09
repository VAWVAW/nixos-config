# System configuration for my main desktop PC
{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd

    ../common/optional/apparmor.nix
    ../common/optional/android.nix
    ../common/optional/systemd-initrd.nix
    ../common/optional/libvirt.nix
    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix

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

  environment.systemPackages = with pkgs; [ nvtopPackages.full ];

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
    binfmt.emulatedSystems = [ "aarch64-linux" ];
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

  nix.settings.secret-key-files =
    [ "/persist/var/lib/binary-cache/cache-key.pem" ];

  boot.kernelParams = [ "resume_offset=6328854" ];
  boot.resumeDevice = config.fileSystems."/swap".device;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
