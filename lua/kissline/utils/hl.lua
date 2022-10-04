local M = {}

function M.createhighlight(name, foreground, background, gui)
  local command = { 'highlight', name }
  if foreground and foreground ~= 'none' then
    table.insert(command, 'guifg=' .. foreground)
  end
  if background and background ~= 'none' then
    table.insert(command, 'guibg=' .. background)
  end
  if gui and gui ~= 'none' then
    table.insert(command, 'gui=' .. gui)
  end
  vim.cmd(table.concat(command, ' '))
end

function M.extract_highlight_colors(color_group, scope)
  if vim.fn.hlexists(color_group) == 0 then
    return nil
  end
  local color = vim.api.nvim_get_hl_by_name(color_group, true)
  if color.background ~= nil then
    color.bg = string.format('#%06x', color.background)
    color.background = nil
  end
  if color.foreground ~= nil then
    color.fg = string.format('#%06x', color.foreground)
    color.foreground = nil
  end
  if scope then
    return color[scope]
  end
  return color
end

function M.format_hl(hl_group)
  return '%#' .. hl_group .. '#'
end

return M
