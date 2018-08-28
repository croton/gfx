/* img2tag -- Generate an HTML tag for a given image. */
parse arg imgfilename
if imgfilename='' then do
  say 'img2tag - Generate an HTML tag for a given image'
  say 'Usage: img2tag imgfilename'
  exit
end
else if \SysFileExists(imgfilename) then do
  say 'img2tag: File not found,' imgfilename
  exit
end

tmpl='<img src="?1" alt="?1" width="?2" height="?3" />'
outp=cmdOutput('identify -format %wx%h' imgfilename '|sed "s/x/ /g"')
if outp=.nil then dim='0 0'
else              dim=outp[1]
say expand(tmpl, imgfilename dim)

/* Examples
   -- Use quotes to combine multiple tokens into a single parameter
   call onelineMerge 'my ?1 template for ?2 on ?3', 'Groovy "all dudes" THU'
   -- No quotes means a token per parameter
   call onelineMerge 'my ?1 template for ?2 on ?3', 'Groovy all dudes THU'
*/
exit

::requires 'CmdUtils.cls'
