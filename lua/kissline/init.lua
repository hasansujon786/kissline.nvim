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

local initColors = function ()
  local highlight_colors={
    normal  = '#98C379',
    insert  = '#61AFEF',
    terminal= '#61AFEF',
    visual  = '#C678DD',
    replace = '#E06C75',
  }

  for k, v in pairs(highlight_colors) do
    vim.cmd(string.format('hi Kissline_mode_%s    guifg=#2C323C guibg=%s gui=bold', k, v))
    vim.cmd(string.format('hi Kissline_mode_sp_%s guifg=%s guibg=#3E4452 gui=bold', k, v))
  end

end
initColors()

return {}
