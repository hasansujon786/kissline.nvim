local Job = require('plenary.job')
local M = {}

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
M.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

M.if_nil = function(x, was_nil, was_not_nil)
  if x == nil then
    return was_nil
  else
    return was_not_nil
  end
end

M.get_default = function(x, default)
  return M.if_nil(x, default, x)
end

M.git_branch = function()
  local isReadonly = vim.api.nvim_buf_get_option(0, 'readonly')
  local isModifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
  if isReadonly or not isModifiable then
    return ''
  end

  local j = Job:new({
    command = 'git',
    -- args = {'rev-parse', '--abbrev-ref', 'HEAD'},
    args = { 'branch', '--show-current' },
    cwd = vim.fn.expand('%:p:h'),
  })

  local ok, result = pcall(function()
    return vim.trim(j:sync()[1])
  end)

  if ok then
    return result
  else
    return ''
  end
end

M.get_lsp_client = function()
  local msg = 'LSP Inactive'
  local buf_ft = vim.bo.filetype
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  local lsps = ''
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      if lsps == '' then
        lsps = client.name
      else
        if not string.find(lsps, client.name) then
          lsps = lsps .. ', ' .. client.name
        end
      end
    end
  end
  if lsps == '' then
    return msg
  else
    return lsps
  end
end

return M
