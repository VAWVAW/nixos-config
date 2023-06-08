local telescope = require("telescope")

local actions = require("telescope.actions")

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { truncate = 1 },
    initial_mode = "normal",
    mappings = {
      i = {
        ["<C-c>"] = actions.close,
        ["<C-_>"] = actions.which_key,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-o>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-p>"] = actions.preview_scrolling_up,
        ["<C-n>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

        ["<C-l>"] = actions.complete_tag,
      },
      n = {
        ["<Esc>"] = actions.close,
        ["q"] = actions.close,
        ["?"] = actions.which_key,
        ["/"] = { "<cmd>startinsert<CR>", type = "command" },

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<CR>"] = actions.select_default,
        ["<C-o>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-p>"] = actions.preview_scrolling_up,
        ["<C-n>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
      },
    },
  },
  pickers = {
    find_files = {
      initial_mode = "insert"
    },
    live_grep = {
      initial_mode = "insert"
    }
  },
}

telescope.load_extension("ui-select")
