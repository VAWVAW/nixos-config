{ lib, ... }: {
  options.sops = lib.mkOption { type = lib.types.anything; };
  config.sops.secrets.vawvaw-password.path = null;
}
