/* mgopacity - Change opacity of an image */
parse arg filename pct outp options
if abbrev('?', filename) then do
  say 'mgopacity - Change opacity of an image. Default pct=50'
  say 'usage: mgopacity imagefile [percentage] [outputfile]'
  say 'examples - mgopacity cheechers.jpg'
  say '           mgopacity cheechers.jpg 25 ch-25o.jpg'
  exit
end
if \datatype(pct,'W') then pct=50
if outp='' then do
  parse var filename filestem '.' ext
  outp=filestem'-o'pct'.'ext
end

icmd='magick' filename '-fill white -colorize' pct'%' outp
say 'Set opacity of' filename 'to' pct'% ->' outp
ADDRESS CMD icmd
exit
