let s:banner_msg = ''
let s:is_banner_active = 0
let s:timer_id = 0

function! kissline#banner#_show(msg, opts) abort
  if (s:is_banner_active)
    call timer_stop(s:timer_id)
  endif

  let s:banner_msg = a:msg
  let s:is_banner_active = 1
  let timer = get(a:opts, 'timer', 5000)
  let s:timer_id = timer_start(timer, 'kissline#banner#_hide')
  call kissline#_update_all()
endfunction

function! kissline#banner#_hide(timer_id) abort
  let s:is_banner_active = 0
  call kissline#_update_all()
endfunction

function! kissline#banner#_is_active() abort
  return s:is_banner_active
endfunction

function! kissline#banner#Message() abort
  let banner_hw = (winwidth(0)) / 2
  let padding_x = banner_hw + (len(s:banner_msg) / 2)
  let line = printf('%'.padding_x.'S', s:banner_msg)
  return s:is_banner_active ? line : ''
endfunction
" call kissline#banner#_show('testing', {'timer': 3000})
" call kissline#banner#_show('testing',{})
