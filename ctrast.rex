/* ctrast - Derived from colorcontrast tool */
arg hexcolor options
if abbrev('?', hexcolor) | length(hexcolor)<>6 then do
  say 'usage: ctrast hexcolor [factor]'
  exit
end

dark=darken(hexcolor, options)
light=lighten(hexcolor, options)
say 'Hex' hexcolor 'darker='dark 'lighter='light
call demo hexcolor
exit

demo: procedure
  arg hexcolor1
  parse value hex2rgb(hexcolor1) with r1 g1 b1
  bright1=getBrightness(r1, g1, b1)
  say hexcolor1 '('r1 g1 b1') brightness ->' bright1
  say '*** Change RGB to HEX for black, white, and seashell ***'
  say 'RGB 0, 0, 0 = hex' rgb2hex(0,0,0)
  say 'RGB 255, 255, 255 = hex' rgb2hex(255,255,255)
  say 'RGB seashell rgb(255,245,238) = hex' rgb2hex(255,245,238)
  say '*** Change HEX to RGB for black, white, and seashell ***'
  say 'HEX 000000 = RGB' hex2rgb(000000)
  say 'HEX FFFFFF = RGB' hex2rgb(FFFFFF)
  say 'HEX FFF5EE = RGB' hex2rgb(FFF5EE)
  return

darken: procedure
  arg hexcolor, factor
  if \datatype(factor,'N') then factor=.25
  parse value hex2rgb(hexcolor) with R G B
  r2=format(R*(1-factor),,0)
  g2=format(G*(1-factor),,0)
  b2=format(B*(1-factor),,0)
  say 'Darker RGB by' factor':' r2 g2 b2
  return rgb2hex(r2,g2,b2)

lighten: procedure
  arg hexcolor, factor
  if \datatype(factor,'N') then factor=.25
  parse value hex2rgb(hexcolor) with R G B
  r2=format(R+(255-R)*factor,,0)
  g2=format(G+(255-G)*factor,,0)
  b2=format(B+(255-B)*factor,,0)
  say 'Lighter RGB by' factor':' r2 g2 b2
  return rgb2hex(r2,g2,b2)

/* Determine color brightness for a given RGB value. */
getBrightness: procedure
  parse arg r, g, b
  return ((r*299)+(g*587)+(b*114))/1000

/* Determine color difference for a given RGB value. */
getDiff: procedure
  parse arg r1, r2, g1, g2, b1, b2
  return (max(r1, r2)-min(r1, r2)) + (max(g1, g2)-min(g1, g2)) + (max(b1, b2)-min(b1, b2))

/* Convert a six-character color hex string to RGB values. */
hex2rgb: procedure
  parse arg r +2 g +2 b +2
  return x2d(r) x2d(g) x2d(b)

rgb2hex: procedure
  arg R, G, B
  return d2x(R)||d2x(G)||d2x(B)
