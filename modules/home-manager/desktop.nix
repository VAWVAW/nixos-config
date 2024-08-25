{ config, pkgs, lib, ... }:
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
      mods = types.enum [ "Super" "Alt" "Ctrl" "Shift" ];
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
          default = "Alt";
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

    theme = {
      wallpaper = mkOption {
        description = "the wallpaper to use";
        type = types.nullOr types.path;
        default = null;
      };

      focused = {
        border = mkOption {
          description = "the border color for focused items";
          type = types.str;
          default = "#4c7899";
        };
        background = mkOption {
          description = "the background color for focused items";
          type = types.str;
          default = "#285577";
        };
        text = mkOption {
          description = "the text color for focused items";
          type = types.str;
          default = "#ffffff";
        };
      };
      secondary = {
        border = mkOption {
          description =
            "the border color for secondary items like visible but inactive workspaces";
          type = types.str;
          default = "#333333";
        };
        background = mkOption {
          description =
            "the background color for secondary items like visible but inactive workspaces";
          type = types.str;
          default = "#5f676a";
        };
        text = mkOption {
          description =
            "the text color for secondary items like visible but inactive workspaces";
          type = types.str;
          default = "#ffffff";
        };
      };
      unfocused = {
        border = mkOption {
          description = "the border color for unfocused items";
          type = types.str;
          default = "#333333";
        };
        background = mkOption {
          description = "the background color for unfocused items";
          type = types.str;
          default = "#222222";
        };
        text = mkOption {
          description = "the text color for unfocused items";
          type = types.str;
          default = "#888888";
        };
      };
      urgent = {
        border = mkOption {
          description = "the border color for urgent items";
          type = types.str;
          default = "#c01010";
        };
        background = mkOption {
          description = "the background color for urgent items";
          type = types.str;
          default = "#900000";
        };
        text = mkOption {
          description = "the text color for urgent items";
          type = types.str;
          default = "#ffffff";
        };
      };
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
      transformMod = builtins.replaceStrings [ "Super" "Alt"] ["Mod4" "Mod1"];
      generateKeybind = genExec: bind: {
        name = transformMod
          (builtins.concatStringsSep "+" (bind.mods ++ [ bind.key ]));
        value = genExec bind;
      };
      generateKeybinds = genExec: binds:
        builtins.listToAttrs (map (generateKeybind genExec) binds);

    in mkIf config.wayland.windowManager.sway.enable {
      inherit (cfg.keybinds.generated) left right up down;
      modifier = transformMod cfg.keybinds.generated.mod;

      # keyboard layout
      input."type:keyboard" = {
        xkb_layout = config.home.keyboard.layout;
        xkb_variant = config.home.keyboard.variant;
        xkb_options =
          builtins.concatStringsSep "," config.home.keyboard.options;
      };

      output = mkMerge [
        # screens
        (builtins.listToAttrs (builtins.map (s: {
          inherit (s) name;
          value = {
            inherit (s) position scale;
            resolution = s.size;
          };
        }) cfg.screens))

        # wallpaper
        (mkIf (cfg.theme.wallpaper != null) {
          "*".bg = "${toString cfg.theme.wallpaper} fill";
        })
      ];

      # workspaces
      workspaceOutputAssign = builtins.concatMap (screen:
        map (workspace: {
          inherit workspace;
          output = screen.name;
        }) screen.workspaces) cfg.screens;

      # startup commands
      startup = builtins.map (cmd: { command = cmd; }) cfg.startup_commands;

      # theming
      colors = let
        genColor = variant: {
          inherit (variant) background border text;
          childBorder = variant.border;
          indicator = variant.border;
        };
      in {
        focused = genColor cfg.theme.focused;
        focusedInactive = genColor cfg.theme.secondary;
        unfocused = genColor cfg.theme.unfocused;
        urgent = genColor cfg.theme.urgent;
        background = "#000000";
      };

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
      formatColor = color: "rgb(${lib.removePrefix "#" color})";
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
        # workspaces
        workspace = builtins.concatMap
          (s: map (ws: "${toString ws}, monitor:desc:${s.name}") s.workspaces)
          cfg.screens;

        # startup commands
        exec-once = cfg.startup_commands ++
          # wallpaper
          lib.optional (cfg.theme.wallpaper != null)
          "${pkgs.swaybg}/bin/swaybg --image ${cfg.theme.wallpaper} --mode fill";

        # theming
        general = {
          "col.active_border" = formatColor cfg.theme.focused.border;
          "col.inactive_border" = formatColor cfg.theme.unfocused.border;
        };
        plugin.hy3.tabs = {
          "col.active" = formatColor cfg.theme.focused.background;
          "col.text.active" = formatColor cfg.theme.focused.text;
          "col.inactive" = formatColor cfg.theme.unfocused.background;
          "col.text.inactive" = formatColor cfg.theme.unfocused.text;
          "col.urgent" = formatColor cfg.theme.urgent.background;
          "col.text.urgent" = formatColor cfg.theme.urgent.text;
        };

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
