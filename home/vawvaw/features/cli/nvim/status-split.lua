local aerial = require("aerial")
local nvim_tree = require("nvim-tree.api")

local function open_status_split()
  if STATUS_SPLIT then
    return
  end
  STATUS_SPLIT = true
  aerial.open()
  vim.cmd("above split")
  nvim_tree.tree.open({ current_window = true })
  vim.api.nvim_win_set_width(0, 30)
end

local function close_status_split()
  STATUS_SPLIT = false
  nvim_tree.tree.close()
  aerial.close()
end

local function toggle_status_split()
  if STATUS_SPLIT then
    close_status_split()
  else
    open_status_split()
  end
end

local function focus_status_split()
  if STATUS_SPLIT ~= true then
    open_status_split()
  end

  nvim_tree.tree.focus()
end


local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>e", focus_status_split, opts)
vim.keymap.set("n", "<leader>w", toggle_status_split, opts)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local FormatOptions = augroup("FormatOptions", { clear = true })
autocmd("VimEnter", {
  group = FormatOptions,
  pattern = "*",
  desc = "Open status split",
  callback = function()
    open_status_split()
    vim.cmd("wincmd l")
  end,
})
