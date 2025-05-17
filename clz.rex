/* fdcolor -- find colors using imgk-colors.xfn */
parse arg pfx params
COLORFILE=value('X2HOME',,'ENVIRONMENT')||'\lists\imgk-colors.xfn'
if \SysFileExists(COLORFILE) then do
  say 'Unable to locate colors in' COLORFILE
  exit
end

select
  when pfx='?' then call help
  when pfx='r' then call findRed params
  when pfx='g' then call findGreen params
  when pfx='b' then call findBlue params
  when pfx='n' then call findByName params
  when pfx='rgb' then call name2Rgb params
  otherwise call findAny pfx params
end
exit

name2Rgb: procedure expose COLORFILE
  parse arg colorname
  if colorname='' then do
    say 'Please provide a color name.'
    return
  end
  rc=SysFileSearch(colorname, COLORFILE, 'colors.')
  if colors.0=0 then say ''
  else do i=1 to colors.0
    parse upper value colors.i with cname . '(' rgb ')' .
    if translate(colorname)=cname then do
      say rgb
      cb=.WindowsClipboard~new
      cb~copy(rgb)
      leave i
    end
  end i
  return

findByName: procedure expose COLORFILE
  parse arg colorname
  rc=SysFileSearch(colorname, COLORFILE, 'colors.')
  if colors.0=0 then say 'No colors found with value="'colorname'" in' COLORFILE 'rc='rc
  do i=1 to colors.0
    say colors.i
  end i
  return

/* Search for colors containing the search string */
findAny: procedure expose COLORFILE
  parse arg red green blue .
  if red='' then do
    red='#'
    rc=SysFileSearch(red, COLORFILE, 'colors.') -- match ALL values
    if colors.0=0 then say 'No colors found with value="'red'" in' COLORFILE 'rc='rc
    else do i=1 to colors.0
      say colors.i
    end i
    return
  end
  reds.=getRed(red)
  if reds.0=0 then say 'No colors found with RED value="'red'" in' COLORFILE 'rc='rc
  else do
    ctr=0
    do i=1 to reds.0
      if pos(','green',', reds.i)>0 then do
        ctr=ctr+1
        greens.ctr=reds.i
      end
    end i
    greens.0=ctr
    if greens.0=0 then do i=1 to reds.0; say i reds.i; end i
    else do
      hasblue=0
      do i=1 to greens.0
        if pos(blue')', greens.i)>0 then do
          hasblue=1
          say '' greens.i
        end
      end i
      if \hasblue then do i=1 to greens.0; say i greens.i; end i
    end
  end
  return

getRed: procedure expose COLORFILE
  arg colorvalue
  rc=sysFileSearch('rgb('colorvalue',', COLORFILE, 'colors.')
  return colors.

getGreen: procedure expose COLORFILE
  parse arg colorvalue
  rc=sysFileSearch(','colorvalue',', COLORFILE, 'colors.')
  return colors.

getBlue: procedure expose COLORFILE
  parse arg colorvalue
  rc=sysFileSearch(colorvalue')', COLORFILE, 'colors.')
  return colors.

/* search for colors whose RED = specified value */
findRed: procedure expose COLORFILE
  parse arg redvalue
  rc=sysFileSearch('rgb('redvalue, COLORFILE, 'colors.')
  call report colors., 'redvalue="'redvalue'"'
  return

/* search for colors whose GREEN = specified value */
findGreen: procedure expose COLORFILE
  parse arg greenvalue
  rc=sysFileSearch(','greenvalue',', COLORFILE, 'colors.')
  call report colors., 'greenvalue="'greenvalue'"'
  return

/* search for colors whose BLUE = specified value */
findBlue: procedure expose COLORFILE
  parse arg bluevalue
  rc=sysFileSearch(bluevalue')', COLORFILE, 'colors.')
  call report colors., 'bluevalue="'bluevalue'"'
  return

report: procedure
  use arg findings., message
  if findings.0=0 then say 'No colors found with' message
  else do i=1 to findings.0
    say findings.i
  end i
  return

help: procedure
  say 'clz -- Look up color names and values from ImageMagick resource file.'
  say 'Enter one or more RGB values to find name and hex value.'
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

::requires 'UtilRoutines.rex'
::requires 'winSystm.cls'
