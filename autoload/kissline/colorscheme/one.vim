function! kissline#colorscheme#one#_set_colorscheme() abort
  " hi Kissline_active_0
  " hi Kissline_active_0_alt
  hi Kissline_active_1      guibg=#3E4452 guifg=#ABB2BF
  hi Kissline_active_1_alt  guibg=#2C323C guifg=#3E4452
  hi Kissline_active_middle guibg=#2C323C guifg=#717785

  " Secondary section color (inactive)
  hi Kissline_inactive_1      guibg=#3E4452 guifg=#717785
  hi Kissline_inactive_1_alt  guibg=#2C323C guifg=#3E4452

  " Banner section color
  hi Kissline_banner guibg=tomato guifg=black gui=bold
  " Default color
  hi Statusline   guibg=#2C323C guifg=#ABB2BF
  hi StatusLineNC guibg=#2C323C guifg=#717785

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

function! kissline#colorscheme#one#_hide_statusline_colors() abort
  if( &background == 'dark' )
    hi User1 guibg=#282C34 guifg=#282C34
    hi User2 guibg=#282C34 guifg=#282C34
    " Secondary section color
    hi User3 guibg=#282C34 guifg=#282C34
    hi User4 guibg=#282C34 guifg=#282C34
    " Statusline middle
    hi User5 guibg=#282C34 guifg=#282C34
    " Secondary section color (inactive)
    hi User6 guibg=#282C34 guifg=#282C34
    " Default color
    hi statusline   guibg=#282C34 guifg=#282C34
    hi StatusLineNC guibg=#282C34 guifg=#282C34
  endif
endfunction


" delete this
" let s:status_color={
"   \ 'n' :'#98C379',
"   \ 'v' :'#C678DD',
"   \ 'i' :'#61AFEF',
"   \ 't' :'#61AFEF',
"   \ 'r' :'#E06C75',
"   \}
" function _update_vim_mode_color(mode) abort
"   " @todo: replace color update system in statsuline
"   if (hasan#goyo#is_running()) | return | endif

"   let bg = get(s:status_color, g:vim_current_mode, 'n')

"   if (exists('g:kissline_banner_is_hidden') && !g:kissline_banner_is_hidden)
"     exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
"     exe 'hi User2 guifg='.bg.' guibg=tomato gui=bold'
"   else
"     exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
"     exe 'hi User2 guifg='.bg.' guibg=#3E4452 gui=bold'
"   endif
"   " if exists('$TMUX')
"   "   call s:updateVimuxLine(bg)
"   " endif
" endfunction

" function s:updateVimuxLine(bg)
"   call system('tmux set -g window-status-current-format "#[fg=#282C34,bg='.a:bg.',noitalics]#[fg=black,bg='.a:bg.'] #I #[fg=black, bg='.a:bg.'] #W #[fg='.a:bg.', bg=#282C34]"')
" endfunction
