local M = {}

M.filename = function(bufnr)
  local file = vim.fn.bufname(bufnr)
  local buftype = vim.fn.getbufvar(bufnr, '&buftype')
  local filetype = vim.fn.getbufvar(bufnr, '&filetype')
  if buftype == 'help' then
    return 'help:' .. vim.fn.fnamemodify(file, ':t:r')
  elseif buftype == 'quickfix' then
    return 'quickfix'
  elseif filetype == 'TelescopePrompt' then
    return 'Telescope'
  elseif filetype == 'NvimTree' then
    return 'EXPLORER'
  elseif file:sub(file:len() - 2, file:len()) == 'FZF' then
    return 'FZF'
  elseif buftype == 'terminal' then
    local _, mtch = string.match(file, 'term:(.*):(%a+)')
    return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ':t')
  elseif file == '' then
    return '[No Name]'
  end
  return vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
end

return M
