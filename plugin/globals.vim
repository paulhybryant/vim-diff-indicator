let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif


" Filetype of the diff indicator buffer
let g:indicator_ft = "indicator"

" Name of the sign defined for diff indicator
let g:indicator_name = "DiffIndicator"
