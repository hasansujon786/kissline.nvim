return  {
  mode = {
    hl = 'guibg=#ffffff guifg=#ff0000',
    separator = {'<', '>'},
    fn = function ()
      return vim.fn['kissline#CurrentMode']()
    end,
  },
  harpoon = {
    hl = 'guibg=#ffffff guifg=#ff0000',
    separator = {'<', '>'},
    fn = function ()
      local status = require("harpoon.mark").status()
      return status == '' and '' or 'H:' .. status
    end
  },

  get_lsp_client = {
    hl = 'guibg=#ff0000 guifg=#ffffff',
    separator = {'<', '>'},
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

