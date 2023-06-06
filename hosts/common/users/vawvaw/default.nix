{ pkgs, config, lib, outputs, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.groups.vawvaw = { gid = lib.mkDefault 1000; };
  users.users.vawvaw = {
    isNormalUser = true;
    uid = lib.mkDefault 1000;
    shell = pkgs.zsh;
    group = "vawvaw";
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

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfE4SmPSqUtzlIwhHIamwYVkinxYNYFZ9QPD+3/FJRpZSHHOBtKkLo3iZsHNttH75/zLaZV/ARS69FPJ3IMd+i2WTk0ZcDxOFeT71Aser+OJphyruruB6/VxCRq2eWezRI2Z1KnCh5vxpc4mNXEkFStuS/AebKB2oNG18WZJcUnamELA7WzxUBkT1aQKEhRIiIKyaEOEoF7u0RB1/0rhnOx7g+Zisj95507zhLHsHzPqJXjqYRMa3+u2k72nRUc5QTjLbc0aqKjfrjAF/24IAOjlCPs/yQWPfe6LGoRK5K7LHQnuI4+wnBCL4pyicnsMB433mNxyYYfhrX7B1A5HcMqewLYXUIb1dcmOzZK2jZVHZs831Wh+0s2hWtZYcjFDgmVne3sGK8/mYKPbgKw+9li7An05OatMSWbXsAqWawIap5JWrYlMXLRwfx764JxWaZadhlKTWvhRU2jnkMHG5MQUKt7MIMdj87fVN4rWZ6PD1MLe6VDdsEiSt/v7uwy9fFJOKJV2kdRKKZCYbUeF//aaUG89cF6sSgZTht/RL9y8W9+cqm8GoXnd/9fPfx1xsCPF2bwKVvneW4UMspHrRIHTgxqpDunsQMZ7A2C5DJW+iXnAduLw6xx6v0Qu88MCCaeThudqqYVSoWF4b27rOTJ0btw0Nwf/5wodrPghgvHQ== (none)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBmVYcMguXo1kj8gePdF4+NW5NkvamLB0TfmkHy6CVa iPad"
    ];

    passwordFile = config.sops.secrets.vawvaw-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.vawvaw-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.vawvaw = import ./home/${config.networking.hostName}.nix;
}
