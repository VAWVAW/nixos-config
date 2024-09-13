{ helpers, ... }: {

  plugins.fugitive.enable = true;

  plugins.nvim-tree = {
    enable = true;
    disableNetrw = true;
    hijackNetrw = true;
    syncRootWithCwd = true;
    respectBufCwd = true;

    filters.dotfiles = true;

    filesystemWatchers.ignoreDirs = [ "^/nix/store" ];

    updateFocusedFile = {
      enable = true;
      updateRoot = true;
    };

    git = {
      enable = true;
      ignore = false;
      timeout = 1000;
      showOnOpenDirs = false;
    };

    modified = {
      enable = true;
      showOnOpenDirs = false;
    };

    diagnostics = {
      enable = true;
      showOnDirs = true;
      showOnOpenDirs = false;
      severity.min = "info";
    };

    renderer = {
      rootFolderLabel = ":t";
      highlightGit = true;
      fullName = true;
      icons.glyphs = {
        default = "";
        symlink = "";
        folder = {
          arrowOpen = "";
          arrowClosed = "";
          default = "";
          open = "";
          empty = "";
          emptyOpen = "";
          symlink = "";
          symlinkOpen = "";
        };
        git = {
          renamed = "➜";
          unmerged = "";
          deleted = "";
          unstaged = "󰊢";
          untracked = "󰊢";
          staged = "";
          ignored = "";
        };
      };
    };

    onAttach = helpers.mkRaw ''
      function(bufnr)
        local api = require("nvim-tree.api")

        local function get_gs(node)
          local gs = node.git_status.file

          -- If the current node is a directory get children status
          if gs == nil then
            gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
                or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
          end
          return gs
        end

        local function git_add()
          local node = api.tree.get_node_under_cursor()
          local gs = get_gs(node)

          -- If the file is untracked, unstaged or partially staged, we stage it
          if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
            vim.cmd("silent Git add " .. node.absolute_path)
          end

          api.tree.reload()
        end

        local function git_unstage()
          local node = api.tree.get_node_under_cursor()
          local gs = get_gs(node)

          -- If the file is staged, we unstage
          if gs == "M " or gs == "A " then
            vim.cmd("silent Git restore --staged " .. node.absolute_path)
          end

          api.tree.reload()
        end

        local function nmap(l, r, opts)
          opts = { noremap = true, silent = true }
          opts.buffer = bufnr
          vim.keymap.set("n", l, r, opts)
        end

        nmap("q", api.tree.close)
        nmap("/", api.tree.search_node)
        nmap("t", api.tree.toggle_hidden_filter)
        nmap("K", api.node.show_info_popup)

        nmap("h", api.node.navigate.parent_close)
        nmap("l", api.node.open.preview)
        nmap("<Tab>", api.node.open.preview)
        nmap("<CR>", function()
          api.node.open.edit()
          api.tree.close()
        end)
        nmap("v", function()
          api.node.open.vertical()
          api.tree.close()
        end)
        nmap("s", function()
          api.node.open.horizontal()
          api.tree.close()
        end)
        nmap("i", function()
          api.node.open.edit()
          api.tree.open()
        end)

        nmap("o", api.node.run.system)

        nmap("<C-n>", api.node.navigate.sibling.next)
        nmap("<C-p>", api.node.navigate.sibling.prev)

        nmap("a", api.fs.create)
        nmap("r", api.fs.rename)
        nmap("R", api.fs.rename_sub)
        nmap("d", api.fs.remove)
        nmap("yy", api.fs.copy.node)
        nmap("x", api.fs.cut)
        nmap("p", api.fs.paste)

        nmap("Y", api.fs.copy.filename)
        nmap("gy", api.fs.copy.relative_path)
        nmap("gY", api.fs.copy.absolute_path)

        nmap("gs", git_add)
        nmap("gu", git_unstage)
        nmap("gn", api.node.navigate.git.next)
        nmap("gp", api.node.navigate.git.prev)
      end
    '';
  };

  keymaps = helpers.keymaps.mkKeymaps {
    mode = "n";
    options = {
      noremap = true;
      silent = true;
    };
  } [{
    key = "<leader>e";
    action = ":NvimTreeFocus<CR>";
  }];
}
