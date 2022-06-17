/* makelogo - Use imagemagick to create simple transparent logo
   The first word and second word each have their own color.
   example - makelog mylogo 150 58 Your Study.com
*/
parse arg outf imgwidth hOffset phrase
if abbrev('?', outf) then do
  say 'makelogo - Create a logo from a 2-word phrase'
  say 'usage: makelogo output width xPos-Second-Word phrase'
  exit
end
if \datatype(imgwidth,'W') then imgwidth=200
if \datatype(hOffset,'W') then hOffset=50  -- position at which to write word TWO

word1Color='"rgb(0,104,139)"' -- DeepSkyBlue4 rgb(0,104,139) #00688B
word2Color='"rgb(0,154,205)"' -- DeepSkyBlue3 rgb(0,154,205) #009ACD
icmd='magick -size' imgwidth'x50 xc:none -fill "rgb(0,104,139)" -font Tahoma-Bold -pointsize 24 -gravity northwest' ,
  '-annotate +0+0 "'word(phrase,1)'" -fill "rgb(0,154,205)" -annotate +'hOffset'+0 "'subword(phrase,2)'"' outf
say icmd
ADDRESS CMD icmd
'@pause'
'call jpg' outf
say 'Testing...'
say 'magick -size' imgwidth'x50 xc:none' fg('Sienna') font('Segoe-UI', 40) orient() ,
  print('Blaha') print('Hahaha', 'thistle', 95)
exit

font: procedure
  parse arg name, size
  if name='' then name='Tahoma-Bold'
  if \datatype(size,'W') then size=24
  return '-font' name '-pointsize' size

print: procedure
  parse arg text, color, xpos, ypos
  if \datatype(xpos,'W') then xpos=0
  if \datatype(ypos,'W') then ypos=0
  if color='' then return '-annotate +'xpos'+'ypos '"'text'"'
  return fg(color) '-annotate +'xpos'+'ypos '"'text'"'

orient: procedure
  arg p
  select
    when p='NE' then placement='northeast'
    when p='SE' then placement='southeast'
    when p='SW' then placement='southwest'
    when p='C' then placement='center'
    otherwise placement='northwest'
  end
  return '-gravity' placement

fg: procedure
  parse arg color
  return '-fill "'color'"'

name2rgb: procedure
  parse arg colorname
  return 'rgb(?,?,?)'
