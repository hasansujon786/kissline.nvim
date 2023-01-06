-- local file_provider = require('kissline.profider.file')
-- local icon_provider = require('kissline.profider.icon')
-- local navic = require('nvim-navic')
local tab = require('kissline.tab')
local utils = require('kissline.utils')
local configs = require('kissline.configs')

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
  return tab.generateWinTab(buf, win, win == active_win)
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
