/* colorcardf -- Create a composite image from a list of hexvalues from STDIN.*/
arg options
if abbrev('?', options, 1) then do
  say 'usage: colorcardf'
  exit
end

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
cnt=0
filenames=''
do forever
  parse pull hexvalue name
  if hexvalue='' then iterate
  cnt=cnt+1
  filenames=filenames cnt'.png'
  mgcmd=colorit(hexvalue, name, cnt'.png')
  say '->' mgcmd
  ADDRESS CMD mgcmd
end
exit

programEnd:
  outf='colorcards-'cnt'.png'
  'mgappend' strip(filenames) '-o' outf '-v'
  'del' filenames
  if SysFileExists(outf) then 'jpg' outf
  exit 0

colorit: procedure
  parse arg hexvalue, name, filename
  xcmd='magick -size 100x50 xc:'hexvalue
  note='-pointsize 12 -fill black -gravity northwest -annotate +5+5 "'name hexvalue'"'
  return xcmd note filename
