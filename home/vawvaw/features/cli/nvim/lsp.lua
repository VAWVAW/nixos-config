local lspconfig = require("lspconfig")
local telescope = require("telescope.builtin")

-- signs
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn",  text = "" },
  { name = "DiagnosticSignHint",  text = "" },
  { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- keybinds
local function map(mode, l, r, opts)
  opts = opts or { noremap = true, silent = true }
  vim.keymap.set(mode, l, r, opts)
end

map('n', 'gl', vim.diagnostic.open_float)
map('n', '<leader>p', vim.diagnostic.goto_prev)
map('n', '<leader>n', vim.diagnostic.goto_next)
map('n', '<leader>q', telescope.diagnostics)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings
    local opts = { noremap = true, silent = true, buffer = ev.buf }
    map('n', 'gd', telescope.lsp_definitions, opts)
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gr', telescope.lsp_references, opts)
    map('n', 'gi', telescope.lsp_implementations, opts)
    map('n', 'gk', telescope.lsp_type_definitions, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<leader>a', vim.lsp.buf.code_action, opts)
    map('n', '<leader>f', vim.lsp.buf.format, opts)
    map('n', '<F6>', vim.lsp.buf.rename, opts)
    map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('i', '<C-k>', vim.lsp.buf.signature_help, opts)
  end,
})

-- python
lspconfig.pyright.setup {}

-- rust
lspconfig.rust_analyzer.setup {}

-- nix
lspconfig.nil_ls.setup {}

-- lua
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    }
  }
}
