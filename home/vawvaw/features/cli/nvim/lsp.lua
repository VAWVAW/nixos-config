local lspconfig = require("lspconfig")

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
local function nmap(l, r, opts)
  opts = { noremap = true, silent = true }
  vim.keymap.set("n", l, r, opts)
end

nmap('gl', vim.diagnostic.open_float)
nmap('<leader>p', vim.diagnostic.goto_prev)
nmap('<leader>n', vim.diagnostic.goto_next)
nmap('<leader>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings
    local opts = { noremap = true, silent = true, buffer = ev.buf }
    nmap('gd', vim.lsp.buf.definition, opts)
    nmap('gD', vim.lsp.buf.declaration, opts)
    nmap('gr', vim.lsp.buf.references, opts)
    nmap('gi', vim.lsp.buf.implementation, opts)
    nmap('gk', vim.lsp.buf.type_definition, opts)
    nmap('K', vim.lsp.buf.hover, opts)
    nmap('<leader>k', vim.lsp.buf.signature_help, opts)
    nmap('<leader>a', vim.lsp.buf.code_action, opts)
    nmap('<leader>f', vim.lsp.buf.format, opts)
    nmap('<F6>', vim.lsp.buf.rename, opts)
  end,
})

-- python
lspconfig.pyright.setup {}

-- rust
lspconfig.rust_analyzer.setup {}

-- nix
lspconfig.rnix.setup {}

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
