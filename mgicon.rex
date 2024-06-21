/* mgicon - Make a favicon from an image. */
parse arg filename options
if abbrev('?', filename) then do
  say 'usage: mgicon imagefile'
  exit
end
if \SysFileExists(filename) then do
  say 'File not found:' filename
  exit
end

parse var filename fstem '.' fext
icmd='magick' filename '-background none -resize 16x16 -density 16x16' fstem'.ico'
say icmd
ADDRESS CMD icmd
exit
