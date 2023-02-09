{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    initExtra = ''
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
      zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'# enable completion features
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

        # Print a new line before the prompt, but only if it is not the first line
        if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
          if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
          else
            print ""
          fi
        fi
      }

      VI_MODE="%(#.red.blue)"
      prompt_symbol=⏣
      [ "$EUID" -eq 0 ] && prompt_symbol=🕱
      PROMPT=$'%F{%(#.blue.green)}┌──(%B%F{%(#.red.blue)}%n%F{%(#.white.blue)}$prompt_symbol%(#. .)%F{%(#.red.blue)}%m%b%F{%(#.blue.green)})-[%B%F{reset}%~%b%F{%(#.blue.green)}]\n└─%B%F{$VI_MODE}%(#.#.$)%b%F{reset} '
      RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

      # start shell in vi mode
      bindkey -v

      # change prompt depending on vi mode
      function set-prompt () {
          case ''${KEYMAP} in
            (vicmd)      VI_MODE="yellow" ;;
            (main|viins) VI_MODE="%(#.red.blue)" ;;
            (*)          VI_MODE="%(#.red.blue)" ;;
          esac
          PS1=$'%F{%(#.blue.green)}┌──(%B%F{%(#.red.blue)}%n%F{%(#.white.blue)}$prompt_symbol%(#. .)%F{%(#.red.blue)}%m%b%F{%(#.blue.green)})-[%B%F{reset}%~%b%F{%(#.blue.green)}]\n└─%B%F{$VI_MODE}%(#.#.$)%b%F{reset} '
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
