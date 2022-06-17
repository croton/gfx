/* imt -- ImageMagick Utility Tool
   Created 10-29-2018
*/
parse arg pfx params
-- LOGFILE=.stream~new(value('cjp',,'ENVIRONMENT')||'\bak\imt.log')
LOGFILE=.stream~new('.\imt.log')

select
  when pfx='c' then call logcmd makeCanvas(params)
  when pfx='ct' then call logcmd makeCanvasClear(params)
  when pfx='g' then call logcmd makeGradient(params)
  when pfx='ico' then call logcmd makeIcon(params)
  when pfx='t' then say 'version' imgkversion()
  otherwise
    call help
end
exit

logcmd: procedure expose LOGFILE
  parse arg icmd
  if icmd<>'' then do
    say 'Write to log' LOGFILE
    LOGFILE~lineout(date('s') icmd)
    LOGFILE~close
  end
  return

help: procedure
  say 'imt -- An ImageMagick utility tool, version' 0.1
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

-- ::requires 'UtilRoutines.rex'
::requires 'imagemagick.rex'
