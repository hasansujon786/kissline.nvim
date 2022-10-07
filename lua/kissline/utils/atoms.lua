local M = {}

function M.clicable(text, lua_fn_name)
  return string.format('%%@v:lua.%s@%s%%X', lua_fn_name, text)
end
function M.withHl(text, hl)
  return string.format('%%#%s#%s', hl, text)
end

return M
