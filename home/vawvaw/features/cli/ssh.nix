{ outputs, ... }:
let hostnames = builtins.attrNames outputs.nixosConfigurations;
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "net" = {
        host = (builtins.concatStringsSep " " hostnames)
          + " home.vaw-valentin.de server.vaw-valentin.de";
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address =
              "/run/user/1000/gnupg/d.db6k4od13tuchts5jdmgus9t/S.gpg-agent";
            host.address =
              "/run/user/1000/gnupg/d.db6k4od13tuchts5jdmgus9t/S.gpg-agent.extra";
          }
          {
            bind.address =
              "/run/user/1000/gnupg/d.db6k4od13tuchts5jdmgus9t/S.gpg-agent.ssh";
            host.address =
              "/run/user/1000/gnupg/d.db6k4od13tuchts5jdmgus9t/S.gpg-agent.ssh";
          }
        ];
      };
      "andorra" = {
        host = (builtins.concatStringsSep " "
          outputs.nixosConfigurations."hades".config.programs.ssh.knownHosts."andorra".hostNames)
          + " andorra";
        hostname = "andorra.imp.fu-berlin.de";
        user = "vw7335fu";

        forwardAgent = true;
      };
      "serenity" = {
        user = "sysvw02";
        hostname = "160.45.110.40";
        proxyJump = "andorra";
        setEnv."TERM" = "xterm";
        extraOptions = {
          "HostKeyAlgorithms" = "+ssh-rsa";
          "PubKeyAcceptedKeyTypes" = "+ssh-rsa";
          "KexAlgorithms" = "+diffie-hellman-group-exchange-sha1";
        };
      };
    };
  };
}
