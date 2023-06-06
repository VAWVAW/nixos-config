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
    -- formatting
    formatting.rustfmt,
    formatting.nixfmt,

    -- diagnostics
    diagnostics.statix,
    cspell.diagnostics.with(cspell_config),

    -- code actions
    code_actions.statix,
    code_actions.gitsigns,
    cspell.code_actions.with(cspell_config),
  },
}
