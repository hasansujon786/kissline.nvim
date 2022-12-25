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

local function genTabColors(tabStyle)
  if tabStyle == 'angel_bar' then
    local tabcolors = {
    tabline     = { bg = '#16181c', fg = '#5C6370'},
    tabActive   = { bg = '#242b38', fg = '#dddddd'},
    tabInactive = { bg = '#1e2127', fg = '#5C6370'}
    }
    hl.createhighlight('KisslineTabLine', tabcolors.tabline.fg, tabcolors.tabline.bg)
    hl.createhighlight('KisslineTabActiveDim', tabcolors.tabline.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineTabActive', tabcolors.tabActive.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineTabSeparatorActive', tabcolors.tabline.bg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineTabInactive', tabcolors.tabInactive.fg, tabcolors.tabInactive.bg)
    hl.createhighlight('KisslineTabSeparatorInactive', tabcolors.tabline.bg, tabcolors.tabInactive.bg)
  else
    local tabcolors = {
      tabline       = { bg = '#21252b', fg = '#5C6370'},
      tabActive     = { bg = '#242b38', fg = '#dddddd'},
      tabActiveSp   = { bg = '#242b38', fg = '#61AFEF'},
      tabInactive   = { bg = '#21252b', fg = '#5C6370'},
      tabInactiveSp = { bg = '#21252b', fg = '#17191C'},
    }
    hl.createhighlight('KisslineTabLine', tabcolors.tabline.fg, tabcolors.tabline.bg)
    hl.createhighlight('KisslineTabActiveDim', tabcolors.tabline.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineTabActive', tabcolors.tabActive.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineTabSeparatorActive', tabcolors.tabActiveSp.fg, tabcolors.tabActiveSp.bg)
    hl.createhighlight('KisslineTabInactive', tabcolors.tabInactive.fg, tabcolors.tabInactive.bg)
    hl.createhighlight('KisslineTabSeparatorInactive', tabcolors.tabInactiveSp.fg, tabcolors.tabInactiveSp.bg)
  end
end

local function genWinbarColors(tabStyle)
  if tabStyle == 'angel_bar' then
    local tabcolors = {
    tabline     = { bg = '#16181c', fg = '#5C6370'},
    tabActive   = { bg = '#242b38', fg = '#dddddd'},
    tabInactive = { bg = '#1e2127', fg = '#5C6370'}
    }
    hl.createhighlight('KisslineWinbarLine', tabcolors.tabline.fg, tabcolors.tabline.bg)
    hl.createhighlight('KisslineWinbarActiveDim', tabcolors.tabline.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineWinbarActive', tabcolors.tabActive.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineWinbarSeparatorActive', tabcolors.tabline.bg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineWinbarInactive', tabcolors.tabInactive.fg, tabcolors.tabInactive.bg)
    hl.createhighlight('KisslineWinbarSeparatorInactive', tabcolors.tabline.bg, tabcolors.tabInactive.bg)
  else
    -- local main = '#2D3343'
    local main = '#242B38'
    local tabcolors = {
      tabline         = { fg = '#5C6370', bg = '#1f262d' }, -- fg = '#7e8b9e'
      tabActive       = { fg = '#dddddd', bg = main },
      tabItemInactive = { fg = '#3d4451', bg = main },
      tabIndicActive  = { fg = '#61AFEF', bg = main },
      tabIndicInactive= { fg = main,      bg = main },
      tabActiveTail   = { fg = '#1c1e24', bg = main },
    }

    hl.createhighlight('KisslineWinbarLine', tabcolors.tabline.fg, tabcolors.tabline.bg)

    hl.createhighlight('KisslineWinbarActive', tabcolors.tabActive.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineWinbarInactive', tabcolors.tabline.fg, tabcolors.tabItemInactive.bg)
    hl.createhighlight('KisslineWinbarItemActive', tabcolors.tabline.fg, tabcolors.tabActive.bg)
    hl.createhighlight('KisslineWinbarItemInactive', tabcolors.tabItemInactive.fg, tabcolors.tabItemInactive.bg)

    hl.createhighlight('KisslineWinbarIndicatorActive', tabcolors.tabIndicActive.fg, tabcolors.tabIndicActive.bg)
    hl.createhighlight('KisslineWinbarIndicatorInactive', tabcolors.tabIndicInactive.fg, tabcolors.tabIndicInactive.bg)
    hl.createhighlight('KisslineWinbarSeparator', tabcolors.tabActiveTail.fg, tabcolors.tabActiveTail.bg)
  end
end

local function init(opts)
  if opts.eneble_winbar then
    genWinbarColors(opts.tab_style)
  end
  if not opts.disable_tab then
    genTabColors(opts.tab_style)
  end
  if not opts.disable_line then
    hl.createhighlight('Kissline_cur_mode_active', colors.black, colors.normal, 'bold')
    hl.createhighlight('Kissline_cur_mode_sp_active', colors.normal, colors.visual_grey)

    for key, value in pairs(colors) do
      hl.createhighlight('Kissline_mode_'..key, '#2C323C', value, 'bold')
      hl.createhighlight('Kissline_mode_sp_'..key, value,'#3E4452')
    end
  end
end

return {
  init = init,
}

