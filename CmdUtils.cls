/* -----------------------------------------------------------------------------
   argsParser allows parsing of command-line switches into named parameter values.
   First parameter, fieldstem, is a stem whose indexes represent field names and
   whose values represent command-line switches; it is altered by assigning new
   indexes, named 'value' for each matching item. Returns any portion of the input
   which does not follow a switch.
   Example-
   opts.user='u'; opts.pwd='p'; rc=paramParser opts., 'myfile -u GIJoe -p Adventure'
   yields .. opts.user.value='GIJoe' opts.pwd.value='Adventure' rc='myfile'
   -----------------------------------------------------------------------------
*/
::routine argsParser public
  use arg fieldstem., input, delim
  if arg(1,'O') then return .nil
  -- Set a default delimiter
  if arg(3,'O') then delim='-'
  -- trace 'r'
  nextDelim=' 'delim
  firstDelim=input~words+1
  do key over fieldstem.
    sw=delim||fieldstem.key
    swpos=input~wordpos(sw)
    if swpos=0 then iterate
    firstDelim=min(firstDelim,swpos)
    parse var input (sw) data (nextDelim)
    if data='' then fieldstem.key.value=.true
    else            fieldstem.key.value=data
  end
  -- Return unmatched input string
  widx=input~wordindex(firstDelim)
  if widx=0 then return input            -- no switches found
  else           return input~left(widx-1)

/* argParser returns a directory, storing unmatched input string under entry 'NOMATCH' */
::routine argParser public
  use arg fieldstem., input, delim
  if arg(1,'O') then return .nil
  -- Set a default delimiter
  if arg(3,'O') then delim='-'
  optionValues=.directory~new
  nextDelim=' 'delim
  firstDelim=input~words+1
  do key over fieldstem.
    sw=delim||fieldstem.key
    swpos=input~wordpos(sw)
    if swpos=0 then iterate
    firstDelim=min(firstDelim,swpos)
    parse var input (sw) data (nextDelim)
    -- if data='' then optionValues[key]=.true
    optionValues[key]=data~strip -- ~word(1)
  end
  widx=input~wordindex(firstDelim)
  if input<>'' then do
    -- Store the data that was NOT associated to any switch
    if widx=0 then
      optionValues['NOMATCH']=input       -- no switches found
    else
      optionValues['NOMATCH']=input~left(widx-1)
  end
  return optionValues

::routine ask public
  parse arg question, keepCase
  .STDOUT~charout(question' ')
  if arg(2)=.true then parse pull ans
  else                 pull ans
  return ans

::routine askYN public
  parse arg question
  return ask(question)~left(1)='Y'

::routine askYesNo public
  parse arg question, affirm
  if arg(2,'O') then affirm=''
  return ask(question)~left(1)=affirm

::routine print public
  parse arg info
  return .STDOUT~charout(info)

-- Pass a given command to the external environment and return results as array
::routine cmdOutput public
  parse arg command
  if arg(1,'O') then return .NIL
  myresults=.Array~new
  ADDRESS CMD command '| RXQUEUE'
  do while queued()<>0
    parse pull entry
    if entry='' then iterate
    myresults~append(entry)
  end
  if myresults~items=0 then return .NIL
  return myresults

::routine cmdOutputLine public
  parse arg command
  myresults=cmdOutput(command)
  if myresults=.NIL then return ''
  return myresults[1]

-- Replace a string containing embedded placeholders with specified values.
::routine expandstr public
  use arg cmdstr, values, PH
  if arg(3,'O') then PH='?'
  posPH=cmdstr~pos(PH)
  if posPH=0 then return cmdstr
  newstr=''
  do item over values until posPH=0
    parse var cmdstr before (PH) cmdstr
    newstr=newstr||before||item
    posPH=cmdstr~pos(PH)
    if posPH=0 then newstr=newstr||cmdstr
  end
  return newstr

-- Alternate pattern .. replace ?1,?2,?n with space delimited string
::routine expand public
  parse arg str, values
  newstr=str
  do w=1 to values~words
    PH='?'w
    newstr=newstr~changestr('?'w,values~word(w))
  end w
  return newstr

::routine ifyes public
  parse arg expr, cyes, cno
  if expr then return cyes
  return cno

::routine ifnil public
  parse arg expr, cyes
  if expr=.NIL then return cyes
  return expr
