/* mgchop - Use the imagemagick -chop utility */
parse arg imgfilename amount gravity outp
if (abbrev('?', imgfilename) | \datatype(amount,'W')) then do
  say 'usage: mgchop imgfilename amount [gravity] [outp]'
  exit
end

cutFrom=getChopGravity(gravity)
if outp='' then do
  parse var imgfilename fstem '.' ext
  outp=fstem'-chop'cutFrom'-'amount'.'ext
end
say 'Chop' amount 'from' cutFrom 'of' imgfilename 'into' outp
call prompt 'magick' imgfilename getChop(amount, gravity) outp
exit

getChop: procedure
  arg amt, grav
  defaultOption='-chop 0x'amt
  select
    when grav='B' then return '-gravity south -chop 0x'amt  -- BOTTOM
    when grav='L' then return '-chop' amt'x0'               -- LEFT
    when grav='R' then return '-gravity east -chop' amt'x0' -- RIGHT
    otherwise return defaultOption                          -- TOP
  end

getChopGravity: procedure
  arg grav
  select
    when grav='B' then return 'BOTTOM'
    when grav='L' then return 'LEFT'
    when grav='R' then return 'RIGHT'
    otherwise return 'TOP'
  end

::requires 'UtilRoutines.rex'
