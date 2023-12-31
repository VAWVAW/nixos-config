# This file (and the global directory) holds config that I use on all hosts
{ lib, inputs, outputs, config, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./acme.nix
    ./btrfs-optin-persistence.nix
    ./cli.nix
    ./encrypted-root.nix
    ./locale.nix
    ./mailcap.nix
    ./nix.nix
    ./openssh.nix
    ./sops.nix
    ./system-mail.nix
    ./yubikey.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      platform = config.nixpkgs.hostPlatform.system;
    };
  };

  # keep a copy of the system configuration
  environment.etc."nixos-current".source = ./../../..;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };

  networking = { firewall.enable = lib.mkDefault true; };

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
  };
}
