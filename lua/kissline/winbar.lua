-- local file_provider = require('kissline.profider.file')
-- local icon_provider = require('kissline.profider.icon')
-- local navic = require('nvim-navic')
local tab = require('kissline.tab')

local api = vim.api
local fn = vim.fn
-- state
local active_win = 0
-- TODO: <05.10.22> get active_win proper way

local function update_cur_win()
  active_win = api.nvim_get_current_win()
end

local function layout()
  -- print(vim.fn.localtime())
  local win = api.nvim_get_current_win()
  local buf = api.nvim_get_current_buf()

  local t = tab.generateWinTab(buf, win == active_win, 1)
  return t

  -- local fname = file_provider.filename(buf)
  -- local icon = icon_provider.fileIcon(buf, true, '')
  -- local separator = ' > '
  -- local location = navic.get_location()
  -- local has_location = location ~= ''
  -- return ' ' .. icon .. ' ' .. fname .. ' ' .. location
  -- return string.format(' %s %s%s%s', icon, fname, has_location and separator or '', location)
end

-- vim.cmd[[hi KisslineTabActive guibg=#3E4452]]

return {
  update_cur_win = update_cur_win,
  layout = layout,
  init = function()
    active_win = api.nvim_get_current_win()
    vim.o.winbar = '%{%v:lua.require("kissline.winbar").layout()%}'
  end,
}
