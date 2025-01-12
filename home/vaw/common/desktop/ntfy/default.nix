{ config, pkgs, lib, ... }:
let
  settingsFormat = pkgs.formats.yaml { };

  command = pkgs.writeShellScript "ntfy-command" ''
    export NIXOS_XDG_OPEN_USE_PORTAL="${config.home.sessionVariables.NIXOS_XDG_OPEN_USE_PORTAL}"

    notify_args=(--app-name=ntfy)

    NTFY_CLICK=$(echo "$NTFY_RAW" | ${pkgs.jq}/bin/jq -r '.click // empty')

    case "$NTFY_TOPIC" in
      mail)
        box=$(echo "$NTFY_MESSAGE" | ${pkgs.gnused}/bin/sed 's/^New E-Mail on //')
        ${pkgs.isync}/bin/mbsync "$box"
        ${pkgs.notmuch}/bin/notmuch new --no-hooks
        ${config.programs.notmuch.hooks.postNew}

        NTFY_MESSAGE=$(echo "$NTFY_MESSAGE" | ${pkgs.gnused}/bin/sed -E 's/^New E-Mail on [0-9]+_/New E-Mail on /')
      ;;
    esac

    case "$NTFY_PRIORITY" in
      1|2)
        notify_args+=(--urgency=low)
        ;;
      4|5)
        notify_args+=(--urgency=critical)
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

    if [ -n "$NTFY_CLICK" ]; then
      notify_args+=(--action=url="$NTFY_CLICK")
    fi

    output=$(${pkgs.libnotify}/bin/notify-send "''${notify_args[@]}" "$EMOJIS$EMOJI_SEPERATOR''${NTFY_TITLE:-$NTFY_TOPIC}" "$NTFY_MESSAGE")

    if [ "$output" = "url" ]; then
      ${pkgs.xdg-utils}/bin/xdg-open "$NTFY_CLICK"
    fi
  '';

  molly-command = pkgs.writeShellScript "ntfy-molly" ''
    ${pkgs.libnotify}/bin/notify-send --app-name=molly-ntfy --icon=${pkgs.signal-desktop}/share/icons/hicolor/64x64/apps/signal-desktop.png "You may have a new message"
  '';

  configuration = settingsFormat.generate "ntfy-config.yaml" {
    default-host = "https://ntfy.nlih.de";
    default-command = "${command}";
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
