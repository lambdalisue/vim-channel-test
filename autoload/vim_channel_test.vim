let s:root = fnamemodify(expand('<sfile>'), ':p:h:h')
let s:sep = has('win32') ? '\' : '/'

function! s:start() abort
  let script = join([s:root, 'script', 'server.ts'], s:sep)
  let s:job = job_start(['deno', 'run', '-A', script], {
        \ 'mode': 'json',
        \ 'err_mode': 'nl',
        \ 'pty': 0,
        \ 'env': {
        \   'NO_COLOR': 1,
        \ },
        \ 'err_cb': funcref('s:err_cb'),
        \ 'exit_cb': funcref('s:exit_cb'),
        \})
  echomsg "Server started"
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
  silent! unlet! s:job
endfunction

function! vim_channel_test#notify(data) abort
  if !exists('s:job')
    call s:start()
  endif
  return ch_sendraw(s:job, json_encode([0, a:data]) . "\n", {
        \ 'timeout': 2000,
        \})
endfunction

function! vim_channel_test#request(data) abort
  if !exists('s:job')
    call s:start()
  endif
  return ch_sendexpr(s:job, a:data, {
        \ 'timeout': 2000,
        \})
endfunction
