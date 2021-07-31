local components = require('kissline.components')
local utils = require('kissline.utils')
local default_hl = {bg = '#2C323C', fg = '#717785'}
local default_hl_inactive = { bg='#ff0000', fg='#ABB2BF'}

local function generate_highlights(component_name, highlight, next_cp, is_active)
  local hl_state = is_active and 'active' or 'inactive'

  -- component hi
  vim.cmd(string.format('hi Kissline_%s_%s guibg=%s guifg=%s', hl_state, component_name, highlight.bg, highlight.fg))

  -- separatedn hi
  local next_hl = next_cp and utils.get_default(components[next_cp].hl, default_hl) or default_hl
  vim.cmd(string.format('hi Kissline_sp_%s_%s guibg=%s guifg=%s', hl_state, component_name, next_hl.bg, highlight.bg))
end

local function generate_component(component_name, component)
  if type(component.fn) == 'string' then
    return ' '.. component.fn .. ' '
  else
    return [[ %{luaeval('require("kissline.components").]] .. component_name ..[[.fn()')} ]]
  end
end

local function generate_section(component_name, side, next_cp, is_active)
  local component = components[component_name]
  local separtor = utils.get_default(component.separator, nil)
  local use_mode_hl = utils.get_default(component.use_mode_hl, false)
  local highlight = use_mode_hl and default_hl or utils.get_default(component.hl, default_hl)
  local hl_state = is_active and 'active' or 'inactive'
  local line = ''

  generate_highlights(component_name, highlight, next_cp, is_active)
  local sp_hi_name = use_mode_hl and '%#Kissline_cur_mode_sp_'..hl_state..'#' or '%#Kissline_sp_'..hl_state..'_'..component_name..'#'
  local cp_hi_name = use_mode_hl and '%#Kissline_cur_mode_'..hl_state..'#' or '%#Kissline_'..hl_state..'_'..component_name..'#'
  local cp_generated = generate_component(component_name, component)

  -- separtor left
  if side == 'right' and separtor then
    line = line .. sp_hi_name
    line = line .. component.separator[1]
  end
  -- component
  line = line .. cp_hi_name
  line = line .. cp_generated
  -- separator right
  if side == 'left' and separtor then
    line = line .. sp_hi_name
    line = line .. component.separator[2]
  end

  return line
end

local layout_active = {
  {'mode', 'filename_with_icon'},
  {'harpoon', 'get_lsp_client', 'space_width', 'filetype', 'scroll_info', 'line_info'}
}
local layout_inactive = {
  {'filename_with_icon'},
  {'scroll_info'}
}


local function active ()
  local sline = '%{kissline#_update_color()}'
  for idx, cn in ipairs(layout_active[1]) do
    sline = sline ..generate_section(cn, 'left', layout_active[1][idx + 1], true)
  end
  local sline = sline .."%=" -- (Middle) align from right
  local sline = sline .."%<" -- truncate left

  for idx, cn in ipairs(layout_active[2]) do
    sline = sline ..generate_section(cn, 'right', layout_active[2][idx - 1], true)
  end
  return sline
end

local function inactive ()
  local sline = ''
  for idx, cn in ipairs(layout_inactive[1]) do
    sline = sline ..generate_section(cn, 'left', layout_inactive[1][idx + 1], false)
  end
  local sline = sline .."%=" -- (Middle) align from right
  local sline = sline .."%<" -- truncate left

  for idx, cn in ipairs(layout_inactive[2]) do
    sline = sline ..generate_section(cn, 'right', layout_inactive[2][idx - 1], false)
  end
  return sline
end




return {
  active = active,
  inactive = inactive
}
