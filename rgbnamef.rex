/* newtablef -- A filter for generating HTML tables */
parse arg options
COLORFILE=value('X2HOME',,'ENVIRONMENT')||'\lists\imgk-colors.xfn'
if \SysFileExists(COLORFILE) then do
  say 'Unable to locate colors in' COLORFILE
  exit
end
SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
collection=.array~new
do forever
  parse pull data
  if data='' then iterate
  collection~append(data)
end
exit

programEnd:
  inp=.stream~new(COLORFILE)
  colordata=inp~arrayin
  inp~close
  loop item over collection
    parse var item red green blue rest
    say red green blue rest findname(colordata, red, green, blue)
  end
  exit 0

findname: procedure
  use arg colors, R, G, B
  red='rgb('R','
  green=','G','
  blue=B')'
  candidates=.array~new
  shortlist=.array~new
  loop item over colors
    if pos(red,item)>0 then candidates~append(item)
  end
  if candidates~items=0 then return '' -- 'redX' R
  loop item over candidates
    if pos(green, item)>0 then shortlist~append(item)
  end
  if shortlist~items=0 then return '' -- 'greenX' G
  loop item over shortlist
    if pos(blue, item)>0 then do
      parse var item name . '(' . ')' hexvalue
      return space(name hexvalue, 1)
    end
  end
  return '?'
