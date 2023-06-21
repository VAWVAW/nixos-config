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
  blue = 39,
  brown = 130,
  cyan = 51,
  cyan_dark = 30,
  gold = 136,
  green = 34,
  green_dark = 28,
  green_pale = 78,
  gray = 244,
  gray_blue = 26,
  gray_dark = 235,
  gray_red = 203,
  magenta = 201,
  red = 196,
  violet = 93,
  white = 231,
}
local common = {
  file = {
    add = colors.green,
    delete = colors.red,
    change = colors.blue,
    ignored = colors.gold,
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

  -- pmenu
  Pmenu                       = { fg = colors.white, bg = colors.gray_dark },
  PmenuSel                    = { fg = colors.white, bg = colors.gray_blue },

  -- keywords
  PreProc                     = colors.gray_blue,
  Title                       = colors.magenta,
  Identifier                  = { fg = colors.cyan_dark, style = "none" },
  Special                     = colors.violet,
  StorageClass                = colors.brown,
  Include                     = { link = "Statement" },
  Operator                    = { link = "Normal" },

  Constant                    = colors.violet,
  Statement                   = colors.brown,
  Function                    = colors.gold,
  Comment                     = colors.cyan,
  Type                        = colors.green_pale,

  -- data types
  Number                      = colors.blue,
  String                      = colors.green_dark,
  Character                   = { link = "String" },
  Boolean                     = colors.brown,

  -- vimdiff
  DiffAdd                     = { fg = colors.black, bg = common.file.add },
  DiffDelete                  = { fg = colors.black, bg = common.file.delete },
  DiffChange                  = { fg = colors.black, bg = common.file.change },

  -- plugins:
  -- gitsigns
  GitSignsAdd                 = common.file.add,
  GitSignsDelete              = common.file.delete,
  GitSignsChange              = common.file.change,

  -- illuminate
  IlluminatedWordText         = { bg = common.illuminate },
  IlluminatedWordRead         = { bg = common.illuminate },
  IlluminatedWordWrite        = { bg = common.illuminate },

  -- nvim-tree
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
