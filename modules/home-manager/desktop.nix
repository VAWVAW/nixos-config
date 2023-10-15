{ lib, ... }:
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
            example = literalExpression "[\"9\" \"10\"]";
          };
        };
      });
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
}
