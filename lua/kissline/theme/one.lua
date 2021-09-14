local hl = require('kissline.utils.hl')

local colors = {
  normal  ='#98C379',
  insert  ='#61AFEF',
  terminal='#61AFEF',
  visual  ='#C678DD',
  replace ='#E06C75',

  green         = '#98C379',
  yellow        = '#E5C07B',
  comment_grey  = '#5C6370',
  red           = '#E06C75',
  special_grey  = '#3B4048',
  gutter_fg_grey= '#4B5263',
  visual_grey   = '#3E4452',
  cursor_grey   = '#2C323C',
  dark_yellow   = '#D19A66',
  blue          = '#61AFEF',
  purple        = '#C678DD',
  black         = '#282C34',
  menu_grey     = '#3E4452',
  dark_red      = '#BE5046',
  white         = '#ABB2BF',
  cyan          = '#56B6C2',
  vertsplit     = '#181A1F',
}

local function init()
  vim.fn['kissline#colors#_ApplyTabLineColors']()
  hl.createhighlight('Kissline_cur_mode_active', colors.black, colors.normal, 'bold')
  hl.createhighlight('Kissline_cur_mode_sp_active', colors.normal, colors.visual_grey)

  for key, value in pairs(colors) do
    hl.createhighlight('Kissline_mode_'..key, '#2C323C', value, 'bold')
    hl.createhighlight('Kissline_mode_sp_'..key, value,'#3E4452')
  end
end

return {
  init = init
}

