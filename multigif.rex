/* multigif */
parse arg name imgspec delayMS imgwidth
if name='' then call help

ADDRESS CMD 'identify' imgspec
if delayMS='' delay=200
else          delay=delayMS
if imgwidth<>'' then do
  icmd='imconvert -resize' imgwidth'x' imgspec
  ADDRESS CMD icmd
end
icmd='imconvert -delay' delay -loop 0 imgspec name'.gif'
ADDRESS CMD icmd
exit

help:
say 'anigif - Create an animated GIF from a series of images'
say 'usage: anigif name imgspec delayMS [imgwidth]'
exit
