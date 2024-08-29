{ config, pkgs, lib, ... }:
let
  settingsFormat = pkgs.formats.yaml { };

  command = pkgs.writeShellScript "ntfy-command" ''
    if [ "$NTFY_TOPIC" = "push-update" ]; then
      case "$NTFY_MESSAGE" in
        email-*)
          box=$(echo "$NTFY_MESSAGE" | ${pkgs.gnused}/bin/sed 's/^[^-]*-[^-]*-//')
          ${pkgs.isync}/bin/mbsync "$box"
          ${pkgs.notmuch}/bin/notmuch new --no-hooks
          ${config.programs.notmuch.hooks.postNew}
          echo "finished email update"
          exit 0
          ;;
      esac
      echo unknown message: $NTFY_MESSAGE
      exit 1
    fi

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

    ${pkgs.libnotify}/bin/notify-send --app-name=ntfy --urgency="$URGENCY" "$EMOJIS$EMOJI_SEPERATOR''${NTFY_TITLE:-$NTFY_TOPIC}" "$NTFY_MESSAGE"
  '';

  configuration = settingsFormat.generate "ntfy-config.yaml" {
    default-host = "https://ntfy.nlih.de";
    default-command = "${pkgs.bash}/bin/bash ${command}";
    subscribe =
      [ { topic = "nina"; } { topic = "desktop"; } { topic = "push-update"; } ];
  };

  script = pkgs.writeShellScript "ntfy-script" ''
    ${pkgs.ntfy-sh}/bin/ntfy sub --token "$(${pkgs.coreutils}/bin/cat ${
      config.sops.secrets."ntfy-token".path
    })" --from-config --config ${configuration}
  '';
in {
  options.services.ntfy.enable = lib.mkEnableOption "ntfy daemon";

  config = lib.mkIf config.services.ntfy.enable {
    sops.secrets."ntfy-token" = { };
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
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
