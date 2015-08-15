" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Opens a new split for the overview window on the right
function! syoverview#CreateOverviewBuffer()  " {{{
  let l:curwinnr = winnr('.')
  setlocal splitright
  execute '2vnew +setlocal\\ nonu\\ winfixwidth\\ buftype=nofile\\ filetype=' . g:syoverview_ft
  " 2vnew
  " setlocal nonu winfixwidth
  " set buftype=nofile
  " set filetype=syoverview
  " execute 'normal 83i\<CR>'
  let g:syoverview_bufnr = bufnr('%')

  " Jump back to the prevous window
  execute l:curwinnr . 'wincmd w'
  call syoverview#UpdateLocationIndicator(line('.'), line('$'))

  " This should be set when the plugin is loaded
  execute 'sign define ' . g:syoverview_indicator_name . 'text=+'
  autocmd CursorMoved * :call syoverview#UpdateLocationIndicator(line('.'), line('$'))
endfunction
" }}}

function! syoverview#UpdateLocationIndicator(linenr, total)
  if &filetype is g:syoverview_ft
    return
  endif
  let l:newnr = (a:linenr - 1) * 80 / a:total + 1
  if exists('g:syoverview_sign_linenr') && l:newnr != g:syoverview_sign_linenr
    execute 'sign unplace ' . g:syoverview_sign_linenr. ' buffer=' . g:syoverview_bufnr
  endif

  if !exists('g:syoverview_sign_linenr') || g:syoverview_sign_linenr != l:newnr
    let g:syoverview_sign_linenr = l:newnr
    execute 'sign place ' . g:syoverview_sign_linenr . ' line=' . g:syoverview_sign_linenr . ' name=' . g:syoverview_indicator_name . ' buffer=' . g:syoverview_bufnr
  endif
endfunction

" Unused
function! s:FindSyOverviewWindow()
  for tabnr in range(1, tabpagenr('$'))
    for winnr in range(1, tabpagewinnr(tabnr, '$'))
      if gettabwinvar(tabnr, winnr, 'id') is 'winsyoverview'
        return [tabnr, winnr]
      endif
    endfor
  endfor
  return [0, 0]
endfunction
