{ outputs, lib, config, ... }:

let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in
{
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
      path = "/local_persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts = {
      "vaw-valentin.de" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVjDeeECOjKK1H9x+R+ZS4pYx6CGJXGmmHNS83JEXUJ";
      };
      "github.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      "vaw-pi-initrd" = {
        hostNames = [ "vaw-pi" "home.vaw-valentin.de" ];
        publicKeyFile = ../../vaw-pi/ssh_initrd_host_ed25519_key.pub;
      };
      "vserver-initrd" = {
        hostNames = [ "vserver" "server.vaw-valentin.de" ];
        publicKeyFile = ../../vserver/ssh_initrd_host_ed25519_key.pub;
      };
      # home.vaw-valentin.de is added to vaw-pi in default.nix
    } // builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = (lib.optional (name == hostname) "localhost");
      })
      hosts;
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
