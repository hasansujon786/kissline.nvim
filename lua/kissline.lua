local utils = require('kissline.utils')
local configs = require('kissline.configs')
-- local layout = require('kissline.layout')

return {
  setup = function(opts)
    opts = opts and opts or {}
    opts.disable_line = utils.get_default(opts.disable_line, false)
    opts.disable_tab = utils.get_default(opts.disable_tab, false)
    opts.eneble_winbar = utils.get_default(opts.eneble_winbar, false)
    opts.tab_style = utils.get_default(opts.tab_style, 'default')
    vim.g.loaded_kissline_sline = not opts.disable_line
    vim.g.loaded_kissline_tline = not opts.disable_tab
    configs.options = opts

    if opts.eneble_winbar then
      require('kissline.winbar').init()
      vim.fn['kissline#_init_winbar_autocommands']()
    end
    if not opts.disable_tab then
      require('kissline.tab').setTabConfigs(opts)
      vim.fn['kissline#_init_tline_autocommands']()
    end
    require('kissline.theme.one').init(opts)
    if not opts.disable_line then
      vim.fn['kissline#_init_sline_autocommands']()
    end
  end,
}
