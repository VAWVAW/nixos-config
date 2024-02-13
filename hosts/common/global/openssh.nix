{ outputs, lib, config, ... }:

let
  hosts = removeAttrs outputs.nixosConfigurations [ "iso" ];
  hostname = config.networking.hostName;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [{
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    knownHosts = let cfg = config.programs.ssh.knownHosts;
    in lib.mkMerge [
      {
        "vaw-valentin.de" = {
          publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVjDeeECOjKK1H9x+R+ZS4pYx6CGJXGmmHNS83JEXUJ";
        };
        "github.com" = {
          publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };

        # FU berlin
        "andorra" = {
          publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgTtze6DGyz7hVaergSU1BCZeJqbd31vhFGpHqVUTo8";
          hostNames = [ "andorra.imp.fu-berlin.de" "telnet.imp.fu-berlin.de" ];
        };
        "gitlab-fu" = {
          publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8fk9/xUeUqdjchrVrHvLRiPOvqRLI7B0FnsmnaoUlE";
          hostNames = [ "git.imp.fu-berlin.de" ];
        };

        "athena".extraHostNames = [ "home.vaw-valentin.de" ];
        "athena-initrd" = {
          inherit (cfg."athena") hostNames;
          publicKeyFile = ../../athena/ssh_initrd_host_ed25519_key.pub;
        };

        "hades-initrd" = {
          inherit (cfg."hades") hostNames;
          publicKeyFile = ../../hades/ssh_initrd_host_ed25519_key.pub;
        };
      }
      (builtins.mapAttrs (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = lib.optional (name == hostname) "localhost";
      }) hosts)
    ];
  };
}
