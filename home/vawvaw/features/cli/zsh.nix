{ pkgs, config, lib, ... }: {
  options.programs.zsh = {
    promptColor = lib.mkOption {
      type = lib.types.str;
      default = "blue";
      description = lib.mdDoc "The color to display in the default zsh promt";
    };
    startTmux = lib.mkEnableOption "tmux";
  };

  config.programs.zsh = let inherit (config.programs.zsh) promptColor;
  in {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    initExtra = ''
      ${lib.optionalString config.programs.zsh.startTmux ''
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

      # enable vcs integration
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' formats '%F{14}%b%%b%F{green}]-[%B%F{magenta}%r%f/%S'
      zstyle ':vcs_info:git:*' formats '%F{magenta}%r%f/%S'
      zstyle ':vcs_info:*' actionformats '%F{14}%b%%b%F{green}]-[%B%F{red}%a%%b%F{green}]-[%B%F{magenta}%r%f/%S'
      zstyle ':vcs_info:git:*' actionformats '%F{red}%a%%b%F{green}]-[%B%F{magenta}%r%f/%S'
      zstyle ':vcs_info:*' nvcsformats "%~"

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

        vcs_info
      }

      # print git branch/rev using prompt formatting
      git-branch ()
      {
        {
          git symbolic-ref -q HEAD
        } &> /dev/null

        # 0: normal
        # 1: detached HEAD
        # other: no git repo
        STATUS=$?

        if [ $STATUS -eq 0 ]; then
          BRANCH="%F{14}$(git branch --show-current)"
        elif [ $STATUS -eq 1 ]; then
          BRANCH="%F{red}$(git rev-parse --short HEAD)"
        else
          return
        fi

        echo "%F{green}(%B$BRANCH%b%F{green})-%f"
      }

      VI_MODE="blue"
      prompt_symbol=" "
      PROMPT=$'%F{green}┌──(%B%F{${promptColor}}%n%F{cyan}$prompt_symbol%F{${promptColor}}%m%b%F{green})-$(git-branch)%F{green}[%B%f''${vcs_info_msg_0_}%b%F{green}]\n└─%B%F{$VI_MODE}$%b%f '

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
