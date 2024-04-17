# This file (and the global directory) holds config that I use on all hosts
{ lib, outputs, ... }: {
  imports = [
    ./acme.nix
    ./btrfs-optin-persistence.nix
    ./cli.nix
    ./encrypted-root.nix
    ./home-manager.nix
    ./locale.nix
    ./mailcap.nix
    ./nix.nix
    ./openssh.nix
    ./sops.nix
    ./system-mail.nix
    ./yubikey.nix
    ./zram.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  # keep a copy of the system configuration
  environment.etc."nixos-current".source = ./../../..;

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
