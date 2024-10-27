{ inputs, config, pkgs, ... }: {
  sops.secrets."artemis-nyx-borg" = {
    owner = "borg";
    format = "binary";
    sopsFile = "${inputs.self}/secrets/artemis-nyx-borg";
  };

  services.borgbackup = {
    repos."local" = { };

    jobs."local" = {
      repo = config.services.borgbackup.repos."local".path;
      encryption.mode = "none";
      backupSnapshot = true;
    };
    jobs."remote-nyx" = {
      repo = "borg@home.vaw-valentin.de:.";
      encryption.mode = "none";
      backupSnapshot = true;
      environment."BORG_RSH" = "${pkgs.openssh}/bin/ssh -oBatchMode=yes -i ${
          config.sops.secrets."artemis-nyx-borg".path
        }";
    };
  };
}
