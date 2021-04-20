
function! kissline#_hide_statusline_colors()
  let colorscheme = get(g:kissline, 'colorscheme', 'one')
  call function('kissline#colorscheme#'.colorscheme.'#_hide_statusline_colors')()
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


