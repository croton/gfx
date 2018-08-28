@echo off
:: ipress -- Image press down, that is, compress image.

if "%1"=="" goto noargs
goto default

:noargs
echo ipress - Use ImageMagick to compress (and backup) an image
echo Usage: ipress imagefilename [qualityPct]
goto end

:default
SETLOCAL
set qpct=%2
if "%2"=="" set qpct=75
set bak=%~n1_full%~x1
echo Compressing image by %qpct% percent ...
printf "BEFORE: "
identify %1
mogrify -strip -quality %qpct%%% %1
:: ImageMagick produces a backup; rename it
ren %1~ %bak%
printf "AFTER:  "
identify %1
ENDLOCAL
goto end

:end
