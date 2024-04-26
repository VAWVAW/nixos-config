{ pkgs, config, lib, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.groups.vaw = { gid = lib.mkDefault 1000; };
  users.users.vaw = {
    isNormalUser = true;
    uid = lib.mkDefault 1000;
    shell = pkgs.zsh;
    group = "vaw";
    extraGroups = [ "wheel" "video" "audio" ] ++ ifTheyExist [
      "adbusers"
      "network"
      "wireshark"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "networkmanager"
    ];
    openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBmVYcMguXo1kj8gePdF4+NW5NkvamLB0TfmkHy6CVa iPad"
      ];
      keyFiles = [ ./home/pubkey_ssh.txt ];
    };

    hashedPasswordFile = config.sops.secrets.vaw-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.vaw-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.vaw = import ./home/${config.networking.hostName}.nix;
}
