/* rz -- Resize an image to a given width. */
parse arg imgfilename newwidth
if imgfilename='' then do
  say 'rz - Resize an image to a given width'
  say 'Usage: rz imgfilename width'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'rz: File not found,' imgfilename
  exit
end

imgwidth=cmdTop('identify -format %w' imgfilename)
if \imgwidth~datatype('N') then do
  say 'Unable to determine width of' imgfilename
  exit
end

-- ecmd=resizeByPercentage(imgfilename, imgwidth, newwidth)
ecmd=resize(imgfilename, newwidth)
say ecmd
ADDRESS CMD ecmd
exit

resizeByPercentage: procedure
  parse arg filename, imgwidth, newwidth
  parse var filename fstem '.' fext
  if \datatype(newwidth, 'W') then pct=75
  else                             pct=format(newwidth/imgwidth*100,,2)

  parse var pct wholenum '.' decm
  if decm=0 then pct=wholenum
  outp=fstem'-p'pct~changestr('.','')||'.'fext
  return 'magick' imgfilename '-resize' pct'%' outp

-- How to resize to a height ... x[heightValue]
-- 'magick' imgfilename '-resize x610' outp
resize: procedure
  parse arg filename, newdim
  parse var filename fstem '.' fext
  outp=fstem'-'newdim'.'fext
  return 'magick' filename '-resize' newdim outp

::requires 'UtilRoutines.rex'
