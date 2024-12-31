{ inputs, config, pkgs, lib, ... }:
let
  home_config = ((builtins.head
    (import ../../../home/vaw/common/desktop/accounts.nix {
      inherit pkgs lib inputs;
      config.programs.mbsync.enable = true;
    }).config.contents).content);
  inherit (home_config.accounts.email) accounts;

  accountNames = builtins.attrNames accounts;
  removeNumber = name: builtins.head (builtins.tail (lib.splitString "_" name));

  onNewMail = name:
    pkgs.writeShellScript "imapnotify-onNewMail-${name}" ''
      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/token)" --tags incoming_envelope https://ntfy.nlih.de/mail "New E-Mail on ${name}"'';

  onDeletedMail = name:
    pkgs.writeShellScript "imapnotify-onDeletedMail-${name}" ''
      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/token)" --tags incoming_envelope https://ntfy.nlih.de/mail "New E-Mail on ${name}"'';

  genConfig = raw_name:
    let
      account = accounts."${raw_name}";
      name = removeNumber raw_name;
    in {
      alias = name;

      inherit (account.imap) host;
      port = account.imap.port or 993;
      tls = account.imap.tls.enable or true;

      username = account.userName or account.address;
      passwordCmd = "${pkgs.coreutils}/bin/cat $CREDENTIALS_DIRECTORY/${name}";

      boxes = [{ mailbox = account.folders.inbox or "Inbox"; }];

      onNewMail = builtins.toString (onNewMail raw_name);
      onDeletedMail = builtins.toString (onDeletedMail raw_name);
    };

  configuration = (pkgs.formats.yaml { }).generate "goimapnotify-config.yaml" {
    configurations = map genConfig accountNames;
  };
in {
  sops.secrets = builtins.listToAttrs (map (name: {
    inherit name;
    value = { sopsFile = "${inputs.self}/secrets/mail.yaml"; };
  }) (builtins.attrNames home_config.sops.secrets)) // {
    "imapnotify-token".sopsFile = "${inputs.self}/secrets/artemis.yaml";
  };

  systemd.services."imapnotify" = {
    serviceConfig = {
      Type = "exec";
      ExecStart =
        "${pkgs.goimapnotify}/bin/goimapnotify -conf ${configuration}";

      Restart = "always";
      RestartSec = 30;

      DynamicUser = true;
      LoadCredential = (map (raw_name:
        let name = removeNumber raw_name;
        in "${name}:${config.sops.secrets."mail/${name}".path}") accountNames)
        ++ [ "token:${config.sops.secrets."imapnotify-token".path}" ];
    };
    unitConfig = {
      Description = "imapnotify notification";
      After = "network-online.target";
    };
    wantedBy = [ "multi-user.target" ];
    onFailure = [ "unit-status-notification@%n.service" ];
  };
}
