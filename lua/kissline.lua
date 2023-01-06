local utils = require('kissline.utils')
local configs = require('kissline.configs')

return {
  setup = function(opts)
    opts = utils.merge(configs.default, opts or {})
    configs.updateConfigs(opts)

    if opts.eneble_winbar then
      require('kissline.winbar').init()
      vim.fn['kissline#_init_winbar_autocommands']()
    end
    if opts.eneble_tab then
      require('kissline.tab').setTabConfigs(opts)
      vim.fn['kissline#_init_tline_autocommands']()
    end
    require('kissline.theme.one').init(opts)
    if opts.eneble_line then
      vim.fn['kissline#_init_sline_autocommands']()
    end
  end,
}
