let s:mode = ''
function! kissline#_update_color() abort
  let l:mode_color_names={
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
  let mode = get(l:mode_color_names, mode(), 'normal')
  if s:mode == mode
    return ''
  endif
  let s:mode = mode
  exec printf('hi! link Kissline_cur_mode_active     Kissline_mode_%s', mode)
  exec printf('hi! link Kissline_cur_mode_sp_active  Kissline_mode_sp_%s', mode)
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
   call setwinvar(0, '&statusline', luaeval("require('kissline.layout').inactive()"))
endfunction
function! kissline#_focus()
   call setwinvar(0, '&statusline', luaeval("require('kissline.layout').active()"))
endfunction

