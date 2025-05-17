
::routine darken PUBLIC
  arg hexcolor, factor
  if \datatype(factor,'N') then factor=.25
  else if factor>1 then factor=.25
  parse value hex2rgb(hexcolor) with R G B
  r2=format(R*(1-factor),,0)
  g2=format(G*(1-factor),,0)
  b2=format(B*(1-factor),,0)
  return rgb2hex(r2,g2,b2)

::routine lighten PUBLIC
  arg hexcolor, factor
  if \datatype(factor,'N') then factor=.25
  else if factor>1 then factor=.25
  parse value hex2rgb(hexcolor) with R G B
  r2=format(R+(255-R)*factor,,0)
  g2=format(G+(255-G)*factor,,0)
  b2=format(B+(255-B)*factor,,0)
  return rgb2hex(r2,g2,b2)

::routine darker PUBLIC
  arg hexcolor1, hexcolor2
  parse value hex2rgb(hexcolor1) with r1 g1 b1
  parse value hex2rgb(hexcolor2) with r2 g2 b2
  brightDiff=getBrightness(r2, g2, b2) - getBrightness(r1, g1, b1)
  -- Darker colors have lower brightness
  if brightDiff>0 then return hexcolor1
  return hexcolor2

/* Determine color brightness for a given RGB value. */
::routine getBrightness PUBLIC
  arg r, g, b
  return ((r*299)+(g*587)+(b*114))/1000

/* Determine color difference for a given RGB value. */
::routine getColorDiff PUBLIC
  arg r1, r2, g1, g2, b1, b2
  return (max(r1, r2)-min(r1, r2)) + (max(g1, g2)-min(g1, g2)) + (max(b1, b2)-min(b1, b2))

/* Convert a six-character color hex string to RGB values. */
::routine hex2rgb PUBLIC
  -- arg r +2 g +2 b +2
  arg rgbvalue
  if left(rgbvalue,1)='#' then val=substr(rgbvalue,2)
  else                         val=rgbvalue
  if length(val)=3 then val=copies(val,2)
  say 'parsing rgb' val
  parse var val r +2 g +2 b +2
  return x2d(r) x2d(g) x2d(b)

::routine rgb2hex PUBLIC
  arg R, G, B
  return d2x(R)||d2x(G)||d2x(B)

::routine lightOrDark PUBLIC
  arg hexcolor
  parse value hex2rgb(hexcolor) with r g b
  return (getBrightness(r,g,b)>120)

::routine LOD PUBLIC
  arg R G B
  if \datatype(R,'W') then R=0
  if \datatype(G,'W') then G=0
  if \datatype(B,'W') then B=0
  return (getBrightness(R,G,B)>120)
