{ pkgs, ... }: {
  # yubikey as gpg smartcard
  services.pcscd.enable = true;

  # fix pcscd
  environment.systemPackages = with pkgs; [ pcscliteWithPolkit.out ];
}
