/* cropper - Crop an image optionally specifying a size and an offset */
parse arg imgfilename wd ht xpos ypos
if abbrev('?', imgfilename) then do
  say 'cropper - Crop an image optionally specifying a size and an offset'
  say 'Usage: cropper imgfilename width height xpos ypos'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'cropper: File not found,' imgfilename
  exit
end
if \datatype(xpos,'W') then xpos=0
if \datatype(ypos,'W') then ypos=0

xcmd=cropCmd(imgfilename,wd,ht,xpos,ypos)
call prompt xcmd
exit

cropCmd: procedure
  parse arg imgfilename, wd, ht, xpos, ypos
  parse var imgfilename filestem '.' ext
  outp=cmdtop('identify -format %wx%h' imgfilename)
  parse var outp imgW 'x' imgH
  -- If crop width not provided use image width
  if datatype(wd,'W') then width=wd
  else if datatype(imgW,'W') then width=imgW
  else width=100
  -- If crop height not provided use half of image height
  if datatype(ht,'W') then height=ht
  else if datatype(imgH,'W') then height=imgH/2
  else height=100
  return 'magick' imgfilename '-crop' width'x'height||'+'xpos'+'ypos filestem'-'xpos'-'ypos'.'ext

::requires 'UtilRoutines.rex'
