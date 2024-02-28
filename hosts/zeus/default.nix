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

    ../common/optional/containers

    ../common/optional/desktop

    ../common/global
    ../common/users/vawvaw

    ./config
  ];

  networking.hostName = "zeus";

  programs.firejail.enable = true;

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

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      systemd = {
        services."print-info" = {
          wantedBy = [ "initrd.target" ];
          requires = [ "systemd-vconsole-setup.service" ];
          after = [ "systemd-vconsole-setup.service" ];
          before = [ "systemd-ask-password-console.service" ];

          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";

          script = ''
            echo "" > /dev/tty1
            echo '###########################################################' > /dev/tty1
            echo "" > /dev/tty1
            echo 'This laptop belongs to Valentin <valentin@vaw-valentin.de>.' > /dev/tty1
            echo "" > /dev/tty1
            echo '###########################################################' > /dev/tty1
            echo "" > /dev/tty1
          '';
        };
      };
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
