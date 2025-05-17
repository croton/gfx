/* colorcontrast
   From https://www.w3.org/TR/AERT/#color-contrast
  Two colors provide good color visibility if the brightness difference and the color difference
  between the two colors are greater than a set range.

  Color brightness is determined by the following formula:
  ((red-value X 299) + (green-value X 587) + (blue-value X 114)) / 1000
  Note: This algorithm is taken from a formula for converting RGB values to YIQ values.
        This brightness value gives a perceived brightness for a color.

  Color difference is determined by the following formula:
  (maximum (red-value 1, red-value 2) - minimum (red-value 1, red-value 2)) +
  (maximum (green-value 1, green-value 2) - minimum (green-value 1, green-value 2)) +
  (maximum (blue-value 1, blue-value 2) - minimum (blue-value 1, blue-value 2))

  The range for color brightness difference is 125. The range for color difference is 500.
  Suggested message:
    Poor visibility between text and background colors.
  Suggested repair:
    Allow the user to change the poor color combinations.
    Store any good color combinations entered by the user and use them as default prompts in the future.
*/
arg hexcolor1 hexcolor2 option
if (hexcolor1='' | hexcolor2='') then do
  say 'usage: colorcontrast hexcolor1 hexcolor2 [LD|B]'
  exit
end

call compareHexColor hexcolor1, hexcolor2
say 'Darker color:' darker(hexcolor2, hexcolor1)
if option='LD' then do
  dark=darken(hexcolor1, .3)
  light=lighten(hexcolor1, .3)
  say 'Hex' hexcolor1 'darker='dark 'lighter='light
end
else do
  say 'Show brightness for' hexcolor1 getHexBrightness(hexcolor1)

end
exit

darker: procedure
  arg hexcolor1, hexcolor2
  parse value hex2rgb(hexcolor1) with r1 g1 b1
  parse value hex2rgb(hexcolor2) with r2 g2 b2
  brightDiff=getBrightness(r2, g2, b2) - getBrightness(r1, g1, b1)
  -- Darker colors have lower brightness
  if brightDiff>0 then return hexcolor1
  return hexcolor2

compareHexColor: procedure
  arg hexcolor1, hexcolor2
  parse value hex2rgb(hexcolor1) with r1 g1 b1
  parse value hex2rgb(hexcolor2) with r2 g2 b2
  bright1=getBrightness(r1, g1, b1)
  bright2=getBrightness(r2, g2, b2)
  say hexcolor1 '('r1 g1 b1') brightness ->' bright1
  say hexcolor2 '('r2 g2 b2') brightness ->' bright2
  brightDiff=(bright2-bright1)
  say 'Brightness diff:' brightDiff
  colorDiff=getDiff(r1, r2, g1, g2, b1, b2)
  say 'Color diff:' colorDiff
  if abs(brightDiff)>=125 then say 'Contrast OK'
  else say 'Not enough contrast'
  if colorDiff>=500 then say 'Color variance OK'
  else say 'Not enough color variance'
  return

demoConversions: procedure
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

/* Determine color brightness for a given RGB value. */
getBrightness: procedure
  parse arg r, g, b
  return ((r*299)+(g*587)+(b*114))/1000

getHexBrightness: procedure
  parse arg hexcolor
  parse value hex2rgb(hexcolor) with r g b
  return getBrightness(r, g, b)

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
