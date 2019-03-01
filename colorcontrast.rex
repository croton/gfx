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

  The rage for color brightness difference is 125. The range for color difference is 500.
  Suggested message:
    Poor visibility between text and background colors.
  Suggested repair:
    Allow the user to change the poor color combinations.
    Store any good color combinations entered by the user and use them as default prompts in the future.
*/
arg hexcolor1 hexcolor2 .
color2='ffffff'
say 'color2 to RGB:' color2 '->' hex2rgb(color2)
parse value hex2rgb(hexcolor1) with r1 g1 b1
parse value hex2rgb(hexcolor2) with r2 g2 b2
bright1=getBrightness(r1, g1, b1)
bright2=getBrightness(r2, g2, b2)
say hexcolor1 '('r1 g1 b1') brightness ->' bright1
say hexcolor2 '('r2 g2 b2') brightness ->' bright2
say 'Brightness diff:' (bright2-bright1)
say 'Color diff:' getDiff(r1, r2, g1, g2, b1, b2)
exit

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
  -- say '['r g b']'
  return x2d(r) x2d(g) x2d(b)

