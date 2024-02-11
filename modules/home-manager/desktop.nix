{ config, lib, ... }:
with lib; {
  options.desktop = {
    screens = mkOption {
      default = [ ];
      description = ''
        Physical screens that should be configured by
        the window manager / compositor.
      '';
      type = types.listOf (types.submodule {
        options = {
          name = mkOption { type = types.str; };
          size = mkOption {
            type = types.str;
            default = "1920x1080";
            description = "Size of the screen";
            example = literalExpression "2256x1504";
          };
          scale = mkOption {
            type = types.str;
            default = "1";
            description = ''
              Scale factor of the screen. Non-integer scales
              can be blurry on wayland.
            '';
            example = literalExpression ''"2"'';
          };
          position = mkOption {
            type = types.str;
            default = "0 0";
            description = ''
              Virtual position of the screen.
            '';
            example = literalExpression "1920 0";
          };
          workspaces = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              Workspaces to assign to this screen.
            '';
            example = literalExpression ''["9" "10"]'';
          };
        };
      });
    };

    keybinds = let
      mods = types.enum [ "super" "alt" "ctrl" "shift" ];
      keyOpts = {
        "mods" = mkOption {
          description = "Modifiers for the keybind";
          type = types.listOf mods;
          default = [ ];
        };

        "key" = mkOption { type = types.str; };
      };
      keybindOpts = keyOpts // { "command" = mkOption { type = types.str; }; };
    in {
      "binds" = mkOption {
        description = ''
          Generic keybinds.
        '';
        type = types.listOf (types.submodule { options = keybindOpts; });
        default = [ ];
      };

      "global-binds" = mkOption {
        description = ''
          Generic keybinds that work in all modes.
        '';
        type = types.listOf (types.submodule { options = keybindOpts; });
        default = [ ];
      };

      "modes" = mkOption {
        description = ''
          Generic modes/submaps that provide only the specified keybinds.
        '';
        default = { };

        type = types.attrsOf (types.submodule {
          options = {
            "enter" =
              mkOption { type = types.submodule { options = keyOpts; }; };
            "default-exit" = mkOption {
              description =
                "Generate exit commands for Escape, BackSpace and `enter`";
              type = types.bool;
              default = true;
            };
            "binds" = mkOption {
              type = types.listOf (types.submodule {
                options = keybindOpts // {
                  "exit" = mkOption {
                    description = "Exit the mode after executing the command";
                    type = types.bool;
                    default = true;
                  };
                };
              });
              default = [ ];
            };
          };
        });
      };

      "generated" = {
        "mod" = mkOption {
          description = "The mod key to use in generated keybinds.";
          type = mods;
          default = "alt";
        };
        "left" = mkOption {
          description = "The left key to use in generated keybinds";
          type = types.str;
          default = "h";
        };
        "down" = mkOption {
          description = "The down key to use in generated keybinds";
          type = types.str;
          default = "j";
        };
        "up" = mkOption {
          description = "The up key to use in generated keybinds";
          type = types.str;
          default = "k";
        };
        "right" = mkOption {
          description = "The right key to use in generated keybinds";
          type = types.str;
          default = "l";
        };
      };
    };

    startup_commands = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Commands to execute at startup of the
        window manager / compositor.
      '';
      example = literalExpression ''
        [ "''${pkgs.noisetorch}/bin/noisetorch -i" ]
      '';
    };
  };

  options.wayland.windowManager.hyprland.extraBinds = mkOption {
    description = "Additional keybindings to add to `settings.binds`.";
    type = types.listOf types.str;
    default = [ ];
  };

  config.wayland.windowManager = let cfg = config.desktop;
  in {
    sway.config = let
      generateKeybind = genExec: bind: {
        name = builtins.replaceStrings [ "super" "alt" ] [ "mod4" "mod1" ]
          (builtins.concatStringsSep "+" (bind.mods ++ [ bind.key ]));
        value = genExec bind;
      };
      generateKeybinds = genExec: binds:
        builtins.listToAttrs (map (generateKeybind genExec) binds);

    in mkIf config.wayland.windowManager.sway.enable {
      # keyboard layout
      input."type:keyboard" = {
        xkb_layout = config.home.keyboard.layout;
        xkb_variant = config.home.keyboard.variant;
        xkb_options =
          builtins.concatStringsSep "," config.home.keyboard.options;
      };

      # screens
      output = builtins.listToAttrs (builtins.map (s: {
        inherit (s) name;
        value = {
          inherit (s) position scale;
          resolution = s.size;
        };
      }) cfg.screens);
      # and workspaces
      workspaceOutputAssign = builtins.concatMap (screen:
        map (workspace: {
          inherit workspace;
          output = screen.name;
        }) screen.workspaces) cfg.screens;

      # startup commands
      startup = builtins.map (cmd: { command = cmd; }) cfg.startup_commands;

      # keybinds
      keybindings =
        # general exec binds
        (generateKeybinds (bind: "exec " + bind.command)
          (cfg.keybinds.binds ++ cfg.keybinds.global-binds)) //
        # mode enter binds
        (builtins.listToAttrs (builtins.attrValues (builtins.mapAttrs
          (name: mode: generateKeybind (_: "mode " + name) mode.enter)
          cfg.keybinds.modes)));

      # modes
      modes = builtins.mapAttrs (_: mode:
        generateKeybinds

        (bind:
          if builtins.isString bind.command then
            (lib.optionalString bind.exit "mode default; ") + "exec "
            + (toString bind.command)
          else
            "mode default")

        (mode.binds
          ++ (map (bind: bind // { exit = false; }) cfg.keybinds.global-binds)
          ++ (lib.optionals mode.default-exit [
            {
              mods = [ ];
              key = "escape";
              command = null;
            }
            {
              mods = [ ];
              key = "backspace";
              command = null;
            }
            (mode.enter // { command = null; })
          ]))

      ) cfg.keybinds.modes;
    };

    hyprland = let
      generateKeybind = dispatch: bind:
        let mods = builtins.concatStringsSep "+" bind.mods;
        in "${mods}, ${bind.key}, " + (dispatch bind);
    in mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        # keyboard layout
        input = {
          kb_layout = config.home.keyboard.layout;
          kb_variant = config.home.keyboard.variant;
          kb_options =
            builtins.concatStringsSep "," config.home.keyboard.options;
        };

        # screens
        monitor = builtins.map (s:
          "desc:${s.name}, ${builtins.replaceStrings [ " " ] [ "x" ] s.size}, ${
            builtins.replaceStrings [ " " ] [ "x" ] s.position
          }, ${s.scale}") cfg.screens;
        # and workspaces
        workspace = builtins.concatMap
          (s: map (ws: "${toString ws}, monitor:desc:${s.name}") s.workspaces)
          cfg.screens;

        # startup commands
        exec-once = cfg.startup_commands;

        # keybinds
        bind =
          # specific binds from hyprland config
          config.wayland.windowManager.hyprland.extraBinds ++

          # general exec binds
          (map (generateKeybind (bind: "exec, " + bind.command))
            (cfg.keybinds.binds ++ cfg.keybinds.global-binds)) ++

          # mode enter binds
          (builtins.attrValues (builtins.mapAttrs
            (name: mode: generateKeybind (_: "submap, " + name) mode.enter)
            cfg.keybinds.modes));
      };

      # modes
      extraConfig = let
        generateModeBind = bind:
          (lib.optional (builtins.isString bind.command)
            (generateKeybind (bind: "exec, " + bind.command) bind))
          ++ (lib.optional bind.exit
            (generateKeybind (_: "submap, reset") bind));

        generateModeBinds = mode:
          builtins.concatLists (map generateModeBind (mode.binds
            ++ (map (bind: bind // { exit = false; }) cfg.keybinds.global-binds)
            ++ (lib.optionals mode.default-exit [
              {
                mods = [ ];
                key = "escape";
                command = null;
                exit = true;
              }
              {
                mods = [ ];
                key = "backspace";
                command = null;
                exit = true;
              }
              (mode.enter // {
                command = null;
                exit = true;
              })
            ])));

        modes = builtins.concatStringsSep "\n" (builtins.attrValues
          (builtins.mapAttrs (name: mode: ''
            submap = ${name}
            ${builtins.concatStringsSep "\n"
            (map (bind: "bind = " + bind) (generateModeBinds mode))}
            submap = reset
          '') cfg.keybinds.modes));
      in ''
        ${modes}
      '';
    };
  };
}
