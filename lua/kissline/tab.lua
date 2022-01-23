local file_provider = require('kissline.profider.file')
local icon_provider = require('kissline.profider.icon')

-- state
local maxTabLenght = 27
local tabsCanFit = 4
local tab_style = 'default'

local show_project_tab = false
local current_tab_list = {}
local selected_tab = nil

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

local getTabName = function (bufNr, isSelected, section_hl)
  local fname = file_provider.filename(bufNr)
  local icon = icon_provider.fileIcon(bufNr, isSelected, section_hl)
  local stringLenght = fname:len() + 2
  local availableTabSpace = maxTabLenght - 3        -- 3 spaces used by cross & indicator icon

  if stringLenght > (availableTabSpace - 2) then
    return string.format(' %s %s.. ', icon, fname:sub(1, availableTabSpace - 6))
  else
    local pad = (availableTabSpace - stringLenght)/2
    local balancer =  math.fmod(stringLenght, 2)
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
  local buttonClose = buttonHl..'%'..tabNr..'X'..icon_provider.icons.close..' %X'
  local modifiedIcon = icon_provider.icons.dot..' '

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

local generate_styled_tab = function(tab)
  -- local fname = file_provider.filename(tab.bufnr)
  -- return fname
  local buflist = vim.fn.tabpagebuflist(tab.tabnr)
  local winnr = vim.fn.tabpagewinnr(tab.tabnr)
  local isModified = vim.api.nvim_buf_get_option(buflist[winnr], 'modified')
  local barIcon = (tab.is_selected and icon_provider.icons.line_double or icon_provider.icons.line_l)
  local barHl = (tab.is_selected and '%#KisslineTabSeparatorActive#' or '%#KisslineTabSeparatorInactive#')
  local tabHl = (tab.is_selected and '%#KisslineTabActive#' or '%#KisslineTabInactive#')
  local buttonHl = (vim.fn.tabpagenr('$') == 1 and '%#KisslineTabActiveDim#' or '')
  local buttonClose = buttonHl..'%'..tab.tabnr..'X'..icon_provider.icons.close..' %X'
  local modifiedIcon = icon_provider.icons.dot..' '

  if tab.is_selected then
    selected_tab = tab
  end

  if tab_style == 'angel_bar' then
    return '%'..tab.tabnr..'T'..barHl..''
      ..tabHl..getTabName(buflist[winnr], tab.is_selected, tabHl)
      ..(isModified and modifiedIcon or buttonClose)..barHl..''..'%T'
  else
    return '%'..tab.tabnr..'T'..barHl..barIcon
      ..tabHl..getTabName(buflist[winnr], tab.is_selected, tabHl)
      ..(isModified and modifiedIcon or buttonClose)..'%#KisslineTabLine#'..'%T'
  end
end

function ToggleProjectTab()
  show_project_tab = not show_project_tab
  vim.cmd[[redrawtabline]]
end

local tabs = function(tab_list)
  local tabline = '%#KisslineTabLine#'
  for _, tab in ipairs(tab_list) do
      tabline = tabline .. generate_styled_tab(tab)
  end
  if tab_style == 'default' then
    tabline = tabline..'%#KisslineTabSeparatorInactive#'..icon_provider.icons.line_l
  end
  return tabline .. '%#KisslineTabLine#'
end

local layout = function()
  if show_project_tab then
    local current_project, projects = Proj_tabname_list()
    current_tab_list = current_project.tabs
  else
    current_tab_list = file_provider.all_tabname_list()
  end

  local line = ''
  line = line .. tabs(current_tab_list)
  if #current_tab_list > tabsCanFit then
    line = line .. '%=%#KisslineTabActive# '..vim.fn.tabpagenr()..'/'..#current_tab_list..' '
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
  get_current_tab_list = function()
    return current_tab_list
  end,
  layout = layout,
  setTabConfigs = function (opts)
    tab_style = opts.tab_style
  end,
  onWindowResize = function ()
    local width = vim.api.nvim_get_option('columns') - 6
    tabsCanFit = math.floor(width/maxTabLenght)
  end
}
