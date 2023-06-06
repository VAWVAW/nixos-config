require("nvim-tree").setup {
  disable_netrw = true,
  hijack_netrw = true,

  update_focused_file = {
    enable = true,
    update_cwd = true,
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

  on_attach = function (bufnr)
    local api = require("nvim-tree.api")

    local function nmap(l, r, opts)
      opts = { noremap = true, silent = true }
      opts.buffer = bufnr
      vim.keymap.set("n", l, r, opts)
    end

    nmap("q", api.tree.close)
    nmap("/", api.tree.search_node)
    nmap("t", api.tree.toggle_hidden_filter)
    nmap("<C-k>", api.node.show_info_popup)

    nmap("l", api.node.open.preview)
    nmap("<CR>", function () api.node.open.edit(); api.tree.close() end)
    nmap("h", api.node.navigate.parent_close)
    nmap("<Tab>", api.node.open.preview)
    nmap("v", api.node.open.vertical)

    nmap("a", api.fs.create)
    nmap("r", api.fs.rename)
    nmap("R", api.fs.rename_sub)
    nmap("d", api.fs.remove)
    nmap("y", api.fs.copy.node)
    nmap("x", api.fs.cut)
    nmap("p", api.fs.paste)

    nmap("<C-y>", api.fs.copy.filename)
    nmap("gy", api.fs.copy.relative_path)
    nmap("gY", api.fs.copy.absolute_path)
  end
}
