/* multigif */
parse arg name imgspec delayMS imgwidth
if abbrev('?', name) then do
  say 'multigif - Create an animated GIF from a series of images'
  say 'usage: multigif name imgspec delayMS [imgwidth]'
  exit
end

ADDRESS CMD 'identify' imgspec
if delayMS='' then delay=200
else               delay=delayMS
if imgwidth<>'' then do
  icmd='magick -resize' imgwidth'x' imgspec
  -- ADDRESS CMD icmd
  call runcmd icmd
end
icmd='magick -delay' delay '-loop 0' imgspec name'.gif'
ADDRESS CMD icmd
exit

::requires 'UtilRoutines.rex'
