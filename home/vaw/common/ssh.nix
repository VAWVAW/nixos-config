{ lib, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "artemis" = {
        host = "artemis server.vaw-valentin.de";
        hostname = "server.vaw-valentin.de";
      };
      "fu-login" = {
        host = "andorra.imp.fu-berlin.de sanmarino.imp.fu-berlin.de";
        user = "vw7335fu";
      };
      "fu" = lib.hm.dag.entryAfter [ "fu-login" ] {
        host =
          "*.imp.fu-berlin.de !andorra.imp.fu-berlin.de !sanmarino.imp.fu-berlin.de !git.imp.fu-berlin.de";
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
