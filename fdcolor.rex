/* fdcolor -- find colors using imgk-colors.xfn */
parse arg pfx params
COLORFILE=value('X2HOME',,'ENVIRONMENT')||'\lists\imgk-colors.xfn'
if \SysFileExists(COLORFILE) then do
  say 'Unable to locate colors in' COLORFILE
  exit
end

select
  when pfx='-?' then call help
  when pfx='r' then call findRed params
  when pfx='g' then call findGreen params
  when pfx='b' then call findBlue params
  otherwise call findAny pfx params
end
exit

/* Search for colors containing the search string */
findAny: procedure expose COLORFILE
  parse arg value
  if value='' then value='#'
  rc=SysFileSearch(strip(value), COLORFILE, 'colors.')
  if colors.0=0 then say 'No colors found with value="'value'" in' COLORFILE 'rc='rc
  else do i=1 to colors.0
    say colors.i
  end i
  return

/* search for colors whose RED=240 */
findRed: procedure expose COLORFILE
  parse arg redvalue
  rc=sysFileSearch('rgb('redvalue, COLORFILE, 'colors.')
  call report colors., 'redvalue="'redvalue'"'
  return

/* search for colors whose RED=240 */
findGreen: procedure expose COLORFILE
  parse arg greenvalue
  rc=sysFileSearch(','greenvalue',', COLORFILE, 'colors.')
  call report colors., 'greenvalue="'greenvalue'"'
  return

/* search for colors whose RED=240 */
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
  say 'fdcolor -- A utility tool, version' 0.1
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

::requires 'UtilRoutines.rex'
