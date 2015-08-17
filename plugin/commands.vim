let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif


""
" @usage
" Open the diff indicator window
command OpenDiffIndicator call indicator#OpenIndicatorWindow()

""
" @usage
" Close the diff indicator window
command CloseDiffIndicator call indicator#CloseIndicatorWindow()
