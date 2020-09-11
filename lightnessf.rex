/* lightness -- A filter to set a CSS class based on darkness of a color */
parse arg options
if options='-?' then do
  say 'usage: lightness options'
  exit
end

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull name rgb hexval
  if name='' then iterate
  if isDark(substr(hexval,2)) then say name rgb hexval 'lightText'
  else                             say name rgb hexval
end
exit

isDark: procedure
  arg hexval
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
