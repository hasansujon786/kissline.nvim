let g:kissline_theme = {
  \ 'active': {
  \   'left': [[ 'mode','readonly', 'spell'],
  \            [ 'modified', 'filename'],
  \            [ 'coc_status']],
  \
  \   'right':[[ 'lineinfo' ],
  \            [ 'percent',],
  \            [ 'filetype', 'space_width', 'tasktimer_status']],
  \ },
  \ 'inactive': {
  \   'left': [[ 'modified', 'filename']],
  \
  \   'right':[[ 'percent' ]]
  \ },
  \ }

function s:get_colors(layout, side, stage, alt) abort
 let separator = a:alt ? g:kissline.separator[a:side] : ''
 let alt_color = a:alt ? '_alt' : ''
 return printf('%%#Kissline_%s_%s%s#%s', a:layout, a:stage, alt_color, separator)
endfunction

function! kissline#layout#create(layout, side, theme) abort
  let row_config = g:kissline_theme[a:layout][a:side]
  let fn_names_in_flatten_array = []

  let i = 0
  for stage in row_config
    if a:side == 'left'
      call add(fn_names_in_flatten_array, s:get_colors(a:layout, a:side, i, 0))
    endif

    for fn_name in stage
      call add(fn_names_in_flatten_array, g:kissline.component[fn_name])
    endfor

    if a:side == 'left'
      call add(fn_names_in_flatten_array, s:get_colors(a:layout, a:side, i, 1))
    else
      call add(fn_names_in_flatten_array, s:get_colors(a:layout, a:side, i, 0))
      call add(fn_names_in_flatten_array, s:get_colors(a:layout, a:side, i, 1))
    endif
    let i = i + 1
  endfor

  if a:side == 'right'
    call reverse(fn_names_in_flatten_array)
  endif
  return join(fn_names_in_flatten_array, '')
endfunction

