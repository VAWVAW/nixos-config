local function highlight(group, properties)
  if type(properties) ~= "table" then
    properties = { fg = properties }
  end

  local cmd
  if properties.link ~= nil then
    cmd = table.concat({ "highlight!", "link", group, properties.link }, " ")
  else
    local bg = properties.bg == nil and "" or "ctermbg=" .. properties.bg
    local fg = properties.fg == nil and "" or "ctermfg=" .. properties.fg
    local style = properties.style == nil and "" or "cterm=" .. properties.style
    cmd = table.concat({ "highlight", group, bg, fg, style }, " ")
  end
  vim.api.nvim_command(cmd)
end

local function load(theme)
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  for group, properties in pairs(theme) do
    highlight(group, properties)
  end
end


local colors = {
  black = 16,
  blue = 33,
  blue_light = 39,
  blue_dark = 26,
  brown = 172,
  cyan = 51,
  cyan_dark = 37,
  gold = 220,
  green = 47,
  green_dark = 34,
  gray = 244,
  gray_dark = 235,
  gray_red = 203,
  magenta = 201,
  red = 196,
  violet = 165,
  white = 231,
}
local common = {
  file = {
    add = 34,
    delete = colors.red,
    change = colors.blue_light,
    ignored = colors.gray,
    modified = colors.magenta,
  },
  errors = {
    light = colors.gray_red,
  },
  illuminate = colors.gray_dark,
  bufferline = {
    default = { fg = colors.gray, bg = colors.black, style = "none" },
    selected = { fg = colors.white, bg = colors.black, style = "bold" },
    visible = { fg = colors.gray, bg = colors.black, style = "bold" },
  },
}

local theme = {
  LineNr                      = colors.gray,
  SignColumn                  = { bg = colors.black },
  DapBreakpoint               = colors.red,
  NonText                     = colors.blue,

  -- pmenu
  Pmenu                       = { fg = colors.white, bg = colors.gray_dark },
  PmenuSel                    = { fg = colors.white, bg = colors.blue },

  -- keywords
  PreProc                     = colors.blue,
  Title                       = colors.magenta,
  Identifier                  = { fg = colors.cyan_dark, style = "none" },
  Special                     = colors.violet,
  StorageClass                = colors.brown,
  Include                     = { link = "Statement" },
  Operator                    = { link = "Normal" },

  Statement                   = colors.brown,
  Function                    = colors.gold,
  Comment                     = colors.cyan,
  Type                        = colors.green,
  LspInlayHints               = colors.gray,

  -- data types
  Constant                    = colors.magenta,
  String                      = colors.green_dark,
  Character                   = { link = "String" },

  -- vimdiff
  DiffAdd                     = { fg = colors.black, bg = 65 },
  DiffChange                  = { fg = colors.black, bg = 67 },
  DiffDelete                  = { fg = colors.black, bg = 133 },
  DiffText                    = { fg = colors.black, bg = 251 },

  -- plugins:

  RainbowDelimiterBlue        = colors.blue_dark,

  -- gitsigns
  GitSignsAdd                 = common.file.add,
  GitSignsDelete              = common.file.delete,
  GitSignsChange              = common.file.change,

  -- illuminate
  IlluminatedWordText         = { bg = common.illuminate },
  IlluminatedWordRead         = { bg = common.illuminate },
  IlluminatedWordWrite        = { bg = common.illuminate },

  -- nvim-tree
  NvimTreeFolderIcon          = colors.blue_dark,
  NvimTreeRootFolder          = colors.brown,
  NvimTreeSpecialFile         = colors.brown,
  NvimTreeImageFile           = colors.brown,
  NvimTreeWindowPicker        = { fg = colors.black, bg = colors.cyan },

  NvimTreeGitNew              = common.errors.light,
  NvimTreeGitDirty            = common.errors.light,
  NvimTreeGitIgnored          = common.file.ignored,

  NvimTreeGitRenamed          = common.file.add,
  NvimTreeGitDeleted          = common.file.delete,
  NvimTreeGitStaged           = common.file.change,
  NvimTreeGitMerge            = common.file.change,

  NvimTreeFileDirty           = common.file.change,
  NvimTreeFileNew             = common.file.add,
  NvimTreeModifiedFile        = common.file.modified,

  -- bufferline
  BufferLineFill              = common.bufferline.default,
  BufferLineBackground        = common.bufferline.default,
  BufferLineIndicatorSelected = common.bufferline.selected,
  BufferLineIndicatorVisible  = common.bufferline.visible,

  BufferLineBufferSelected    = common.bufferline.selected,
  BufferLineBufferVisible     = common.bufferline.visible,

  BufferLineSeparator         = common.bufferline.default,
  BufferLineSeparatorSelected = common.bufferline.selected,
  BufferLineSeparatorVisible  = common.bufferline.visible,

  BufferLineModified          = common.file.modified,
  BufferLineModifiedVisible   = common.file.modified,
  BufferLineModifiedSelected  = common.file.modified,

  BufferLineTab               = common.bufferline.default,
  BufferLineTabSelected       = common.bufferline.selected,
  BufferLineTabClose          = common.bufferline.selected,

  -- language specific
  ["@property.toml"]          = { link = "@type.toml" }
}

load(theme)
