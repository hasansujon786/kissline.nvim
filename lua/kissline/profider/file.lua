local Path = require "plenary.path"
local Job = require "plenary.job"
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
  elseif file:sub(file:len()-2, file:len()) == 'FZF' then
    return 'FZF'
  elseif buftype == 'terminal' then
    local _, mtch = string.match(file, "term:(.*):(%a+)")
    return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ':t')
  elseif file == '' then
    return '[No Name]'
  end
  return vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
end

M.bufname = function (bufnr)
  local cur_bufname = vim.fn.bufname(bufnr)
  cur_bufname = cur_bufname:gsub('/','\\')

  return vim.fn.fnamemodify(cur_bufname, ':p')
end


M.cur_buf_proj_root = function(path)
  local fpath = Path:new(path)
  local parent = fpath:parent()

  local j = Job:new({
    command = "git",
    -- args = {'rev-parse', '--abbrev-ref', 'HEAD'},
    -- args = {'branch', '--show-current'},
    args = {'rev-parse', '--show-toplevel'},
    cwd = parent.filename
  })

  local ok, result = pcall(function()
    return vim.trim(j:sync()[1])
  end)

  if ok then
    return result
  else
    return 'xx'
  end
end


M.all_tabname_list = function()
  local tabnr = 1
  local all_tabs = {}
  local projects = {
    projects_tabs = { },
    project_length = 0,
  }

  while tabnr <= vim.fn.tabpagenr('$') do
    local cur_tab_buflist = vim.fn.tabpagebuflist(tabnr)
    local cur_tab_winnr = vim.fn.tabpagewinnr(tabnr)
    local cur_tab_bufnr = cur_tab_buflist[cur_tab_winnr]

    local cur_bufname = M.bufname(cur_tab_bufnr)
    local root_dir = M.cur_buf_proj_root(cur_bufname)

    local tab_data = {
      tabnr = tabnr,
      bufnr = cur_tab_bufnr,
      winnr = cur_tab_bufnr,
      tab_buf_name = cur_bufname,
      is_selected = tabnr == vim.fn.tabpagenr(),
      root_dir = root_dir,
    }
    table.insert(all_tabs, tab_data)

    if projects.projects_tabs[root_dir] == nil then
      projects.project_length = projects.project_length + 1
      projects.projects_tabs[root_dir] = {
        projectnr = projects.project_length,
        tabs = {}
      }
    end
    table.insert(projects.projects_tabs[root_dir].tabs, tab_data)

    tabnr = tabnr + 1
  end

  return all_tabs, projects
end


Proj_tabname_list = function ()
  local cur_bufname = M.bufname(vim.fn.bufnr())
  local cur_pro_root = M.cur_buf_proj_root(cur_bufname)

  local _, projects = M.all_tabname_list()
  return projects.projects_tabs[cur_pro_root], projects
end

-- function GetFoo()
--   local foo = ToggleProjectTabM.bufname(vim.fn.bufnr())

--   local path = Path:new(foo)
--   -- P(M.cur_buf_proj_root(path))
--   P(path:parent())
-- end

-- local foo = Cur_proj_tabname_list()

-- P(cur_bufname)

-- vim.bo.filetype

return M
