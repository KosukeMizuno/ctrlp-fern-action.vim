if exists('g:loaded_ctrlp_fern_action') && g:loaded_ctrlp_fern_action
  finish
endif
let g:loaded_ctrlp_fern_action = 1
let s:save_cpo = &cpo
set cpo&vim

let s:fern_action_var = {
\  'init':   'ctrlp#fern_action#init()',
\  'enter':  'ctrlp#fern_action#enter()',
\  'accept': 'ctrlp#fern_action#accept',
\  'lname':  'fern_action',
\  'sname':  'fernact',
\  'type':   'line',
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:fern_action_var)
else
  let g:ctrlp_ext_vars = [s:fern_action_var]
endif
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#fern_action#id() abort
  return s:id
endfunction

function! ctrlp#fern_action#enter() abort
  let rs = split(execute('nmap'), '\n')
  call map(rs, { _, v -> v[3:] })
  call map(rs, { _, v -> matchlist(v, '^\([^ ]\+\)\s*\*\?@\?\(.*\)$')[1:2] })
  let pattern1 = '^<Plug>(fern-action-\zs.*\ze)$'
  let pattern2 = '^<Plug>(fern-action-'
  call map(rs, { _, v -> v + [matchstr(v[1], pattern1)] })
  call filter(rs, { _, v -> !empty(v[2]) })
  call filter(rs, { _, v -> v[0] !~# '^<Plug>' || v[0] =~# pattern2 })
  call map(rs, { _, v -> v[2] })
  let s:action_list = rs
  return s:id
endfunction

function! ctrlp#fern_action#init() abort
  return s:action_list
endfunc

function! ctrlp#fern_action#accept(mode, str) abort
  call ctrlp#exit()
  call feedkeys("\<Plug>(fern-action-"..a:str..")")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:fen:fdl=0:ts=2:sw=2:sts=2
