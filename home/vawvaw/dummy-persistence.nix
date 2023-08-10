{ lib, ... }: {
  options.home.persistence = lib.mkOption { type = lib.types.anything; };
}
