function kissline#_init_sline_autocommands() abort
  call kissline#_update_all()

  augroup Kissline_statusline
    au!
    au FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost,ColorScheme
          \ * call kissline#_update_all()
    au User NotifierNotificationLoaded,NeogitStatusRefreshed call kissline#_update_all()
    au FocusLost * call kissline#_blur()
  augroup END
endfunction

function kissline#_init_tline_autocommands() abort
  set tabline=%!kissline#_tab_layout()

  augroup Kissline_tabline
    au!
    au VimResized * lua require('kissline.tab').onWindowResize()
    au ColorScheme * lua require('kissline.theme.one').init(require('kissline.configs').options)
  augroup END
endfunction

function kissline#_init_winbar_autocommands() abort
  augroup Kissline_winbar
    au!
    au FocusGained,WinEnter,BufEnter,WinLeave,BufLeave,WinClosed * lua require('kissline.winbar').update_cur_win(true)
    au ColorScheme * lua require('kissline.theme.one').init(require('kissline.configs').options)
  augroup END
endfunction

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

function! kissline#_update_all(...)
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [luaeval("require('kissline.layout').active()")] : [luaeval("require('kissline.layout').active()"), luaeval("require('kissline.layout').inactive()")]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
  " if it is floating Window then update kissline again
  if nvim_win_get_config(win_getid(w)).relative != ''
    call timer_start(10, 'kissline#_update_all')
  endif
endfunction
function! kissline#_blur()
  call setwinvar(0, '&statusline', luaeval("require('kissline.layout').inactive()"))
endfunction
function! kissline#_focus()
  call setwinvar(0, '&statusline', luaeval("require('kissline.layout').active()"))
endfunction

function! kissline#TaskTimerStatus()
  if !exists('g:tt_loaded')
    return ''
  else
    try
      let icon = tt#get_status() =~ 'break' ? '' : ''
      let status = (!tt#is_running() && !hasan#tt#is_tt_paused() ? 'off' :
            \ hasan#tt#is_tt_paused() ? 'paused' :
            \ tt#get_remaining_smart_format())
      return icon.' '.status
    catch
      return ''
    endtry
  endif
endfunction

" Tab ============================================

function! kissline#_tab_layout()
  return luaeval("require('kissline.tab').layout()")
endfunction
