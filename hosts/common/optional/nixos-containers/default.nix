{ lib, ... }: {
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = lib.mkDefault {};

    enableIPv6 = true;
  };
}
