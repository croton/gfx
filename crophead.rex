/* Crop sections from header image */
parse arg imgf y increment
if imgf='' | \SysFileExists(imgf) then do
  say 'crophead - Crop sections from CoC header image'
  say 'Usage: crophead imagefile [y][increment]'
  exit
end
parse var imgf fstem '.' .
dims=cmdOutputLine('iid  -format %w-%h' imgf)
parse var dims wd '-' ht

totalHeight=ht
cropHeight=280
loops=0
start=0
step=15
limit=totalHeight-cropHeight
outputFolder='crophead'

if datatype(y,'W') & limit>y then start=y
if datatype(increment,'W') then
 if limit>(increment+start) then step=increment

say 'Crop image of original dimensions of' wd 'x' ht 'into'
say 'sections of' cropHeight'px height beginning at' start 'incrementing by' step
do i=start by step to limit
  loops=loops+1
  bottomEdge=i+cropHeight
  bottomCut=totalHeight-bottomEdge
  resultfile=fstem'-crop'i'.jpg'
  icmd='icv' imgf '-crop 0x'cropHeight'+0+'i resultfile
  say ' Crop from' i 'to' bottomEdge 'cut off' bottomCut ':' icmd
  ADDRESS CMD icmd
end i
call move2folder fstem'-*', outputFolder
say 'Crops created='loops
exit

move2folder: procedure
  parse arg fspec, destination
  if \SysFileExists(destination) then 'mkdir' destination
  else say 'Destination folder exists'
  'move' fspec destination
  return rc

::requires 'CmdUtils.cls'
