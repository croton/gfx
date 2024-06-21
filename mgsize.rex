/* mgsize -- Resize an image to a given width. */
parse arg imgfilename newwidth options
if abbrev('?', imgfilename) then do
  say 'mgsize - Resize an image to a given width or height'
  say 'Usage: mgsize imgfilename width [-h]'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'mgsize: File not found,' imgfilename
  exit
end

-- ecmd=resizeByPercentage(imgfilename, newwidth)
call prompt resize(imgfilename, newwidth, options)
exit

resize: procedure
  parse arg filename, newdim, doHeight
  parse var filename fstem '.' fext
  outp=fstem'-'newdim'.'fext
  if doHeight='' then amt=newdim
  else                amt='x'newdim
  return 'magick' filename '-resize' amt outp

resizeByPercentage: procedure
  parse arg filename, newwidth
  imgwidth=cmdTop('identify -format %w' filename)
  if \imgwidth~datatype('N') then do
    say 'Unable to determine width of' filename
    return
  end
  parse var filename fstem '.' fext
  if \datatype(newwidth, 'W') then pct=75
  else                             pct=format(newwidth/imgwidth*100,,2)
  parse var pct wholenum '.' decm
  if decm=0 then pct=wholenum
  outp=fstem'-p'pct~changestr('.','')||'.'fext
  return 'magick' imgfilename '-resize' pct'%' outp

-- How to resize to a height ... x[heightValue]
-- 'magick' imgfilename '-resize x610' outp

::requires 'UtilRoutines.rex'
