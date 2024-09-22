{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.framework-13th-gen-intel
    ../common
    ../common/users/vaw

    ./config
  ];

  networking = {
    hostName = "zeus";
    networkmanager.enable = true;
  };

  desktop.enable = true;

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
    initrd.systemd.services."print-info".enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = false;
        editor = false;
        configurationLimit = 30;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware.graphics.enable32Bit = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;

  nix.settings.secret-key-files =
    [ "/persist/var/lib/binary-cache/cache-key.pem" ];

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
