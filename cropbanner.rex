/* Test cropbanner */
parse arg imgf resizeWidthOnly .
if imgf='' | \SysFileExists(imgf) then do
  say 'cropbanner - Resize and crop an image to fit the CoC rotating banner'
  say 'Usage: cropbanner imagefile [resizeWidthOnly]'
  exit
end
parse var imgf fstem '.' .
dims=cmdOutputLine('iid  -format %w-%h' imgf)
parse var dims wd '-' ht
say 'Original dimensions:' wd 'x' ht
targetWd=720
targetHt=320
tempfile=fstem'-'targetWd'w.jpg'
resultfile=fstem'-'targetWd'x'targetHt'.jpg'
pctWd=targetWd/wd*100

-- Resize to a width
icmd='icv' imgf '-resize' format(pctWd,,2)'%' tempfile
say 'Cmd:' icmd
icmd

if \SysFileExists(tempfile) then do
  say 'Unable to resize to width!'
  exit
end
if resizeWidthOnly=1 then exit

-- Now query the new height
ht=cmdOutputLine('iid  -format %h' tempfile)
say 'New height:' ht
shaveHt=(ht-targetHt)/2
icmd='icv' tempfile '-shave 0x'shaveHt resultfile
say 'Cmd:' icmd
icmd
if SysFileExists(resultfile) then 'del' tempfile

exit

::requires 'CmdUtils.cls'
