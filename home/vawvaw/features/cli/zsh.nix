{ pkgs, config, lib, ... }: {
  options.programs.zsh.promptColor = lib.mkOption {
    type = lib.types.str;
    default = "blue";
    description = lib.mdDoc "The color to display in the default zsh promt";
  };

  config.programs.zsh = let promptColor = config.programs.zsh.promptColor;
  in {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    initExtra = ''
      ${lib.optionalString config.programs.tmux.enable ''
        # start tmux
                if [ -z "$TMUX" ]; then
                  exec ${pkgs.tmux}/bin/tmux attach
                fi
      ''}

      setopt promptsubst

      # enable completion features
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

      # If this is an xterm set the title to user@host:dir
      case "$TERM" in
      xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
        TERM_TITLE=$'\e]0;''${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
        ;;
      *)
        ;;
      esac

      precmd() {
        # Print the previously configured title
        print -Pnr -- "$TERM_TITLE"
      }

      VI_MODE="blue"
      prompt_symbol=" "
      PROMPT=$'%F{green}┌──(%B%F{${promptColor}}%n%F{cyan}$prompt_symbol%F{${promptColor}}%m%b%F{green})-[%B%F{reset}%~%b%F{green}]\n└─%B%F{$VI_MODE}$%b%F{reset} '

      # start shell in vi mode
      bindkey -v

      # change prompt depending on vi mode
      function set-prompt () {
          case ''${KEYMAP} in
            (vicmd)      VI_MODE="yellow" ;;
            (main|viins) VI_MODE="blue" ;;
            (*)          VI_MODE="blue" ;;
          esac
          PS1=$PROMPT
      }

      function zle-line-init zle-keymap-select {
          set-prompt
          zle reset-prompt
      }

      zle -N zle-line-init
      zle -N zle-keymap-select
    '';
  };
}
