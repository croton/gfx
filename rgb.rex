/* rgb - convert to and from RGB */
arg values
if abbrev('?', values) then do
  say 'usage: rgb values'
  say '  example ..'
  say '  rgb red green blue -> hex value'
  say '  rgb #hex_value -> RGB values'
  say '  rgb windows_value -> RGB values'
  exit
end

if words(values)>=3 then do
  inputType='RGB'
  parse var values red green blue .
  result=rgb2hex(red,green,blue)
end
else do
  if abbrev(values,'#') then do
    inputType='HEX'
    result=html2rgb(substr(values,2))
  end
  else do
    inputType='SYS'
    result=sys2rgb(values)
  end
end
if inputType='RGB' then say left('RGB' red green blue,20,'.') result
else                    say inputType values '->' result
exit

rgb2hex: procedure
  arg red, green, blue
  if \datatype(red,'W') | red<0 | red>255 then red=0
  if \datatype(green,'W') | green<0 | green>255 then green=0
  if \datatype(blue,'W') | blue<0 | blue>255 then blue=0
  return '#'d2hx(red)||d2hx(green)||d2hx(blue)

d2hx: procedure
  arg num
  val=d2x(num)
  if (datatype(val,'N') & val<9) then return '0'val
  return val

/* Convert a windows hex value to RGB */
sys2rgb: procedure
  arg decval
  if \datatype(decval,'W') then return ''
  bluedivisor=2**16
  greendivisor=2**8
  greenq=0
  redq=0
  blueq=decval%bluedivisor    -- int division
  blueqi=decval//bluedivisor  -- remainder
  if blueqi>0 then do
    greenq=blueqi%greendivisor
    redq=blueqi//greendivisor
  end
  return left('R='redq,6) left('G='greenq,6) left('B='blueq,6)

/* Convert an RGB value to a windows hex value */
rgb2sys: procedure
  arg red, green, blue
  bluefactor=2**16
  greenfactor=2**8
  if \datatype(red,'W') | red<0 | red>255 then red=0
  if \datatype(green,'W') | green<0 | green>255 then green=0
  if \datatype(blue,'W') | blue<0 | blue>255 then blue=0
  return red+(green*greenfactor)+(blue*bluefactor)

/* Convert a HTML hex value to RGB */
html2rgb: procedure
  arg rv +2 gv +2 bv +2
  if bv='' then return ''
  return x2d(rv) x2d(gv) x2d(bv)
