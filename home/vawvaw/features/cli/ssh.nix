{ outputs, ... }:
let hostnames = builtins.attrNames outputs.nixosConfigurations;
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "net" = {
        host = (builtins.concatStringsSep " " hostnames)
          + " home.vaw-valentin.de";
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
      "fu-login" = {
        host = "andorra.imp.fu-berlin.de sanmarino.imp.fu-berlin.de";
        user = "vw7335fu";
      };
      "fu" = {
        host = "compute*";
        hostname = "%h.imp.fu-berlin.de";
        user = "vw7335fu";
        proxyJump = "sanmarino.imp.fu-berlin.de";
      };
      "fob" = {
        host = "fob fob.spline.de";
        hostname = "fob.spline.de";
        user = "vawvaw";
        extraOptions."PubKeyAcceptedKeyTypes" = "+ssh-rsa";
      };

      "serenity" = {
        user = "sysvw02";
        hostname = "160.45.110.40";
        proxyJump = "sanmarino.imp.fu-berlin.de";
        setEnv."TERM" = "xterm";
        extraOptions = {
          "HostKeyAlgorithms" = "+ssh-rsa";
          "PubKeyAcceptedKeyTypes" = "+ssh-rsa";
          "KexAlgorithms" = "+diffie-hellman-group-exchange-sha1";
        };
      };
      "ldom02" = {
        host = "ldom02";
        hostname = "10.10.40.102";
        user = "sysvw02";
        proxyJump = "serenity";
        setEnv."TERM" = "xterm";
      };
    };
  };
}
