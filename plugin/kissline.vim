" Plugin:      https://github.com/hasansujon786/kissline.nvim
" Description: A simple & fast statusline for Vim.
" Maintainer:  hasansujon786 <https://github.com/hasansujon786>

if exists('g:loaded_kissline') || &cp
  finish
endif

" Global values {{{
let g:loaded_kissline = 1
let g:kissline_banner_msg = ''
let g:kissline_banner_is_hidden = 1
let g:kissline_icon_renderer = get(g:,'kissline_icon_renderer', 'none')

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
  \ 'big_dot':  '●',
  \}


" file:/data/data/com.termux/files/usr/share/nvim/runtime/doc/options.txt:5797
let g:kissline = {
  \ 'colorscheme': 'one',
  \ 'component': {
  \   'mode': "\ %{kissline#CurrentMode()}\ ",
  \   'readonly': "%{&readonly?'\ ".g:kissline_icons.lock." ':''}",
  \   'spell': "%{&spell?'\ ".g:kissline_icons.dic." ':''}",
  \   'wrap': "%{&wrap?'\ ".g:kissline_icons.wrap." ':''}",
  \   'modified': " %{&modified?'*':'-'} ",
  \   '_modified': " %{&modified? g:kissline_icons.big_dot : kissline#_get_icon()} ",
  \   'space_width': " %{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth} ",
  \   'filetype': " %{''!=#&filetype?&filetype:'none'} ",
  \   'filename_with_icon': " %{&modified? g:kissline_icons.big_dot : kissline#_get_icon()} %t ",
  \   'filename': " %t ",
  \   'percent': " %3p%% ",
  \   'lineinfo': " %3l:%-2v ",
  \   'coc_status': " %{kissline#CocStatus()} ",
  \   'tasktimer_status': " %{kissline#TaskTimerStatus()} ",
  \   'banner': " %{kissline#BannerMsg()} ",
  \   'mini_scrollbar': " %{kissline#Mini_scrollbar()} ",
  \   'fugitive': " %{kissline#Fugitive()} ",
  \   'subseparator': " | "
  \   },
  \ 'separator': {'left': '', 'right': '', 'space': ' '},
  \ 'subseparator': {'left': '', 'right': ''},
  \ }
" }}}

set statusline=%!kissline#_layout_active()
augroup StausLine
  au!
  au FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost
        \ * call kissline#_update_all()
  au FocusLost * call kissline#_blur()
  au VimEnter,ColorScheme * call kissline#_init()
  " au User GoyoLeave nested call kissline#_init()
  " @todo: hide statusline for goyo
  " au User GoyoEnter nested call kissline#_hide_statusline_colors()
augroup END


" vim: et sw=2 sts=2
