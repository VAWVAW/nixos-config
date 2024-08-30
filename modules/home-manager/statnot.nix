{ config, pkgs, lib, ... }:
let cfg = config.services.statnot;
in {
  options.services.statnot = {
    enable = lib.mkEnableOption "statnot service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.statnot;
      defaultText = lib.literalExpression "pkgs.statnot";
      description = "Package providing {command}`statnot`.";
    };

    configFile = lib.mkOption {
      type = with lib.types; nullOr (either str path);
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services."statnot" = {
      Unit = {
        Description = "Statnot notification daemon";
        Conflicts = [ "graphical-session.target" ];
      };

      Install.WantedBy = [ "default.target" ];

      Service = {
        ExecStart = lib.escapeShellArgs ([ "${cfg.package}/bin/statnot" ]
          ++ lib.optional (cfg.configFile != null) "${cfg.configFile}");
      };
    };

    xdg.configFile."systemd/user/graphical-session.target.d/statnot.conf".text =
      ''
        [Unit]
        OnSuccess=statnot.service
      '';
  };
}
