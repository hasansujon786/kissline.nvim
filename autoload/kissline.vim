
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kissline#_layout_active {{{
function! kissline#_layout_active()
  let statusline=""
  let statusline.="%{kissline#_update_color()}"

  if (exists('g:statusline_banner_is_hidden') && !g:statusline_banner_is_hidden)
    let statusline.="%#StatusLine_banner#"
    let statusline.=g:statusline.component.banner
    let statusline.="%=" " (Middle) align from right
  else
    " first level
    let statusline.="%#StatusLine_active_0#"
    let statusline.=g:statusline.component.mode
    let statusline.=g:statusline.component.readonly
    let statusline.=g:statusline.component.spell
    let statusline.=g:statusline.component.wrap
    let statusline.="%#StatusLine_active_0_alt#"
    let statusline.=g:statusline.separator.left

    " second level
    let statusline.="%#StatusLine_active_1#"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.modified
    let statusline.=g:statusline.separator.space
    let statusline.="%<" " truncate left
    let statusline.=g:statusline.component.filename
    let statusline.=g:statusline.separator.space
    let statusline.="%#StatusLine_active_1_alt#"
    let statusline.=g:statusline.separator.left

    " third level
    let statusline.="%#StatusLine_active_middle#"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.coc_status
    let statusline.=g:statusline.separator.space

    let statusline.="%=" " (Middle) align from right

    " third level
    let statusline.="%#StatusLine_active_middle#"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.tasktimer_status
    let statusline.=g:statusline.separator.space

    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.space_width
    let statusline.=g:statusline.separator.space

    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.filetype
    let statusline.=g:statusline.separator.space

    " second level
    let statusline.="%#StatusLine_active_1_alt#"
    let statusline.=g:statusline.separator.right
    let statusline.="%#StatusLine_active_1#"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.percent
    let statusline.=g:statusline.separator.space

    " first level
    let statusline.="%#StatusLine_active_0_alt#"
    let statusline.=g:statusline.separator.right
    let statusline.="%#StatusLine_active_0#"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.lineinfo
    let statusline.=g:statusline.separator.space

  endif
  return statusline
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kissline#_layout_inactive {{{
function! kissline#_layout_inactive()
  let statusline=""
  let statusline.="%#StatusLine_inactive_1#"
  let statusline.=g:statusline.separator.space
  let statusline.=g:statusline.component.modified
  let statusline.=g:statusline.separator.space
  let statusline.="%<" " turncate left
  let statusline.=g:statusline.component.filename
  let statusline.=g:statusline.separator.space
  let statusline.="%#StatusLine_inactive_1_alt#"
  let statusline.=g:statusline.separator.left
  let statusline.="%#StatusLineNC#"

  let statusline.="%=" " (Middle) align from right

  let statusline.="%#StatusLineNC#"
  let statusline.="%#StatusLine_inactive_1_alt#"
  let statusline.=g:statusline.separator.right
  let statusline.="%#StatusLine_inactive_1#"
  let statusline.=g:statusline.separator.space
  let statusline.=g:statusline.component.lineinfo
  let statusline.=g:statusline.separator.space

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
  exec printf('hi! link StatusLine_active_0     StatusLine_active_0_%s', mode)
  exec printf('hi! link StatusLine_active_0_alt StatusLine_active_0_%s_alt', mode)
  return ''
endfunction

function! kissline#_set_colorscheme()
  let colorscheme = get(g:statusline, 'colorscheme', 'one')
  call function('kissline#colorscheme#'.colorscheme.'#_set_colorscheme')()
endfunction
function! kissline#_hide_statusline_colors()
  let colorscheme = get(g:statusline, 'colorscheme', 'one')
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
  if (!g:statusline_banner_is_hidden)
    call timer_stop(s:banner_msg_timer_id)
  endif

  let g:statusline_banner_msg = a:msg
  let g:statusline_banner_is_hidden = 0
  let timer = get(a:opts, 'timer', 5000)
  let s:banner_msg_timer_id = timer_start(timer, 'statusline#_hide_banner')
  call kissline#_update_all()
endfunction
" call kissline#_show_banner('testing', {'timer': 3000})
" call kissline#_show_banner('testing',{})
function! kissline#_hide_banner(timer_id) abort
  let g:statusline_banner_is_hidden = 1
  call kissline#_update_all()
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
