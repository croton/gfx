@echo off
::imgk -- Use ImageMagick
if "%1"=="" goto noargs
goto default

:noargs
echo Usage: imgk imagefilename
goto end

:default
SETLOCAL
set imgkdir=C:\cjptech\ImageMagick-6.8.9-4
set animate=%imgkdir%\animate
set compare=%imgkdir%\compare
set composite=%imgkdir%\composite
set conjure=%imgkdir%\conjure
set convert=%imgkdir%\convert
set dcraw=%imgkdir%\dcraw
set display=%imgkdir%\display
set emfplus=%imgkdir%\emfplus
set ffmpeg=%imgkdir%\ffmpeg
set hp2xx=%imgkdir%\hp2xx
set identify=%imgkdir%\identify
set imdisplay=%imgkdir%\IMDisplay
set import=%imgkdir%\import
set mogrify=%imgkdir%\mogrify
set montage=%imgkdir%\montage
set stream=%imgkdir%\stream

set out=%2
if "%2"=="" set out=%~n1_out%~x1
:: Thumbnails
:: %convert% -sample 80x40 %1 %out%
:: %convert% -sample 25%x25% %1 %out%

:: Information
:: %identify% -verbose %1

:: Rotate
:: %convert% -rotate 45 %1 %out%

:: convert between formats, ex. myimg.jpg myimg.png
:: %convert% %1 %out%

:: Add text annotations
set text=Croton Concepts 2014
:: %convert% %1 -pointsize 30 -fill black -gravity northwest -annotate +10+50 "%text%" %out%
::%convert% %1 -fill "rgb(163,186,192)" -gravity northwest
:: -pointsize 20 -annotate +1060+60 "November"
:: -pointsize 40 -annotate +1220+65 "14"
:: -pointsize 20 -annotate +1165+90 "2014" %out%

:: Charcoal effects
:: %convert% -charcoal 2 %1 %out%

:: List colors
:: %convert% -list color

:: Create a composite image
:: %cv% -size 120x120 xc:bisque mycompos.gif
:: %cm% -geometry  +5+10 trout1.gif mycompos.gif mycompos.gif
:: %cm% -geometry +35+50 snoopy.gif mycompos.gif mycompos.gif
:: %cm% -geometry +70+70 scooby.gif mycompos.gif mycompos.gif
:: %cm% -geometry +10+55 foldertree_plus.gif mycompos.gif mycompos.gif

:: Rounded corners
%convert% -size 300x285 xc:none -fill SteelBlue -draw "roundRectangle 0,0 300,285, 15,15" rnd-rect.png

:: Create a rectangle with a gradient
:: %convert% -size 400x100 gradient:orange-wheat1 gradiant.png

:: Round the corners and add the text
:: %convert% -size 400x100 xc:none -fill white -draw "roundRectangle 0,0 400,100 15,15" gradiant.png ^
:: -compose SrcIn -composite -font verdana.ttf -pointsize 50 ^
:: -draw "gravity center fill orange text 0,0 'BubbyBrook' " rounded_gradiant.png

:: Add the date the photo was taken to the image
:: FOR /F %%x IN ('c:\ImageMagick-6.6.3-Q16\identify -format "%%[date:create]" %1') DO SET DateTime=%%x
:: %convert% %1 -pointsize 20 -fill black -gravity northwest ^
:: -annotate +0+0 "Date: %DateTime%" %out%

:: Looping over various files (insert ~n for filestem, ~x for extension)
:: for %%i in (*.jpg) DO echo %%~ni

ENDLOCAL
goto end

:end
