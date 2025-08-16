" ----------------------- VerumQuaerite's Custom Status Line -----------------
" ----------------------------- github.com/V1337Q ----------------------------

set laststatus=2
function! CocStatus()
	return get(g:, 'coc_status', '')
endfunction
set statusline+=%{CocStatus()}

function! Buffer() abort
  let buffers = []
  for nr in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let name = bufname(nr) ==# '' ? '[No Name]' : fnamemodify(bufname(nr), ':t')
    call add(buffers, printf('%d.%s', nr, name))
  endfor
  " return join(buffers, get(g:, 'buffereze_separator', ' | '))
  return join(buffers, get(g:, 'buffereze_separator', ' │ '))
endfunction


function! StatusCoC(...)
  let info = get(b:, 'coc_diagnostic_info', {})
  let msgs = []
  if !empty(info) && get(info, 'error', 0)
    call add(msgs, s:error_sign . info['error'])
  endif
  if !empty(info) && get(info, 'warning', 0)
    call add(msgs, s:warning_sign . info['warning'])
  endif
  let status = get(g:, 'coc_status', '')
  if get(a:, 1, 0)
    let status = substitute(status, '%', '%%', 'g')
  endif
  return coc#compat#trim(join(msgs, ' ') . ' ' . status)
endfunction

" function! coc#statuswarning(...)
"   let info = get(b:, 'coc_diagnostic_info', {})
"   let msgs = []
"   if !empty(info) && get(info, 'error', 0)
"     call add(msgs, s:error_sign . info['error'])
"   endif
"  endfunction

function MyCoCStatus() abort
  let status = coc#status()

  let status = substitute(status, 'E:', '', 'g')
  let status = substitute(status, 'W:', '', 'g')
  let status = substitute(status, 'I:', '󰋼', 'g')
  let status = substitute(status, 'H:', '󰛩', 'g')

  return status
endfunction

function CocDiagnosticStatus() abort
  " let info = get(g:, 'coc_diagnostic_info', {})

  " if empty(info) | return '' | endif
  if !exists('g:coc_diagnostic_info')
    return ''
  endif

  let info = g:coc_diagnostic_info
  if empty(info)
    return ''
  endif

  let out = []
  if get(info, 'error', 0)
    call add(out, ''.info.error)
  endif
  if get(info, 'warning', 0)
    call add(out, ''.info.warning)
  endif
  if get(info, 'information', 0)
    call add(out, ''.info['information'])
  endif
  if get(info, 'hint', 0)
    call add(out, ''.info['hint'])
  endif
  
  return join(out, ' ')
endfunction



function! Modes(mode)
	if a:mode == 'n'
		hi ModeText guifg=#449dab       guibg=#171B24       cterm=NONE
	elseif a:mode == 'i'
		hi ModeText guifg=#f7768e       guibg=#171B24       cterm=NONE
	elseif a:mode == 'R'
		hi ModeText guifg=#9ece6a       guibg=#171B24       cterm=NONE
	elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
		hi ModeText guifg=#e0af68       guibg=#171B24       cterm=NONE
	elseif a:mode == 'c'
		hi ModeText guifg=#86aaec       guibg=#171B24       cterm=NONE
	elseif a:mode == 't'
		hi ModeText guifg=#c68aee       guibg=#171B24       cterm=NONE
	endif

	return ''
endfunction

function! SymbolMode(modified)
endfunction

function! SetFiletype(filetype)
	if a:filetype == ''
		return 'unknown'
	else
		return a:filetype
	endif
endfunction

function! HandleColumnGap()
	let l:col = col('.')

	" if l:col > 9
	" 	return '✖  '
	" else
	" 	return '✖  '
	" endif
	"
	"
	"=================
	" if l:col > 9
	" 	return '✖  '
	" else
	" 	return '✖  '
	" endif
	"==================
	if l:col > 9
		return ''
	else
		return ''
	endif
	"
	" if l:col > 9
	" 	return '󰴽 '
	" else
	" 	return '󰴽 '
	" endif
	"
	" if l:col > 9
	" 	return ' 󱘖 '
	" else
	" 	return ' 󱘖 '
	" endif


endfunction

"Renders Nerd Font for User
" function! RenderNf3() 
" 	let l:col = '.'
" 	if l:col > 9 
" 		return '󰉋'
" 	else 
" 		return '󰉋'
" 	endif
" endfunction

function! RenderNf3() 
	let l:col = '.'
	if l:col > 9 
		return ' '
	else 
		return ' '
	endif
endfunction


"Render Nerd Font for path
" function! RenderNf()
" 	let l:col = '.'
" 	if l:col > 9
" 		return ' '
" 	else
" 		return ' '
" 	endif
" endfunction

function! RenderNf()
	let l:col = '.'
	if l:col > 9
		return ' '
	else
		return ' '
	endif
endfunction

"Render Nerd Font for Git
" function! RenderNf2()
" 	let l:col = '.'
" 	if l:col > 9
" 		return ' '
" 	else
" 		return ' '
" 	endif
" endfunction

function! RenderNf2()
	let l:col = '.'
	if l:col > 9
		return ' '
	else
		return ' '
	endif
endfunction

function! GetBranchName()
	let l:dir = expand('%:h')
	if empty(finddir('.git', l:dir . ';'))
		return 'no-git'
	endif
	return trim(system('git -C ' . shellescape(l:dir) . ' branch --show-current 2>/dev/null'))
endfunction

function! GetGitStatus()
	let l:dir = expand('%:h')
	if empty(finddir('.git', l:dir . ';'))
		return ''
	endif

  let l:status = systemlist('git -C ' . shellescape(l:dir) . ' status --porcelain=2 --branch')

  let l:ahead       = ''
  let l:behind      = ''
  let l:staged      = ''
  let l:modified   = ''
  let l:untracked   = ''


  "Ahead/behind
  if !empty(l:status)
    if l:status[0] =~ 'ahead (\d\+)'
      let l:ahead = '^'
    endif
    if l:status[0] =~ 'behind (\d\+)'
      let l:behind = '-^' 
    endif
  endif

  "File changes
  for l:line in l:status
    if l:line =~ '^1 ' && l:line[2] !=# '.' "staged
      let l:staged = '  '
    elseif l:line =~ '^1 ' && l:line[3] !=# '.' "unstaged
      let l:modified = ' '
    elseif l:line =~ '^?'
      let l:untracked = ' ?'
    endif
  endfor

  return l:ahead . l:staged . l:modified . l:untracked

endfunction
  
  function! RenderCpp()
	let l:col = '.'
	if l:col > 9
		return ''
	else
		return ''
	endif
endfunction


" function! GetFileType()
"     let filetype_actions = {
"         \ 'cpp': 'RenderCpp',
"         \ 'rust': 'comvimed#RunRust',
"         \ 'python': 'comvimed#PythonComp',
"         \ 'go': 'comvimed#GoComp',
"         \ 'c': 'comvimed#cComp',
"         \ 'java': 'comvimed#JavaComp',
"         \ 'asm': 'comvimed#AsmComp',
"         \ 'lua': 'comvimed#LuaComp'
"     \ }

"     if has_key(filetype_actions, &filetype)
"         call function(filetype_actions[&filetype])()
"     else
"         echo "Action not available yet."
"     endif
" endfunction

function! GetFiletype()
	if &filetype ==# 'python' && col('.')
        	return ' '
	elseif &filetype ==# 'cpp' && col('.')
        	return ' '
	elseif &filetype ==# 'rust' && col('.')
        	return ' '
	elseif &filetype ==# 'c' && col('.')
        	return ' '
	elseif &filetype ==# 'lua' && col('.')
        	return ' '
	elseif &filetype ==# 'gdscript' && col('.')
        	return ' '
	elseif &filetype ==# 'vim' && col('.')
        	return ' '
	elseif &filetype ==# 'asm' && col('.')
        	return ' '
	elseif &filetype ==# 'zig' && col('.')
        	return ' '
	elseif &filetype ==# 'julia' && col('.')
        	return ' '
	elseif &filetype ==# 'dosini' && col('.')
        	return '  '
	elseif &filetype ==# 'sh' && col('.')
        	return ' '
	elseif &filetype ==# 'zsh' && col('.')
        	return ' '
	" elseif &filetype ==# 'markdown' && col('.')
          " return '⚙️'
	elseif &filetype ==# 'markdown' && col('.')
          return '⚙️
	elseif &filetype ==# 'text' && col('.')
          return '󰈚 '
  elseif &filetype ==# 'startify' &&col('.')
          return '🔍'
    endif
endfunction


function! GetLSPName()
	if &filetype ==# 'python' && col('.')
        	return '  pylsp'
	elseif &filetype ==# 'cpp' && col('.')
        	return '  clangd'
	elseif &filetype ==# 'rust' && col('.')
        	return '  rust-analyzer'
	elseif &filetype ==# 'c' && col('.')
        	return '  clangd'
	elseif &filetype ==# 'lua' && col('.')
        	return '  luals'
	elseif &filetype ==# 'gdscript' && col('.')
        	return ' '
	" elseif &filetype ==# 'vim' && col('.')
        	" return ' '
	" elseif &filetype ==# 'asm' && col('.')
        	" return ' '
	" elseif &filetype ==# 'zig' && col('.')
        	" return ' '
	" elseif &filetype ==# 'julia' && col('.')
        	" return ' '
  else 
    return '  ~'
    endif
endfunction

" function! GetFiletype()
"     let l:ft = &filetype
"     let l:col = col('.')

"     if l:col <= 9
"         return ''
"     endif

"     return {
"         \ 'c':         ' ',
"         \ 'cpp':       ' ',
"         \ 'asm':       ' ',
"         \ 'python':    ' ',
"         \ 'julia':     ' ',
"         \ 'haskell':   ' ',
"         \ 'json':      ' ',
"         \ 'vim':       ' ',
"         \ 'gdscript':  ' ',
"         \ 'lua':       ' ',
"         \ 'zig':       ' ',
"         \ 'rust':      ' ',
"         \ }.get(l:ft, '')
" endfunction


" function! GitDirty()
"   let l:dir = expand('%:p:h')
"   if empty(finddir('.git', l:dir . ';'))
"     return ''
"   endif
"   let l:status = system('git -C ' . shellescape(l:dir) . ' status --porcelain 2>/dev/null')
"   return empty(l:status) ? '' : '✗'
" endfunction

hi StatusLine       guifg=#171B20    guibg=NONE    cterm=NONE
hi StatusLineNC     guifg=NONE    guibg=NONE    cterm=NONE

hi Separator        guifg=#171B24       guibg=#171B20       cterm=NONE
hi Separator2       guifg=#e9a180       guibg=#171B24       cterm=NONE
hi PathText         guifg=#c68aee       guibg=#171B24       cterm=NONE
hi ungu             guifg=#c68aee       guibg=#171B24       cterm=NONE
hi gray             guifg=#c68aee       guibg=#171B24       cterm=NONE
hi FileText         guifg=#acb0d0       guibg=#171B24       cterm=NONE
hi FiletypeText     guifg=#e9a180       guibg=#171B24       cterm=NONE

hi LineText         guifg=#e26c7c       guibg=#171B24       cterm=NONE
hi red              guifg=#e26c7c       guibg=#171B20       cterm=NONE
hi ColumnText       guifg=#7da6ff       guibg=#171B24       cterm=NONE

hi PercentageText   guifg=#86aaec       guibg=#171B24       cterm=NONE
hi TotalLineText    guifg=#c68aee       guibg=#171B24       cterm=NONE

hi BranchNameText   guifg=#78DBA9       guibg=#171B24       cterm=NONE
hi hijau            guifg=#78DBA9       guibg=#171B24       cterm=NONE
" hi green            guifg=#78DBA9       guibg=#171B24       cterm=NONE
hi invis            guifg=#171B20       guibg=#171B20       cterm=NONE
hi abu              guifg=#2b3038       guibg=#171B20       cterm=NONE
hi hijau2           guifg=#78DBA9       guibg=#171B20       cterm=NONE
hi BranchIDText     guifg=#e9a180       guibg=#171B24       cterm=NONE


set statusline  =%{Modes(mode())}

set statusline +=%#Separator# 
" set statusline +=%#ModeText#\ 
" set statusline+=%#ModeText#%{'\ '.mode()[0]}\
set statusline+=%#ModeText#%{'\ '.mode()[0]}\ 
" set statusline+=%#ModeText#%{mode()[0]}
"
" set statusline +=%#Separator#\ 
" set statusline +=%#Separator# 
"
set statusline +=%#Separator#\ 
set statusline +=%#Separator# 
set statusline +=%#ungu#%{RenderNf3()}
set statusline +=%#PathText#\ %{expand('%:p:h:t')}\ 
set statusline +=%#Separator#\ 
set statusline +=%#Separator# 
set statusline +=%#Separator2#%{RenderNf()}
" set statusline +=%#Separator2#\ %t
set statusline +=%#Separator2#%{Buffer()}
set statusline +=%#Separator# 

" set statusline +=%#invis# 
" set statusline +=%#abu#%{GetGitStatus()}

" set statusline +=%#invis# 
" set statusline +=%#abu#%{GetLSPName()}
set statusline +=%=

set statusline +=%#abu#%{GetLSPName()}
set statusline +=%#invis# 

set statusline +=%#red#%{coc#status()}
set statusline +=%#invis# 
" set statusline +=%{coc#status()}


" set statusline +=%#Separator# 
" set statusline+=%{GitDirty()}
set statusline +=%#hijau2#%{RenderNf2()}
set statusline +=%#hijau2#%{GetBranchName()}
set statusline +=%#invis# 
" set statusline +=%#Separator#\ 
"

set statusline +=%#Separator# 
set statusline +=%#Separator2#%{GetFiletype()}
set statusline +=%#FiletypeText#%{SetFiletype(&filetype)}
set statusline +=%#Separator#\ 

" set statusline +=%#Separator# 
" " set statusline+=%{GitDirty()}
" set statusline +=%#hijau#%{RenderNf2()}
" set statusline +=%#BranchNameText#%{GetBranchName()}
" set statusline +=%#Separator#\ 

set statusline +=%#Separator# 
set statusline +=%#ColumnText#%2l\ 
" set statusline +=%#Separator2#%{HandleColumnGap()}
" set statusline +=%#Separator2#/ 
" set statusline +=%#ColumnText#/ 
set statusline +=%#ColumnText#- 
set statusline +=%#ColumnText#%2c\ 
set statusline +=%#Separator#\ 
" set statusline +=%#Separator#
" set statusline +=%#Separator#
" set statusline +=%#PercentageText#\%P\ 
" " set statusline +=%#Separator2#\ 
" set statusline +=%#Separator2#/\ 
" set statusline +=%#TotalLineText#%L
" set statusline +=%#Separator#
" set statusline +=%{coc#status()}%{get(b:,'coc_current_function','')}
