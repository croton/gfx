/* mglogo - Use imagemagick to create simple transparent logo
   The first word and second word each have their own color.
   example - mglogo mylogo 150 58 Your Study.com
*/
parse arg outf imgwidth hOffset phrase
if abbrev('?', outf) then do
  say 'mglogo - Create a logo from a 2-word phrase'
  say 'usage: mglogo output width xPos-Second-Word phrase'
  say 'ex: mglogo my-logo.png 150 75 Bubbling Brook.com'
  exit
end
if \datatype(imgwidth,'W') then imgwidth=200
if \datatype(hOffset,'W') then hOffset=50  -- position at which to write word TWO

icmd=canvas(imgwidth,50) font('Georgia-Bold', 24, 'darksalmon') orient('NW') placetext(word(phrase,1)) ,
     placetext(subword(phrase,2),'firebrick', hOffset)
say 'RC' run(icmd outf)

if SysFileExists(outf) then 'call jpg' outf
exit

run: procedure
  parse arg command
  say 'magick>' command
  ADDRESS CMD 'magick' command
  return rc

canvas: procedure
  parse arg width, height, color
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  if color='' then bg='xc:none'
  else             bg='xc:'color
  return '-size' width'x'height bg

font: procedure
  parse arg name, size, color
  if name='' then name='Tahoma-Bold'
  if \datatype(size,'W') then size=24
  if color='' then return '-font' name '-pointsize' size
  return '-fill' color '-font' name '-pointsize' size

placetext: procedure
  parse arg text, color, xpos, ypos
  if \datatype(xpos,'W') then xpos=0
  if \datatype(ypos,'W') then ypos=0
  if color='' then return '-annotate +'xpos'+'ypos '"'text'"'
  return fg(color) '-annotate +'xpos'+'ypos '"'text'"'

orient: procedure
  arg p
  select
    when p='N' then placement='north'
    when p='E' then placement='east'
    when p='S' then placement='south'
    when p='W' then placement='west'
    when p='NE' then placement='northeast'
    when p='SE' then placement='southeast'
    when p='NW' then placement='northwest'
    when p='SW' then placement='southwest'
    otherwise placement='center'
  end
  return '-gravity' placement

fg: procedure
  parse arg color
  if color='' then color='black'
  return '-fill' color

name2rgb: procedure
  parse arg colorname
  -- Use the "clz" utility to perform lookup
  return cmdtop('clz n' colorname'|grep -i "'colorname 'rgb"|wordf 3')

::requires 'UtilRoutines.rex'
