/* mgpress -- Image press down, that is, compress image. */
parse arg filename ratio destination
if filename='' | \SysFileExists(filename) then call help
call compressImage filename, ratio, destination
exit

compressImage: procedure
  parse arg filename, ratio, outputDir
  if \datatype(ratio,'W') then ratio=50
  parse var filename filestem '.' ext
  if outputDir='' then
    newfile=filestem'-qual'ratio'.'ext
  else
    newfile=outputDir'\'filename
  say 'Compress' filename 'by' ratio'%'
  call charout , 'BEFORE: '
  'identify' filename
  -- 'mogrify -strip -quality' ratio'%' filename
  call prompt 'magick' filename '-quality' ratio newfile
  -- 'magick' filename '-quality' ratio newfile
  call charout , 'AFTER:  '
  'identify' newfile
  return

help: procedure
  say 'mgpress - Use ImageMagick to compress (and backup) an image'
  say 'Usage: mgpress imagefilename [qualityPct] [outputDir]'
  say '  default qualityPct = 50'
  exit

::requires 'UtilRoutines.rex'
