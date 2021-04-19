
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kissline#_layout_active {{{
function! kissline#_layout_active()
  let statusline=""
  let statusline.="%{kissline#_update_color()}"

  if (exists('g:kissline_banner_is_hidden') && !g:kissline_banner_is_hidden)
    let statusline.="%#Kissline_banner#"
    let statusline.=g:kissline.component.banner
    let statusline.="%=" " (Middle) align from right
  else
    " first level
    let statusline.="%#Kissline_active_0#"
    let statusline.=g:kissline.component.mode
    let statusline.=g:kissline.component.readonly
    let statusline.=g:kissline.component.spell
    let statusline.=g:kissline.component.wrap
    let statusline.="%#Kissline_active_0_alt#"
    let statusline.=g:kissline.separator.left

    " second level
    let statusline.="%#Kissline_active_1#"
    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.modified
    let statusline.=g:kissline.separator.space
    let statusline.="%<" " truncate left
    let statusline.=g:kissline.component.filename
    let statusline.=g:kissline.separator.space
    let statusline.="%#Kissline_active_1_alt#"
    let statusline.=g:kissline.separator.left

    " third level
    let statusline.="%#Kissline_active_middle#"
    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.coc_status
    let statusline.=g:kissline.separator.space

    let statusline.="%=" " (Middle) align from right

    " third level
    let statusline.="%#Kissline_active_middle#"
    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.tasktimer_status
    let statusline.=g:kissline.separator.space

    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.space_width
    let statusline.=g:kissline.separator.space

    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.filetype
    let statusline.=g:kissline.separator.space

    " second level
    let statusline.="%#Kissline_active_1_alt#"
    let statusline.=g:kissline.separator.right
    let statusline.="%#Kissline_active_1#"
    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.percent
    let statusline.=g:kissline.separator.space

    " first level
    let statusline.="%#Kissline_active_0_alt#"
    let statusline.=g:kissline.separator.right
    let statusline.="%#Kissline_active_0#"
    let statusline.=g:kissline.separator.space
    let statusline.=g:kissline.component.lineinfo
    let statusline.=g:kissline.separator.space

  endif
  return statusline
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kissline#_layout_inactive {{{
function! kissline#_layout_inactive()
  let statusline=""
  let statusline.="%#Kissline_inactive_1#"
  let statusline.=g:kissline.separator.space
  let statusline.=g:kissline.component.modified
  let statusline.=g:kissline.separator.space
  let statusline.="%<" " turncate left
  let statusline.=g:kissline.component.filename
  let statusline.=g:kissline.separator.space
  let statusline.="%#Kissline_inactive_1_alt#"
  let statusline.=g:kissline.separator.left
  let statusline.="%#StatusLineNC#"

  let statusline.="%=" " (Middle) align from right

  let statusline.="%#StatusLineNC#"
  let statusline.="%#Kissline_inactive_1_alt#"
  let statusline.=g:kissline.separator.right
  let statusline.="%#Kissline_inactive_1#"
  let statusline.=g:kissline.separator.space
  let statusline.=g:kissline.component.lineinfo
  let statusline.=g:kissline.separator.space

  return statusline
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Controls {{{
let s:mode_color_names={
  \ 'n'  : 'normal',
  \ 't'  : 'terminal',
  \ 'v'  : 'visual',
  \ 'V'  : 'visual',
  \ "\<C-V>" : 'visual',
  \ 'i'  : 'insert',
  \ 'R'  : 'replace',
  \ 'c'  : 'normal',
  \
  \ 's'  : 'select',
  \ 'S'  : 'sline',
  \ "\<C-S>" : 'sblock',
  \ 'Rv' : 'vreplace',
  \ 'cv' : 'vimex',
  \ 'ce' : 'ex',
  \ 'r'  : 'prompt',
  \ 'rm' : 'more',
  \ 'r?' : 'confirm',
  \ '!'  : 'shell',
  \ 'no' : 'normal·operator pending',
  \}

let s:mode = ''
function! kissline#_update_color() abort
  let mode = get(s:mode_color_names, mode(), 'normal')
  if s:mode == mode
    return ''
  endif
  let s:mode = mode
  exec printf('hi! link Kissline_active_0     Kissline_active_0_%s', mode)
  exec printf('hi! link Kissline_active_0_alt Kissline_active_0_%s_alt', mode)
  return ''
endfunction

function! kissline#_set_colorscheme()
  let colorscheme = get(g:kissline, 'colorscheme', 'one')
  call function('kissline#colorscheme#'.colorscheme.'#_set_colorscheme')()
endfunction
function! kissline#_hide_statusline_colors()
  let colorscheme = get(g:kissline, 'colorscheme', 'one')
  call function('kissline#colorscheme#'.colorscheme.'#_hide_statusline_colors')()
endfunction

function! kissline#_update_all()
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [kissline#_layout_active()] : [kissline#_layout_active(), kissline#_layout_inactive()]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
endfunction
function! kissline#_blur()
   call setwinvar(0, '&statusline', kissline#_layout_inactive())
endfunction
function! kissline#_focus()
   call setwinvar(0, '&statusline', kissline#_layout_active())
endfunction

let s:banner_msg_timer_id = 0
function! kissline#_show_banner(msg, opts) abort
  if (!g:kissline_banner_is_hidden)
    call timer_stop(s:banner_msg_timer_id)
  endif

  let g:kissline_banner_msg = a:msg
  let g:kissline_banner_is_hidden = 0
  let timer = get(a:opts, 'timer', 5000)
  let s:banner_msg_timer_id = timer_start(timer, 'kissline#_hide_banner')
  call kissline#_update_all()
endfunction
" call kissline#_show_banner('testing', {'timer': 3000})
" call kissline#_show_banner('testing',{})
function! kissline#_hide_banner(timer_id) abort
  let g:kissline_banner_is_hidden = 1
  call kissline#_update_all()
endfunction

function kissline#_get_icon()
  if g:kissline_icon_renderer == 'nvim-web-devicons'
    return kissline#icon#nvim_web_devicons()
  else
    return '-'
  endif
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
