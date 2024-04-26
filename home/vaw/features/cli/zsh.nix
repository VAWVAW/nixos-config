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


      # start shell in vi mode
      bindkey -v
    '';
  };
}
