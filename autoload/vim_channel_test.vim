let s:root = fnamemodify(expand('<sfile>'), ':p:h:h')
let s:sep = has('win32') ? '\' : '/'

function! vim_channel_test#start() abort
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

function! vim_channel_test#test() abort
  let text = readfile(join([s:root, 'test.txt'], s:sep))
  let result = ch_sendexpr(s:job, text, {
        \ 'timeout': 2000,
        \})
  echomsg string(result)
endfunction
