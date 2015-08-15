" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Opens a new split for the indicator window on the right
function! indicator#CreateIndicatorBuffer()  " {{{
  " Keep the window number of the current window
  let l:curwinnr = winnr()
  " Open a window on the right
  " TODO: Make this configurable
  setlocal splitright
  " Set attributes for the indicator window
  execute '5vnew +setl\ nonu\ winfixwidth\ buftype=nofile\ filetype=' . g:indicator_ft
  " 2vnew
  " setlocal nonu winfixwidth
  " set buftype=nofile
  " set filetype=indicator
  " execute 'normal 83i\<CR>'

  " Set the global variable storing the buffer id of the indicator buffer.
  let g:indicator_winnr = winnr()
  let g:indicator_bufnr = bufnr('%')

  " Jump back to the prevous window
  execute l:curwinnr . 'wincmd w'

  execute 'sign define ' . g:indicator_name . ' text=+'
  " Initialize the indicator window
  call indicator#UpdateLocationIndicator(line('.'), line('$'))

  " Creates the buffer-local autocmd
  autocmd CursorMoved <buffer> :call indicator#UpdateLocationIndicator(line('.'), line('$'))
endfunction
" }}}

" Refresh the contents of the indicator window
function! indicator#UpdateLocationIndicator(linenr, total) " {{{
  let l:newnr = (a:linenr - 1) * winheight(g:indicator_winnr) / a:total + 1
  if exists('g:indicator_sign_linenr') && l:newnr != g:indicator_sign_linenr
    execute 'sign unplace ' . g:indicator_sign_linenr. ' buffer=' . g:indicator_bufnr
  endif

  if !exists('g:indicator_sign_linenr') || g:indicator_sign_linenr != l:newnr
    let g:indicator_sign_linenr = l:newnr
    execute 'sign place ' . g:indicator_sign_linenr . ' line=' . g:indicator_sign_linenr . ' name=' . g:indicator_name . ' buffer=' . g:indicator_bufnr
  endif
endfunction
" }}}
