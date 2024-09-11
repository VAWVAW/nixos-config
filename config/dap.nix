{ helpers, ... }: {
  plugins.dap = {
    enable = true;

    signs.dapBreakpoint.text = "󰃤";
    signs.dapBreakpoint.texthl = "DapBreakpoint";

    extensions = {
      dap-python.enable = true;
      dap-virtual-text.enable = true;
      dap-ui = {
        enable = true;

        controls.enabled = false;
        layouts = [
          {
            position = "right";
            size = 70;
            elements = [
              {
                id = "scopes";
                size = 0.35;
              }
              {
                id = "breakpoints";
                size = 0.25;
              }
              {
                id = "stacks";
                size = 0.2;
              }
              {
                id = "watches";
                size = 0.2;
              }
            ];
          }
          {
            position = "bottom";
            size = 10;
            elements = [
              {
                id = "repl";
                size = 0.4;
              }
              {
                id = "console";
                size = 0.6;
              }
            ];
          }
        ];
        mappings = {
          expand = [ "h" "l" ];
          open = "<CR>";
        };
      };
    };
  };

  keymaps = helpers.keymaps.mkKeymaps {
    mode = "n";
    options = {
      noremap = true;
      silent = true;
    };
  } [
    {
      key = "<leader>db";
      action = helpers.mkRaw "require('dap').toggle_breakpoint";
    }
    {
      key = "<leader>do";
      action = helpers.mkRaw "require('dapui').toggle";
    }
    {
      key = "<leader>dc";
      action = helpers.mkRaw "require('dap').continue";
    }
    {
      key = "<leader>dr";
      action = helpers.mkRaw "require('dap').run_last";
    }
    {
      key = "<leader>dt";
      action = helpers.mkRaw "require('dap').terminate";
    }

    {
      key = "<leader>dj";
      action = helpers.mkRaw "require('dap').step_into";
    }
    {
      key = "<leader>dk";
      action = helpers.mkRaw "require('dap').step_back";
    }
    {
      key = "<leader>dl";
      action = helpers.mkRaw "require('dap').step_over";
    }
    {
      key = "<leader>dh";
      action = helpers.mkRaw "require('dap').step_out";
    }
  ];
}
