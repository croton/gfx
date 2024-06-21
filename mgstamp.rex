/* mgstamp - Stamp text onto an image or canvas.
   magick imgfile -gravity northwest -font Segoe-UI -fill crimson -pointsize 20 -annotate +20+20 "your message" outfile
   or simpler syntax
   magick -size 500x200 canvas:none -pointsize 16 -draw "text 15,15 'At our house we open cans.'" outfile
*/
parse arg imgfilename phrase
if imgfilename='' then do
  say 'mgstamp - Stamp text onto an image.'
  say 'Usage: mgstamp imgfilename phrase [options]'
  say '  -g gravity, default=northwest'
  say '  -f font, default=Consolas'
  say '  -fs fontsize, default=20'
  say '  -c color, default=RoyalBlue'
  say '  -x xpos, default=0'
  say '  -y ypos, default=0'
  say '  -o outputfile, default=filename-stamp.extension'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'mgstamp: Image file not found,' imgfilename
  imgfilename='-size 500x500 xc:lightblue'
end

w=wordpos('-g',phrase)
if w>0 then do; orient=word(phrase,w+1); phrase=delword(phrase,w,2); end; else orient='northwest'

w=wordpos('-f',phrase)
if w>0 then do; font=word(phrase,w+1); phrase=delword(phrase,w,2); end; else font='Consolas'

w=wordpos('-fs',phrase)
if w>0 then do; fontsize=word(phrase,w+1); phrase=delword(phrase,w,2); end; else fontsize=20

w=wordpos('-c',phrase)
if w>0 then do; color=word(phrase,w+1); phrase=delword(phrase,w,2); end; else color='RoyalBlue'

w=wordpos('-x',phrase)
if w>0 then do; xpos=word(phrase,w+1); phrase=delword(phrase,w,2); end; else xpos=0

w=wordpos('-y',phrase)
if w>0 then do; ypos=word(phrase,w+1); phrase=delword(phrase,w,2); end; else ypos=0

w=wordpos('-o',phrase)
if w>0 then do; outf=word(phrase,w+1); phrase=delword(phrase,w,2); end; else outf='mgstamp.png'

icmd='magick' imgfilename '-gravity' orient '-font' font '-pointsize' fontsize '-fill' color '-annotate' offset(xpos,ypos) '"'phrase'"' outf
call prompt icmd
exit

offset: procedure
  arg xpos, ypos
  return '+'xpos'+'ypos

::requires 'UtilRoutines.rex'
