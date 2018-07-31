global nodeName, odrName, errorCode, expression, debugLevel

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

def setHttpDebug(nodeName, odrName, errorCode, expression, debugLevel):
  node = AdminConfig.getid("/Node:"+nodeName+"/")
  if (node == ""):
    raise NameError(nodeName + " is not the name of a valid node")
  odr = AdminConfig.getid("/Node:"+nodeName+"/Server:"+odrName+"/")
  if (odr == ""):
    raise NameError(odrName + " is not the name of a valid ODR on node " + nodeName)    
    
  mbeanStr='WebSphere:*,type=ODRDebug,node=' + nodeName + ',process=' + odrName
  mbeans=convertToList(AdminControl.queryNames(mbeanStr))
  for mbean in mbeans:
    AdminControl.invoke(mbean,'setHttpDebug',errorCode + ' ' + expression + ' ' + debugLevel)
    print "done"
    
def printHelp(): 
  print """   
  Supported Operations:
    setHttpDebug <nodeName> <odrName> <errorCode> <expression> <debugLevel>
      nodeName is the name of the node
      odrName is the name of the ODR
      errorCode is the HTTP error code (e.g. 404, 503, etc)
      expression specifies if the error code is being debugged
           'false' means debugging is always disabled when the error occurs
           'true' means debugging is always enabled when the error occurs
           otherwise, any valid boolean expression as allowed in an HTTP or SOAP work class
      debugLevel 
           '0' prints a concise description on a single line
           '1' additionally prints an appropriate subset of target.xml
           '2' additionally prints target.xml in it's entirety
  """
   
if(len(sys.argv) > 2):
  action = sys.argv[0].rstrip()
  nodeName = sys.argv[1].rstrip()
  odrName = sys.argv[2].rstrip()
  if (action == 'setHttpDebug'):
    if (len(sys.argv) == 6):
      errorCode = sys.argv[3].rstrip()
      expression = sys.argv[4].rstrip()	
      debugLevel = sys.argv[5].rstrip()	
      setHttpDebug(nodeName, odrName, errorCode, expression, debugLevel)
    else:
      print "Wrong number of arguments for setHttpDebug operation"
      printHelp()
  else:
    print "Unsupported operation"
    printHelp()
else:
    printHelp()
 
 
