{ pkgs, lib, config, ... }:
let
  fetchKey = { url, sha256 ? lib.fakeSha256 }:
    builtins.fetchurl { inherit sha256 url; };

  pinentry = if config.gtk.enable then {
    package = pkgs.pinentry-qt;
    name = "qt";
  } else {
    package = pkgs.pinentry-curses;
    name = "curses";
  };
in {
  home.packages = [ pinentry.package ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8" ];
    pinentryFlavor = pinentry.name;
    enableExtraSocket = true;
  };

  programs = let
    fixGpg = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      gpgconf --launch gpg-agent
    '';
  in {
    bash.profileExtra = fixGpg;
    fish.loginShellInit = fixGpg;
    zsh.loginExtra = fixGpg;

    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.local/share/gnupg";
      publicKeys = [{
        source = fetchKey {
          url =
            "https://vaw-valentin.de/508F0546A3908E3FE6732B8F9BEFF32F6EF32DA8.asc";
          sha256 =
            "sha256:f10490c9d06f8ba4333cc53d62bc4bf3af48c116938b293b4cb0e6f2de8b55d2";
        };
        trust = "ultimate";
      }];
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list =
          "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
      scdaemonSettings = { disable-ccid = true; };
    };
  };

  home.persistence."/local_persist/home/vawvaw" = {
    directories = [ ".local/share/gnupg" ];
  };
}
