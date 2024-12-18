{ config, pkgs, lib, ... }:
let
  settingsFormat = pkgs.formats.yaml { };

  command = pkgs.writeShellScript "ntfy-command" ''
    case "$NTFY_TOPIC" in
      mail)
        box=$(echo "$NTFY_MESSAGE" | ${pkgs.gnused}/bin/sed 's/^New E-Mail on //')
        ${pkgs.isync}/bin/mbsync "$box"
        ${pkgs.notmuch}/bin/notmuch new --no-hooks
        ${config.programs.notmuch.hooks.postNew}
        export NTFY_MESSAGE=$(echo "$NTFY_MESSAGE" | ${pkgs.gnused}/bin/sed -E 's/^New E-Mail on [0-9]+_/New E-Mail on /')
      ;;
    esac

    case "$NTFY_PRIORITY" in
      1|2)
        URGENCY=low
        ;;
      4|5)
        URGENCY=critical
        ;;
      *)
        URGENCY=normal
        ;;
    esac

    EMOJIS=""
    EMOJI_SEPERATOR=""

    IFS=,
    for TAG in $NTFY_TAGS
    do
      EMOJIS=$EMOJIS$(${pkgs.jq}/bin/jq -j ".\"$TAG\"" < ${./emoji.json})
      EMOJI_SEPERATOR=" "
    done

    ${pkgs.libnotify}/bin/notify-send --app-name=ntfy --urgency="$URGENCY" --icon="$ICON" "$EMOJIS$EMOJI_SEPERATOR''${NTFY_TITLE:-$NTFY_TOPIC}" "$NTFY_MESSAGE"
  '';

  molly-command = pkgs.writeShellScript "ntfy-molly" ''
    ${pkgs.libnotify}/bin/notify-send --app-name=molly-ntfy --icon=${pkgs.signal-desktop}/share/icons/hicolor/64x64/apps/signal-desktop.png "You may have a new message"
  '';

  configuration = settingsFormat.generate "ntfy-config.yaml" {
    default-host = "https://ntfy.nlih.de";
    default-command = "${pkgs.bash}/bin/bash ${command}";
    subscribe = [ { topic = "desktop"; } { topic = "mail"; } ];
  };

  script = pkgs.writeShellScript "ntfy-script" ''
    PATH=/bin ${pkgs.ntfy-sh}/bin/ntfy sub --token "$(${pkgs.coreutils}/bin/cat ${
      config.sops.secrets."ntfy-token".path
    })" --from-config --config ${configuration} "$(${pkgs.coreutils}/bin/cat ${
      config.sops.secrets."molly-up".path
    })" "${molly-command}"
  '';
in {
  options.services.ntfy.enable = lib.mkEnableOption "ntfy daemon";

  config = lib.mkIf config.services.ntfy.enable {
    sops.secrets = {
      "ntfy-token" = { };
      "molly-up" = { };
    };

    systemd.user.services."ntfy" = {
      Unit = {
        Description = "ntfy desktop notifications";
        After = [ "sops-nix.service" ];
      };
      Service = {
        ExecStart = "${script}";
        Restart = "on-failure";
        RestartSec = 15;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
