local hi_secondary = { bg='#3E4452', fg='#ABB2BF'}

return  {
  mode = {
    use_mode_hl = true,
    separator = {'', ''},
    fn = function ()
      return vim.fn['kissline#CurrentMode']()
    end,
  },
  harpoon = {
    fn = function ()
      local status = require("harpoon.mark").status()
      return status == '' and '' or 'H:' .. status
    end
  },
  line_info = {
    use_mode_hl = true,
    separator = {'', ''},
    fn = '%3l:%-2v'
  },
  filename_with_icon = {
    hl = hi_secondary,
    separator = {'', ''},
    fn = '%t'
  },
  scroll_info = {
    hl = hi_secondary,
    separator = {'', ''},
    fn = '%3p%%'
  },
  filetype = {
    fn = function ()
      local ft=vim.api.nvim_buf_get_option(0, 'filetype')
      return  ft == '' and 'none' or ft
    end
  },
  space_width = {
    fn = "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}"
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

