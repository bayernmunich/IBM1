#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or 
#  distributing.

#
# script for connecting overlay networks from two distinct cells
#
# author: Ben Parees (bparees@us.ibm.com)
#

import java.util as util
import java.io as javaio

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
     
def syncNodes():
	node_ids = convertToList(AdminConfig.list("Node"))
	for node in node_ids:
		nodeName = AdminConfig.showAttribute(node,"name")
		nodeSynch = AdminControl.completeObjectName("type=NodeSync,node=" + nodeName + ",*")
		if (nodeSynch != ""):
			AdminControl.invoke(nodeSynch,"sync")

def removeOverlayBridgeData(fileName):
	overlayBridgeID=getOverlayBridgeID()
	p = util.Properties()
	propertiesFile =javaio.FileInputStream(fileName)
	p.load( propertiesFile) 
	remoteCellName=p.getProperty("cellName") 
	cellAccessPoint=getRemoteCellAccessPoint(remoteCellName,overlayBridgeID)
	AdminConfig.remove(cellAccessPoint)	

def createOverlayBridgeData(fileName):
	overlayBridgeID=getOverlayBridgeID()

	p = util.Properties()
	propertiesFile =javaio.FileInputStream(fileName)
	p.load( propertiesFile) 
	remoteCellName=p.getProperty("cellName") 
	cellAccessPoint=getRemoteCellAccessPoint(remoteCellName,overlayBridgeID)

	dmgrBootAnchorHost=p.getProperty("dmgrBootAnchorHost")
        if(dmgrBootAnchorHost!=None and dmgrBootAnchorHost!=""):
		dmgrBootAnchorPortString=p.getProperty("dmgrBootAnchorPort")
		dmgrBootAnchorPort=-1
		try:
			dmgrBootAnchorPort=int(dmgrBootAnchorPortString)
		except(ValueError):
			print "Skipping entry "+dmgrBootAnchorHost+":"+dmgrBootAnchorPortString+" due to invalid port value"
		if(dmgrBootAnchorPort>-1):
			getOverlayEndpoint(cellAccessPoint,dmgrBootAnchorHost,dmgrBootAnchorPort)
	i=0
	while(1):
  		agentBootAnchorHost=p.getProperty("nodeAgentBootAnchorHost."+str(i))
		if(agentBootAnchorHost==None or agentBootAnchorHost==""):
			break
		agentBootAnchorPortString=p.getProperty("nodeAgentBootAnchorPort."+str(i))
                agentBootAnchorPort=-1
                try:
                        agentBootAnchorPort=int(agentBootAnchorPortString)
		except(ValueError):
			print "Skipping entry "+agentBootAnchorHost+":"+agentBootAnchorPortString+" due to invalid port value"
                if(agentBootAnchorPort>-1):
                        getOverlayEndpoint(cellAccessPoint,agentBootAnchorHost,agentBootAnchorPort)
		i=i+1

def createOverlayEndpoint(cellAP,host,port):
       print "creating OverlayEndpoint host="+host+" port="+str(port)
       AdminConfig.create("OverlayEndpoint",cellAP,[["host",host],["port",port]])

def getOverlayEndpoint(cellAP,host,port):
        l=convertToList(AdminConfig.list('OverlayEndpoint',cellAP))
        for ep in l:
                epHost=AdminConfig.showAttribute(ep,'host')
                epPort=AdminConfig.showAttribute(ep,'port')
                #print "checking "+host+":"+str(port)+" vs "+epHost+":"+str(epPort)
                if(epHost==host and str(epPort)==str(port)):
                        print "Found OverlayEndpoint for "+host+":"+str(port)
                        return ep
        return createOverlayEndpoint(cellAP,host,port)

def getCellID():
	s=convertToList(AdminConfig.list('Cell'))
	if(len(s)>0):	
        	print "Got cell name="+s[0]
		return s[0]
	else:
		fatal("Could not determine cell name")

def createOverlayBridge(cellID):
	overlayBridge=AdminConfig.create('MultiCellOverlayBridge',cellID,[])
	return overlayBridge	

def getOverlayBridgeID():
	s=convertToList(AdminConfig.list('MultiCellOverlayBridge'))
	if(len(s)==0):
		return createOverlayBridge(getCellID())
	elif(len(s)==1):
		return s[0]
	else:
		fatal("Multiple MultiCellOverlayBridge objects found")

def createRemoteCellAccessPoint(remoteCellName,overlayBridgeID):
        print "Creating RemoteCellAccessPoint for cell="+remoteCellName
	return AdminConfig.create('RemoteCellAccessPoint',overlayBridgeID,[['cellName',remoteCellName]])
	
def getRemoteCellAccessPoint(remoteCellName,overlayBridgeID):
	l=convertToList(AdminConfig.list('RemoteCellAccessPoint',overlayBridgeID))
	for bridge in l:
		cellName=AdminConfig.showAttribute(bridge,'cellName')
                #print "checking "+cellName+" vs "+remoteCellName
		if(cellName==remoteCellName):
			print "Found RemoteCellAccessPoint for cell "+cellName
			return bridge
	return createRemoteCellAccessPoint(remoteCellName,overlayBridgeID)

def printHelp():
	print """
	Usage: 
		To link a remote cell to this cell:
			importOverlayConfig.py link <remote cell overlaynodes.config file>
		To unlink a remote cell from this cell:
			importOverlayConfig.py unlink <remote cell overlaynodes.config file>
        """
        
if (len(sys.argv)==2):
    action=sys.argv[0].rstrip()
    if(action == 'link'):
		createOverlayBridgeData(sys.argv[1].rstrip())
		AdminConfig.save()
		syncNodes()
    elif(action == 'unlink'):
		removeOverlayBridgeData(sys.argv[1].rstrip())
		AdminConfig.save()
		syncNodes()
    else:
    	print "Unsupported operation."
    	printHelp()    
elif (len(sys.argv)>1):
	print "Wrong number of arguments"
	printHelp()
else:
	printHelp()
