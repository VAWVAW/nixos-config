local lspconfig = require("lspconfig")

-- keybinds
local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>p', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings
    local opts = { noremap = true, silent = true, buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>g', vim.lsp.buf.code_action, opts)
  end,
})

-- python
lspconfig.pyright.setup {}

-- rust
lspconfig.rust_analyzer.setup {}
