/* An API for common tasks using ImageMagick */
::requires 'UtilRoutines.rex'

::routine imgkVersion public
  return '0.01'

::routine makeCanvas public
  parse arg width color outf
  if datatype(width,'W') then isize=width'x'width
  else                        isize=width
  if color='' then color='khaki'
  if outf='' then outf='tmp.jpg'
  icmd='magick -size' isize 'xc:'color outf
  call prompt icmd
  return icmd

::routine makeCanvasClear public
  parse arg inf outf
  icmd='magick' inf '-alpha transparent' outf
  call prompt icmd
  return icmd

::routine makeGradient public
  parse arg width height color1 color2 outf
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  if color1='' then color1='white'
  if color2='' then color2='black'
  if outf='' then outf='tmp.jpg'
  icmd='magick -size' width'x'height 'gradient:'color1'-'color2 outf
  ok=run(icmd)
  if ok<0 then return ''  -- cmd declined, do not store
  return icmd

