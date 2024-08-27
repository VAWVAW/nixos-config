require("nvim-treesitter.configs").setup {

  ensure_installed = {},
  ignore_install = {},
  sync_install = false,
  auto_install = false,
  modules = {},

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

require("illuminate").configure({
  min_count_to_highlight = 2,
})
