local M = {}

M.default = {
  eneble_line = false,
  eneble_tab = false,
  eneble_winbar = true,
  custon_winbar = {
    -- { title[1], tabHL[2], showActiveBar[3], showCloseBtn[4], showEndBar[5] }
    NvimTree = function()
      return { '         EXPLORER         ', 'NvimTreeWinBar', false, false, false }
    end,
  },
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
