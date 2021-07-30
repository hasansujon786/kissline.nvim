local M = {}

M.fileIcon = function()
 local fname = vim.fn.expand('%:t')
 local fextension = vim.fn.fnamemodify(fname,':e')
 return require('nvim-web-devicons').get_icon(fname,  fextension, {default = true})
end

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
M.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(
        vim.tbl_flatten({ 'autocmd', def }),
        ' '
      )
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

return M
