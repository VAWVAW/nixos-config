{ inputs, config, lib, ... }:
let
  dir = inputs.nixpkgs + "/nixos/modules/programs/foot";
  alacritty = config.programs.alacritty.settings;
in {
  config = lib.mkMerge [
    (lib.mkIf config.programs.foot.enable {
      programs = {
        fish.interactiveShellInit =
          "source ${dir}/config.fish # enable shell integration for foot terminal";
        bash.initExtra =
          ". ${dir}/bashrc # enable shell integration for foot terminal";
        zsh.initExtra = ''
          # enable shell integration for foot terminal
          function osc7-pwd() {
              emulate -L zsh # also sets localoptions for us
              setopt extendedglob
              local LC_ALL=C
              printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
          }

          function chpwd-osc7-pwd() {
              (( ZSH_SUBSHELL )) || osc7-pwd
          }
          add-zsh-hook -Uz chpwd chpwd-osc7-pwd

          function precmd-osc-133-A() {
              print -Pn "\e]133;A\e\\"
          }
          add-zsh-hook -Uz precmd precmd-osc-133-A

          function precmd-osc-133-D() {
              if ! builtin zle; then
                  print -n "\e]133;D\e\\"
              fi
          }
          add-zsh-hook -Uz precmd precmd-osc-133-D

          function preexec-osc-133-C() {
              print -n "\e]133;C\e\\"
          }
          add-zsh-hook -Uz preexec preexec-osc-133-C
        '';
      };
    })
    {
      programs.foot.settings = {
        main.font = "monospace:size=10";
        mouse.hide-when-typing = true;

        colors = let
          inherit (alacritty.colors) primary normal bright;
          c = builtins.substring 1 7;
        in {
          foreground = c primary.foreground;
          background = c primary.background;

          regular0 = c normal.black;
          regular1 = c normal.red;
          regular2 = c normal.green;
          regular3 = c normal.yellow;
          regular4 = c normal.blue;
          regular5 = c normal.magenta;
          regular6 = c normal.cyan;
          regular7 = c normal.white;

          bright0 = c bright.black;
          bright1 = c bright.red;
          bright2 = c bright.green;
          bright3 = c bright.yellow;
          bright4 = c bright.blue;
          bright5 = c bright.magenta;
          bright6 = c bright.cyan;
          bright7 = c bright.white;
        };

        key-bindings = {
          unicode-input = "none";
          scrollback-up-half-page = "Control+Shift+u";
          scrollback-down-half-page = "Control+Shift+d";
          spawn-terminal = "Control+Shift+Return";
          prompt-prev = "Control+Shift+y";
          prompt-next = "Control+Shift+x";
          primary-paste = "Control+Shift+p";
        };
      };
    }
  ];
}
