@echo off
:: cocimg -- Save CelebrationOfCaring image tasks

if "%1"=="" goto noargs
if "%1"=="flyer" goto flyerthumb
if "%1"=="pkg1" goto pkg1
if "%1"=="ocrop" goto ocrop
if "%1"=="pdf2jpg" goto pdf2jpg
if "%1"=="xwhite" goto noborder
:: if "%1"=="@" goto @
goto default

:noargs
echo cocimg - Run imaging tasks for CelebrationOfCaring
echo options:
echo   flyer - Add shadow and rotate the CoC Flyer thumbnail
echo     Usage: flyer imagefilename [outputfile]
echo   pkg1 - Layer text for Individual sponsorship
echo     Usage pkg1 imagefilename [outputfile] [fontname]
echo   ocrop - Crop a circular region from an image
echo     Usage ocrop imagefilename [outputfile]
echo   pdf2jpg - Convert PDF to JPG
echo     Usage pdf2jpg imagefilename [outputfile]
echo   xwhite - Remove white border from an image
echo     Usage xwhite imagefilename [outputfile] [fuzzPct]
goto end

:flyerthumb
SETLOCAL
set out=%3
if "%3"=="" set out=%~n2_thumb%~x2
imconvert %2 ( +clone -background black -shadow 60x5+5+5 ) ^
               +swap -background none -layers merge +repage ^
               -rotate -5 %out%
::               -rotate -5 -resize 82%% %out%
::imconvert %2 ( +clone -background white ) +swap -background none -layers merge +repage -rotate -5 %out%
ENDLOCAL
goto end


:pkg1
SETLOCAL
set cv=C:\cjptech\ImageMagick-6.8.9-4\imconvert
set out=%3
if "%3"=="" set out=%~n2_out%~x2
set fontname=%4
if "%fontname%"=="" set fontname=Ebrima-Bold

%cv% %2 -font %fontname% -pointsize 14 -annotate +50+150 "$" ^
        -pointsize 24 -annotate +57+156 "375" ^
        -annotate +30+185 "Individual" %out%
ENDLOCAL
goto end

:ocrop
SETLOCAL
:: IM identify may have warnings; filter them out to error file
:: identify -format %%w %1 2> imid_err.txt | asarg set /a imgwidth =
set out=%3
if "%3"=="" set out=%~n2_out%~x2
echo imconvert %2 ^
  ( +clone -threshold -1 -negate -fill white -draw "circle 45,45 45,0" ) ^
  -alpha off -compose copy_opacity -composite %out%
ENDLOCAL
goto end

:noborder
SETLOCAL
set out=%3
set fzPct=%4
if "%3"=="" set out=%~n2_noborder%~x2
if "%4"=="" set fzPct=10
imconvert %2 -fuzz %fzPct%%% -trim +repage %out%
ENDLOCAL
goto end

:pdf2jpg
SETLOCAL
set out=%3
if "%3"=="" set out=%~n2-fromPDF.jpg
imconvert -verbose -density 150 -trim %2 -quality 100 -sharpen 0x1.0 %out%
ENDLOCAL
goto end

:default
echo cocimg received Unexpected options!
goto end

:end
