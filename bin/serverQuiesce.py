global nodeName, serverName, phaseOneInterval, performPhaseTwo

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

def quiesceServer(nodeName, serverName, phaseOneInterval, performPhaseTwo):
  node = AdminConfig.getid("/Node:"+nodeName+"/")
  if (node == ""):
    raise NameError(nodeName + " is not the name of a valid node")
  server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
  if (server == ""):
    raise NameError(serverName + " is not the name of a valid server on node " + nodeName)    
    
  try:
    intervalInt=int(phaseOneInterval,10)
    if (intervalInt < 120000):
      raise ValueError
  except ValueError:
    raise ValueError("The phaseOneInterval value is not a valid number or it is less than 120000.  Please verify that the phaseOneInterval is at least 120000 milliseconds.")    
  except TypeError:
    raise TypeError("The phaseOneInterval value is not a valid number")
    
   

  if (performPhaseTwo != 'true' and performPhaseTwo != 'false'):
    raise ValueError("The value of performPhaseTwo is not valid.  Valid values are true or false.")
    
  mbeanStr='WebSphere:*,type=SIPServerQuiesce,node=' + nodeName + ',process=' + serverName
  mbeans=convertToList(AdminControl.queryNames(mbeanStr))
  for mbean in mbeans:
    print mbean
    AdminControl.invoke(mbean,'quiesceServer',nodeName + ' ' + serverName + ' ' + phaseOneInterval + ' ' + performPhaseTwo )
    
def cancelQuiesce(nodeName, serverName):
  node = AdminConfig.getid("/Node:"+nodeName+"/")
  if (node == ""):
    raise NameError(nodeName + " is not the name of a valid node")
  server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
  if (server == ""):
    raise NameError(serverName + " is not the name of a valid server on node " + nodeName)    
    
  mbeanStr='WebSphere:*,type=SIPServerQuiesce,node=' + nodeName + ',process=' + serverName
  mbeans=convertToList(AdminControl.queryNames(mbeanStr))
  for mbean in mbeans:
    print mbean
    AdminControl.invoke(mbean,'cancelQuiesce',nodeName + ' ' + serverName)
    
def printHelp(): 
  print """   
  Supported Operations:
    quiesceServer <nodeName> <serverName> <phaseOneInterval> <performPhaseTwo>
      nodeName is the name of the node
      servername is the name of the server
      phaseOneInterval is the time (in milliseconds) to wait for quiesce to complete
      performPhaseTwo is a boolean indicating whether the server should be stopped after quiescing (true | false)

    cancelQuiesce <nodeName> <serverName>  
      nodeName is the name of the node
      servername is the name of the server
  """
   
   
if(len(sys.argv) > 2):
  action = sys.argv[0].rstrip()
  nodeName = sys.argv[1].rstrip()
  serverName = sys.argv[2].rstrip()
  if (action == 'quiesceServer'):
    if (len(sys.argv) > 4):
      phaseOneInterval = sys.argv[3].rstrip()
      performPhaseTwo = sys.argv[4].rstrip()	
      quiesceServer(nodeName, serverName, phaseOneInterval, performPhaseTwo)
    else:
      print "Missing arguments for quiesceServer operation"
      printHelp()
  elif (action == 'cancelQuiesce'):
    cancelQuiesce(nodeName, serverName)
  else:
    print "Unsupported operation"
    printHelp()
else:
    printHelp()
 
 
 
