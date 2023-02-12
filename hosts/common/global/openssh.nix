{ outputs, lib, config, ... }:

let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in
{
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
    };
    # Allow forwarding ports to everywhere
    gatewayPorts = "clientspecified";

    hostKeys = [{
      path = "/local_persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts = {
      alarmpi = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhnvZIaBL3UrEyoHHkGTbCCtqWaZtf7eGhs4QYSHGDd";
        extraHostNames = [ "home.vaw-valentin.de" ];
      };
      "vaw-valentin.de" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVjDeeECOjKK1H9x+R+ZS4pYx6CGJXGmmHNS83JEXUJ";
      };
    } // builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = lib.optional (name == hostname) "localhost";
      })
      hosts;
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
