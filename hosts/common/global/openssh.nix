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

        "athena".extraHostNames = [ "home.vaw-valentin.de" ];
        "athena-initrd" = {
          inherit (cfg."athena") hostNames;
          publicKeyFile = ../../athena/ssh_initrd_host_ed25519_key.pub;
        };

        "artemis".extraHostNames = [ "server.vaw-valentin.de" ];
        "artemis-initrd" = {
          inherit (cfg."artemis") hostNames;
          publicKeyFile = ../../artemis/ssh_initrd_host_ed25519_key.pub;
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
    knownHostsFiles = [ ./ssh_hosts_fu-berlin ];
  };
}
