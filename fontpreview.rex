/* fontpreview -- Preview a given string in various fonts. */
parse arg phrase
if abbrev('?', phrase) then do
  say 'usage: fontpreview phrase [-fs font-size][-w canvas-width][-o outputfile][-s selected-font-file]'
  exit
end

w=wordpos('-fs',phrase)
if w>0 then do; fs=word(phrase,w+1); phrase=delword(phrase,w,2); end; else fs=20
if \datatype(fs,'W') then fs=20

w=wordpos('-w',phrase)
if w>0 then do; canvaswidth=word(phrase,w+1); phrase=delword(phrase,w,2); end; else canvaswidth=500
if \datatype(canvaswidth,'W') then canvaswidth=500

w=wordpos('-o',phrase)
if w>0 then do; output=word(phrase,w+1); phrase=delword(phrase,w,2); end; else output=''

w=wordpos('-s',phrase)
if w>0 then do; selected=word(phrase,w+1); phrase=delword(phrase,w,2); end; else selected=''

if selected='' then
  --call printallfonts strip(phrase), fs, canvaswidth, ?(output='', 'font-sample', output)
  say 'print all fonts'
else
  say 'print from these fonts:' selected
  call printfont strip(phrase), fs, canvaswidth, ?(output='', 'font-sample', output), selected
exit

printfont: procedure
  parse arg phrase, fontsize, totalwidth, outputfile, fontfile
  fonts=arrayfromfile(fontfile)
  fn=outputfile'.gif'
  say 'Print' fonts~items 'fonts to' fn 'preview phrase "'phrase'" at size' fontsize 'setting width as' totalwidth
  fontnum=0
  lineHt=30
  ypos=20
  ftline=''
  loop font over fonts
    fontnum=fontnum+1
    fontcmd.fontnum=font(font, fontsize) placetext(phrase, 10, ypos) font(,fontsize-4) placetext('('font')', 180, ypos)
    ftline=ftline fontcmd.fontnum
    ypos=ypos+lineHt
  end
  ADDRESS CMD 'magick' canvas(totalwidth, ypos, 'antiquewhite') fg(black) strip(ftline) fn '2>>fontpreview-errors'
  return

printallfonts: procedure
  parse arg phrase, fontsize, totalwidth, outputfile
  fonts=arrayfromfile('C:\Users\celes\cjp\x2\lists\imgk-fonts.xfn')
  say 'Print' fonts~items 'fonts to' outputfile 'preview phrase "'phrase'" at size' fontsize 'setting width as' totalwidth
  bundlesize=fonts~items%10 -- whole number of items per page
  group=1
  fontnum=0
  lineHt=30
  ypos=20
  ftline=''
  loop font over fonts
    fontnum=fontnum+1
    fontcmd.fontnum=font(font, fontsize) placetext(phrase, 10, ypos) font(,fontsize-4) placetext('('font')', 180, ypos)
    ftline=ftline fontcmd.fontnum
    ypos=ypos+lineHt
    if fontnum//bundlesize=0 then do
      fn=outputfile'-'group'.gif'
      fontsUnprinted=fonts~items-fontnum
      say 'Print last item='fontnum 'to file' fn 'fonts left to print:' fontsUnprinted
      ADDRESS CMD 'magick' canvas(totalwidth, ypos, 'antiquewhite') fg(black) strip(ftline) fn '2>>fontpreview-errors'
      group=group+1
      ypos=20
      ftline=''
    end
  end
  if fontsUnprinted>0 then do
    fn=outputfile'-'group'.gif'
    say 'Print last group to file' fn
    ADDRESS CMD 'magick' canvas(totalwidth, ypos, 'antiquewhite') fg(black) strip(ftline) fn '2>>fontpreview-errors'
  end
  else say 'All fonts have been previewed!'
  return

::requires 'iolib.rex'
::requires 'imgkMacro.rex'
