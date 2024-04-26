{ outputs, lib, ... }:
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
              "/run/user/1000/gnupg/d.dhpt8e5jayx45iqmq73jefpp/S.gpg-agent";
            host.address =
              "/run/user/1000/gnupg/d.dhpt8e5jayx45iqmq73jefpp/S.gpg-agent.extra";
          }
          {
            bind.address =
              "/run/user/1000/gnupg/d.dhpt8e5jayx45iqmq73jefpp/S.gpg-agent.ssh";
            host.address =
              "/run/user/1000/gnupg/d.dhpt8e5jayx45iqmq73jefpp/S.gpg-agent.ssh";
          }
        ];
      };
      "artemis" = {
        host = "artemis server.vaw-valentin.de";
        hostname = "server.vaw-valentin.de";
      };
      "fu-login" = {
        host = "andorra.imp.fu-berlin.de sanmarino.imp.fu-berlin.de";
        user = "vw7335fu";
      };
      "fu" = lib.hm.dag.entryAfter [ "fu-login" ] {
        host = "*.imp.fu-berlin.de";
        user = "vw7335fu";
        proxyJump = "sanmarino.imp.fu-berlin.de";
      };
      "fu-compute" = {
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
    };
  };
}
