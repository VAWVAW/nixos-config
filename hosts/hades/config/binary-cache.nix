{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/persist/var/lib/binary-cache/cache-key.pem";
    openFirewall = true;
  };
}
