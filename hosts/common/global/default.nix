# This file (and the global directory) holds config that I use on all hosts
{ pkgs, lib, inputs, outputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./backup.nix
    ./btrfs-optin-persistence.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./sops.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  environment.shells = [ pkgs.bash pkgs.zsh ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  networking = {
    networkmanager.enable = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;
  };

  programs = {
    zsh.enable = true;
    fuse.userAllowOther = true;
    git.enable = true;
    vim.defaultEditor = true;
  };
  hardware.enableRedistributableFirmware = true;

  users.mutableUsers = false;

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
