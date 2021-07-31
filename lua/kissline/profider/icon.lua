local M = {}

local highlight = function(name, foreground, background)
  local command = {'highlight', name}
  if foreground and foreground ~= 'none' then
    table.insert(command, 'guifg=' .. foreground)
  end
  if background and background ~= 'none' then
    table.insert(command, 'guibg=' .. background)
  end
  vim.cmd(table.concat(command, ' '))
end

local create_component_highlight_group = function(color, highlight_tag)
  if color.bg and color.fg then
    local highlight_group_name = table.concat({'luatab', highlight_tag}, '_')
    highlight(highlight_group_name, color.fg, color.bg)
    return highlight_group_name
  end
end

local extract_highlight_colors = function(color_group, scope)
  if vim.fn.hlexists(color_group) == 0 then return nil end
  local color = vim.api.nvim_get_hl_by_name(color_group, true)
  if color.background ~= nil then
    color.bg = string.format('#%06x', color.background)
    color.background = nil
  end
  if color.foreground ~= nil then
    color.fg = string.format('#%06x', color.foreground)
    color.foreground = nil
  end
  if scope then return color[scope] end
  return color
end

M.get_devicon = function(bufnr, isSelected, section_hl)
  local dev, devhl
  local file = vim.fn.bufname(bufnr)
  local buftype = vim.fn.getbufvar(bufnr, '&buftype')
  local filetype = vim.fn.getbufvar(bufnr, '&filetype')
  if filetype == 'TelescopePrompt' then
    dev, devhl = require'nvim-web-devicons'.get_icon('telescope')
  elseif filetype == 'fugitive' then
    dev, devhl = require'nvim-web-devicons'.get_icon('git')
  elseif filetype == 'vimwiki' then
    dev, devhl = require'nvim-web-devicons'.get_icon('markdown')
  elseif buftype == 'terminal' then
    dev, devhl = require'nvim-web-devicons'.get_icon('zsh')
  else
    dev, devhl = require'nvim-web-devicons'.get_icon(file, vim.fn.expand('#'..bufnr..':e'), {default=true})
  end
  if dev then
    local fg = extract_highlight_colors(devhl, 'fg')
    local bg = extract_highlight_colors(section_hl, 'bg')
    local hl = create_component_highlight_group({bg = bg, fg = fg}, devhl)
    return (isSelected and '%#'..hl..'#' or '') .. dev .. '%#'..section_hl..'#'
    -- return (isSelected and '%#'..hl..'#' or '') .. dev .. (isSelected and '%#TabLineSel#' or '') .. ' '
  end
  return ''
end

-- P(M.tabDevicon(vim.api.nvim_get_current_buf(), true))

M.icons = {
  lock = '',
  checking = '',
  warning = '',
  error = '',
  ok = '',
  info = '',
  hint = '',
  line = '',
  dic  = '',
  wrap = '蝹',
  cup = '',
  search = '',
  dot =  '●',
  pomodoro = '',
}

return M
