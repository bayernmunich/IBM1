#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or 
# distributing.

#
# Script for linking two cells together via the overlay transport
#

# Begin copied from importOverlayConfig.py

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

def checkForDuplicates(myCellName,overlayBridgeID):
    cell_list = []
    cell_list.append(myCellName)  
    l=convertToList(AdminConfig.list('RemoteCellAccessPoint',overlayBridgeID))
    for bridge in l:
        remoteCellName=AdminConfig.showAttribute(bridge,'cellName')
        cell_list.append(remoteCellName)
    dups = [x for x in cell_list if cell_list.count(x) > 1]
    if dups :
        fatal("Cell names are not unique")

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
	
	# remove exisiting OverlayData associated with the cell - won't throw exception if empty 
	removeOverlayBridgeData(fileName)
	 
	cellAccessPoint=getRemoteCellAccessPoint(remoteCellName,overlayBridgeID)

	# do not allow duplicate cells 
	checkForDuplicates(getCellName(),overlayBridgeID)	

	dmgrBootAnchorHost=p.getProperty("dmgrBootAnchorHost")
        if(dmgrBootAnchorHost!=None and dmgrBootAnchorHost!=""):
		dmgrBootAnchorPortString=p.getProperty("dmgrBootAnchorPort")
		dmgrBootAnchorPort=-1
		try:
			dmgrBootAnchorPort=int(dmgrBootAnchorPortString)
		except(ValueError):
			print "\tSkipping entry "+dmgrBootAnchorHost+":"+dmgrBootAnchorPortString+" due to invalid port value"
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
			print "\tSkipping entry "+agentBootAnchorHost+":"+agentBootAnchorPortString+" due to invalid port value"
                if(agentBootAnchorPort>-1):
                        getOverlayEndpoint(cellAccessPoint,agentBootAnchorHost,agentBootAnchorPort)
		i=i+1

def createOverlayEndpoint(cellAP,host,port):
       # print "creating OverlayEndpoint host="+host+" port="+str(port)
       AdminConfig.create("OverlayEndpoint",cellAP,[["host",host],["port",port]])

def getOverlayEndpoint(cellAP,host,port):
        l=convertToList(AdminConfig.list('OverlayEndpoint',cellAP))
        for ep in l:
                epHost=AdminConfig.showAttribute(ep,'host')
                epPort=AdminConfig.showAttribute(ep,'port')
                #print "checking "+host+":"+str(port)+" vs "+epHost+":"+str(epPort)
                if(epHost==host and str(epPort)==str(port)):
                        #print "Found OverlayEndpoint for "+host+":"+str(port)
                        return ep
        return createOverlayEndpoint(cellAP,host,port)

 

def getCellID():
	s=convertToList(AdminConfig.list('Cell'))
	if(len(s)>0):	
        	#print "Got cell name="+s[0]
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
        #print "Creating RemoteCellAccessPoint for cell="+remoteCellName
	return AdminConfig.create('RemoteCellAccessPoint',overlayBridgeID,[['cellName',remoteCellName]])
	
def getRemoteCellAccessPoint(remoteCellName,overlayBridgeID):
	l=convertToList(AdminConfig.list('RemoteCellAccessPoint',overlayBridgeID))
	for bridge in l:
		cellName=AdminConfig.showAttribute(bridge,'cellName')
                #print "checking "+cellName+" vs "+remoteCellName
		if(cellName==remoteCellName):
			#print "Found RemoteCellAccessPoint for cell "+cellName
			return bridge
	return createRemoteCellAccessPoint(remoteCellName,overlayBridgeID)

# End copied from importOverlayConfig.py

def getVal(arg):
   parts = arg.split("::")
   if (len(parts) < 2):
      return ""
   else:
      return parts[1].rstrip()
      
def getCellName():
   global AdminConfig
   cells = AdminConfig.list("Cell")
   return AdminConfig.showAttribute(cells, "name" )

def usage(msg):
   print msg
   print "\t-importSigner:<host>:<port>:<keyStore>   extract the root signer certificate from the key store and place in <dstFile>"
   print "\t-removeSigner:<host>:<port>:<keyStore>   remove the root signer certificate from the key store"
   print "\t-getOverlay::<dstFile>                   extract the overlay configuration file and store it in <dstFile>"
   print "\t-addOverlay::<srcFile>                   add the overlay configuration from <srcFile> to this cell's overlay configuration"
   sys.exit(1)

myCell=getCellName()
configChange=0
for arg in sys.argv:
   filePath=getVal(arg)
   if (arg.startswith("-importSigner:")):
      parts = arg.split(":")
      if (len(parts) != 4):
	 usage("invalid format; it should be '-importSigner:<host>:<port>:<keyStore>'")
      host=parts[1].rstrip()
      port=parts[2].rstrip()
      keyStore=parts[3].rstrip()
      # try removing the cert first 
      try :
        AdminTask.deleteSignerCertificate(['-keyStoreName', keyStore, '-certificateAlias', 'host-'+host+'-port-'+port])
      except :
        # do nothing - no cert was available for this alias so continue importing
        print "\tNo existing signer certificate found ... continue importing"
      print "\tImporting signer certificate from key store "+keyStore+" at port "+port+" of host "+host+" ..."
      AdminTask.retrieveSignerFromPort (['-host', host, '-port', port, '-keyStoreName', keyStore, '-certificateAlias', 'host-'+host+'-port-'+port])
      print "\tImported signer certificate from key store "+keyStore+" at port "+port+" of host "+host
      configChange=1
   elif (arg.startswith("-getOverlay:")):
      print "\tStoring overlay config from cell "+myCell+" in file "+filePath+" ..."
      AdminConfig.extract('cells/'+myCell+'/overlaynodes.config', filePath)
      print "\tStored overlay config from cell "+myCell+" in file "+filePath
   elif (arg.startswith("-addOverlay:")):
      print "\tAdding overlay config to cell "+myCell+" from file "+filePath+" ..."
      createOverlayBridgeData(filePath)
      print "\tAdded overlay config to cell "+myCell+" from file "+filePath
      configChange=1
   elif (arg.startswith("-removeSigner:")):
      parts = arg.split(":")
      if (len(parts) != 4):
	 usage("invalid format; it should be '-removeSigner:<host>:<port>:<keyStore>'")
      host=parts[1].rstrip()
      port=parts[2].rstrip()
      keyStore=parts[3].rstrip()
      print "\tRemoving signer certificate from key store "+keyStore+" at port "+port+" of host "+host+" ..."
      AdminTask.deleteSignerCertificate(['-keyStoreName', keyStore, '-certificateAlias', 'host-'+host+'-port-'+port])       
      print "\tRemoved signer certificate from key store "+keyStore+" at port "+port+" of host "+host
      configChange=1  
   else:
      usage("unrecognized option: "+arg)

if (configChange != 0):
   print "\tSaving configuration ..."
   AdminConfig.save()
   syncNodes()
