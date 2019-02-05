/* cocimg -- Save CelebrationOfCaring image tasks */
parse arg pfx params
select
  when pfx='flyer' then call flyerthumb params
  when pfx='pkg1' then call pkg1 params
  when pfx='ocrop' then call ocrop params
  when pfx='pdf2jpg' then call pdf2jpg params
  when pfx='xwhite' then call noborder params
  otherwise call help
end
exit

pdf2jpg: procedure
  parse arg imgfilename outfile
  if outfile='' then do
    parse var imgfilename filestem'.' ext
    outfile=filestem'-fromPDF.jpg'
  end
  icmd='imconvert -verbose -density 150 -trim' imgfilename '-quality 100 -sharpen 0x1.0' outfile
  say 'Run' icmd
  ADDRESS CMD icmd
  return

flyerthumb: procedure
  parse arg imgfilename outfile
  if outfile='' then do
    parse var imgfilename filestem'.' ext
    outfile=filestem'-thumb.'ext
  end
  icmd='imconvert' imgfilename '( +clone -background black -shadow 60x5+5+5 )',
       '+swap -background none -layers merge +repage -rotate -5' outfile
  /* Alternate option ....
    -rotate -5 -resize 82%% outfile
    imconvert %2 ( +clone -background white ) +swap -background none -layers merge +repage -rotate -5 outfile
  */
  say 'Run' icmd
  return

pkg1: procedure
  parse arg imgfilename outfile fontname
  cv='C:\cjptech\ImageMagick-6.8.9-4\imconvert'
  if outfile='' then do
    parse var imgfilename filestem'.' ext
    outfile=filestem'-out.'ext
  end
  if fontname='' then fontname='Ebrima-Bold'
  icmd='imconvert' imgfilename '-font %fontname% -pointsize 14 -annotate +50+150 "$"',
       '-pointsize 24 -annotate +57+156 "375" -annotate +30+185 "Individual"' outfile
  say 'Run' icmd
  return

/*
:ocrop
:: IM identify may have warnings; filter them out to error file
:: identify -format %%w %1 2> imid_err.txt | asarg set /a imgwidth =
set out=%3
if "%3"=="" set out=%~n2_out%~x2
say imconvert %2
  ( +clone -threshold -1 -negate -fill white -draw "circle 45,45 45,0" )
  -alpha off -compose copy_opacity -composite %out%

:noborder
set out=%3
set fzPct=%4
if "%3"=="" set out=%~n2_noborder%~x2
if "%4"=="" set fzPct=10
imconvert %2 -fuzz %fzPct%%% -trim +repage %out%
*/

help:
say 'cocimg - Run imaging tasks for CelebrationOfCaring'
say 'options:'
say '  flyer - Add shadow and rotate the CoC Flyer thumbnail'
say '    Usage: flyer imagefilename [outputfile]'
say '  pkg1 - Layer text for Individual sponsorship'
say '    Usage pkg1 imagefilename [outputfile] [fontname]'
say '  ocrop - Crop a circular region from an image'
say '    Usage ocrop imagefilename [outputfile]'
say '  pdf2jpg - Convert PDF to JPG'
say '    Usage pdf2jpg imagefilename [outputfile]'
say '  xwhite - Remove white border from an image'
say '    Usage xwhite imagefilename [outputfile] [fuzzPct]'
exit
