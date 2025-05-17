/* Test FontSampler */
parse arg input
obj=.FontSampler~new()
-- say obj
gif=obj~demoFontByName(input)
if gif<>.nil then say 'Created GIF of font samples:' gif
exit

/* --------------------------- Class Definitions ---------------------------- */
::class FontSampler public
::method fontlist ATTRIBUTE
::method fonts ATTRIBUTE
::method init
  -- expose a b
  use arg a, b
  self~fontlist='C:\Users\celes\cjp\x2\lists\imgk-fonts.xfn'
  self~fonts=arrayfromfile('C:\Users\celes\cjp\x2\lists\imgk-fonts.xfn')

::method string
  return 'A FontSampler based on' self~fontlist

::method demoFontByName
  arg beginWith, fontsize, outputfile
  if beginWith='' then beginWith='A'
  if fontsize='' then fontsize=14
  if outputfile='' then outputfile='fontsample-'beginWith'.gif'

  fonts=self~getCmd('type' self~fontlist '| grep -ie "^'beginWith'"')
  ctr=0
  loop font over self~fonts
    if abbrev(translate(font), beginWith) then do
      ctr=ctr+1
      targetfonts.ctr=font
    end
    targetfonts.0=ctr
  end
  if targetfonts.0=0 then do
    say 'No fonts found beginning with' beginWith'!'
    return .nil
  end
  ftline=''
  y=10
  do i=1 to targetfonts.0
    say i 'Font' targetfonts.i
    ftline=ftline '-font' targetfonts.i '-annotate +5+'y '"'i targetfonts.i'"'
    y=y+15
  end
  xcmd='magick -size 165x'y 'xc:skyblue -background skyblue -fill black' ,
        '-pointsize' fontsize ftline outputfile
  say xcmd
  xcmd
  return outputfile

::method getCmd
  parse arg command
  myresults=.Array~new
  ADDRESS CMD command '| RXQUEUE'
  do while queued()<>0
    parse pull entry
    if entry='' then iterate
    myresults~append(entry)
  end
  return myresults

::method addDateStamp
  parse arg filename
  if \SysFileExists(filename) then do
    say 'File' filename 'does not exist!'
    return .nil
  end
  parse var date('L') with dy mon year
  -- '-fill "rgb(163,186,192)" -gravity northwest' 2=Andalus
  convert='imconvert'
  compose='composite'
  cvArgs='-size 280x100 xc:none' ,
         '-fill "rgb(163,186,192)" -gravity northwest -font Bell-MT-Bold' ,
         '-pointsize 40 -annotate +1055+55 "November"' ,
         '-pointsize 80 -annotate +1235+45 "14" -stretch condensed' ,
         '-pointsize 32 -annotate +1160+85 "2014"'
  xtpos=filename~lastpos('.')
  outfn=filename~left(xtpos-1)||'-out'||filename~substr(xtpos)
  convert filename cvArgs outfn
  return outfn

::requires 'iolib.rex'
