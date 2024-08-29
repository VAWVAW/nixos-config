{ config, ... }: {
  services.borgbackup = {
    repos."local" = { };

    jobs."local" = {
      repo = config.services.borgbackup.repos."local.path";
      encryption.mode = "none";
      backupSnapshot = true;
    };
  };
}
