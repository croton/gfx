/* A collection of macros using ImageMagick */
::requires 'UtilRoutines.rex'

::routine makeThumbnail PUBLIC
  parse arg fn, width, height
  if \datatype(width,'W') then width=10
  if \datatype(height,'W') then height=width
  return 'magick' fn '-trim -resize' width'x'height

::routine makeThumbByPct PUBLIC
  parse arg fn, percentage
  if \datatype(percentage,'N') then percentage=10
  pct=percentage/100
  parse value cmdTop('iid  -format %w-%h' fn) with wd '-' ht
  width=format(wd*pct,,0)
  height=format(ht*pct,,0)
  return 'magick' fn '-trim -resize' width'x'height

::routine convertFormat PUBLIC
  parse arg fn, targetExt
  if targetExt='' then say 'Please specify a target format.'
  else if filespec('E', fn)=targetExt then do
    say 'Already in format' targetExt
    return ''
  end
  parse var fn filestem '.' .
  return 'magick' fn filestem'.'targetExt

::routine rotate PUBLIC
  parse arg fn, rotation
  if \datatype(rotation,'W') then rotation=45
  else if abs(rotation)>360 then rotation=rotation//360
  return 'magick convert -rotate' rotation fn

::routine setout PUBLIC
  parse arg filestem '.' ext, suffix
  if suffix='' then outfn=filestem'-out.'ext
  else              outfn=filestem'-'suffix'.'ext
  if SysFileExists(outfn) then outfn=filestem'-'time('S')||'.'ext
  return filespec('N', outfn)

::routine setcanvas PUBLIC
  parse arg dim, color
  if abbrev('?',dim) then do
    say 'setcanvas dim color'
    return ''
  end
  -- Dimension may be expressed as WxH or just W
  parse var dim width 'x' height
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  if color='' then color='none'
  return 'magick -size' width'x'height 'xc:'color

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
  return 'magick' inf '-background none -resize' isize '-density' isize outf

::routine makeGradient public
  parse arg width height color1 color2 outf
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  if color1='' then color1='white'
  if color2='' then color2='black'
  if outf='' then outf='tmp.jpg'
  return 'magick -size' width'x'height 'gradient:'color1'-'color2 outf

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

::routine getdim PUBLIC
  parse arg fn
  parse value cmdTop('iid  -format %w-%h' fn) with wd '-' ht
  return wd ht

::routine canvas PUBLIC
  parse arg width, height, color
  if \datatype(width,'W') then width=100
  if \datatype(height,'W') then height=width
  if color='' then bg='xc:none'
  else             bg='xc:'color
  return '-size' width'x'height bg

::routine fg PUBLIC
  parse arg color
  if color='' then color='black'
  return '-fill' color

::routine f PUBLIC
  parse arg name
  return '-font' name

::routine fs PUBLIC
  arg size
  return '-pointsize' size

::routine font PUBLIC
  parse arg name, size
  select
    when name='' then return fs(size)
    when size='' then return f(name)
    otherwise return f(name) fs(size)
  end

::routine placetext PUBLIC
  parse arg text, xpos, ypos, color
  if \datatype(xpos,'W') then xpos=0
  if \datatype(ypos,'W') then ypos=0
  if color='' then return '-annotate +'xpos'+'ypos '"'text'"'
  return fg(color) '-annotate +'xpos'+'ypos '"'text'"'

