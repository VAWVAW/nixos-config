{ outputs, lib, ... }:
let hostnames = builtins.attrNames outputs.nixosConfigurations;
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      net = {
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
    };
  };
}
