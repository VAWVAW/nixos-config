{ config, lib, ... }: {
  systemd.services."nix-serve".wantedBy = lib.mkForce [ ];
  services.nix-serve = {
    enable = true;
    secretKeyFile = builtins.head config.nix.settings.secret-key-files;
    openFirewall = true;
  };
}
