local lspconfig = require("lspconfig")
local telescope = require("telescope.builtin")
local dap = require("dap")
local dapui = require("dapui")

-- signs
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn",  text = "" },
  { name = "DiagnosticSignHint",  text = "" },
  { name = "DiagnosticSignInfo",  text = "" },
  { name = "DapBreakpoint",       text = "󰃤" },
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

    -- debug mappings
    map('n', '<leader>db', dap.toggle_breakpoint)
    map('n', '<F7>', dap.step_into)
    map('n', '<F8>', dap.step_over)
    map('n', '<F9>', dap.step_out)
    map('n', '<F10>', dap.continue)
    map('n', '<leader>dl', dapui.toggle)
    map('n', '<leader>dt', dap.terminate)
  end,
})

dapui.setup {
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.25,
        },
        {
          id = "breakpoints",
          size = 0.25
        },
        {
          id = "stacks",
          size = 0.25
        },
        {
          id = "watches",
          size = 0.25
        }
      },
      position = "right",
      size = 70
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.5
        },
        {
          id = "console",
          size = 0.5
        }
      },
      position = "bottom",
      size = 10
    }
  },
  mappings = {
    expand = {"h", "l"},
    open = "<CR>"
  }
}

-- python
lspconfig.pyright.setup {}

-- rust
local rust_tools = require("rust-tools")
rust_tools.setup {
}

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
