{ inputs, config, pkgs, lib, helpers, ... }:
let
  cfg = config.plugins.dap.extensions.dap-lldb;
  dapHelpers = import "${inputs.nixvim}/plugins/by-name/dap/dapHelpers.nix" {
    inherit lib helpers;
  };
in {
  options.plugins.dap.extensions.dap-lldb = {
    enable = lib.mkEnableOption "dap-lldb";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vimPlugins.nvim-dap-lldb;
    };

    codelldbPath = lib.mkOption {
      type = lib.types.str;
      default =
        "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
    };

    customConfigurations = lib.mkOption {
      type =
        (lib.types.attrsOf (lib.types.listOf dapHelpers.configurationOption));
      default = { };
      example = {
        c = [{
          name = "Launch debugger";
          type = "lldb";
          request = "launch";
          cwd = "\${workspaceFolder}";
          program = helpers.mkRaw ''
            function()
               -- Build with debug symbols
               local out = vim.fn.system({"make", "debug"})
               -- Check for errors
               if vim.v.shell_error ~= 0 then
                  vim.notify(out, vim.log.levels.ERROR)
                  return nil
               end
               -- Return path to the debuggable program
               return "path/to/executable"
            end
          '';
        }];
      };
    };
  };
  config = lib.mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
    plugins.dap = {
      enable = true;
      extensionConfigLua = ''
        require('dap-lldb').setup({
          codelldb_path = "${cfg.codelldbPath}",
          configurations = ${helpers.toLuaObject cfg.customConfigurations}
        })
      '';
    };
  };
}
