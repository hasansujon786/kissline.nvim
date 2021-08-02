local utils = require('kissline.utils')
local file_provider = require('kissline.profider.file')
local icon_provider = require('kissline.profider.icon')

local hi_secondary = { bg='#3E4452', fg='#ABB2BF'}

-- toggle and stirng fn need space
return  {
  mode = {
    use_mode_hl = true,
    fn = function ()
      local mode_names={
        n  = 'NORMAL',
        no = 'NORMAL·OPERATOR·PENDING',
        v  = 'VISUAL',
        V  = 'V-LINE',
        s  = 'SELECT',
        S  = 'S-LINE',
        i  = 'INSERT',
        R  = 'REPLACE',
        Rv = 'V-REPLACE',
        c  = 'NORMAL',
        cv = 'VIM EX',
        ce = 'EX',
        r  = 'PROMPT',
        rm = 'MORE',
        t  = 'TERMINAL',
        ['r?'] = 'CONFIRM',
        ['!']  = 'SHELL',
        [''] = 'V-BLOCK',
        [''] = 'S-BLOCK',
      }
      return mode_names[vim.fn.mode()]
    end,
  },
  arrow_separator = {
    use_mode_hl = true,
    separator = {'', ''},
    fn = ''
  },
  spell = {
    use_mode_hl = true,
    toggle = function ()
      return vim.fn.getbufvar(vim.api.nvim_get_current_buf(), '&spell')
    end,
    fn = function ()
      return '  '
    end,
  },
  readonly = {
    use_mode_hl = true,
    toggle = function ()
      return vim.api.nvim_buf_get_option(0, 'readonly')
    end,
    fn = function ()
      return '  '
    end,
  },
  wrap = {
    use_mode_hl = true,
    toggle = function ()
      return vim.fn.getbufvar(vim.api.nvim_get_current_buf(), '&wrap')
    end,
    fn = function ()
      return " wrap "
    end
  },
  harpoon = {
    toggle = function ()
      return require("harpoon.mark").status() ~= ''
    end,
    fn = function ()
      return  ' H:' .. require("harpoon.mark").status() ..' '
    end
  },
  line_info = {
    use_mode_hl = true,
    separator = {'', ''},
    fn = ' %3l:%-2v '
  },
  filename_with_icon = {
    hl = hi_secondary,
    -- raw = true,
    separator = {'', ''},
    fn = function (highlights, is_active)
      -- local icon = icon_provider.get_devicon(vim.api.nvim_get_current_buf(), is_active, highlights[1])
      local icon = utils.fileIcon()
      local fname = file_provider.filename(vim.api.nvim_get_current_buf())
      return string.format('%s %s', icon, fname)
    end,
  },
  scroll_info = {
    hl = hi_secondary,
    separator = {'', ''},
    fn = ' %3p%% '
  },
  filetype = {
    fn = function ()
      local ft=vim.api.nvim_buf_get_option(0, 'filetype')
      return  ft == '' and 'none' or ft
    end
  },
  space_width = {
    fn = " %{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth} "
  },
  git_branch = {
    toggle = function ()
      return utils.git_branch() ~= ''
    end,
    fn = function ()
      return '  '..utils.git_branch()..' '
    end
  },
  task_timer = {
    fn = function ()
      return vim.fn['kissline#TaskTimerStatus']()
    end
  },

  get_lsp_client = {
    fn = function(msg)
      msg = msg or "LSP Inactive"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      local lsps = ""
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          -- print(client.name)
          if lsps == "" then
            -- print("first", lsps)
            lsps = client.name
          else
            if not string.find(lsps, client.name) then
              lsps = lsps .. ", " .. client.name
            end
            -- print("more", lsps)
          end
        end
      end
      if lsps == "" then
        return msg
      else
        return lsps
      end
    end
  }
}

