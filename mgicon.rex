/* mgicon - Make a favicon from an image. */
parse arg filename options
if abbrev('?', filename) then do
  say 'usage: mgicon imagefile [-s size]'
  exit
end
if \SysFileExists(filename) then do
  say 'File not found:' filename
  exit
end

w=wordpos('-s',options)
if w>0 then do; size=word(options,w+1); options=delword(options,w,2); end; else size=''
-- if \datatype(size,'W') then size=100

parse var filename fstem '.' fext
dimensions=size'x'size
if size='' then
  icmd='magick' filename '-background none -density 100x100' fstem'.ico'
else
  icmd='magick' filename '-background none -resize' dimensions '-density' dimensions fstem'.ico'
say icmd
ADDRESS CMD icmd
exit
