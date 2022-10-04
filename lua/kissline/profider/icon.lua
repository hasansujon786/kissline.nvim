local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
  return ''
end
local hl = require('kissline.utils.hl')

local M = {}

M.fileIcon = function(bufnr, isColored, section_hl)
  local devIcon, icon_fg = '', ''
  local bufname = vim.fn.bufname(bufnr)
  local f_name, f_extension = vim.fn.fnamemodify(bufname, ':t'), vim.fn.fnamemodify(bufname, ':e')
  f_extension = f_extension ~= '' and f_extension or vim.bo.filetype

  -- devIcon, devhl = devicons.get_icon(f_name, f_extension, { default = true })
  devIcon, icon_fg = devicons.get_icon_color(f_name, f_extension, { default = true })

  if isColored and section_hl then
    local icon_hl_group = 'KisslineFileIcon' .. f_extension
    if vim.fn.hlexists(icon_hl_group) == 0 then
      hl.createhighlight(icon_hl_group, icon_fg, hl.extract_highlight_colors(section_hl, 'bg'))
    end
    return hl.format_hl(icon_hl_group) .. devIcon .. hl.format_hl(section_hl)
  else
    return devIcon
  end
end

M.icons = {
  lock = '',
  checking = '',
  warning = '',
  error = '',
  ok = '',
  info = '',
  hint = '',
  line = '',
  dic = '',
  wrap = '蝹',
  cup = '',
  search = '',
  dot = '●',
  pomodoro = '',
  left_trunc_marker = '',
  right_trunc_marker = '',
  close = '',
  line_double = '‖',
  line_l = '▎',
  -- line_double = '⏽',
  -- line_l = '░'
}

return M
