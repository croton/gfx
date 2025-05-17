/* imgk -- utility tool */
parse arg imgfn pfx params
if abbrev('?', imgfn) then call help

w=wordpos('-o',params)
if w>0 then do; outf=word(params,w+1); params=delword(params,w,2); end; else outf=''

select
  when pfx='tp' then call makeTransparent imgfn, outf
  when pfx='tp2' then call makeTransparent2 imgfn, outf
  when pfx='th' then call makeThumb imgfn, params, outf
  when pfx='thp' then call makeThumbByPercent imgfn, params, outf
  when pfx='cv' then call convertFormat imgfn, params, outf
  when pfx='ro' then call prompt rotate(imgfn, params) ?(outf='', setout(imgfn), outf)
  when pfx='canvas' then call makeCanvas imgfn, params
  when pfx='preop' then call imgPreop imgfn, params
  otherwise
    if SysFileExists(imgfn) then 'iid' imgfn
    else do
      say 'File' imgfn 'does not exist. Create it?'
      call help
    end
end
exit

makeThumb: procedure
  parse arg fn, width height, outf
  if \datatype(width,'W') then do
    say 'usage: makeThumbnail imgfile width height'
    return
  end
  icmd=makeThumbnail(fn, width, height)
  say 'Create thumb:' icmd
  if outf='' then call prompt icmd setout(fn)
  else            call prompt icmd outf
  return

makeThumbByPercent: procedure
  parse arg fn, percentage, outf
  call prompt makeThumbByPct(fn, percentage) outp=?(outf='', setout(fn), outf)
  return

makeTransparent: procedure
  parse arg fn, outf
  call prompt 'magick' fn '-transparent white' ?(outf='', setout(fn), outf)
  return

makeTransparent2: procedure
  parse arg fn, outf
  call prompt 'magick' fn '-alpha transparent' ?(outf='', setout(fn), outf)
  return

makeCanvas: procedure
  parse arg fn, dim color
  call prompt setcanvas(dim, color) fn
  return

/* Examples
  convert between formats, ex. myimg.jpg myimg.png
  convert imgfile outf
*/
convertFormat: procedure
  parse arg fn, targetExt
  if targetExt='' then say 'Please specify a target format.'
  else if filespec('E', fn)=targetExt then say 'Already in format' targetExt
  else do
    parse var fn filestem '.' .
    icmd='magick' fn filestem'.'targetExt
    call prompt icmd
  end
  return

imgPreop: procedure
  parse arg fn, maxwidth
  if abbrev('?', maxwidth) then do
    say 'usage: imgPreop imgfilename maxwidth'
    return
  end
  if \SysFileExists(fn) then say 'Image file not found:' fn
  else do
    if \datatype(maxwidth,'W') then maxwidth=1000
    parse value getdim(fn) with w h .
    say 'Pre-optimize images to be no more than twice maximum page width;'
    say 'Image' fn '('w'x'h') should be resized to no more than' maxwidth*2'px if rendered at max width of' maxwidth'px'
  end
  return

help: procedure
  say 'imgk -- A utility tool, version' 0.1
  say 'usage: imgk image-filename [options][-o outputfile]'
  say 'options:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  exit

::requires 'imgkMacro.rex'
