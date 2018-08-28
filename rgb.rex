-- rgb
parse arg values
rgbInput=0
if values~words=1 then result=hex2rgb(values)
else do
  rgbInput=1
  parse var values red green blue .
  result=rgb2hex(red,green,blue)
end
if rgbInput then say 'RGB' red green blue '->' result
else             say 'Hex' values '->' result
exit

/*  */
hex2rgb: procedure
parse arg values
remain=values//65536
return remain

/*  */
rgb2hex: procedure
parse arg red green blue
if \datatype(red,'W') | red<0 | red>255 then red=0
if \datatype(green,'W') | green<0 | green>255 then green=0
if \datatype(blue,'W') | blue<0 | blue>255 then blue=0
return blue+(green*256)+(red*65536)

