local M = {}

M.default = {
  eneble_line = false,
  eneble_tab = false,
  eneble_winbar = true,
  -- tab_style = 'angel_bar',
  actions = {
    rename = {
      eneble = false,
      fn = nil,
    },
  },
}

M.options = M.default

M.updateConfigs = function(opts)
  M.options = opts
end

return M
