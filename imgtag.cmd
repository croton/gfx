@echo off
:: imgtag -- Produce an HTML image tag for a given image

if "%1"=="" goto noargs
goto default

:noargs
echo imgtag - Produce an HTML image tag for a given image
echo Usage: imgtag imagefilename [removeTempfile]
goto end

:default
SETLOCAL
set tmpl=imgtagTmpl.txt
IF NOT EXIST %tmpl% (
  printf "<img src=\"?1\" alt=\"?2\" width=\"?3\" height=\"?4\" />" > %tmpl%
)
identify -format %%wx%%h %1 | sed "s/x/ /g" | asarg echo %1 %~n1 | asarg merge %tmpl%
IF NOT "%2" == "" (
  del %tmpl%
)
ENDLOCAL
goto end

:end
