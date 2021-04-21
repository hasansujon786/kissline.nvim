let s:separator = kissline#_get_config('kissline_separator')
let s:layout    = kissline#_get_config('kissline_layout')

function s:get_colors(state, side, stage, alt) abort
 let separator = a:alt ? s:separator[a:side] : ''
 let alt_color = a:alt ? '_alt' : ''
 return printf('%%#Kissline_%s_%s%s#%s', a:state, a:stage, alt_color, separator)
endfunction

function! kissline#layout#create(state, side, theme) abort
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

