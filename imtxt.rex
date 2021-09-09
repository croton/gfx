/* imtxt - Create a text banner */
parse arg outf dim bg font fontsize content
if abbrev('?', outf) then do
  say 'imtxt - Create a text banner'
  say 'usage: imtxt outfile dimension backgdcolor font fontsize phrase'
  say 'example: imtxt msg.jpg 250x50 plum Arial-Black 20 Hi there this is my banner!'
  exit
end
if dim='' then dim='250x150'
if bg='' then bg='thistle'
if font='' then font='Agency-FB-Bold'
if fontsize='' then fontsize='25'
if content='' then content='It is now' time('c')
call make outf, dim, bg, font, fontsize, content
exit

make: procedure
  parse arg outf, dim, bg, fo, fosize, content
  icmd='magick -size' dim '-background' bg '-font' fo '-pointsize' fosize '-fill black -gravity Center caption:"'content'" -flatten' outf
  call prompt icmd
  return

::requires 'UtilRoutines.rex'
::requires 'imagemagick.rex'
