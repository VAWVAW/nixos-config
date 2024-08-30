{ pkgs, config, lib, ... }: {
  options.programs.zsh = {
    promptColor = lib.mkOption {
      type = lib.types.str;
      default = "blue";
      description = lib.mdDoc "The color to display in the default zsh promt";
    };
    startTmux = lib.mkEnableOption "tmux";
  };

  config.programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit -d ~/.cache/zcompdump
      zstyle ':completion:*:*:*:*:*' menu select
      zstyle ':completion:*' auto-description 'specify: %d'
      zstyle ':completion:*' completer _expand _complete
      zstyle ':completion:*' format 'Completing %d'
      zstyle ':completion:*' group-name ''''''
      zstyle ':completion:*' list-colors ''''''
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' use-compctl false
      zstyle ':completion:*' verbose true
      zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
    '';
    initExtra = ''
      ${lib.optionalString config.programs.zsh.startTmux ''
        # start tmux
        if [ -z "$TMUX" ]; then
          exec ${pkgs.tmux}/bin/tmux attach
        fi
      ''}

      # start shell in vi mode
      bindkey -v

      ${lib.optionalString config.desktop.enable ''
        # notification on command completion
        # based on zbell plugin
        if [[ -o interactive ]] && zmodload zsh/datetime && autoload -Uz add-zsh-hook && autoload -Uz regexp-replace; then
          znotify_timestamp=$EPOCHSECONDS
          znotify_ignore=($EDITOR $PAGER ssh nix nix-shell)

          # $1: command
          # $2: duration in seconds
          znotify_notify() {
            ${pkgs.libnotify}/bin/notify-send --app-name=znotify "Command completed in ''${2}s:" $1
          }

          # $1: command
          znotify_begin() {
            znotify_timestamp=$EPOCHSECONDS
            znotify_lastcmd=$1
          }

          znotify_end() {
            local cmd_duration=$(( $EPOCHSECONDS - $znotify_timestamp ))
            local ran_long=$(( $cmd_duration >= 10 ))

            local lastcmd_tmp="$znotify_lastcmd"
            regexp-replace lastcmd_tmp '^sudo ' ""

            [[ $znotify_last_timestamp == $znotify_timestamp ]] && return

            [[ $lastcmd_tmp == "" ]] && return

            znotify_last_timestamp=$znotify_timestamp

            local has_ignored_cmd=0
            for cmd in ''${(s:;:)lastcmd_tmp//|/;}; do
              words=(''${(z)cmd})
              util=''${words[1]}
              if (( ''${znotify_ignore[(i)$util]} <= ''${#znotify_ignore} )); then
                has_ignored_cmd=1
                break
              fi
            done

            (( ! $has_ignored_cmd && ran_long)) && znotify_notify $znotify_lastcmd $cmd_duration
          }

          add-zsh-hook preexec znotify_begin
          add-zsh-hook precmd znotify_end
        fi
      ''}
    '';
  };
}
