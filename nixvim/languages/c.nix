{ config, pkgs, lib, helpers, ... }: {
  options.languages.c.enable = lib.mkEnableOption "c language support";

  config.plugins = lib.mkIf config.languages.c.enable {
    lsp.enable = true;
    lsp.servers.ccls.enable = true;

    dap.enabled = true;
    dap.extensions.dap-lldb.enable = true;

    dap.adapters.executables."gdb" = {
      command = "${pkgs.gdb}/bin/gdb";
      args = [ "--interpreter=dap" "--eval-command" "set print pretty on" ];
    };
    dap.extensions.dap-lldb.customConfigurations."c" = [{
      name = "Debug (gdb)";
      type = "gdb";
      request = "launch";
      cwd = "\${workspaceFolder}";
      program = helpers.mkRaw ''
        function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end
      '';
    }];
  };
}
