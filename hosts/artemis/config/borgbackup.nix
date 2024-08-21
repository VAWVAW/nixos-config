{ config, pkgs, ... }: {
  sops.secrets."artemis-nyx-borg" = {
    owner = "borg";
    format = "binary";
    sopsFile = ../../../secrets/artemis-nyx-borg;
  };


  services.borgbackup.jobs."local" = {
    repo = "/backup/borgbackup";
    encryption.mode = "none";
    backupSnapshot = true;
  };

  services.borgbackup.jobs."remote-nyx" = {
    repo = "borg@home.vaw-valentin.de:.";
    encryption.mode = "none";
    backupSnapshot = true;
    environment."BORG_RSH" = "${pkgs.openssh}/bin/ssh -oBatchMode=yes -i ${
        config.sops.secrets."artemis-nyx-borg".path
      }";
  };

}
