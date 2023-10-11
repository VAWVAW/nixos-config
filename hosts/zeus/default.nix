{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.framework-13th-gen-intel

    ../common/optional/apparmor.nix
    ../common/optional/systemd-initrd.nix
    ../common/optional/networkmanager.nix
    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/secureboot.nix
    ../common/optional/libvirt.nix

    ../common/optional/desktop

    ../common/global
    ../common/users/vawvaw

    ./config
  ];

  networking.hostName = "zeus";

  programs.firejail.enable = true;

  services.upower.enable = true;

  powerManagement.cpuFreqGovernor = "powersave";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = config.fileSystems."/swap".device;

    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    };
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 40;
      };
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
