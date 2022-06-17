/* colorparse -- A filter for color variables derived from a stylesheet.
   Instead of seeing just hex values, this filter will merge the values
   with an HTML template in order to actually see the colors.
*/
parse arg options
if options='?' then do
  say 'usage: colorparsef options'
  exit
end

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd

/* A typical line might be -
   --ltBlue1: #C5E9F7;
*/
do forever
  parse pull field fvalue .
  if field='' then iterate
  say merge(field, fvalue)
end
exit

merge: procedure
  parse arg fname, fvalue
  if isDarkHex(fvalue) then css='style="color:#FFFFFF; background:'fvalue'"'
  else                      css='style="background:'fvalue'"'
  return '<span' css'>'fname'</span>'

isDarkHex: procedure
  arg hexcolorcode
   -- Remove pound symbol and semi-colon
  hexval=substr(changestr(';', hexcolorcode, ''),2)
  -- return 0
  parse value hex2rgb(hexval) with r1 g1 b1
  return getBrightness(r1,g1,b1)<90

getBrightness: procedure
  parse arg r, g, b
  return ((r*299)+(g*587)+(b*114))/1000

/* Convert a six-character color hex string to RGB values. */
hex2rgb: procedure
  parse arg r +2 g +2 b +2
  return x2d(r) x2d(g) x2d(b)

programEnd:
  exit 0
