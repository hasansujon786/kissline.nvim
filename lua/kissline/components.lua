local utils = require('kissline.utils')
local file_provider = require('kissline.profider.file')
local icon_provider = require('kissline.profider.icon')

local hi_secondary = { bg='#3E4452', fg='#ABB2BF'}
local selected_sp = 1
local separator = {
  { primary = {'', ''}, secondary = {'', ''} },
  { primary = {'', ''}, secondary = {'', ''} },
  { primary = {'', ''}, secondary = {'', ''} },
  { primary = {'', ''}, secondary = {'', ''} },
}

-- NOTE: toggle and stirng fn need space

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
    separator = separator[selected_sp].primary,
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
    separator = separator[selected_sp].primary,
    fn = ' %3l:%-2v '
  },
  filename_with_icon = {
    hl = hi_secondary,
    -- raw = true,
    separator = separator[selected_sp].primary,
    fn = function (isActive, section_hl)
      -- TODO: add icon section to every component
      local bufnr = vim.api.nvim_get_current_buf()
      local fname = file_provider.filename(bufnr)
      local icon = icon_provider.fileIcon(bufnr)
      return string.format('%s %s', icon, fname)
    end,
  },
  scroll_info = {
    hl = hi_secondary,
    separator = separator[selected_sp].primary,
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
  lsp_status = {
    fn = function()
      local progress_message = vim.lsp.util.get_progress_messages()
      if #progress_message == 0 then
        return  utils.get_lsp_client()
      end

      local status = {}
      for _, msg in pairs(progress_message) do
        table.insert(status, (msg.percentage or 0) .. '% ' .. (msg.title or ''))
      end
      return table.concat(status, ' ')
    end
  },
}

