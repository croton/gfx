/* imgk -- utility tool */
parse arg imgfn pfx params
if abbrev('?', imgfn) then call help
else if \SysFileExists(imgfn) then call help

select
  when pfx='th' then call makeThumbnail imgfn, params
  when pfx='thp' then call makeThumbByPct imgfn, params
  when pfx='cv' then call convertFormat imgfn, params
  when pfx='ro' then call rotate imgfn, params
  otherwise 'iid -verbose' imgfn
end
exit

/* Examples
   convert -sample 80x40 %1 %out%
   convert -sample 25%x25% %1 %out%
*/
makeThumbnail: procedure
  parse arg fn, width height
  if \datatype(width,'W') then width=10
  if \datatype(height,'W') then height=10
  icmd='magick' fn '-trim -resize' width'x'height getOutput(fn)
  call prompt icmd
  return

makeThumbByPct: procedure
  parse arg fn, percentage outfn
  if \datatype(percentage,'N') then percentage=10
  pct=percentage/100
  parse value cmdTop('iid  -format %w-%h' fn) with wd '-' ht
  width=format(wd*pct,,0)
  height=format(ht*pct,,0)
  outp=?(outfn='', getOutput(fn), outfn)
  icmd='magick' fn '-trim -resize' width'x'height outp
  call prompt icmd
  return

/* Examples
  convert between formats, ex. myimg.jpg myimg.png
  convert %1 %out%
*/
convertFormat: procedure
  parse arg fn, targetExt
  if targetExt='' then say 'Please specify a target format.'
  else if filespec('E', fn)=targetExt then say 'Already in format' targetExt
  else do
    parse var fn filestem '.' .
    icmd='magick' fn filestem'.'targetExt
    call prompt icmd
  end
  return

/* convert -rotate 45 %1 %out% */
rotate: procedure
  parse arg fn, rotation
  if \datatype(rotation,'W') then rotation=45
  else if abs(rotation)>360 then rotation=rotation//360
  icmd='magick -rotate' rotation fn getOutput(fn, 'ro'rotation)
  call prompt icmd
  return

getOutput: procedure
  parse arg filestem '.' ext, suffix
  if suffix='' then outfn=filestem'-out.'ext
  else              outfn=filestem'-'suffix'.'ext
  if SysFileExists(outfn) then outfn=filestem'-'time('S')||'.'ext
  return filespec('N', outfn)

help: procedure
  say 'imgk -- A utility tool, version' 0.1
  say 'usage: imgk image-filename [options]'
  say 'options:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  exit

::requires 'UtilRoutines.rex'
