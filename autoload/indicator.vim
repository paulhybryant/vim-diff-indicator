" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

let s:plugin = maktaba#plugin#Get('vim-diff-indicator')
call s:plugin.Load('globals')

""
" Opens a new split for the indicator window
function! indicator#OpenIndicatorWindow() abort " {{{
  if !exists('b:sy.hunks')
    return
  endif

  if !exists('g:indicator_bufnr')
    execute 'sign define' g:indicator_name 'text=' . s:plugin.Flag('IndicatorSign')
    silent! execute 'botright vertical 2 new'
    " Set the global variable storing the buffer id of the indicator buffer.
    let g:indicator_bufnr = bufnr('%')
    let g:indicator_winnr = winnr()
    " Set attributes for the indicator window
    silent! execute 'setlocal filetype=' . g:indicator_ft
    setlocal nonu
    setlocal winfixwidth
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal foldmethod=manual
    setlocal nofoldenable
    setlocal nobuflisted
    setlocal nospell

    " Jump back to the prevous window
    execute 'wincmd p'

    " Initialize the indicator window
    call s:UpdateLocationIndicator(line('.'), line('$'))
    call s:RefreshDiffOverview(b:sy.hunks, line('$'))

    " Creates the buffer-local autocmd
    autocmd CursorMoved * if exists('b:sy.hunks') | :call s:UpdateLocationIndicator(line('.'), line('$'))
    autocmd BufWritePost * if exists('b:sy.hunks') | :call s:RefreshDiffOverview(b:sy.hunks, line('$'))
    autocmd BufEnter * if exists('b:sy.hunks') | :call s:RefreshDiffOverview(b:sy.hunks, line('$'))
  elseif bufwinnr(g:indicator_bufnr) == -1
    silent! execute 'botright vertical 2 split'
    silent! execute 'buffer' g:indicator_bufnr
    execute 'wincmd p'
  endif
endfunction
" }}}


""
" Closes the indicator window
function! indicator#CloseIndicatorWindow() abort " {{{
  if bufwinnr(g:indicator_bufnr) == -1
    return
  endif
  execute 'bd!' g:indicator_bufnr
endfunction
" }}}


""
" Refresh the diff overview buffer
function! s:RefreshDiffOverview(hunks, total) abort " {{{
  if bufwinnr(g:indicator_bufnr) == -1
    return
  endif

  execute g:indicator_winnr . 'wincmd w'
  " Clear the contents
  let l:height = winheight(g:indicator_winnr)
  for i in range(1, l:height)
    call setline(i, '')
  endfor
  execute 'sign unplace * buffer=' . g:indicator_bufnr

  let l:indicator_signs = {}
  for hunk in a:hunks
    let l:start = float2nr(round(hunk['start'] * l:height / a:total * 1.0)) + 1
    let l:end = float2nr(round(hunk['end'] * l:height / a:total * 1.0)) + 1
    for i in range(l:start, l:end)
      execute 'sign place' i 'line=' . i 'name=' . hunk['type'] 'buffer=' . g:indicator_bufnr
      let l:indicator_signs[i] = hunk['type']
    endfor
  endfor
  execute 'wincmd p'
  let b:indicator_signs = l:indicator_signs
endfunction
" }}}


""
" Refresh the location indicator sign
function! s:UpdateLocationIndicator(linenr, total) abort " {{{
  if !exists('b:indicator_linenr')
    let b:indicator_linenr = -1
  endif
  let l:newnr = (a:linenr - 1) * winheight(g:indicator_winnr) / a:total + 1
  if l:newnr != b:indicator_linenr
    if b:indicator_linenr > 0
      execute 'sign unplace' b:indicator_linenr 'buffer=' . g:indicator_bufnr
      if exists('b:indicator_signs') && has_key(b:indicator_signs, b:indicator_linenr)
        execute 'sign place' b:indicator_linenr 'line=' . b:indicator_linenr 'name=' . b:indicator_signs[b:indicator_linenr] 'buffer=' . g:indicator_bufnr
      endif
    endif
    let b:indicator_linenr = l:newnr
    execute 'sign place' b:indicator_linenr 'line=' . b:indicator_linenr 'name=' . g:indicator_name 'buffer=' . g:indicator_bufnr
  endif
endfunction
" }}}
