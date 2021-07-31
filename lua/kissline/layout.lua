local components = require('kissline.components')
local utils = require('kissline.utils')
local hl = {
  default = {
    active   = {bg = '#2C323C', fg = '#717785'},
    inactive = {bg = '#3E4452', fg = '#3E4452'},
  }
}

local function generate_highlights(component_name, component, next_cp, is_active)
  local use_mode_hl = utils.get_default(component.use_mode_hl, false)
  local hl_state = is_active and 'active' or 'inactive'
  local hl_cp = use_mode_hl and hl.default[hl_state] or utils.get_default(component.hl, hl.default[hl_state])
  local sp_hi_name = ''
  local cp_hi_name = ''

  if use_mode_hl then
    cp_hi_name = string.format('Kissline_cur_mode_%s', hl_state)
    sp_hi_name = string.format('Kissline_cur_mode_sp_%s', hl_state)
  else
    cp_hi_name = string.format('Kissline_%s_%s', hl_state, component_name)
    sp_hi_name = string.format('Kissline_sp_%s_%s', hl_state, component_name)

    -- component hi
    vim.cmd(string.format('hi %s guibg=%s guifg=%s', cp_hi_name, hl_cp.bg, hl_cp.fg))

    -- separatedn hi
    local next_hl = next_cp and utils.get_default(components[next_cp].hl, hl.default[hl_state]) or hl.default[hl_state]
    vim.cmd(string.format('hi %s guibg=%s guifg=%s', sp_hi_name, next_hl.bg, hl_cp.bg))
  end

  return cp_hi_name, sp_hi_name
end

local function generate_component(component_name, component, highlights, is_active)
  if type(component.fn) == 'string' then
    return component.fn
  elseif component.raw then
    return ' '..component.fn(highlights, is_active).. ' '
  elseif type(component.toggle) == 'function' then
    return string.format(
      [[%%{luaeval('require("kissline.components").%s.toggle()')?luaeval('require("kissline.components").%s.fn()'):''}]],
      component_name, component_name
    )
  else
    return string.format([[ %%{luaeval('require("kissline.components").%s.fn()')} ]], component_name)
  end
end

local function generate_section(component_name, side, next_cp, is_active)
  local component = components[component_name]
  local separtor = utils.get_default(component.separator, nil)
  local line = ''

  local cp_hi_name, sp_hi_name = generate_highlights(component_name, component, next_cp, is_active)
  local cp_generated = generate_component(component_name, component, {cp_hi_name, sp_hi_name}, is_active)

  -- separtor left
  if side == 'right' and separtor then
    line = line .. '%#'..sp_hi_name..'#'
    line = line .. component.separator[1]
  end
  -- component
  line = line .. '%#'..cp_hi_name..'#'
  line = line .. cp_generated
  -- separator right
  if side == 'left' and separtor then
    line = line .. '%#'..sp_hi_name..'#'
    line = line .. component.separator[2]
  end

  return line
end

local layout_active = {
  {'mode', 'spell', 'readonly', 'wrap', 'arrow_separator', 'filename_with_icon'},
  {'harpoon', 'get_lsp_client', 'git_branch',  'space_width', 'filetype', 'scroll_info', 'line_info'}
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
