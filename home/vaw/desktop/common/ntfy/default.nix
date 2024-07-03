{ pkgs, config, ... }:
let
  settingsFormat = pkgs.formats.yaml { };

  command = pkgs.writeShellScript "ntfy-command" ''
    case "$NTFY_PRIORITY" in
      1|2)
        URGENCY=low
        ;;
      0|3)
        URGENCY=normal
        ;;
      4|5)
        URGENCY=critical
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
    subscribe = [ { topic = "nina"; } { topic = "desktop"; } ];
  };

  script = pkgs.writeShellScript "ntfy-script" ''
    ${pkgs.ntfy-sh}/bin/ntfy sub --token "$(${pkgs.coreutils}/bin/cat ${
      config.sops.secrets."ntfy-token".path
    })" --from-config --config ${configuration}
  '';
in {
  sops.secrets."ntfy-token" = { };
  systemd.user.services."ntfy" = {
    Unit = {
      Description = "ntfy desktop notifications";
      After = [ "network-online.target" "sops-nix.service" ];
    };
    Service = {
      ExecStart = "${script}";
      Restart = "on-failure";
      RestartSec = 15;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
