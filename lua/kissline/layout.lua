local components = require('kissline.components')
local utils = require('kissline.utils')
local default_hl = {bg = '#2C323C', fg = '#717785'}
local M = {}

local function generate_section(component_name, side, next_cn)
  local component = components[component_name]
  local separtor = utils.get_default(component.separator, nil)
  local highlight = nil
  local line = ''

  -- setting up compnent hi
  if component.hl == true then
    highlight = default_hl
  else
    highlight = utils.get_default(component.hl, default_hl)
    vim.cmd(string.format('hi Kissline_%s guibg=%s guifg=%s', component_name, highlight.bg, highlight.fg))
  end

  if next_cn then
    local next_component = components[next_cn]
    local next_hl = utils.get_default(next_component.hl, default_hl)
    vim.cmd(string.format('hi Kissline_sp_%s guibg=%s guifg=%s', component_name, next_hl.bg, highlight.bg))
  else
    vim.cmd(string.format('hi Kissline_sp_%s guibg=%s guifg=%s', component_name, default_hl.bg, highlight.bg))
  end

  if side == 'right' and separtor then
    if component.hl == true then
      line = line .. '%#Kissline_mode_sp#'
      else
      line = line .. '%#'..'Kissline_sp_'.. component_name ..'#'
    end
    line = line .. component.separator[1]
  end

  if component.hl == true then
    line = line .. '%#Kissline_mode#'
    else
    line = line .. '%#'..'Kissline_'.. component_name ..'#'
  end

  if type(component.fn) == 'string' then
    line = line .. component.fn
  else
    line = line .. [[ %{luaeval('require("kissline.components").]] .. component_name ..[[.fn()')} ]]
  end

  if side == 'left' and separtor then
    if component.hl == true then
      line = line .. '%#Kissline_mode_sp#'
      line = line .. '%#Kissline_mode_sp#'
      else
      line = line .. '%#'..'Kissline_sp_'.. component_name ..'#'
    end
    line = line .. component.separator[2]
  end
  -- line = line .. [[%{luaeval('require("kissline.components").component_decorator')]]..'("'..component_name..'")}'
  return line
end

-- P(generate_section('get_lsp_client'))
local layout_active = {
  {'mode', 'filename_with_icon'},
  {'harpoon', 'get_lsp_client', 'space_width', 'filetype', 'scroll_info', 'line_info'}
}


M.active = function ()
  -- return components.get_lsp_client()
  local sline = '%{kissline#_update_color_lua()}'
  for idx, cn in ipairs(layout_active[1]) do
    sline = sline ..generate_section(cn, 'left', layout_active[1][idx + 1])
  end
  local sline = sline .."%=" -- (Middle) align from right
  local sline = sline .."%<" -- truncate left

  for idx, cn in ipairs(layout_active[2]) do
    sline = sline ..generate_section(cn, 'right', layout_active[2][idx - 1])
  end
  return sline
end

return M
