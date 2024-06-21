/* mgcolorize */
parse arg filename colorname outp options
if abbrev('?', colorname) then do
  say 'usage: mgcolorize imagefile colorname [outputfile] [-t tint]'
  say 'examples - mgcolorize cheechers.jpg purple'
  say '           mgcolorize cheechers.jpg #C94571'
  exit
end

w=wordpos('-t',options)
if w>0 then do; tint=word(options,w+1); options=delword(options,w,2); end; else tint=100
if \datatype(tint,'W') then tint=200

if outp='' then do
  parse value filespec('N', filename) with filestem '.' ext
  if left(colorname,1)='#' then outp=filestem'-'substr(colorname,2)'.'ext
  else                          outp=filestem'-'colorname'.'ext
end
if pos('#', colorname)>0 then
  icmd='magick' filename '-colorspace gray +level-colors ,"'colorname'"' outp
else
  icmd='magick' filename '-colorspace gray +level-colors ,'colorname outp

altcmd='magick' filename '-colorspace gray -fill' colorname '-tint' tint outp

ADDRESS CMD icmd
say 'See colorized file:' outp
exit
