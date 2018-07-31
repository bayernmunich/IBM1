#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for creating ODR dynamic cluster
#
# author: Anil Ambati (aambati@us.ibm.com)

import sys
import java.util.HashSet as HashSet
import java.util.Properties as Properties
import javax.management.ObjectName as ObjectName

###################################################
# Parameters controlling execution of the script
###################################################

SCRIPT_VERSION="09/01/11"
dcName = None
ngName = None
nodeName = None
opMode = "automatic"
defaultMode = "manual"
localCluster = "default"
numVerticalInstance = 0
isolationGroup = ""
strictIsolationEnabled = "false"
maxInstances = -1
minInstances = 1
noOfDCs = 1
serverInactivityTime = 60

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split("\"")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def convertToList2(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist
     
def syncAndSaveNodes():
     Sync1 = AdminControl.completeObjectName('type=DeploymentManager,*')
     print "Saving configuration..."
     AdminConfig.save()
     print "Synchronizing changes to active nodes..."
     AdminControl.invoke(Sync1, 'syncActiveNodes', 'true')
     node_ids = convertToList(AdminConfig.list("Node"))
     for node in node_ids:
        nodeName = AdminConfig.showAttribute(node,"name")
        nodeSynch = AdminControl.completeObjectName("type=NodeSync,node=" + nodeName + ",*")
        if (nodeSynch != ""):
           AdminControl.invoke(nodeSynch,"sync")

def modifyOperationalMode(clusterName):
    dcid = AdminConfig.getid("/DynamicCluster:"+clusterName)
    AdminConfig.modify(dcid,[["operationalMode",opMode]])

def createNG():
   exist = doesNodeGroupExist(ngName)
   if (exist == "false"):
     print "Creating node group " + ngName
     AdminTask.createNodeGroup(ngName)
        
   if (nodeName == None):
     print "Node name is not specified, so will not add node to the ODR node group " + ngName
     return
   else:
     try:
       print "Adding node '" + nodeName + "' to the node group " + ngName
       AdminTask.addNodeGroupMember(ngName, ["-nodeName", nodeName])
       return
     except:
       print "Could not add node '" + nodeName + "' to the node group '" + ngName + "'. May be it is already a member of the node group"

def doesNodeGroupExist(nodeGroupName):
   ngid = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
   print ngid
   if (ngid != None and ngid !=""):
      return "true"
   else:
      return "false"

def doesClusterExist(clusterName):
   dcid = AdminConfig.getid("/DynamicCluster:"+clusterName)
   if (dcid != None and dcid !=""):
      return "true"
   else:
      return "false"

def createODRDynamicCluster():
    clusterName = dcName
    # don't create cluster if it already exists
    exist = doesClusterExist(clusterName)
    if (exist == "true"):
      print "Dynamic cluster '" + clusterName + "' already exists. Skipping its creation..."
      return

    mbean=AdminControl.queryNames("WebSphere:*,process=dmgr,type=DynamicClusterConfigManager")

    attrsProps = Properties()
    attrsProps.put("numVerticalInstances",numVerticalInstance)
    attrsProps.put("operationalMode",defaultMode)
    attrsProps.put("isolationGroup",isolationGroup)
    attrsProps.put("strictIsolationEnabled",strictIsolationEnabled)
    attrsProps.put("maxInstances",str(maxInstances))
    attrsProps.put("minInstances",str(minInstances))
    if (minInstances == 0):
        attrsProps.put("serverInactivityTime", serverInactivityTime)
 
    #memPolicy = "node_nodegroup ="
    #memPolicy = memPolicy +  "\'" + ngName +"\'"
    clusterProperties = Properties()
    clusterProperties.put("templateName","http_sip_odr_server")
    print "Creating ODR dynamic cluster " + clusterName
    localCluster = AdminControl.invoke_jmx(ObjectName(mbean),"createODRDynamicCluster",
                        [ngName,clusterName,attrsProps,clusterProperties],
                        ["java.lang.String","java.lang.String","java.util.Properties","java.util.Properties"])

def removeStandaloneODR(): 
   if (nodeName != None):
     odrid = AdminConfig.getid("/Node:"+nodeName+"/Server:odr/")
     if (odrid != ""):
       print "Found stand alone ODR by name 'odr' on the node " + nodeName + ", removing it..."
       na = AdminControl.queryNames("type=NodeAgent,node="+nodeName+",*")
       status = AdminControl.invoke(na,'getProcessStatus','odr')
       print "odr status ="+status
       AdminControl.invoke(na,'terminate','odr')
       AdminConfig.remove(odrid)
     else:
       print "Stand alone ODR by name 'odr' is not present on the node '" + nodeName + "'"

def setAPCPredictorProperty():
   cell=AdminConfig.list("Cell")
   properties=convertToList(AdminConfig.showAttribute(cell,"properties"))
   propertyAllReadySet = 0
   for property in properties:
      propName = AdminConfig.showAttribute(property,"name")
      if (propName=="APC.predictor"):
         propertyAllReadySet = 1
         break
         
   if (propertyAllReadySet == 0):
      print "Setting cell custom property APC.predictor"
      AdminConfig.create('Property', cell, '[[name "APC.predictor"] [value "CPU"]]') 


def getServerEntry(srvName):
  serverIndexes = convertToList(AdminConfig.list("ServerIndex"))
  for serverIndex in serverIndexes:
     serverEntries = convertToList(AdminConfig.showAttribute(serverIndex, "serverEntries"))
     for serverEntry in serverEntries:
        serverName = AdminConfig.showAttribute(serverEntry, "serverName")
        serverType = AdminConfig.showAttribute(serverEntry, "serverType")
        if (serverType == "ONDEMAND_ROUTER" and serverName == srvName):
          print "Returning " + serverEntry + " for server " + srvName
          return serverEntry
          
def getHostAndPort(endPointName, serverEntryId):
  hostPort = []
  foundEndPoint=0
  namedEndPoints = convertToList(AdminConfig.list("NamedEndPoint", serverEntryId))
  for namedEndPoint in namedEndPoints:
    namedEndPointName = AdminConfig.showAttribute(namedEndPoint, "endPointName")
    #print "Checking if " + namedEndPointName + " matches specified end point " + endPointName
    if (namedEndPointName == endPointName):
      endPoint = AdminConfig.showAttribute(namedEndPoint, "endPoint")
      host = AdminConfig.showAttribute(endPoint, "host")
      port = AdminConfig.showAttribute(endPoint, "port")
      hostPort.append(host)
      hostPort.append(port)
      foundEndPoint=1
      break
  return hostPort
        
def updateVirtualHost(virtualHostName, hostName, port):    
    vhost=AdminConfig.getid("/VirtualHost:"+virtualHostName)
    aliases=convertToList2(AdminConfig.showAttribute(vhost,"aliases"))
    found = 0
    for alias in aliases:
       hn=AdminConfig.showAttribute(alias,"hostname")
       if (hn == "*" or hn == hostName):
          portnum=AdminConfig.showAttribute(alias,"port");
          if (portnum == port):
             found = 1
             print "Skipping adding " + hostName + "@" + port + " to the virtual host " + virtualHostName + " as it already exists"
             break
                
    if (found == 0):
        print "Adding " + hostName + "@" + port + " to the virtual host " + virtualHostName
        attrs=[["hostname",hostName],["port",port]]
        AdminConfig.create("HostAlias", vhost, attrs)


def addHttpSipPortsToDefaultHost():
  odrName = str(dcName) + "_" + str(nodeName)
  serverEntryId = getServerEntry(odrName)
  hostPort = getHostAndPort("PROXY_HTTP_ADDRESS", serverEntryId)
  updateVirtualHost("default_host", hostPort[0], hostPort[1])
  hostPort1 = getHostAndPort("PROXY_HTTPS_ADDRESS", serverEntryId)
  updateVirtualHost("default_host", hostPort1[0], hostPort1[1])
  hostPort2 = getHostAndPort("PROXY_SIP_ADDRESS", serverEntryId)
  updateVirtualHost("default_host", hostPort2[0], hostPort2[1])
  hostPort3 = getHostAndPort("PROXY_SIPS_ADDRESS", serverEntryId)
  updateVirtualHost("default_host", hostPort3[0], hostPort3[1]) 
     
#
#
#  Start off main() program
#
#
print "#######################################################"
print "## Create a dynamic cluster"
print "## Version:  "
print "#######################################################"
print ""

isolationGroupSpecified = 0
strictIsolationSpecified = 0
maxInstancesSpecified = 0
dcNameSpecified = 0
nodeNameSpecified = 0
ngNameSpecified = 0

if (len(sys.argv)>0):
   for arg in sys.argv:
       if (arg.startswith("-dcName:")):
           parts = arg.split(":")
           dcName=parts[1]
           dcNameSpecified = 1
       elif (arg.startswith("-nodeName:")):
           parts = arg.split(":")
           nodeName=parts[1]
           nodeNameSpecified = 1
       elif (arg.startswith("-ngName:")):
           parts = arg.split(":")
           ngName=parts[1]
           ngNameSpecified = 1
       elif (arg.startswith("-opMode:")):
           parts = arg.split(":")
           if (parts[1] == "manual" or parts[1] == "automatic"):
              opMode=parts[1]
       elif (arg.startswith("-numVerticalInstances:")):
           parts = arg.split(":")
           if (parts[1] != "" and parts[1] > 0):
              numVerticalInstance=parts[1]
       elif (arg.startswith("-strictIsolation:")):
           parts = arg.split(":")
           if (parts[1] == "true" or parts[1] == "false"):
              strictIsolationEnabled=parts[1]
           strictIsolationSpecified = 1
       elif (arg.startswith("-isolationGroup:")):
           parts = arg.split(":")
           if (parts[1] != ""):
             isolationGroup=parts[1]
             isolationGroupSpecified = 1
       elif (arg.startswith("-maxInstances:")):
           parts = arg.split(":")
           if (parts[1] != ""):
              try:
                maxInsts = int(parts[1])
                if (maxInsts >= 1):
                  maxInstances=maxInsts
                  maxInstancesSpecified = 1
              except ValueError:
                print "Maximum instances must be a number"
                sys.exit(1)
       elif (arg.startswith("-minInstances:")):
           parts = arg.split(":")
           if (parts[1] != ""):
              try:
                minInsts = int(parts[1])
                if (minInsts >= 0):
                  minInstances=minInsts
              except ValueError:
                print "Minimum instances must be a number"
                sys.exit(1)
       elif (arg.startswith("-serverInactivityTime:")):
           parts = arg.split(":")
           if (parts[1] != ""):
              try:
                serverInactivityTime = int(parts[1])
              except ValueError:
                print "Server inactivity time must be a number"
                sys.exit(1)
       else:
           print "unrecognized option: "+arg
           print "available options:"
           print "\t-ngName:<node group name>                            Name of a node group"
           print "\t-opMode:<operational mode>                           Operational mode for the dynamic cluster. Valid values are 'manual' , 'automatic'"
           print "\t-numVerticalInstances:<number of vertical instances> Number of vertical instances on each node"
           print "\t-strictIsolation:<true/false>                        Strict isolation"
           print "\t-isolationGroup:<isolation group>                    Isolation group"
           print "\t-maxInstances:<max instances>                        Maximum number of cluster instances"
           print "\t-minInstances:<min instances>                         Minimum number of cluster instances"
           print "\t-serverInactivityTime:<time in minutes>              Server inactivity is the time in minutes to wait before stopping instances after the application placement controller determines that the resources are required by some other dynamic cluster."
           sys.exit(1)

if (ngNameSpecified == 0 or dcNameSpecified == 0):
   print "-dcName:<dynamic cluster name> and -ngName:<node group name> options must be specified"
   sys.exit(1)

if (minInstances > maxInstances and maxInstancesSpecified == 1):
   print "Minimum instances must be less than or equal to maximum instances"
   sys.exit(1)
   
if (minInstances == 0):
   print "Number of minimum instances is specified as 0. This will enable lazy start feature for the dynamic cluster."

if (isolationGroupSpecified == 1 and strictIsolationSpecified == 1):
   print "Both -isolationGroup and -strictIsolation cannot be specify. Please specify either -isolationGroup or -strictIsolation"
   sys.exit(1)

createNG()
syncAndSaveNodes()

createODRDynamicCluster()
syncAndSaveNodes()

modifyOperationalMode(dcName)
removeStandaloneODR()
setAPCPredictorProperty()

addHttpSipPortsToDefaultHost()

syncAndSaveNodes()
print "Done."