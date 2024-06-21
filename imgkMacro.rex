/* A collection of macros using ImageMagick */
::requires 'UtilRoutines.rex'

/* Examples
   convert -sample 80x40 arg1 outf
   convert -sample 25%x25% arg1 outf
*/
::routine makeThumbnail PUBLIC
  parse arg fn, width, height
  if \datatype(width,'W') then width=10
  if \datatype(height,'W') then height=10
  icmd='magick' fn '-trim -resize' width'x'height getOutput(fn)
  call prompt icmd
  return icmd

::routine makeThumbByPct PUBLIC
  parse arg fn, percentage outfn
  if \datatype(percentage,'N') then percentage=10
  pct=percentage/100
  parse value cmdTop('iid  -format %w-%h' fn) with wd '-' ht
  width=format(wd*pct,,0)
  height=format(ht*pct,,0)
  outp=?(outfn='', getOutput(fn), outfn)
  icmd='magick' fn '-trim -resize' width'x'height outp
  call prompt icmd
  return icmd

/* Examples
  convert between formats, ex. myimg.jpg myimg.png
  convert %1 %out%
*/
::routine convertFormat PUBLIC
  parse arg fn, targetExt
  if targetExt='' then say 'Please specify a target format.'
  else if filespec('E', fn)=targetExt then do
    say 'Already in format' targetExt
    icmd=''
  end
  else do
    parse var fn filestem '.' .
    icmd='magick' fn filestem'.'targetExt
    call prompt icmd
  end
  return icmd

/* convert -rotate 45 %1 %out% */
::routine rotate PUBLIC
  parse arg fn, rotation
  if \datatype(rotation,'W') then rotation=45
  else if abs(rotation)>360 then rotation=rotation//360
  icmd='magick -rotate' rotation fn getOutput(fn, 'ro'rotation)
  call prompt icmd
  return icmd

::routine getOutput PRIVATE
  parse arg filestem '.' ext, suffix
  if suffix='' then outfn=filestem'-out.'ext
  else              outfn=filestem'-'suffix'.'ext
  if SysFileExists(outfn) then outfn=filestem'-'time('S')||'.'ext
  return filespec('N', outfn)
