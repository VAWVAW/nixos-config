local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,
  fallback_severity = vim.diagnostic.severity.HINT,
  sources = {
    -- git
    code_actions.gitsigns,

    -- nix
    formatting.nixfmt,
    diagnostics.statix,
    code_actions.statix,

    -- rust
    formatting.rustfmt,

    -- python
    formatting.black,
    diagnostics.pylint,

    -- json
    formatting.jq,

    -- toml
    formatting.taplo,
  },
}
