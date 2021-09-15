" Plugin:      https://github.com/hasansujon786/kissline.nvim
" Description: A simple & fast statusline for Vim.
" Maintainer:  hasansujon786 <https://github.com/hasansujon786>

if exists('g:loaded_kissline') || &cp
  finish
endif
let g:loaded_kissline = 1
" lua require('kissline')
" set statusline=%!kissline#layout#active()
lua require('kissline.tab').onWindowResize()
set tabline=%!kissline#_tab_layout()
lua require('kissline.theme.one').init()

augroup StausLine
  au!
  au FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost,ColorScheme
        \ * call kissline#_update_all()
  au User NotifierNotificationLoaded,NeogitStatusRefreshed call kissline#_update_all()
  au FocusLost * call kissline#_blur()
  au ColorScheme * lua require('kissline.theme.one').init()
  au VimResized * lua require('kissline.tab').onWindowResize()
augroup END


" vim: et sw=2 sts=2
" /usr/share/nvim/runtime/doc/options.txt:5797
