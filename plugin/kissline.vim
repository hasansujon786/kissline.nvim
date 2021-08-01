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
augroup END


" vim: et sw=2 sts=2
" file:/data/data/com.termux/files/usr/share/nvim/runtime/doc/options.txt:5797
