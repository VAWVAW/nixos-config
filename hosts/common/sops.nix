{ inputs, config, ... }:
let
  key = builtins.elemAt
    (builtins.filter (k: k.type == "ed25519") config.services.openssh.hostKeys)
    0;
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.sshKeyPaths = [ key.path ];
    secrets."ntfy-desktop" = {
      sopsFile = "${inputs.self}/secrets/system.yaml";
      mode = "0400";
    };
  };
}
