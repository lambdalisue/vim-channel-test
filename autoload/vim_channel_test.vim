let s:root = fnamemodify(expand('<sfile>'), ':p:h:h')
let s:sep = has('win32') ? '\' : '/'

function! vim_channel_test#start() abort
  let script = join([s:root, 'script', 'server.ts'], s:sep)
  call job_start(['deno', 'run', '-A', script], {
        \ 'mode': 'json',
        \ 'err_mode': 'nl',
        \ 'pty': 0,
        \ 'env': {
        \   'NO_COLOR': 1,
        \ },
        \ 'err_cb': funcref('s:err_cb'),
        \ 'exit_cb': funcref('s:exit_cb'),
        \})
endfunction

function! s:err_cb(chan, msg) abort
  echohl ErrorMsg
  for line in split(a:msg, '\n')
    echomsg line
  endfor
  echohl None
endfunction

function! s:exit_cb(job, status) abort
  echomsg "Server closed"
endfunction

function! vim_channel_test#verify(n, buffer) abort
  return [a:n, len(a:buffer) is# a:n]
endfunction
