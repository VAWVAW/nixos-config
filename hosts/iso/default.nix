{ inputs, lib, ... }: {
  imports = [
    (inputs.nixpkgs
      + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix")

    ../common/global
    ../common/optional/desktop
    ../common/users/vaw

    ./config.nix
  ];

  disabledModules = [
    "${inputs.self}/hosts/common/global/boot-partition.nix"
    "${inputs.self}/hosts/common/global/btrfs-optin-persistence.nix"
    "${inputs.self}/hosts/common/global/encrypted-root.nix"
    "${inputs.self}/hosts/common/global/sops.nix"
    "${inputs.self}/hosts/common/global/system-mail.nix"
  ];

  # dummy sops config for user
  options.sops = lib.mkOption { type = lib.types.anything; };
  config.sops.secrets.vaw-password.path = null;

  config = {
    # fix openssh.nix
    services.openssh = {
      hostKeys = lib.mkForce [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings.PermitRootLogin = lib.mkForce "yes";
    };

    security.pam.services.sshd.rules.session."ssh-notify" = {
      enable = lib.mkForce false;
      args = lib.mkForce [ ];
    };

    # fix installer defaults
    services.xserver.enable = lib.mkForce false;
    hardware.pulseaudio.enable = lib.mkForce false;
    boot.plymouth.enable = lib.mkForce false;
  };
}
