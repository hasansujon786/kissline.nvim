function! kissline#icon#nvim_web_devicons()
 let fname = expand('%')
 let fextension = fnamemodify(fname,':e')
 return luaeval('require"nvim-web-devicons".get_icon("'.fname.'", "'.fextension.'", { default = true })')
endfunction
