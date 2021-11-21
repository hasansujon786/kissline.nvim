local utils = require('kissline.utils')
-- local layout = require('kissline.layout')

-- local update = {
--   all = function ()
--     -- vim.opt.statusline = layout.active()
--     -- vim.opt.statusline = layout.inactive()
--   end
-- }

-- local autocmds = {
--   Kissline = {
--     {'WinEnter', '*', update.all()}
--   }
-- }

-- local initColors = function ()
--   local highlight_colors={
--     normal  = '#98C379',
--     insert  = '#61AFEF',
--     terminal= '#61AFEF',
--     visual  = '#C678DD',
--     replace = '#E06C75',
--   }

--   for k, v in pairs(highlight_colors) do
--     vim.cmd(string.format('hi Kissline_mode_%s    guifg=#2C323C guibg=%s gui=bold', k, v))
--     vim.cmd(string.format('hi Kissline_mode_sp_%s guifg=%s guibg=#3E4452 gui=bold', k, v))
--   end

-- end
-- initColors()

return {
  setup = function (opts)
    vim.g.loaded_kissline = true
    opts = opts and opts or {}
    opts.tab_style = utils.get_default(opts.tab_style, 'default')

    require('kissline.tab').setTabConfigs(opts)
    require('kissline.theme.one').init(opts)
    vim.fn['kissline#_init_autocommands']()
  end
}


