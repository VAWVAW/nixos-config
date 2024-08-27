local outline = require("symbols-outline")
local nvim_tree = require("nvim-tree.api")

local function open_status_split()
  if STATUS_SPLIT then
    return
  end
  STATUS_SPLIT = true
  nvim_tree.tree.close()
  outline.open_outline()
end

local function close_status_split()
  STATUS_SPLIT = false
  nvim_tree.tree.close()
  outline.close_outline()
end

local function toggle_status_split()
  if STATUS_SPLIT then
    close_status_split()
  else
    open_status_split()
  end
end


local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>e", nvim_tree.tree.focus, opts)
vim.keymap.set("n", "<leader>w", toggle_status_split, opts)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local FormatOptions = augroup("FormatOptions", { clear = true })
autocmd(
  "FileType", {
    group = FormatOptions,
    pattern = "Outline",
    desc = "open nvim-tree",
    callback = function()
      vim.cmd("setlocal signcolumn=no")
      vim.cmd("above split")
      nvim_tree.tree.open({ current_window = true })
      vim.api.nvim_win_set_width(0, 30)
    end
  }
)
