"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" default configs {{{
let s:kissline_icon_renderer = get(g:, 'kissline_icon_renderer', 'none')
let s:kissline_colorscheme   = get(g:, 'kissline_colorscheme', 'one')
let s:kissline_separator     = get(g:, 'kissline_separator', {'left': '', 'right': '', 'space': ' '})
let s:kissline_subseparator  = get(g:, 'kissline_subseparator', {'left': '', 'right': ''})
let s:kissline_layout        = get(g:, 'kissline_layout', {
      \ 'active': {
      \   'left': [['mode','readonly', 'spell', 'wrap'],
      \            ['filename_with_icon'],
      \            ['coc_status']],
      \   'right':[['lineinfo'],
      \            ['percent'],
      \            ['fugitive','tasktimer_status', 'space_width', 'filetype']],
      \ },
      \ 'inactive': {
      \   'left': [['filename_with_icon']],
      \   'right':[['percent']]
      \ }
      \ })
let s:kissline_icons = {
      \ 'lock': '', 'checking': '', 'warning': '', 'error':    '',
      \ 'ok':   '', 'info':     '', 'hint':    '', 'line':     '',
      \ 'dic':  '', 'wrap':     '蝹', 'cup':    '', 'search':   '',
      \ 'dot':  '●', 'pomodoro':  '',
      \}
let s:kissline_components = {
      \ 'mode': "\ %{kissline#CurrentMode()}\ ",
      \ 'readonly': "%{&readonly?'\ ".s:kissline_icons.lock." ':''}",
      \ 'spell': "%{&spell?'\ ".s:kissline_icons.dic." ':''}",
      \ 'wrap': "%{&wrap?'\ ".s:kissline_icons.wrap." ':''}",
      \ 'modified': " %{&modified?'*':'-'} ",
      \ '_modified': " %{&modified? '".s:kissline_icons.dot."' : kissline#_get_icon()} ",
      \ 'space_width': " %{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth} ",
      \ 'filetype': " %{''!=#&filetype?&filetype:'none'} ",
      \ 'filename_with_icon': " %{&modified? '".s:kissline_icons.dot."' : kissline#_get_icon()} %t ",
      \ 'filename': " %t ",
      \ 'percent': " %3p%% ",
      \ 'lineinfo': " %3l:%-2v ",
      \ 'coc_status': " %{kissline#CocStatus()} ",
      \ 'tasktimer_status': " %{kissline#TaskTimerStatus()} ",
      \ 'banner': " %{kissline#banner#Message()} ",
      \ 'mini_scrollbar': " %{kissline#Mini_scrollbar()} ",
      \ 'fugitive': " %{kissline#Fugitive()} ",
      \ }
if exists('g:kissline_component_functions') && type(g:kissline_component_functions) == v:t_dict
  for item in items(g:kissline_component_functions)
    let s:kissline_components[item[0]] = printf(' %%{%s()} ', item[1])
  endfor
endif
let s:mode_names={
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

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Controls {{{
function kissline#_get_config(config) abort
  return get(s:, a:config, 0)
endfunction

let s:mode_color_names={
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

function! kissline#_init()
  let colorscheme = kissline#_get_config('kissline_colorscheme')
  call function('kissline#colorscheme#'.colorscheme.'#_init')()
endfunction

function! kissline#_update_all()
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [kissline#layout#active()] : [kissline#layout#active(), kissline#layout#inactive()]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
endfunction
function! kissline#_blur()
   call setwinvar(0, '&statusline', kissline#layout#inactive())
endfunction
function! kissline#_focus()
   call setwinvar(0, '&statusline', kissline#layout#active())
endfunction

function kissline#_get_icon()
  let renderer = kissline#_get_config('kissline_icon_renderer')
  try
    if renderer == 'nvim-web-devicons'
      return kissline#icon#nvim_web_devicons()
    elseif renderer == 'vim-devicons'
      return WebDevIconsGetFileTypeSymbol()
    elseif renderer == 'nerdfont.vim'
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Component functions {{{
function! kissline#CurrentMode()
  " exists('g:loaded_sneak_plugin') && sneak#is_sneaking() ? 'SNEAK ' :
  return &ft == 'fern' ? 'fern' :
        \ toupper(s:mode_names[mode()])
endfunction

function! kissline#CocStatus()
  return exists('*coc#status') ? coc#status() : ''
endfunction

function! kissline#TaskTimerStatus()
  if !exists('g:all_plug_loaded')
    return s:kissline_icons.checking
  else | try
    let icon = tt#get_status() =~ 'break' ? s:kissline_icons.cup : s:kissline_icons.pomodoro
    let status = (!tt#is_running() && !hasan#tt#is_tt_paused() ? 'off' :
          \ hasan#tt#is_tt_paused() ? 'paused' :
          \ tt#get_remaining_smart_format())
    return icon.' '.status
    catch | return '' | endtry
  endif
endfunction

function! kissline#Mini_scrollbar()
  " https://www.reddit.com/r/vim/comments/lvktng/tiny_statusline_scrollbar/
  " Plug 'https://github.com/drzel/vim-line-no-indicator'
  let width = 9
  let perc = (line('.') - 1.0) / (max([line('$'), 2]) - 1.0)
  let before = float2nr(round(perc * (width - 3)))
  let after = width - 3 - before
  " return '[' . repeat(' ',  before) . '=' . repeat(' ', after) . ']'
  return repeat('░',  before) . '▒' . repeat('░', after)
endfunction


function! kissline#Fugitive() abort
  if exists('g:loaded_fugitive')
    let l:branch = fugitive#head()
    return l:branch !=# '' ? ' ' . branch : ''
  endif
  return ''
endfunction

" alternative branch parsing if fugitive.vim not installed
function! kissline#GitBranch() abort
  let l:branch = system('cd '.expand('%:p:h').' && git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d "\n"')
  if !strlen(l:branch) || !isdirectory(expand('%:p:h'))
    return ''
  else
    return ' ' . l:branch . ''
  endif
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
