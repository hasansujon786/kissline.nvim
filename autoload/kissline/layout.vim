let s:layout     = kissline#_get_config('kissline_layout')
let s:separator  = kissline#_get_config('kissline_separator')
let s:components = kissline#_get_config('kissline_components')

function! kissline#layout#active()
  let statusline="%{kissline#_update_color()}"

  if kissline#banner#_is_active()
    let statusline.="%#Kissline_banner#"
    let statusline.=s:components.banner
    return statusline
  endif

  let statusline.= s:create_layout('active', 'left', 'default')
  let statusline.="%=" " (Middle) align from right
  let statusline.="%<" " truncate left
  let statusline.= s:create_layout('active', 'right', 'default')
  return statusline
endfunction

function! kissline#layout#inactive()
  let statusline=""
  let statusline.= s:create_layout('inactive', 'left', 'default')
  let statusline.="%=" " (Middle) align from right
  let statusline.="%<" " truncate left
  let statusline.= s:create_layout('inactive', 'right', 'default')
  return statusline
endfunction


function s:get_colors(state, side, stage, alt) abort
 let separator = a:alt ? s:separator[a:side] : ''
 let alt_color = a:alt ? '_alt' : ''
 return printf('%%#Kissline_%s_%s%s#%s', a:state, a:stage, alt_color, separator)
endfunction

function! s:create_layout(state, side, theme) abort
  let components = kissline#_get_config('kissline_components')
  let row_config = s:layout[a:state][a:side]
  let fn_names_in_flatten_array = []

  let i = 0
  for stage in row_config
    if a:side == 'left'
      call add(fn_names_in_flatten_array, s:get_colors(a:state, a:side, i, 0))
    endif

    for fn_name in stage
      call add(fn_names_in_flatten_array, components[fn_name])
    endfor

    if a:side == 'left'
      call add(fn_names_in_flatten_array, s:get_colors(a:state, a:side, i, 1))
    else
      call add(fn_names_in_flatten_array, s:get_colors(a:state, a:side, i, 0))
      call add(fn_names_in_flatten_array, s:get_colors(a:state, a:side, i, 1))
    endif
    let i = i + 1
  endfor

  if a:side == 'right'
    call reverse(fn_names_in_flatten_array)
  endif
  return join(fn_names_in_flatten_array, '')
endfunction

