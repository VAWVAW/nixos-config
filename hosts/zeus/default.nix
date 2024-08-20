{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.framework-13th-gen-intel

    ../common/optional/apparmor.nix
    ../common/optional/networkmanager.nix
    ../common/optional/secureboot.nix
    ../common/optional/libvirt.nix

    ../common/optional/containers

    ../common/optional/desktop

    ../common/global
    ../common/users/vaw

    ./config
  ];

  networking.hostName = "zeus";

  services = {
    upower.enable = true;
    logind.lidSwitch = "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  powerManagement.cpuFreqGovernor = "powersave";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = config.fileSystems."/swap".device;

    kernelModules = [ "kvm-intel" ];

    initrd.availableKernelModules =
      [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 30;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  nix.settings.secret-key-files =
    [ "/persist/var/lib/binary-cache/cache-key.pem" ];

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
