require("gitsigns").setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true,
  watch_gitdir = {
    interval = 5000,
    follow_files = true,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },

  -- keybinds
  on_attach = function (bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or { noremap = true, silent = true }
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>gn", gs.next_hunk)
    map("n", "<leader>gp", gs.preview_hunk)

    map('n', '<leader>gs', gs.stage_hunk)
    map('n', '<leader>gr', gs.reset_hunk)
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gR', gs.reset_buffer)
    map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end)
    map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end)

    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gl', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line{full=true} end)
    -- map('n', '<leader>gd', gs.diffthis)
    -- map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)
  end
}
