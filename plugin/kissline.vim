" Plugin:      https://github.com/hasansujon786/kissline.nvim
" Description: A simple & fast statusline for Vim.
" Maintainer:  hasansujon786 <https://github.com/hasansujon786>

if exists('g:loaded_kissline') || &cp
  finish
endif
let g:loaded_kissline = 1
" lua require('kissline')
" set statusline=%!kissline#layout#active()
augroup StausLine
  au!
  au FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost,ColorScheme
        \ * call kissline#_update_all()
  au User NotifierNotificationLoaded,NeogitStatusRefreshed call kissline#_update_all()
  au FocusLost * call kissline#_blur()
  au VimEnter,ColorScheme * lua require('kissline.theme.one').init()
  au ColorScheme * call TablineApplyColors()
augroup END


" vim: et sw=2 sts=2
" file:/data/data/com.termux/files/usr/share/nvim/runtime/doc/options.txt:5797

set tabline=%!kissline#_tab_layout()

function! TablineApplyColors()
  hi KisslineTab           guibg=#2d3343 guifg=#5C6370
  hi KisslineTabActive     guibg=#242b38 guifg=#dddddd
  hi KisslineBar           guibg=#2d3343 guifg=#5C6370
  hi KisslineBarActive     guibg=#242b38 guifg=#61AFEF
  hi KisslineTabLine       guibg=#2d3343 guifg=#5C6370
endfunction

call TablineApplyColors()

