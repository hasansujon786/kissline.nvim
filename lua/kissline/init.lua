local utils = require('kissline.utils')
local layout = require('kissline.layout')

local update = {
  all = function ()
    vim.opt.statusline = layout.active()
  end
}

local autocmds = {
  Kissline = {
    {'WinEnter', '*', update.all()}
  }
}

return {}
