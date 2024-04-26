{ lib, ... }: {
  options.sops = lib.mkOption { type = lib.types.anything; };
  config.sops.secrets.vaw-password.path = null;
}
