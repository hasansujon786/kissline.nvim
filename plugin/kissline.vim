" Plugin:      https://github.com/hasansujon786/kissline.nvim
" Description: A simple & fast statusline for Vim.
" Maintainer:  hasansujon786 <https://github.com/hasansujon786>

if exists('g:loaded_kissline') || &cp
  finish
endif

let g:loaded_kissline = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global values {{{
let g:nerdfont_loaded = 0
let g:kissline_banner_msg = ''
let g:kissline_banner_is_hidden = 1

let g:kissline_icons = {
  \ 'lock':     '',
  \ 'checking': '',
  \ 'warning':  '',
  \ 'error':    '',
  \ 'ok':       '',
  \ 'info':     '',
  \ 'hint':     '',
  \ 'line':     '',
  \ 'dic':      ' ',
  \ 'wrap':     '蝹',
  \ 'cup':      '',
  \ 'search':   '',
  \ 'pomodoro': '',
  \}


" file:/data/data/com.termux/files/usr/share/nvim/runtime/doc/options.txt:5797
let g:kissline = {
  \ 'colorscheme': 'one',
  \ 'component': {
  \   'mode': "\ %{CurrentMode()}\ ",
  \   'readonly': "%{&readonly?'\ ".g:kissline_icons.lock." ':''}",
  \   'spell': "%{&spell?'\ ".g:kissline_icons.dic." ':''}",
  \   'wrap': "%{&wrap?'\ ".g:kissline_icons.wrap." ':''}",
  \   'modified': "%{&modified?'●':!g:nerdfont_loaded?'':nerdfont#find()}",
  \   'space_width': "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}",
  \   'filetype': "%{''!=#&filetype?&filetype:'none'}",
  \   'filename': "%t",
  \   'percent': "%3p%%",
  \   'lineinfo': "%3l:%-2v",
  \   'coc_status': "%{CocStatus()}",
  \   'tasktimer_status': "%{TaskTimerStatus()}",
  \   'banner': "%{BannerMsg()}",
  \   'mini_scrollbar': "%{Mini_scrollbar()}",
  \   },
  \ 'separator': {'left': '', 'right': '', 'space': ' '},
  \ 'subseparator': {'left': '', 'right': ''},
  \ }
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Component functions {{{

let s:mode_states={
  \ 'n'  : 'Normal',
  \ 'no' : 'Normal·Operator Pending',
  \ 'v'  : 'Visual',
  \ 'V'  : 'V-Line',
  \ "\<C-V>" : 'V-Block',
  \ 's'  : 'Select',
  \ 'S'  : 'S-Line',
  \ "\<C-S>" : 'S-Block',
  \ 'i'  : 'Insert',
  \ 'R'  : 'Replace',
  \ 'Rv' : 'V-Replace',
  \ 'c'  : 'Normal',
  \ 'cv' : 'Vim Ex',
  \ 'ce' : 'Ex',
  \ 'r'  : 'Prompt',
  \ 'rm' : 'More',
  \ 'r?' : 'Confirm',
  \ '!'  : 'Shell',
  \ 't'  : 'Terminal'
  \}

function! CurrentMode()
  return exists('g:loaded_sneak_plugin') && sneak#is_sneaking() ? 'SNEAK ' :
        \ &ft == 'fern' ? 'fern' :
        \ toupper(s:mode_states[mode()])
endfunction

function! LightLineBufSettings()
  let et = &et ==# 1 ? "•" : "➜"
  return ('│ts│'. &tabstop . '│sw│'. &shiftwidth . '│et│' . et . '│')
endfunction

function! CocStatus()
  " . get(b:,'coc_current_function','')
  return exists('*coc#status') ? coc#status() : ''
endfunction

function! TaskTimerStatus()
  if !exists('g:all_plug_loaded')
    return g:kissline_icons.checking
  else | try
    let icon = tt#get_status() =~ 'break' ? g:kissline_icons.cup : g:kissline_icons.pomodoro
    let status = (!tt#is_running() && !hasan#tt#is_tt_paused() ? 'off' :
          \ hasan#tt#is_tt_paused() ? 'paused' :
          \ tt#get_remaining_smart_format())
    return icon.' '.status
    catch | return '' | endtry
  endif
endfunction

function! BannerMsg() abort
  let msg = exists('g:kissline_banner_msg') ? g:kissline_banner_msg : ''
  let banner_w = (winwidth(0)) / 2
  let space = banner_w + (len(msg) / 2)
  let line = printf('%'.space.'S', msg)
  return exists('g:kissline_banner_is_hidden') && !g:kissline_banner_is_hidden ? line : ''
endfunction

function! Mini_scrollbar()
  " https://www.reddit.com/r/vim/comments/lvktng/tiny_statusline_scrollbar/
  " Plug 'https://github.com/drzel/vim-line-no-indicator'
  let width = 9
  let perc = (line('.') - 1.0) / (max([line('$'), 2]) - 1.0)
  let before = float2nr(round(perc * (width - 3)))
  let after = width - 3 - before
  " return '[' . repeat(' ',  before) . '=' . repeat(' ', after) . ']'
  return repeat('░',  before) . '▒' . repeat('░', after)
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


set statusline=%!kissline#_layout_active()
augroup StausLine
  au!
  au FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost
        \ * call kissline#_update_all()
  au FocusLost * call kissline#_blur()
  au VimEnter,ColorScheme * call kissline#_set_colorscheme()
  au User GoyoLeave nested call kissline#_set_colorscheme()
  " @todo: hide statusline for goyo
  au User GoyoEnter nested call kissline#_hide_statusline_colors()
augroup END


" vim: et sw=2 sts=2
