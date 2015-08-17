let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif


nnoremap <unique> <silent> <leader>di :call indicator#OpenIndicatorWindow()<CR>
nnoremap <unique> <silent> <leader>dc :call indicator#CloseIndicatorWindow()<CR>
