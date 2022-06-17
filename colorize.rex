/* colorize */
parse arg filename colorname outp options
if abbrev('?', colorname) then do
  say 'usage: colorize imagefile colorname [outputfile]'
  say 'examples - colorize cheechers.jpg purple'
  say '           colorize cheechers.jpg #C94571'
  exit
end

if outp='' then do
  parse value filespec('N', filename) with filestem '.' ext
  if left(colorname,1)='#' then outp=filestem'-'substr(colorname,2)'.'ext
  else                          outp=filestem'-'colorname'.'ext
end
if pos('#', colorname)>0 then
  icmd='magick' filename '-colorspace gray +level-colors ,"'colorname'"' outp
else
  icmd='magick' filename '-colorspace gray +level-colors ,'colorname outp

ADDRESS CMD icmd
say 'See colorized file:' outp
exit
