let s:mode_color_names={
  \ 'n'  : 'normal',
  \ 't'  : 'terminal',
  \ 'v'  : 'visual',
  \ 'V'  : 'visual',
  \ "\<C-V>" : 'visual',
  \ 'i'  : 'insert',
  \ 'R'  : 'replace',
  \ 'c'  : 'normal',
  \ 's'  : 'replace',
  \}
let s:mode = ''
function! kissline#_update_color() abort
  let mode = get(s:mode_color_names, mode(), 'normal')
  if s:mode == mode
    return ''
  endif
  let s:mode = mode
  exec printf('hi! link Kissline_cur_mode     Kissline_mode_%s', mode)
  exec printf('hi! link Kissline_cur_mode_sp  Kissline_mode_sp_%s', mode)
  return ''
endfunction

function! kissline#_update_all()
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [luaeval("require('kissline.layout').active()")] : [luaeval("require('kissline.layout').active()"), luaeval("require('kissline.layout').inactive()")]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
endfunction
function! kissline#_blur()
   call setwinvar(0, '&statusline', kissline#layout#inactive())
endfunction
function! kissline#_focus()
   call setwinvar(0, '&statusline', kissline#layout#active())
endfunction

function! kissline#_init() abort
  hi Kissline_cur_mode      guibg=#98C379 guifg=#2C323C gui=bold
  hi Kissline_cur_mode_sp  guibg=#3E4452 guifg=#98C379
  " hi Kissline_active_1      guibg=#3E4452 guifg=#ABB2BF
  " hi Kissline_active_1_alt  guibg=#2C323C guifg=#3E4452
  " hi Kissline_active_2      guibg=#2C323C guifg=#717785
  " hi Kissline_active_2_alt  guibg=#2C323C guifg=#2C323C

  " Secondary section color (inactive)
  hi Kissline_inactive_0      guibg=#3E4452 guifg=#717785
  " hi Kissline_inactive_0_alt  guibg=#2C323C guifg=#3E4452    " default
  hi Kissline_inactive_0_alt  guibg=#3E4452 guifg=#3E4452    " preferred with nebulous

  " Banner section color
  hi Kissline_banner guibg=#FF2020 guifg=#ffffff gui=bold
  " Default color
  hi Statusline   guibg=#3E4452 guifg=#ABB2BF
  hi StatusLineNC guibg=#3E4452 guifg=#ABB2BF
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
    exec printf('hi Kissline_mode_%s     guifg=#2C323C guibg=%s gui=bold', key, get(s:highlight_colors,key))
    exec printf('hi Kissline_mode_sp_%s  guibg=#3E4452 guifg=%s', key, get(s:highlight_colors,key))
  endfor
endfunction

function! kissline#CurrentMode()
  let l:mode_names={
        \ 'n'  : 'Normal',
        \ 'no' : 'Normal·Operator Pending',
        \ 'v'  : 'Visual',
        \ 'V'  : 'V-Line',
        \ "\<C-V>" : 'V-Block',
        \ 's'  : 'Select',
        \ 'S'  : 'S-Line',
        \ "\<C-S>" : 'S-Block',
        \ 'i'  : 'Insert',
        \ 'R'  : 'Replace',
        \ 'Rv' : 'V-Replace',
        \ 'c'  : 'Normal',
        \ 'cv' : 'Vim Ex',
        \ 'ce' : 'Ex',
        \ 'r'  : 'Prompt',
        \ 'rm' : 'More',
        \ 'r?' : 'Confirm',
        \ '!'  : 'Shell',
        \ 't'  : 'Terminal'
        \}

  " exists('g:loaded_sneak_plugin') && sneak#is_sneaking() ? 'SNEAK ' :
  return &ft == 'fern' ? 'fern' :
        \ toupper(l:mode_names[mode()])
endfunction
