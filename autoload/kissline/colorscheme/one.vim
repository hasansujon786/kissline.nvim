function! kissline#colorscheme#one#_init() abort
  " hi Kissline_active_0
  " hi Kissline_active_0_alt
  hi Kissline_active_1      guibg=#3E4452 guifg=#ABB2BF
  hi Kissline_active_1_alt  guibg=#2C323C guifg=#3E4452
  hi Kissline_active_2      guibg=#2C323C guifg=#717785
  hi Kissline_active_2_alt  guibg=#2C323C guifg=#2C323C

  " Secondary section color (inactive)
  hi Kissline_inactive_0      guibg=#3E4452 guifg=#717785
  hi Kissline_inactive_0_alt  guibg=#2C323C guifg=#3E4452

  " Banner section color
  hi Kissline_banner guibg=#FF2020 guifg=#ffffff gui=bold
  " Default color
  " hi Statusline   guibg=#2C323C guifg=#ABB2BF
  " hi StatusLineNC guibg=#2C323C guifg=#717785

  let s:highlight_colors={
        \ 'normal'  :'#98C379',
        \ 'insert'  :'#61AFEF',
        \ 'terminal':'#61AFEF',
        \ 'visual'  :'#C678DD',
        \ 'replace' :'#E06C75',
        \}
  for key in keys(s:highlight_colors)
    exec printf('hi Kissline_active_0_%s     guifg=#2C323C guibg=%s gui=bold', key, get(s:highlight_colors,key))
    exec printf('hi Kissline_active_0_%s_alt guibg=#3E4452 guifg=%s', key, get(s:highlight_colors,key))
  endfor

endfunction

