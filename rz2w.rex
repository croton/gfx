/* rz2w -- Resize an image to a given width. */
parse arg imgfilename newwidth
if imgfilename='' then do
  say 'rz2w - Resize an image to a given width'
  say 'Usage: rz2w imgfilename width'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'rz2w: File not found,' imgfilename
  exit
end

imgwidth=cmdOutputLine('identify -format %w' imgfilename)
if \imgwidth~datatype('N') then do
  say 'Unable to determine width of' imgfilename
  exit
end

parse var imgfilename fstem '.' fext
if \newwidth~datatype('W') then pct=75
else                            pct=format(newwidth/imgwidth*100,,2)

parse var pct wholenum '.' decm
if decm=0 then pct=wholenum
outp=fstem'-p'pct~changestr('.','')||'.'fext
ecmd='imconvert' imgfilename '-resize' pct'%' outp
say ecmd
ADDRESS CMD ecmd
exit

::requires 'CmdUtils.cls'
