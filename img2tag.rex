/* img2tag -- Generate an HTML tag for a given image. */
parse arg imgfilename
if imgfilename='' then do
  say 'img2tag - Generate an HTML tag for a given image'
  say 'Usage: img2tag imgfilename'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'img2tag: File not found,' imgfilename
  exit
end

tmpl='<img src="?1" alt="?1" width="?2" height="?3" />'
outp=cmdOut('identify -format %wx%h' imgfilename '|sed "s/x/ /g"')
if outp~items=0 then dim='0 0'
else                 dim=outp[1]
say merge(tmpl, imgfilename dim)
exit

::requires 'UtilRoutines.rex'
