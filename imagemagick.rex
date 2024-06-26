/* An API for common tasks using ImageMagick */
::requires 'UtilRoutines.rex'

::routine imgkVersion public
  return '0.01'

::routine makeCanvas public
  parse arg dim color outf
  if abbrev('?',dim) then do
    say 'makeCanvas dim color outf'
    return ''
  end
  -- Dimension may be expressed as WxH or just W
  parse var dim width 'x' height
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  isize=width'x'height
  if color='' then color='khaki'
  if outf='' then outf='canvas-'color'-'isize'.png'
  icmd='magick -size' isize 'xc:'color outf
  call prompt icmd
  return icmd

::routine makeCanvasClear public
  parse arg inf outf
  icmd='magick' inf '-alpha transparent' outf
  call prompt icmd
  return icmd

::routine makeIcon public
  parse arg inf width name
  if abbrev('?',inf) then do
    say 'makeIcon filename width outf'
    return ''
  end
  if \datatype(width,'W') then width=48
  isize=width'x'width
  if name='' then do
    parse var inf fstem '.' .
    outf=fstem'.ico'
  end
  else outf=name'.ico'
  icmd='magick' inf '-background none -resize' isize '-density' isize outf
  call prompt icmd
  return icmd

::routine makeGradient public
  parse arg width height color1 color2 outf
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  if color1='' then color1='white'
  if color2='' then color2='black'
  if outf='' then outf='tmp.jpg'
  icmd='magick -size' width'x'height 'gradient:'color1'-'color2 outf
  ok=run(icmd)
  if ok<0 then return ''  -- cmd declined, do not store
  return icmd

::routine getChop PUBLIC
  arg amt, grav
  chopFrom=getGravity(grav)
  defaultOption='-chop 0x'amt -- from TOP
  select
    when chopFrom='BOTTOM' then return '-gravity south -chop 0x'amt  -- BOTTOM
    when chopFrom='LEFT' then return '-chop' amt'x0'
    when chopFrom='RIGHT' then return '-gravity east -chop' amt'x0'
    otherwise return defaultOption
  end

::routine getGravity PUBLIC
  arg grav
  select
    when abbrev('TOP', grav) then return 'TOP'
    when abbrev('BOTTOM', grav) then return 'BOTTOM'
    when abbrev('LEFT', grav) then return 'LEFT'
    when abbrev('RIGHT', grav) then return 'RIGHT'
    otherwise return 'TOP'
  end

::routine alterName PUBLIC
  parse arg filestem '.' ext, tag
  if tag='' then tag='new'
  return filestem'-'tag'.'ext

