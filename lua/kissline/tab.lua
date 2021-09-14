local file_provider = require('kissline.profider.file')
local icon_provider = require('kissline.profider.icon')
local utils = require('kissline.utils')
local maxLenght = 20

local getTabName = function (bufNr)
  local tabName = file_provider.filename(bufNr)
  local stringLenght = tabName:len()

  if stringLenght > maxLenght then
    return tabName:sub(1, maxLenght - 2) .. '..'
  elseif stringLenght < maxLenght then
    return tabName .. string.rep(' ', maxLenght - stringLenght)
  end
  return tabName
end

local generateTab = function(tabNr, isSelected)
  local buflist = vim.fn.tabpagebuflist(tabNr)
  local winnr = vim.fn.tabpagewinnr(tabNr)
  local isModified = vim.api.nvim_buf_get_option(buflist[winnr], 'modified')
  local fileIcon = utils.fileIcon()
  local barIcon = icon_provider.icons.line_double
  local barHl = (isSelected and '%#KisslineBarActive#' or '%#KisslineBar#')
  local tabHl = (isSelected and '%#KisslineTabActive#' or '%#KisslineTab#')
  local buttonClose = '%'..tabNr..'X'..icon_provider.icons.close..'%X'
  local modified = icon_provider.icons.dot
  local label = {
    '%'..tabNr..'T'..barHl.. barIcon ..  tabHl,
    tabNr,
    fileIcon,
    getTabName(buflist[winnr]),
    (isModified and modified or buttonClose),
    '%#KisslineTabLine#'..'%T',
  }

  return table.concat(label, ' ')
end

local tabs = function()
  local i = 1
  local tabs = '%#KisslineTabLine#'
  while i <= vim.fn.tabpagenr('$') do
    tabs = tabs ..  generateTab(i, i == vim.fn.tabpagenr())
    i = i + 1
  end
  return tabs .. icon_provider.icons.line_l
end

local layout = function()
  local line = ''
  line = line .. tabs()
  return line
end
-- vim.cmd[[
-- set tabline=%!kissline#_tab_layout()
-- call TablineApplyColors()
-- ]]

return {
  layout = layout
}
