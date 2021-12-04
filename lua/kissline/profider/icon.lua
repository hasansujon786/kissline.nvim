local M = {}

M.fileIcon = function(bufnr, isSelected, section_hl)
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then return '' end

  local devhl, divIcon = '', ''
  local f_name, f_extension = vim.fn.expand '%:t', vim.fn.expand '%:e'
  f_extension = f_extension ~= '' and f_extension or vim.bo.filetype

  local buftype = vim.fn.getbufvar(bufnr, '&buftype')
  local filetype = vim.fn.getbufvar(bufnr, '&filetype')

  if filetype == 'TelescopePrompt' then
    divIcon, devhl = '', 'DevIconDefault'
  elseif filetype == 'fugitive' then
    divIcon, devhl = devicons.get_icon('git')
  elseif filetype == 'vimwiki' then
    divIcon, devhl = devicons.get_icon('markdown')
  elseif buftype == 'terminal' then
    divIcon, devhl = devicons.get_icon('zsh')
  else
    divIcon, devhl = devicons.get_icon(f_name, f_extension, {default = true})
  end

  if isSelected and section_hl then
    return '%#' .. devhl.. '#' .. divIcon .. section_hl
  else
    return divIcon
  end
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
  left_trunc_marker = '',
  right_trunc_marker = '',
  close = '',
  line_double = '‖',
  line_l = '▎'
}

return M
