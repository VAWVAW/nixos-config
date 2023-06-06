local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },

  rainbow = {
    enable = true,
    disable = { "nix" },
    extended_mode = true,
  },
  playground = {
    enable = true,
  },
  autopairs = {
    enable = true,
  },
}
