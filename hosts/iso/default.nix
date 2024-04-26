{ inputs, outputs, config, lib, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.home-manager.nixosModules.home-manager

    ../common/global/cli.nix
    ../common/global/locale.nix
    ../common/global/nix.nix
    ../common/global/yubikey.nix

    ../common/users/vaw

    ./dummy-sops.nix
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      platform = config.nixpkgs.hostPlatform.system;
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = lib.mkForce false;
    hostName = lib.mkForce "nixos-iso";
  };

  users.users.vaw = {
    initialHashedPassword = "";
    passwordFile = lib.mkForce null;
  };

  services.getty.autologinUser = lib.mkForce "vaw";

  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  programs = {
    command-not-found.enable = true;

    ssh = {
      knownHosts = {
        "github.com" = {
          publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };
      };
    };
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
