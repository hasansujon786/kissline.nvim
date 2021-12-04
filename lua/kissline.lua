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
    opts = opts and opts or {}
    opts.tab_style = utils.get_default(opts.tab_style, 'default')
    opts.disable_line = utils.get_default(opts.disable_line, false)
    opts.disable_tab = utils.get_default(opts.disable_tab, false)
    vim.g.loaded_kissline_sline = not opts.disable_line
    vim.g.loaded_kissline_tline = not opts.disable_tab

    if not opts.disable_tab then
      require('kissline.tab').setTabConfigs(opts)
      vim.fn['kissline#_init_tline_autocommands']()
    end
    require('kissline.theme.one').init(opts)
    if not opts.disable_line then
      vim.fn['kissline#_init_sline_autocommands']()
    end

  end
}


