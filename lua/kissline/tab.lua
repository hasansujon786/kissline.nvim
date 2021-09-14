local file_provider = require('kissline.profider.file')
local icon_provider = require('kissline.profider.icon')
local utils = require('kissline.utils')

-- state
local maxTabLenght = 27
local tabsCanFit = 4
-- local paddingLeft = false

local getVisibleTabsIdx = function()
  local currentTabNr = vim.fn.tabpagenr()
  local visible_tabs = {currentTabNr}
  local left = 0
  local right = 0

  if currentTabNr > tabsCanFit then
    right = 0
    left =  tabsCanFit - 1
  elseif currentTabNr <= tabsCanFit then
    right = tabsCanFit - currentTabNr
    left = tabsCanFit - (right + 1)
  end

  for i=1, left do
    table.insert(visible_tabs, currentTabNr - i)
  end
  for i=1, right do
    table.insert(visible_tabs, currentTabNr + i)
  end
  return {visible_tabs, left, right}
end
local is_tab_truncate = function(tabNr)
  local v_tabs_idx = getVisibleTabsIdx()[1]
  return vim.fn.index(v_tabs_idx, tabNr) == -1 and true or false
end

local getTabName = function (bufNr)
  local fileIcon = utils.fileIcon()
  local tabName = fileIcon..' '..file_provider.filename(bufNr)
  local stringLenght = tabName:len()

  if stringLenght > maxTabLenght then
    return tabName:sub(1, maxTabLenght - 2) .. '..'
  elseif stringLenght < maxTabLenght then
    local pad = (maxTabLenght - stringLenght)/2
    table.insert(vim.g.foo, pad)
    return string.rep(' ', pad - math.fmod(stringLenght, 2)) .. tabName .. string.rep(' ', pad)
  end
  return tabName
end

local generateTab = function(tabNr, isSelected)
  local buflist = vim.fn.tabpagebuflist(tabNr)
  local winnr = vim.fn.tabpagewinnr(tabNr)
  local isModified = vim.api.nvim_buf_get_option(buflist[winnr], 'modified')
  local barIcon = (isSelected and icon_provider.icons.line_double or icon_provider.icons.line_l)
  local barHl = (isSelected and '%#KisslineTabSeparatorActive#' or '%#KisslineTabSeparator#')
  local tabHl = (isSelected and '%#KisslineTabActive#' or '%#KisslineTab#')
  local buttonHl = (vim.fn.tabpagenr('$') == 1 and '%#KisslineTabItemInactive#' or '')
  local buttonClose = buttonHl..'%'..tabNr..'X'..icon_provider.icons.close..' %X'
  local modifiedIcon = icon_provider.icons.dot..' '

  return '%'..tabNr..'T'..barHl..barIcon
    ..tabHl.. getTabName(buflist[winnr])
    ..(isModified and modifiedIcon or buttonClose)..'%#KisslineTabLine#'..'%T'
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
  return tabs .. '%#KisslineTabSeparator#'..icon_provider.icons.line_l
end

local layout = function()
  local line = ''
  line = line .. tabs()
  if vim.fn.tabpagenr('$') > tabsCanFit then
    line = line .. '%=%#KisslineTabActive# '..vim.fn.tabpagenr()..'/'..vim.fn.tabpagenr('$')..' '
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
}
