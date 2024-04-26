require("nvim-tree").setup {
  disable_netrw = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,

  update_focused_file = {
    enable = true,
    update_root = true,
  },

  filters = {
    dotfiles = true,
  },

  git = {
    enable = true,
    ignore = false,
    timeout = 1000,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },

  modified = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    icons = {
      hint = " ",
    },
  },

  renderer = {
    root_folder_modifier = ":t",
    highlight_git = true,
    full_name = true,
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          renamed = "➜",
          unmerged = "",
          deleted = "",
          unstaged = "󰊢",
          untracked = "󰊢",
          staged = "",
          ignored = "",
        },
      },
    },
  },

  view = {
    width = 30,
    side = "left",
  },

  on_attach = function(bufnr)
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
        vim.cmd("silent !git add " .. node.absolute_path)
      end

      api.tree.reload()
    end

    local function git_unstage()
      local node = api.tree.get_node_under_cursor()
      local gs = get_gs(node)

      -- If the file is staged, we unstage
      if gs == "M " or gs == "A " then
        vim.cmd("silent !git restore --staged " .. node.absolute_path)
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
    nmap("<CR>", api.node.open.edit)
    nmap("v", api.node.open.vertical)

    nmap("o", api.node.run.system)

    nmap("n", api.node.navigate.sibling.next)
    nmap("p", api.node.navigate.sibling.prev)

    nmap("a", api.fs.create)
    nmap("r", api.fs.rename)
    nmap("R", api.fs.rename_sub)
    nmap("d", api.fs.remove)
    nmap("y", api.fs.copy.node)
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
}

require("project_nvim").setup {
  patterns = { ".git", ".svn", "venv" }
}
