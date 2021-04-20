
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

