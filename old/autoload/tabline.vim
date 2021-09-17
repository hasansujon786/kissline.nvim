let s:tab_ln = g:tabline.tab_lenght - 5
let s:label_ln = s:tab_ln + 2

function! tabline#_layout()
  let s = ''
  let s.= s:hidden_tabs_navigation('left', '%#TabCountButton#')
  let s .= '%#TabLineFill#%T' " reset colors from here
  let s .= s:tabs()
  let s.= s:hidden_tabs_navigation('right', '%#TabCountButton#')
  let s .= '%#TabLineFill#%T' " reset colors from here
  let s.= '%='

  " let s .= tabpagenr('$') > g:tabline.tabs_can_fit ? '%#TabCountSp#%#TabCount#' : '%#TabCountAltSp#%#TabCountAlt#'
  " let s .= ' %2{tabpagenr()}/%-2{tabpagenr("$")} '
  " let s .= '%=%#TabLineSp#%999X▎%#TabEnd#%@OpenFern@ %-6.10{fnamemodify(getcwd(), ":t")[0:9]} %X'
  return s
endfunction

" utils {{{
function s:visible_tabs() abort
  let v_tabs = [tabpagenr()]

  if (tabpagenr() > g:tabline.tabs_can_fit)
    let right = 0
    let left =  g:tabline.tabs_can_fit - 1
  elseif (tabpagenr() <= g:tabline.tabs_can_fit)
    let right = g:tabline.tabs_can_fit - tabpagenr()
    let left = g:tabline.tabs_can_fit - (right + 1)
  endif

  for j in range(1,left)
    call add(v_tabs, tabpagenr() - j)
  endfor
  for k in range(1,right)
    call add(v_tabs, k + tabpagenr())
  endfor
  return [v_tabs, left, right]
endfunction

function! s:is_turncate(tab_nr)
  let [visible_tabs, _, _] = s:visible_tabs()
  return index(visible_tabs, a:tab_nr) == -1 ? 1 : 0
endfunction

function! s:is_tabwin_modified(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  return getbufvar(buflist[winnr - 1], '&modified')
endfunction

function! OpenFern(...)
  Fern . -reveal=%
endfunction
" }}}

" componets {{{
function! s:tabs()
  let tabs = ''
  for tab_nr in range(1,tabpagenr('$'))
    " set the tab page number (for mouse clicks)
    let head = '%'. (tab_nr).'T'
    let separator = tab_nr == tabpagenr() ? '%#TabLineSelSp#'.g:tabline.double_line.'%#TabLineSel#' : '%#TabLineSp#'.g:tabline.double_line.'%#TabLine#'
    let label = '%-'.s:tab_ln.'{TabLabel('.tab_nr.')}'
    let close_btn = (tabpagenr('$') == 1 ? '%#TabLineSelX#' : '').
          \'%'.tab_nr.'X'.g:tabline.tab_close_icon.'%X'
    let tail = s:is_tabwin_modified(tab_nr) ? g:tabline.modified_icon : close_btn

    let tab = head.separator.' '.label.tail.'  '
    let tabs .= s:is_turncate(tab_nr) ? '' : tab
  endfor
  let tabs .= '%#TabLineSp#'.g:tabline.line_left    " last separetor
  let tabs .= '%#TabLineFill#%T' " reset colors from here
  return tabs
endfunction

function! TabLabel(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  let tabName = luaeval(printf("require('hasan.tabline').tabName(%s)", buflist[winnr - 1]))
  let icon = tabline#nvim_web_devicon(tabName)
  let label = a:tab_nr.' '. icon.' '.tabName.' '

  if (len(label) > s:label_ln) | let label = label[0:s:label_ln-3].'..' | endif
  return label
endfunction

function s:hidden_tabs_navigation(direction, hi) abort
  let [v_tabs, v_left, v_right] = s:visible_tabs()
  let count = {
        \'left': tabpagenr() - (v_left + 1),
        \'right': tabpagenr('$') - (tabpagenr() + v_right)
        \}
  let comp = {
        \'left': ' '.count.left.' '.g:tabline.left_trunc_marker.' ',
        \'right': ' '.g:tabline.right_trunc_marker.' '.count.right.' '
        \}

  let active_color = get(count, a:direction) > 0 ? a:hi : ''
  return tabpagenr('$') > g:tabline.tabs_can_fit ? active_color.get(comp, a:direction) : ''
endfunction
" }}}

function! tabline#apply_colors()
  hi TabLine        guibg=#2C323C guifg=#5C6370
  hi TabLineSp      guibg=#2C323C guifg=#4B5263
  hi TabLineFill    guibg=#2C323C guifg=#5C6370
  hi TabLineSel     guibg=#282C34 guifg=#dddddd

  hi TabCount       guibg=#98C379 guifg=#2C323C gui=bold
  hi TabCountSp     guibg=#2C323C guifg=#98C379
  hi TabCountAlt    guibg=#3E4452 guifg=#ABB2BF
  hi TabCountAltSp  guibg=#2C323C guifg=#3E4452

  hi TabLineSelSp   guibg=#282C34 guifg=#61AFEF
  hi TabLineSelX    guibg=#282C34 guifg=#5C6370
  hi TabCountButton guifg=#ABB2BF
endfunction

function! tabline#nvim_web_devicon(fname)
  try
    let fextension = fnamemodify(a:fname,':e')
    return luaeval(printf('require"nvim-web-devicons".get_icon("%s", "%s", { default = true })', a:fname, fextension))
  catch /.*/
    return '[No Name]'
  endtry
endfunction

