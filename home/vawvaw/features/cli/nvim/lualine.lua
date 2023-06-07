local branch = {
  "b:gitsigns_head",
  icons_enabled = true,
  icon = "",
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local filename = {
  "filename",
  path = 1,
  newfile_status = true,
  symbols = {
    modified = "",
    readonly = "",
    unnamed = "[]",
    newfile = "",
  },
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " },
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end
}

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    ignore_focus = { "NvimTree", "aerial" },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = { filename },
    lualine_c = {},

    lualine_x = { "lsp_progress" },
    lualine_y = { diff, spaces, "encoding", "fileformat", filetype, "progress" },
    lualine_z = {},
  },
  extensions = {
    "quickfix",
    "toggleterm",
    "fugitive",
  }
}
