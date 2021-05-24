function! kissline#icon#nvim_web_devicons()
 let fname = expand('%:t')
 let fextension = fnamemodify(fname,':e')
 return luaeval(printf('require"nvim-web-devicons".get_icon("%s", "%s", { default = true })', fname, fextension))
endfunction
