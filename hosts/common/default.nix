# This file (and the global directory) holds config that I use on all hosts
{ inputs, outputs, lib, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.impermanence.nixosModules.impermanence

    ./acme.nix
    ./boot-partition.nix
    ./borgbackup.nix
    ./btrfs-optin-persistence.nix
    ./cli.nix
    ./desktop.nix
    ./encrypted-root.nix
    ./home-manager.nix
    ./initrd.nix
    ./libvirt.nix
    ./locale.nix
    ./mailcap.nix
    ./networkmanager.nix
    ./nginx.nix
    ./nix.nix
    ./openssh.nix
    ./pipewire.nix
    ./podman.nix
    ./secureboot.nix
    ./sops.nix
    ./syncthing.nix
    ./system-mail.nix
    ./unit-fail-notification.nix
    ./yubikey.nix
    ./zram.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  # keep a copy of the system configuration
  environment.etc."nixos-current".source = ../..;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  networking.firewall.enable = lib.mkDefault true;

  hardware.enableRedistributableFirmware = true;

  users.mutableUsers = false;

  system.activationScripts = {
    generateMnt = ''
      [ ! -d /mnt ] && [[ ! "NIXOS_ACTION" == "dry-activate" ]] && mkdir /mnt'';
  };

  security = {
    polkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults lecture = never
      '';
    };

    # Passwordless sudo when SSH'ing with keys
    pam.sshAgentAuth = {
      enable = true;
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    };
  };
}
