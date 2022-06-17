/* ipaste - Paste multiple images together into a single one, horizontally or vertically. */
parse arg options
if abbrev('?', options) then do
  say 'usage: ipaste filenames [-g gap][-d widthXheight][-o outputfile][-v]'
  say 'Options: gap, dimensions, verticalPaste'
  exit
end
w=wordpos('-g',options)
if w>0 then do; gap=word(options,w+1); options=delword(options,w,2); end; else gap=''

w=wordpos('-d',options)
if w>0 then do; dim=word(options,w+1); options=delword(options,w,2); end; else dim=''

w=wordpos('-o',options)
if w>0 then do; outp=word(options,w+1); options=delword(options,w,2); end; else outp=''

w=wordpos('-v',options)
if w>0 then do; vertical=1; options=delword(options,w,1); end; else vertical=0
filelist=strip(options)
firstimg=word(filelist,1)

if outp='' then do
  parse var firstimg filestem '.' ext
  outp=filestem||'-with-'||(words(filelist)-1)||'.'ext
end

if dim='' then do
  -- Use dimensions of first image
  parse value cmdTop('iid  -format %w-%h' firstimg) with wd '-' ht
  say 'Dimensions of' firstimg':' wd 'x' ht
  dim='+'wd'+'ht
end
else do
  parse var dim wd 'x' ht
  dim='+'wd'+'ht
  say 'You specified dimensions of' dim
end
splicecmd='-splice' ?(gap='', '0x0',gap'x'gap)||dim

icmd='magick' filelist ?(vertical, '-append', '+append') '-background transparent' splicecmd outp
call prompt icmd
exit

::requires 'UtilRoutines.rex'
