@echo off
:: cocvue

if "%1"=="-?" goto noargs
goto default

:noargs
echo cocvue - View CoC images in image browser
echo Usage: cocvue option folder
echo   -m = mycview
echo   -n = nexusimage
echo default = jpegview
goto end

:default
SETLOCAL
set vue=jpegview
IF "%1"=="-m" (
  set vue=mycview
) ELSE (
  IF "%1"=="-n" (
  set vue=nexusimage
  )
)
set idir=c:\Users\ACER\cjp-project\caring\i2016
IF NOT "%2"=="" (
  set idir=%2
)
start %vue% %idir%
ENDLOCAL
goto end

:end
