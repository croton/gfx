@echo off
if "%2"=="" goto help
goto default

:help
echo anigif - Create an animated GIF from a series of images
echo usage: anigif name imgspec delayMS [imgwidth]
goto end

:default
SETLOCAL
identify %2
set delay=200
if NOT "%3"=="" set delay=%3
if NOT "%4"=="" imconvert -resize %4x %2
imconvert -delay %delay% -loop 0 %2 %1.gif
ENDLOCAL
goto end

:end
