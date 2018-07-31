def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split(lineSeparator)
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def reset(cellList):
  mbeanStr='WebSphere:*,type=HAWsmmController'
  mbeans=convertToList(AdminControl.queryNames(mbeanStr))
  for mbean in mbeans:
    if(len(cellList) > 0):
      for cell in cellList:
        AdminControl.invoke(mbean,'reset',cell)
        break
    else:
      AdminControl.invoke(mbean,'reset')
      break
  print "done"
    
def printHelp(): 
  print """   
  Supported Operations:
     reset [<cellName> ...]
         cellName is the name of a cell
  """
   
if(len(sys.argv) > 0):
  action = sys.argv[0].rstrip()
  if (action == 'reset'):
    reset(sys.argv[1:len(sys.argv)])
  else:
    print "Unsupported operation"
    printHelp()
else:
  printHelp()
 
