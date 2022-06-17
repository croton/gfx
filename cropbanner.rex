/* Test cropbanner */
parse arg imgf w h resizeWidthOnly .
if imgf='' | \SysFileExists(imgf) then do
  say 'cropbanner - Resize and crop an image to fit the CoC rotating banner'
  say 'Usage: cropbanner imagefile target-width target-height [resizeWidthOnly]'
  exit
end
if \datatype(w,'W') then w=720
if \datatype(h,'W') then h=320
parse var imgf fstem '.' .
dims=cmdTop('iid  -format %w-%h' imgf)
parse var dims wd '-' ht
say 'Original dimensions:' wd 'x' ht
targetWd=w
targetHt=h
tempfile=fstem'-'targetWd'w.jpg'
resultfile=fstem'-'targetWd'x'targetHt'.jpg'
pctWd=targetWd/wd*100

-- Resize to a width
-- icmd='magick' imgf '-resize' format(pctWd,,2)'%' tempfile
icmd='magick' imgf '-resize' targetWd tempfile
say 'Cmd:' icmd
icmd

if \SysFileExists(tempfile) then do
  say 'Unable to resize to width!'
  exit
end
if resizeWidthOnly=1 then exit

-- Now query the new height
ht=cmdTop('iid  -format %h' tempfile)
say 'New height:' ht
shaveHt=(ht-targetHt)/2
icmd='magick' tempfile '-shave 0x'shaveHt resultfile
say 'Cmd:' icmd
icmd
if SysFileExists(resultfile) then 'del' tempfile
exit

::requires 'UtilRoutines.rex'
