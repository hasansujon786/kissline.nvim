-- local file_provider = require('kissline.profider.file')
-- local icon_provider = require('kissline.profider.icon')
-- local navic = require('nvim-navic')
local tab = require('kissline.tab')
local utils = require('kissline.utils')
local configs = require('kissline.configs')
local at = require('kissline.utils.atoms')

local api = vim.api
local fn = vim.fn
-- state
local active_win = 0

local function update_cur_win(shouldCheckFloat)
  if utils.is_floting_window(0) and shouldCheckFloat then
    vim.defer_fn(function()
      update_cur_win(false)
    end, 1)
    return
  end

  active_win = api.nvim_get_current_win()
end

local function generateWinTab(buf, win, isActive)
  local isModified = vim.api.nvim_buf_get_option(buf, 'modified')
  local tabHl = isActive and 'KisslineWinbarActive' or 'KisslineWinbarInactive'
  local barHl = isActive and 'KisslineWinbarIndicatorActive' or 'KisslineWinbarIndicatorInactive'
  local dot = at.withHl('●', isActive and 'KisslineWinbarModified' or 'KisslineWinbarItemInactive')
  local buttonClose = at.withHl('', isActive and 'KisslineWinbarItemActive' or 'KisslineWinbarItemInactive')

  local custon_winbar = configs.options.custon_winbar[vim.bo.filetype]
  if custon_winbar then
    local data = custon_winbar()
    return string.format(
      '%s%s%s%s%s',
      data[3] and at.clicable(at.withHl('▎', barHl), 'kissline_focus_win', win) or '',
      at.clicable(at.withHl(data[1], data[2]), 'kissline_focus_win', win),
      data[4] and at.clicable(isModified and dot or buttonClose, 'close_win', win) or '',
      data[5] and at.withHl('▕', 'KisslineWinbarSeparator') or '',
      data[6] and data[6] or ''
    )
  end

  return string.format(
    '%s%s%s%s%%#KisslineWinbarLine#',
    at.clicable(at.withHl('▎', barHl), 'kissline_focus_win', win),
    at.clicable(at.withHl(tab.getTabName(buf, isActive, tabHl), tabHl), 'kissline_focus_win', win),
    at.clicable(isModified and dot or buttonClose, 'close_win', win),
    at.withHl('▕', 'KisslineWinbarSeparator')
  )
end

local function layout()
  -- local fname = file_provider.filename(buf)
  -- local icon = icon_provider.fileIcon(buf, true, '')
  -- local separator = ' > '
  -- local location = navic.get_location()
  -- local has_location = location ~= ''
  -- return ' ' .. icon .. ' ' .. fname .. ' ' .. location
  -- return string.format(' %s %s%s%s', icon, fname, has_location and separator or '', location)

  local win = api.nvim_get_current_win()
  local buf = api.nvim_get_current_buf()
  return generateWinTab(buf, win, win == active_win)
end

_G.close_win = function(win, count, button, mod)
  if button ~= 'l' then
    return
  end

  local ok_close = pcall(api.nvim_win_close, win, true)
  if not ok_close then
    local ok_quit = pcall(vim.cmd, 'quit')
    if not ok_quit then
      vim.notify('E37: Some file has not been saved since last change', vim.log.levels.WARN)
    end
  end
end

_G.kissline_focus_win = function(win, count, button, mod)
  local rename = configs.options.actions.rename
  if button == 'l' and count == 2 and rename.eneble and utils.is_fn(rename.fn) then
    rename.fn(win)
    return
  end
  if button == 'l' and count == 1 then
    api.nvim_set_current_win(win)
  end
end

return {
  update_cur_win = update_cur_win,
  layout = layout,
  init = function()
    active_win = api.nvim_get_current_win()
    vim.o.winbar = '%{%v:lua.require("kissline.winbar").layout()%}'
  end,
}
