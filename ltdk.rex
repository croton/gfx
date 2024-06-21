/* ltdk - Derived from colorcontrast tool */
arg hexcolor options
if abbrev('?', hexcolor) then do
  say 'ltdk - Calculate lighter and darker shades of a color default factor=25%'
  say 'usage: litdk hexcolor [factor]'
  exit
end
if left(hexcolor, 1)='#' then parse var hexcolor '#' hexcolor
if length(hexcolor)=3 then hexcolor=copies(hexcolor,2)

dark=darken(hexcolor, options)
light=lighten(hexcolor, options)
parse value hex2rgb(hexcolor) with r1 g1 b1
say 'Hex' hexcolor '(RGB' r1 g1 b1') darker='dark 'lighter='light
exit

::requires 'colorlib.rex'
