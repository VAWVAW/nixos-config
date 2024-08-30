{ config, pkgs, lib, ... }:
let
  inherit ((builtins.head
    (import ../../../home/vaw/common/desktop/accounts.nix {
      inherit pkgs lib;
      config = { programs.mbsync.enable = true; };
    }).config.contents).content.accounts.email)
    accounts;

  accountNames = builtins.attrNames accounts;

  onNewMail = name:
    pkgs.writeShellScript "imapnotify-onNewMail-${name}" ''
      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/token)" --tags incoming_envelope https://ntfy.nlih.de/desktop "New E-Mail on ${name}"

      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/token)" https://ntfy.nlih.de/push-update "email-new-${name}"'';

  onDeletedMail = name:
    pkgs.writeShellScript "imapnotify-onDeletedMail-${name}" ''
      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/token)" https://ntfy.nlih.de/push-update "email-delete-${name}"'';

  genConfig = name:
    let account = accounts."${name}";
    in {
      alias = name;

      inherit (account.imap) host port;
      tls = account.imap.tls.enable;

      username = account.userName;
      passwordCmd = "${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/${name}";

      boxes = [{ mailbox = account.folders.inbox; }];

      onNewMail = builtins.toString (onNewMail name);
      onDeletedMail = builtins.toString (onDeletedMail name);
    };

  configuration = (pkgs.formats.yaml { }).generate "goimapnotify-config.yaml" {
    configurations = map genConfig accountNames;
  };
in {
  sops.secrets = builtins.listToAttrs (map (name: {
    name = "mail/${name}";
    value = { sopsFile = ../../../secrets/mail.yaml; };
  }) accountNames) // {
    "update-notify-token".sopsFile = ../../../secrets/artemis.yaml;
  };

  systemd.services."imapnotify" = {
    serviceConfig = {
      Type = "exec";
      ExecStart =
        "${pkgs.goimapnotify-patched}/bin/goimapnotify -conf ${configuration}";

      Restart = "always";
      RestartSec = 30;

      DynamicUser = true;
      LoadCredential =
        (map (name: "${name}:${config.sops.secrets."mail/${name}".path}")
          accountNames)
        ++ [ "token:${config.sops.secrets."update-notify-token".path}" ];
    };
    unitConfig = {
      Description = "imapnotify notification";
      After = "network-online.target";
    };
    wantedBy = [ "multi-user.target" ];
    onFailure = [ "unit-status-notification@%n.service" ];
  };
}
