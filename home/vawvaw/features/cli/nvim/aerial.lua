local aerial = require("aerial")

aerial.setup {
  backends = { "lsp", "treesitter", "markdown", "man" },

  layout = {
    width = 30,
    default_direction = "left",
    placement = "edge",
  },
  attach_mode = "global",

  keymaps = {
    ["?"] = "actions.show_help",
    ["<CR>"] = function()
      aerial.select()
      aerial.close()
    end,
    ["J"] = "actions.down_and_scroll",
    ["K"] = "actions.up_and_scroll",
    ["{"] = "actions.prev",
    ["}"] = "actions.next",
    ["q"] = "actions.close",
    ["s"] = "actions.scroll",
    ["<Tab>"] = "actions.scroll",

    ["l"] = "actions.tree_open",
    ["zo"] = "actions.tree_open",
    ["L"] = "actions.tree_open_recursive",
    ["zO"] = "actions.tree_open_recursive",
    ["h"] = "actions.tree_close",
    ["zc"] = "actions.tree_close",
    ["H"] = "actions.tree_close_recursive",
    ["zC"] = "actions.tree_close_recursive",
    ["zr"] = "actions.tree_increase_fold_level",
    ["zR"] = "actions.tree_open_all",
    ["zm"] = "actions.tree_decrease_fold_level",
    ["zM"] = "actions.tree_close_all",

    ["zx"] = "actions.tree_sync_folds",
    ["zX"] = "actions.tree_sync_folds",

    ["<C-j>"] = false,
    ["<C-k>"] = false,
  },

  filter_kind = false,
  highlight_on_hover = true,
  highlight_on_jump = 500,

  update_events = "TextChanged,InsertLeave",
}
