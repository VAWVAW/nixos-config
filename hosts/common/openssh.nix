{ outputs, pkgs, lib, config, ... }:

let
  hosts = removeAttrs outputs.nixosConfigurations [ "iso" ];
  hostname = config.networking.hostName;
  pubKey = host: ../${host}/ssh_host_ed25519_key.pub;
in {
  users.users.root.openssh.authorizedKeys.keyFiles =
    [ ../../home/vaw/pubkey_ssh.txt ];
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      # Harden
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
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

  security.pam.services.sshd.rules.session."ssh-notify" = let
    script = pkgs.writeShellScript "ssh-notify" ''
      if [ "$PAM_TYPE" != "open_session" ]; then
        exit 0
      fi

      if [ "$PAM_USER" == "borg" ]; then
        exit 0
      fi

      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat ${
        config.sops.secrets."ntfy-desktop".path
      })" --tags "desktop_computer" --title "SSH Login ''${PAM_USER}@${config.networking.hostName}" https://ntfy.nlih.de/desktop "$PAM_USER logged in from ''${PAM_RHOST}"
    '';
  in {
    enable = true;
    control = "optional";
    modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
    args = [ "seteuid" "${script}" ];
    order = 15000;
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

        "nyx".extraHostNames = [ "home.vaw-valentin.de" ];
        "nyx-initrd" = {
          inherit (cfg."nyx") hostNames;
          publicKeyFile = ../nyx/ssh_initrd_host_ed25519_key.pub;
        };

        "athena-initrd" = {
          inherit (cfg."athena") hostNames;
          publicKeyFile = ../athena/ssh_initrd_host_ed25519_key.pub;
        };

        "artemis".extraHostNames = [ "server.vaw-valentin.de" "nlih.de" ];
        "artemis-initrd" = {
          inherit (cfg."artemis") hostNames;
          publicKeyFile = ../artemis/ssh_initrd_host_ed25519_key.pub;
        };

        "hades-initrd" = {
          inherit (cfg."hades") hostNames;
          publicKeyFile = ../hades/ssh_initrd_host_ed25519_key.pub;
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
