
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kissline#_layout_active {{{
function! kissline#_layout_active()
  let statusline=""
  let statusline.="%{kissline#_update_color()}"
  let statusline.= kissline#layout#create('active', 'left', 'default')
  let statusline.="%=" " (Middle) align from right
  let statusline.= kissline#layout#create('active', 'right', 'default')
  return statusline
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kissline#_layout_inactive {{{
function! kissline#_layout_inactive()
  let statusline=""
  let statusline.= kissline#layout#create('inactive', 'left', 'default')
  let statusline.="%=" " (Middle) align from right
  let statusline.= kissline#layout#create('inactive', 'right', 'default')
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
  try
    if g:kissline_icon_renderer == 'nvim-web-devicons'
      return kissline#icon#nvim_web_devicons()
    elseif g:kissline_icon_renderer == 'vim-devicons'
      return WebDevIconsGetFileTypeSymbol()
    elseif g:kissline_icon_renderer == 'nerdfont.vim'
      return nerdfont#find()
    else
      return '-'
    endif
  catch
    return '-'
  endtry
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
