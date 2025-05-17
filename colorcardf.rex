/* colortabf -- Create a composite image from a list of hexvalues from STDIN.*/
arg outfile options
if abbrev('?', outfile, 1) then do
  say 'colortabf - Creates a color table from a list of hexvalues and names from STDIN.'
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
  if outfile='' then outf='colortab-'cnt'.png'
  else               outf=outfile
  'mgappend' strip(filenames) '-o' outf '-v'
  'del' filenames
  if SysFileExists(outf) then 'jpg' outf
  exit 0

colorit: procedure
  parse arg hexvalue, name, filename
  xcmd='magick -size 200x50 xc:'hexvalue
  if lightOrDark(hexvalue)=1 then fg='black'
  else                            fg='snow'
  note='-pointsize 14 -fill' fg '-gravity northwest -annotate +5+5 "'name hexvalue'"'
  return xcmd note filename

::requires 'colorlib.rex'
