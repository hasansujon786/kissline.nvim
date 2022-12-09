local M = {}

function M.clicable(text, lua_fn_name, arg)
  arg = arg and arg or 0
  return string.format('%%%s@v:lua.%s@%s%%X', arg, lua_fn_name, text)
end
function M.withHl(text, hl)
  return string.format('%%#%s#%s', hl, text)
end

return M
