/* qkcrop - Provide convenience functions to crop an image using cropper. */
parse arg imgfilename options
if abbrev('?', imgfilename) then do
  say 'qkcrop - Crop an image horizontally/vertically in segments.'
  say 'Usage: qkcrop imgfilename [-div n] [-seg n] [-ax x|y] [-org s|e]'
  say 'Options:'
  say '  -div n = how many divisions (default 2)'
  say '  -seg n = how many segments (LT divisions, default 1)'
  say '  -ax y = along which axis, x or y (default y)'
  say '  -org s = what origin, (s)tart or (e)nd (default s)'
  say 'Examples:'
  say '  qkcrop myimg.jpg               -- crop top half'
  say '  qkcrop myimg.jpg -org e        -- crop bottom half'
  say '  qkcrop myimg.jpg -ax x         -- crop left half'
  say '  qkcrop myimg.jpg -ax x -org e  -- crop right half'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'qkcrop: File not found,' imgfilename
  exit
end

options=translate(options)
w=wordpos('-DIV',options)
if w>0 then do; divisions=word(options,w+1); options=delword(options,w,2); end; else divisions=2
w=wordpos('-SEG',options)
if w>0 then do; segments=word(options,w+1); options=delword(options,w,2); end; else segments=1
w=wordpos('-AX',options)
if w>0 then do; axis=word(options,w+1); options=delword(options,w,2); end; else axis='Y'
w=wordpos('-ORG',options)
if w>0 then do; origin=word(options,w+1); options=delword(options,w,2); end; else origin='S'
xcmd=cropCmd(imgfilename, divisions, segments, axis, origin)
ADDRESS CMD xcmd
-- say '>>' xcmd
exit

cropCmd: procedure
  parse arg imgfilename, divisions, segments, axis, origin
  parse var imgfilename filestem '.' ext
  outp=cmdtop('identify -format %wx%h' imgfilename)
  parse var outp imgW 'x' imgH

  -- Validate divisions, default=2, max=20
  if \datatype(divisions,'W') then divisions=2
  else if divisions>20 then divisions=20

  -- Validate segments
  if \datatype(segments,'W') then segments=1
  else if segments>divisions then segments=1

  -- Validate axis
  if axis<>'X' then axis='Y'

  -- Validate origin
  if origin<>'E' then origin='S'

  say 'Img dimensions:' imgW 'x' imgH
  say '  divisions ->' divisions
  say '  segments ->' segments
  say '  axis ->' axis
  say '  origin ->' origin

  width=?(axis='Y', imgW, imgW/divisions)
  height=?(axis='Y', imgH/divisions, imgH)
  xpos=?(axis='Y', 0, ?(origin='S', 0, (divisions-segments)*width))
  ypos=?(axis='Y', ?(origin='S', 0, (divisions-segments)*height), 0)
  return 'cropper' imgfilename width height xpos ypos

::requires 'UtilRoutines.rex'
