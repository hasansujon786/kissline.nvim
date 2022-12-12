local at = require('kissline.utils.atoms')
local file_provider = require('kissline.profider.file')
local icon_provider = require('kissline.profider.icon')

-- state
local maxTabLenght = 27
local tabsCanFit = 4
local tab_style = 'default'

local getVisibleTabsIdx = function()
  local currentTabNr = vim.fn.tabpagenr()
  local visible_tabs = { currentTabNr }
  local left = 0
  local right = 0

  if currentTabNr > tabsCanFit then
    right = 0
    left = tabsCanFit - 1
  elseif currentTabNr <= tabsCanFit then
    right = tabsCanFit - currentTabNr
    left = tabsCanFit - (right + 1)
  end

  for i = 1, left do
    table.insert(visible_tabs, currentTabNr - i)
  end
  for i = 1, right do
    table.insert(visible_tabs, currentTabNr + i)
  end
  return { visible_tabs, left, right }
end
local is_tab_truncate = function(tabNr)
  local v_tabs_idx = getVisibleTabsIdx()[1]
  return vim.fn.index(v_tabs_idx, tabNr) == -1 and true or false
end

local function getTabName(bufNr, isSelected, section_hl)
  local fname = file_provider.filename(bufNr)
  local icon = icon_provider.fileIcon(bufNr, isSelected, section_hl)
  local stringLenght = fname:len() + 2
  local availableTabSpace = maxTabLenght - 3 -- 3 spaces used by cross & indicator icon

  if stringLenght > (availableTabSpace - 2) then
    return string.format(' %s %s.. ', icon, fname:sub(1, availableTabSpace - 6))
  else
    local pad = (availableTabSpace - stringLenght) / 2
    local balancer = math.fmod(stringLenght, 2)
    return string.format('%s%s %s%s', string.rep(' ', pad), icon, fname, string.rep(' ', pad + balancer))
  end
end

local generateTab = function(tabNr, isSelected)
  local buflist = vim.fn.tabpagebuflist(tabNr)
  local winnr = vim.fn.tabpagewinnr(tabNr)
  local isModified = vim.api.nvim_buf_get_option(buflist[winnr], 'modified')
  local barIcon = (isSelected and icon_provider.icons.line_double or icon_provider.icons.line_l)
  local barHl = (isSelected and '%#KisslineTabSeparatorActive#' or '%#KisslineTabSeparatorInactive#')
  local tabHl = (isSelected and '%#KisslineTabActive#' or '%#KisslineTabInactive#')
  local buttonHl = (vim.fn.tabpagenr('$') == 1 and '%#KisslineTabActiveDim#' or '')
  local buttonClose = buttonHl .. '%' .. tabNr .. 'X' .. icon_provider.icons.close .. ' %X'
  local modifiedIcon = icon_provider.icons.dot .. ' '

  if tab_style == 'angel_bar' then
    return '%'..tabNr..'T'..barHl..''
      ..tabHl..getTabName(buflist[winnr], isSelected, tabHl)
      ..(isModified and modifiedIcon or buttonClose)..barHl..''..'%T'
  else
    return '%'..tabNr..'T'..barHl..barIcon
      ..tabHl..getTabName(buflist[winnr], isSelected, tabHl)
      ..(isModified and modifiedIcon or buttonClose)..'%#KisslineTabLine#'..'%T'
  end
end

local function generateWinTab(buf, win, isSelected)
  local tabHl = isSelected and 'KisslineWinbarActive' or 'KisslineWinbarInactive'
  local barHl = isSelected and 'KisslineWinbarSeparatorActive' or 'KisslineWinbarSeparatorInactive'
  local dot = at.withHl(' ● ', isSelected and 'KisslineWinbarActive' or 'KisslineWinbarActiveDim')
  local buttonClose = at.withHl('  ', 'KisslineWinbarActiveDim')
  local isModified = vim.api.nvim_buf_get_option(buf, 'modified')

  return string.format(
    '%s%s%s%%#KisslineWinbarLine#',
    at.clicable(at.withHl('⏽', barHl), 'kissline_focus_win', win),
    at.clicable(at.withHl(getTabName(buf, isSelected, tabHl), tabHl), 'kissline_focus_win', win),
    at.clicable(isModified and dot or buttonClose, 'close_win', win)
  )
end

local tabs = function()
  local i = 1
  local tabs = '%#KisslineTabLine#'
  while i <= vim.fn.tabpagenr('$') do
    if is_tab_truncate(i) == false then
      tabs = tabs .. generateTab(i, i == vim.fn.tabpagenr())
    end
    i = i + 1
  end
  if tab_style == 'default' then
    tabs = tabs .. '%#KisslineTabSeparatorInactive#' .. icon_provider.icons.line_l
  end

  return tabs .. '%#KisslineTabLine#'
end

local layout = function()
  local line = ''
  line = line .. tabs()
  if vim.fn.tabpagenr('$') > tabsCanFit then
    line = line .. '%=%#KisslineTabActive# ' .. vim.fn.tabpagenr() .. '/' .. vim.fn.tabpagenr('$') .. ' '
  end
  return line
end
-- vim.cmd[[
-- set tabline=%!kissline#_tab_layout()
-- lua require('kissline.theme.one').init()
-- ]]

-- return luaeval("require('kissline.tab').layout()")
-- lua require('kissline.tab').togglePadding('left')

-- local togglePadding = function (side)
--   if side == 'left' then
--     paddingLeft = not paddingLeft
--     vim.cmd[[set tabline=%!kissline#_tab_layout()]]
--   end
-- end

return {
  layout = layout,
  setTabConfigs = function(opts)
    tab_style = opts.tab_style
  end,
  onWindowResize = function()
    local width = vim.api.nvim_get_option('columns') - 6
    tabsCanFit = math.floor(width / maxTabLenght)
  end,
  generateWinTab = generateWinTab,
}
