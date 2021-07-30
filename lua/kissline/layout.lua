local components = require('kissline.components')
local M = {}

local function generate_section(component_name, side)
  local spIdx = side == 'left' and 2 or 1
  vim.cmd('hi Kissline_'.. component_name ..' '.. components[component_name].hl)

  local line = ''
  line = line .. '%#'..'Kissline_'.. component_name ..'#'

  if side == 'right' then
    line = line .. components[component_name].separator[spIdx]
  end

  line = line .. [[%{luaeval('require("kissline.components").]] .. component_name ..[[.fn()')}]]

  if side == 'left' then
    line = line .. components[component_name].separator[spIdx]
  end
  -- line = line .. [[%{luaeval('require("kissline.components").component_decorator')]]..'("'..component_name..'")}'
  return line
end

-- P(generate_section('get_lsp_client'))
local layout_active = {
  {'mode'},
  {'get_lsp_client', 'harpoon'}
}


M.active = function ()
  -- return components.get_lsp_client()
  local sline = ''
  for _, cn in ipairs(layout_active[1]) do
    sline = sline ..generate_section(cn, 'left')
  end
  local sline = sline .."%=" -- (Middle) align from right
  local sline = sline .."%<" -- truncate left

  for _, cn in ipairs(layout_active[2]) do
    sline = sline ..generate_section(cn, 'right')
  end
  return sline
end

return M
