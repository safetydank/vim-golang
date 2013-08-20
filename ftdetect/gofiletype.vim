" We take care to preserve the user's fileencodings and fileformats,
" because those settings are global (not buffer local), yet we want
" to override them for loading Go files, which are defined to be UTF-8.
let s:current_fileformats = ''
let s:current_fileencodings = ''

" define fileencodings to open as utf-8 encoding even if it's ascii.
function! s:gofiletype_pre()
  let s:current_fileformats = &g:fileformats
  let s:current_fileencodings = &g:fileencodings
  set fileencodings=utf-8 fileformats=unix
  setlocal filetype=go
endfunction

" restore fileencodings as others
function! s:gofiletype_post()
  let &g:fileformats = s:current_fileformats
  let &g:fileencodings = s:current_fileencodings
  silent retab
endfunction

function! s:gofiletype_writepre()
  let b:lastpos = getpos('.')
  silent %!gofmt
  if v:shell_error
    silent undo
  endif
endfunction

function! s:gofiletype_writepost()
  silent retab
  call setpos('.', b:lastpos)
endfunction

au BufNewFile *.go setlocal filetype=go fileencoding=utf-8 fileformat=unix
au BufRead *.go call s:gofiletype_pre()
au BufReadPost *.go call s:gofiletype_post()
au BufWritePre *.go call s:gofiletype_writepre()
au BufWritePost *.go call s:gofiletype_writepost()

