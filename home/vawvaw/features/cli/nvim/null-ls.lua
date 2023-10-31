local null_ls = require("null-ls")
local cspell = require("cspell")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local cspell_config = {
  config = {
    config_file_preferred_name = ".cspell.json",
  },
}

null_ls.setup {
  debug = false,
  fallback_severity = vim.diagnostic.severity.HINT,
  sources = {
    -- spell check
    cspell.diagnostics.with(cspell_config),
    cspell.code_actions.with(cspell_config),

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
  },
}
