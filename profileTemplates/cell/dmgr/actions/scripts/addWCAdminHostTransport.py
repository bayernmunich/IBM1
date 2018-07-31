
import sys, java
lineSeparator = java.lang.System.getProperty('line.separator')

#
# Stolen from some other random augmentation script, this makes a list from
# the sort of thing that AdminConfig.list() and so on return.
#
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

#
# Returns a list of ports that are listed in any named endpoint on the given node.
#
def findUsedPorts(node):
  usedPorts = []
  hostPorts = []
  match = ""
  serverEntries = convertToList(AdminConfig.list("ServerEntry",node))
  serverIndexes = convertToList(AdminConfig.list("ServerIndex",node))
  for serverIndex in serverIndexes:
	hostName = AdminConfig.showAttribute(serverIndex,"hostName")
  print "Processing host:",hostName
  print "Ports by host:",portsByHosts
  for usedPorts in portsByHosts:
		if (usedPorts[0]==hostName):
			print "Host processed before:",hostName
			match = "1"
			hostPorts = usedPorts
  if (match!="1"):
     print "Host not processed before: ",hostName
     hostPorts.append(hostName)	 
  for serverEntry in serverEntries:
    namedEndPoints = convertToList(AdminConfig.list("NamedEndPoint",serverEntry))
    for namedEndPoint in namedEndPoints:
      endPointName = AdminConfig.showAttribute(namedEndPoint,"endPointName")
      endPoint = AdminConfig.showAttribute(namedEndPoint,"endPoint")
      host = AdminConfig.showAttribute(endPoint,"host")
      port = AdminConfig.showAttribute(endPoint,"port")
      hostPorts.append(port)
  print "Ports by host:",hostPorts
  if (match!="1"):
     portsByHosts.append(hostPorts)
  return usedPorts

#
# Returns the NamedEndPoint with the given endPointName from the given ServerEntry,
# or "" if there isn't one
#
def getNamedEndPoint(serverEntry,name):
  neps = convertToList(AdminConfig.list("NamedEndPoint",serverEntry))
  for nep in neps:
    nepname = AdminConfig.showAttribute(nep,"endPointName")
    if (nepname==name):
      return nep
  return ""

#
# Adds named endpoints for each of the given names, with host set to "*"
# and port set to the first otherwise-unused port (based on the usedPorts
# list) >=startScan, to the given server entry
#
def addEndPointsToServerEntry(node,serverEntry,names,startScan,usedPorts):
  tryPort = startScan
  serverName = AdminConfig.showAttribute(serverEntry,"serverName")
  for name in names:
    existingNep = getNamedEndPoint(serverEntry,name)
    if (existingNep!=""):
      print "Endpoint",name,"already exists on",serverName
      continue
    attrs = []
    nameAttr = ["endPointName", name]
    attrs.append(nameAttr)
    nepid = AdminConfig.create("NamedEndPoint",serverEntry,attrs)
    attrs = []
    hostAttr = ["host", "*"]
    while tryPort.toString() in usedPorts[1:]:
      tryPort = tryPort + 1
    usedPorts.append(tryPort.toString())
    portAttr = ["port", tryPort]
    attrs.append(hostAttr)
    attrs.append(portAttr)
    try:
      epid = AdminConfig.create("EndPoint", nepid, attrs)
    except:
      print "Exception creating " + name + " on " + serverName
      continue
    print "Created endpoint",name,"on port",tryPort,"on",serverName

#
# On the given node, adds named endpoints for each of the given names, with host
# set to "*" and port set to the first otherwise-unused port on the node >=startScan, 
# to every server entry (dmgrs first, then nodeagents, then others).  Server entries
# for non-dmgr, non-nodeagent servers are only done if "doOthers" is set to 1.
#
def addEndpoints(node,names,startScan,usedPorts,doOthers):
  serverEntries = convertToList(AdminConfig.list("ServerEntry",node))
  dmgrs = []
  nodeagents = []
  others = []
  usedPorts = []
  hostPorts = []
  serverIndexes = convertToList(AdminConfig.list("ServerIndex",node))
  for serverIndex in serverIndexes:
	hostName = AdminConfig.showAttribute(serverIndex,"hostName")
  for usedPorts in portsByHosts:
	 if (usedPorts[0]==hostName):		 		
		 hostPorts = usedPorts
		 print "Ports being passed:",hostPorts
		 match="1"
  if (match!="1"):
     print "ERROR: Unable to get ports by host name : "
  for serverEntry in serverEntries:
    serverType = AdminConfig.showAttribute(serverEntry,"serverType")
    if (serverType=="DEPLOYMENT_MANAGER"):
      dmgrs.append(serverEntry)
    elif (serverType=="NODE_AGENT"):
      nodeagents.append(serverEntry)
    elif (serverType !="PROXY_SERVER" and serverType != "ONDEMAND_ROUTER"):
      others.append(serverEntry)
  #for serverEntry in dmgrs:
  # addEndPointsToServerEntry(node,serverEntry,names,startScan,hostPorts)
  for serverEntry in nodeagents:
    addEndPointsToServerEntry(node,serverEntry,names,startScan,hostPorts)
  if (doOthers==1):
    for serverEntry in others:
      addEndPointsToServerEntry(node,serverEntry,names,startScan,hostPorts)

def printHelp(): 
    print """   
  DESCRIPTION
      addWCAdminHostTransport.py: this script takes the node name as input: <node_name>
      "e.g.:     addWCAdminHostTransport.py  mynode
   """
    return 1
   
#=======================================================================================================================================================
#
# Main addWCAdminHostTranport.py execution logic:
#
#=======================================================================================================================================================

if(len(sys.argv) == 1):
    nodeName = sys.argv[0]
    print "INFO: nodename="+nodeName
else:
    printHelp()
portsByHosts=[]
nodes = convertToList(AdminConfig.list("Node"))
for node in nodes:
  aNodeName = AdminConfig.showAttribute(node,"name")
  if (aNodeName == nodeName):
     usedPorts = findUsedPorts(node)
     print "Processing node",nodeName
     addEndpoints(node,["WC_adminhost","WC_adminhost_secure"],9060,usedPorts,1)
     addEndpoints(node,["SIP_DEFAULTHOST","SIP_DEFAULTHOST_SECURE"],5060,usedPorts,1)
     print "-----------------------"  
     break

AdminConfig.save();
