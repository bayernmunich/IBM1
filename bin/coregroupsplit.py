#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for creating bridged coregroups
#
# author: Brian Martin (bkmartin@us.ibm.com)
# 10/01/18: Updated by Anil Ambati to allow setting of more options (-nosave, -debug, -bridgeHeapSize, -nodesPerCG, -numberOfServerPerCG)
#             , and to not to use existing coregroups if -reconfig option is specified
#
#
# NOTE: if you are going to run this script on large topologies, you may need to increase com.ibm.SOAP.requestTimeout
# in soap.client.props to a larger value (e.g. 600)
#

import sys
import java.util.HashSet as HashSet
import java.util.HashMap as HashMap
import java.util.TreeMap as TreeMap
import java.util.TreeSet as TreeSet
import java.lang.Integer as Integer
import java.lang.Comparable as Comparable

###################################################
# Parameters controlling execution of the script
###################################################

SCRIPT_VERSION="01/18/10"

# number of nodeagents required per coregroup
nodesPerCG = 3

# maxmium number of servers per coregroup
numberOfServersPerCG = 40

#number of servers per cluster
numberOfServersPerCluster = 10

putAllUnClusteredServersInDefaultCoreGroup = 0

# whether to try to preserve cluster->coregroup mapping
fullReconfigure=0

# whether to build a mesh bridge or linked bridge topology
linkedBridges=0

# coregroup datastack size
coregroupDataStackSize=64

# whether to create separate bridge processes
# bridgeHeapSize gets applied to nodeagent if you don't create separate bridge processes
createBridgeProcesses=0
bridgesPerCG=2
bridgeHeapSize=1024
save=1
debug=0

#
# number of coregroups to create
# 0 = calculate, see -numcoregroups: command line options
#
numberOfCoreGroups=0

#
# whether to put ODRs/Proxy servers in their own coregroup
#
proxyCoreGroup=0

###################################################


class CoreGroup(Comparable):
    name = ""
    configid = None
    clusters = None
    nodeagents = 0
    cgap = None

    def __init__(self,name):
       self.name = name
       self.configid = None
       self.clusters = TreeSet()

    def compareTo(self,other):
       return cmp(self.name,other.name)
   
    def printString(self):
       printstr = "Coregroup Name:" + self.name 
       if (self.configid != None):
           printstr = printstr + ", Config Id:" + str(self.configid)
       printstr = printstr + ", Node agents:"+str(self.nodeagents)
       printstr = printstr+", Coregroup access point:"+str(self.cgap)
       for cluster in self.clusters:
           printstr = printstr, cluster.printString()
       return printstr

class Server(Comparable):
   nodeName = ""
   serverName = ""
   serverType = ""
   clusterName = ""
   cgname = ""
   isBridge = 0

   def toString(self):
       return self.nodeName+"/"+self.serverName+" "+self.serverType+" "+self.clusterName
  
   def printString(self):
       printstr = "Server <Node name:" + self.nodeName + ", Server name:" + self.serverName + ", Server type:" + self.serverType + ", Cluster Name:" + self.clusterName
       printstr = printstr + ", Coregroup name:" + self.cgname + ", is bridge:" + str(self.isBridge)+">"
       return printstr

   def compareTo(self,other):
       return cmp(self.nodeName+"/"+self.serverName,other.nodeName+"/"+other.serverName)

class Cluster(Comparable):
    name = ""
    servers = []
    coregroup = None

    def __init__(self,name):
        self.name = name
        self.servers = []
        self.coregroup = None

    def toString(self):
        return self.name

    def compareTo(self,other):
       return cmp(self.name,other.name)

    def printString(self):
       printstr = "Cluster Name:" + self.name 
       for server in self.servers:
           printstr = printstr, server.printString()
       return printstr
       
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

def getCellName():
	cell = AdminConfig.getid('/Cell:/')
	name = AdminConfig.showAttribute(cell,"name")
	return name

def getServersInCoregroup(coregroup):
    i=0
    for cluster in coregroup.clusters.toArray():
       i = i + len(cluster.servers)
    return i


def getServerType(nodeName,serverName):
     server = convertToList(AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/"))[0]
     serverType = AdminConfig.showAttribute(server,"serverType")
     return serverType

def getClusterName(nodeName,serverName,serverType):
     server = convertToList(AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/"))[0]
     clusterName = AdminConfig.showAttribute(server,"clusterName")
     if (clusterName != None):
         return clusterName
     if (serverType == "DEPLOYMENT_MANAGER"):
         return "WS_DEPLOYMENT_MANAGER"
     if (serverType == "ONDEMAND_ROUTER" or serverType == "PROXY_SERVER"):
         return "WS_PROXY_SERVERS"
     if (serverType == "NODE_AGENT"):
         return "NODE_AGENT:"+nodeName
     if (serverName.startswith("CGBRIDGE_")):
         #expecting the server name to be in the format: CGBRIDGE_<core group name>_<node name>
         sname = serverName[len("CGBRIDGE_"):] #strip CGBRIDGE_ from the server name
         idx = sname.find(nodeName)
         cgname = sname[:idx-1] #retrieve core group name
         clusterName="CGBRIDGE_"+cgname
         return clusterName
     return None
     
 
def getClusterNameForUnClusteredServers(cgName, clusters):
    if (putAllUnClusteredServersInDefaultCoreGroup == 0):
      idx = 1
      clusterName = "WS_UNCLUSTERED_" + cgName + "_%d" % (idx, )
      while (idx > 0): #loop infinitely until we return
          if (clusters.get(clusterName) == None):
              #print "Returning new cluster name for unclustered server:%s" % clusterName
              return clusterName
          else:
              cluster = clusters.get(clusterName)
              if (len(cluster.servers) < numberOfServersPerCluster):
                  #print "Returning existing cluster name for unclustered server:%s" % clusterName + " because it has %s" % len(cluster.servers) + " servers"
                  return clusterName
              else:
                  idx = idx + 1
                  clusterName = "WS_UNCLUSTERED_" + cgName + "_%d" % (idx, )
      return clusterName
    else:
      return "WS_UNCLUSTERED_SERVERS"
 
 
def getConfigIdForTemplate(templateName):
   templates=convertToList(AdminConfig.listTemplates("Server"))
   for template in templates:
       cname = AdminConfig.showAttribute(template,"name")
       if (cname == templateName):
          return template
   return ""

#def getCoregroupForCluster(name,coregroups):
#    coregroupName = name+"CoreGroup"
#    if (name == "WS_DEPLOYMENT_MANAGER"):
#       coregroupName = "DefaultCoreGroup"
#    if (name == "WS_UNCLUSTERED_SERVERS"):
#       coregroupName = "UnclusteredServersCoreGroup"
#    coregroup = coregroups.get(coregroupName)
#    if (coregroup == None):
#        coregroup = CoreGroup(coregroupName)
#        coregroups.put(coregroupName,coregroup)
#    return coregroup


def setExistingCoregroupForCluster(cluster,coregroups,cgname):
    if (cgname != "DefaultCoreGroup"):
       cgiter = coregroups.values().toArray()
       for coregroup in cgiter:
           if (coregroup.name == cgname):
               coregroup.clusters.add(cluster)

def isODRCluster(cluster):
    for server in cluster.servers:
       if (server.serverType != "ONDEMAND_ROUTER"):
           return 0
    return 1
    
def getCoregroupForCluster(cluster,coregroups):
    coregroupName = None;
    name = cluster.name
    if (name == "WS_DEPLOYMENT_MANAGER" or name == "WS_UNCLUSTERED_SERVERS" or (name == "WS_PROXY_SERVERS" and proxyCoreGroup == 0)):
       coregroupName = "DefaultCoreGroup"
       coregroup = coregroups.get(coregroupName)
       coregroup.clusters.add(cluster)
       return coregroup
    if (name == "WS_PROXY_SERVERS" and proxyCoreGroup == 1):
       coregroupName = "BridgedCoreGroupODR"
       coregroup = coregroups.get(coregroupName)
       coregroup.clusters.add(cluster)
       return coregroup
    if (name.startswith("CGBRIDGE_")):
       #remove CGBRIDGE_ from the cluster name, which must be in the format : CGBRIDGE_<core group name>
       lname = name[len("CGBRIDGE_"):]
       coregroup = coregroups.get(lname)
       #coregroup can be null if cell was configured using this script and is being reconfigured again to 
       #less number of coregroups than existing number of coregroups
       if (coregroup != None):
          coregroup.clusters.add(cluster)
          return coregroup
    if (isODRCluster(cluster) == 1 and proxyCoreGroup == 1):
       coregroupName = "BridgedCoreGroupODR"
       coregroup = coregroups.get(coregroupName)
       coregroup.clusters.add(cluster)
       return coregroup

    cgiter = coregroups.values().toArray()
    eligibleGroup = None
    eligibleNum = 99999999;
    nodeAgentCluster=0
    if (name.startswith("NODE_AGENT:")):
       nodeAgentCluster=1
    for coregroup in cgiter:
       if (coregroup.clusters.contains(cluster)):
           return coregroup
       if (nodeAgentCluster):
          serversInCG = coregroup.nodeagents
       else:
          serversInCG = getServersInCoregroup(coregroup)
       if (serversInCG < eligibleNum and (coregroup.name != "BridgedCoreGroupODR" or nodeAgentCluster == 1)):
          eligibleGroup = coregroup
          eligibleNum = serversInCG
    eligibleGroup.clusters.add(cluster)
    if (name.startswith("NODE_AGENT:")):
        eligibleGroup.nodeagents = eligibleGroup.nodeagents + 1
    return eligibleGroup


#def getCoreGroupForServer(server,nodeName,coregroups,clusters):
#    serverName = AdminConfig.showAttribute(server,"name")
#    serverType = AdminConfig.showAttribute(server,"serverType")
#    clusterName = getClusterName(nodeName,serverName,serverType)
#    if (clusters.get(clusterName) == None):
#       print "unable to find cluster for server: "+nodeName+"/"+serverName
#       return "_NONE"
#    return getCoregroupForCluster(clusters.get(clusterName),coregroups)

def getCoreGroupForServer(server, coregroups, clusters):
    if (server == None):
       return "_NONE"
    clusterName = server.clusterName
    if (clusters.get(clusterName) == None):
       print "unable to find cluster for server: %s" % server.nodeName+"/%s" % server.serverName
       return "_NONE"
    return getCoregroupForCluster(clusters.get(clusterName),coregroups)

def createCoregroupInConfig(coregroup,servers):
    cgid = AdminConfig.getid("/CoreGroup:"+coregroup.name+"/")
    if (cgid == None or cgid == ""):
        cell=convertToList(AdminConfig.list("Cell"))[0]
        cgid = AdminConfig.create("CoreGroup",cell,[["name",coregroup.name]])
    return cgid


def getTypeOfObject(objid):
    o = objid[objid.find("("):]
    o = o[o.find("#")+1:]
    return o[:o.find("_")]


def duplicateMultiValue(sourceobj,parentobj,parentattr,destobj,objType,overrideAttributes):
    multiAttrs=[]
    multiTypes=[]
    setAttrs=[]
    attrs = convertToList(AdminConfig.attributes(objType))
    for attr in attrs:
       attrName = attr.split(" ")[0]
       attrType = attr[len(attrName)+1:]
       # Fix WAS7.0 Liveness custom type
       if (attrType == "Liveness"):
          attrType = "Liveness*"
       # see if we need to do multiple types
       if (attrType.find("@")==-1):
          if (attrType[-1] == "*"):
             multiAttrs.append(attrName)
             types = attrType[attrType.find("(")+1:attrType.find(")")].replace(",","").split(" ")
             for type in types:
                if (type[-1] == "@"):
                   type = type[:-1]
                multiTypes.append(type)
          else:
             setAttrs.append([attrName,AdminConfig.showAttribute(sourceobj,attrName)])
    finalAttrs=[]
    for attr in setAttrs:
        for overattr in overrideAttributes:
            if (overattr[0] == attr[0]):
                attr[1] = overattr[1]
        finalAttrs.append(attr)

    if (destobj == None):
       if (parentattr == None):
          newobj = AdminConfig.create(objType,parentobj,finalAttrs)
       else:
          newobj = AdminConfig.create(objType,parentobj,finalAttrs,parentattr)
       #Remove the policies that are created by the AdminConfig.create command for the
       #newly created core group. The policies will be copied from the specified source
       #core group
       if (objType=="CoreGroup"):
          policies = convertToList(AdminConfig.showAttribute(newobj, "policies"))
          for policy in policies:
             AdminConfig.remove(policy)
    else:
       newobj = destobj
       AdminConfig.modify(newobj,finalAttrs)

    for attr in multiAttrs:
       childobjs = convertToList(AdminConfig.showAttribute(sourceobj,attr))
       for childobj in childobjs:
          childtype = getTypeOfObject(childobj)
          duplicateMultiValue(childobj,newobj,attr,None,childtype,[])

    return newobj

def duplicateCoreGroup(coregroup,destgroup):
    cell=convertToList(AdminConfig.list("Cell"))[0]
    destgroup.configid = duplicateMultiValue(coregroup.configid,cell,None,None,"CoreGroup",[["name",destgroup.name]])
#    setAttrs=[]
#    attrs = convertToList(AdminConfig.attributes("CoreGroup"))
#
#    for attr in attrs:
#       attrName = attr.split(" ")[0]
#       attrVal = convertToList(AdminConfig.showAttribute(coregroup.configid,attrName))
#       if (len(attrVal)==1):
#          setAttrs.append([attrName,attrVal[0]])
#       elif (attrName == "coreGroupServers"):
#          print "skipping coreGroupServers"
#       elif (attrName == "customProperties"):
#          duplicateMultiValue(coregroup.configid,coregroup.configid,destgroup.configid,"Property")
#       elif (attrName == "policies"):
#          duplicateMultiValue(coregroup.configid,coregroup.configid,destgroup.configid,"HAManagerPolicy")
#       else:
#          print "ERROR unknown attribute:"+attrName,attrVal
#
#    AdminConfig.modify(destgroup.configid,setAttrs)

def removeExistingCoreGroupServers():
    cgservers = convertToList(AdminConfig.list("CoreGroupServer"))
    for cgs in cgservers:
       AdminConfig.remove(cgs)

def removeExistingBridgedCoreGroups():
    cgroups = convertToList(AdminConfig.list("CoreGroup"))
    for cgs in cgroups:
       name = AdminConfig.showAttribute(cgs,"name")
       if (name != "DefaultCoreGroup"):
           policies = convertToList(AdminConfig.showAttribute(cgs,"policies"))
           for policy in policies:
              AdminConfig.remove(policy)
           AdminTask.deleteCoreGroup("-coreGroupName "+name)

def removeExistingPolicies():
    cgroups = convertToList(AdminConfig.list("CoreGroup"))
    for cgs in cgroups:
       name = AdminConfig.showAttribute(cgs,"name")
       if (name != "DefaultCoreGroup"):
           policies = convertToList(AdminConfig.showAttribute(cgs,"policies"))
           for policy in policies:
               AdminConfig.remove(policy)


def fixupCoreGroupServers(coregroup,cluster):
    for server in cluster.servers:
        cgs = AdminConfig.create("CoreGroupServer",coregroup.configid,[["nodeName",server.nodeName],["serverName",server.serverName]],"coreGroupServers")
        if (server.isBridge):
            ccgs = convertToList2(AdminConfig.showAttribute(coregroup.configid,"preferredCoordinatorServers"))
            if (len(ccgs) < 3):
               ccgs.append(cgs)
               AdminConfig.modify(coregroup.configid,[["preferredCoordinatorServers",ccgs]])
            else:
               AdminConfig.modify(coregroup.configid,[["numCoordinators","2"]])
        sidstr = "/Node:"+server.nodeName+"/Server:"+server.serverName+"/"
        serverid = AdminConfig.getid(sidstr)
        hamanagerservice = AdminConfig.list("HAManagerService",serverid)
        AdminConfig.modify(hamanagerservice,[["coreGroupName",coregroup.name]])
    if (cluster.name.startswith("NODE_AGENT") == 0):
       dcid = AdminConfig.getid("/DynamicCluster:"+cluster.name)
       if (dcid != None and dcid !=""):
           hamanagerservice = AdminConfig.list("HAManagerService",dcid)
           AdminConfig.modify(hamanagerservice,[["coreGroupName",coregroup.name]])


def setupCoreGroupBridgeMeshed(coregroups,servers):
   cgbsettings = convertToList(AdminConfig.list("CoreGroupBridgeSettings"))[0]
   #
   #  create accesspoints and accesspointgroups (one per node)
   #
   nodes = convertToList(AdminConfig.list("Node"))
   cgapHash = HashMap()
   cgaps = []

   #
   # enumerate existing cgaps and delete existing bridge interfaces
   #
   acCgaps = convertToList(AdminConfig.list("CoreGroupAccessPoint"))
   for cgap in acCgaps:
       cgaps.append(cgap)
       cgapname = AdminConfig.showAttribute(cgap,"name")
       coregroupname = AdminConfig.showAttribute(cgap,"coreGroup")
       #print "Existing Core Group Access Point: "+cgapname+"("+coregroupname+")"
       cgapHash.put(coregroupname,cgap)
       #
       # delete existing BridgeInterfaces
       #
       print "Removing Bride Interfaces for existing Core Group Access Point:", cgapname, "(", coregroupname, ")"
       acBI = convertToList(AdminConfig.list("BridgeInterface",cgap))
       for bi in acBI:
          AdminConfig.remove(bi)

   #
   # create any new cgap and recreate bridgeinterfaces
   #
   print "Creating new Core Group Access Points and Bridge Interfaces"
   for node in nodes:
       nodeName = AdminConfig.showAttribute(node,"name")
       nodeservers = convertToList(AdminConfig.list("Server",node))
       for server in nodeservers: 
           serverName = AdminConfig.showAttribute(server,"name")
           serverType = AdminConfig.showAttribute(server,"serverType")
           srv = servers.get(nodeName+"/"+serverName)
           coregroup = getCoreGroupForServer(srv,coregroups,clusters)
           if (srv != None and srv.isBridge == 1):
              cgapName = coregroup.name+"_"+"CGAP"
              cgap = cgapHash.get(coregroup.name)
              if (cgap == None):
                 print "  Creating Core Group Access Point '",cgapName,"' for coregroup '", coregroup.name, "'"
                 cgap = AdminConfig.create("CoreGroupAccessPoint",cgbsettings,[["name",cgapName],["coreGroup",coregroup.name]])
                 cgaps.append(cgap)
                 cgapHash.put(coregroup.name,cgap)
              print "  Creating Bridge Interface (node=" + nodeName + ", server=" + serverName + ") for Core Group Access Point '",cgap,"'"
              AdminConfig.create("BridgeInterface",cgap,[["node",nodeName],["server",serverName],["chain","DCS"]])
   apg = convertToList(AdminConfig.list("AccessPointGroup"))[0]
   if (apg == "" or apg == None):
      apg = AdminConfig.create("AccessPointGroup",cgbsettings,[["name","DefaultAccessPointGroup"],["coreGroupAccessPointRefs",cgaps]])
   else:
      AdminConfig.modify(apg,[["coreGroupAccessPointRefs",cgaps]])


def getLinkedCgapName(coregroupname,coregroups):
   cgroups = coregroups.values().toArray()
   i = 0
   while (cgroups[i].name != coregroupname and i < len(cgroups)):
      i = i + 1
   i=i+1
   if (i == len(cgroups)):
      i = 0
   return coregroupname+"_"+cgroups[i].name+"_CGAP"

def setupCoreGroupBridgeLinked(coregroups,servers):
   cgbsettings = convertToList(AdminConfig.list("CoreGroupBridgeSettings"))[0]
   #
   #  create accesspoints and accesspointgroups (one per node)
   #
   nodes = convertToList(AdminConfig.list("Node"))

   #
   # enumerate existing cgaps and delete existing bridge interfaces
   #
   acCgaps = convertToList(AdminConfig.list("CoreGroupAccessPoint"))
   print
   for cgap in acCgaps:
       cgapname = AdminConfig.showAttribute(cgap,"name")
       coregroupname = AdminConfig.showAttribute(cgap,"coreGroup")
       #
       # delete existing BridgeInterfaces
       #
       print "Removing Bride Interfaces for existing Core Group Access Point:", cgapname, "(", coregroupname, ")"
       acBI = convertToList(AdminConfig.list("BridgeInterface",cgap))
       for bi in acBI:
          AdminConfig.remove(bi)
       AdminConfig.remove(cgap)

   #
   # delete existing AccessPointGroups
   #
   print "Removing existing Access Point Groups"
   acApgs = convertToList(AdminConfig.list("AccessPointGroup"))
   for apg in acApgs:
       AdminConfig.remove(apg)

   #
   # create any new cgap and recreate bridgeinterfaces
   #
   for node in nodes:
       nodeName = AdminConfig.showAttribute(node,"name")
       nodeservers = convertToList(AdminConfig.list("Server",node))
       for server in nodeservers:
           serverName = AdminConfig.showAttribute(server,"name")
           serverType = AdminConfig.showAttribute(server,"serverType")
           srv = servers.get(nodeName+"/"+serverName)
           coregroup = getCoreGroupForServer(srv,coregroups,clusters)
           if (srv != None and srv.isBridge == 1):
              cgapName = getLinkedCgapName(coregroup.name,coregroups)
              cgap = coregroup.cgap
              if (cgap == None):
                 print "  Creating Core Group Access Point '",cgapName,"' for coregroup '", coregroup.name, "'"
                 cgap = AdminConfig.create("CoreGroupAccessPoint",cgbsettings,[["name",cgapName],["coreGroup",coregroup.name]])
                 coregroup.cgap = cgap
              print "  Creating Bridge Interface (node=" + nodeName + ", server=" + serverName + ") for Core Group Access Point '",cgap,"'"
              AdminConfig.create("BridgeInterface",cgap,[["node",nodeName],["server",serverName],["chain","DCS"]])

   cgroups = coregroups.values().toArray()
   i = 0
   j = 1
   while (i<len(cgroups)):
       apgname = cgroups[i].name+"_"+cgroups[j].name+"_APG"
       cgaps = []
       cgaps.append(cgroups[i].cgap)
       cgaps.append(cgroups[j].cgap)
       print "apg "+apgname
       apg = AdminConfig.create("AccessPointGroup",cgbsettings,[["name",apgname],["coreGroupAccessPointRefs",cgaps]])
       i = i + 1
       j = j + 1
       if (j == len(cgroups)):
          j = 0



def fixupHaManagerTransportBufferSize():
   allservers = convertToList(AdminConfig.list("Server"))
   for aserver in allservers:
       hamgr = convertToList(AdminConfig.list("HAManagerService",aserver))
       if (len(hamgr)>0):
           AdminConfig.modify(hamgr[0],[["transportBufferSize",coregroupDataStackSize]])
           tpool = convertToList(AdminConfig.list("ThreadPool",hamgr[0]))
           if (len(tpool)>0):
               AdminConfig.modify(tpool[0],[["maximumSize","13"]])

def modifyHeapSize(server,maxheapsize):
   processDefs = convertToList(AdminConfig.showAttribute(server,"processDefinitions"))
   for processDef in processDefs:
      jvmEntries = convertToList(AdminConfig.showAttribute(processDef,"jvmEntries"))
      for jvmEntry in jvmEntries:
          AdminConfig.modify(jvmEntry,[["maximumHeapSize", maxheapsize]])


#
# method to set cell wide custom property for XD to enable bridge processes instead
# of nodeagents as bridges
#

def setBridgeCustomProperty():
   cell=convertToList(AdminConfig.list("Cell"))[0]
   properties=convertToList(AdminConfig.showAttribute(cell,"properties"))
   for property in properties:
      propName = AdminConfig.showAttribute(property,"name")
      if (propName=="xd.disable.cgb.config"):
         AdminConfig.remove(property)
   AdminConfig.create("Property",cell,[["name","xd.disable.cgb.config"],["value","true"]])




#
# method to create independent bridge processes
#
def doCreateBridgeProcesses(bridgesPerCG,coregroups,clusters,servers):
   setBridgeCustomProperty()
   availableNodes=[]
   availableNodeNames=[]
   for node in nodes:
       nodeName = AdminConfig.showAttribute(node,"name")
       serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:nodeagent/")
       if (serverid != None and serverid != ""):
           availableNodes.append(node)
           availableNodeNames.append(nodeName)
   currentNode=0
   if (bridgesPerCG > len(availableNodes)):
       bridgesPerCG = len(availableNodes)
   for coregroup in coregroups.values():
       firstServer=1
       serversToCreate=bridgesPerCG
       serverprefix="CGBRIDGE_"+coregroup.name
       clusterName="CGBRIDGE_"+coregroup.name
#       cluster=AdminConfig.getid("/ServerCluster:"+clusterName)
#       if (cluster == None or cluster == ""):
#          clusterArgs="[-clusterConfig [["+clusterName+" true]]"
#          cluster=AdminTask.createCluster(clusterArgs)
       for aserver in servers.keySet():
           if (aserver.find(serverprefix)!=-1):
              serversToCreate = serversToCreate-1
              firstServer=0
       iterations=0
       while serversToCreate > 0 and iterations < len(availableNodes):
           bridgeName="CGBRIDGE_"+coregroup.name+"_"+availableNodeNames[currentNode]
           if (servers.get(availableNodeNames[currentNode]+"/"+bridgeName) == None):
              cmdArgs="[-name "+bridgeName+" -templateName default ]"
              print "Creating server with args:"+cmdArgs
              appserver=AdminTask.createApplicationServer(availableNodeNames[currentNode],cmdArgs)
#              cmdArgs="-clusterName "+clusterName+" -memberConfig [["+availableNodeNames[currentNode]
#              cmdArgs+=" "+bridgeName+" \'\' \'\' true false]]"
#              if (firstServer == 1):
#                  cmdArgs+=" -firstMember [[default \'\' \'\' DefaultNodeGroup \'\']]"
#                  firstServer=0
#              AdminTask.createClusterMember(cmdArgs)
#              appserver=AdminConfig.getid("/Node:"+availableNodeNames[currentNode]+"/Server:"+bridgeName+"/")
              serversToCreate = serversToCreate-1
              modifyHeapSize(appserver,bridgeHeapSize)
              server = Server()
              server.nodeName = availableNodeNames[currentNode]
              server.serverName = bridgeName
              server.serverType = getServerType(server.nodeName,server.serverName)
              #server.clusterName = getClusterName(server.nodeName,server.serverName,server.serverType)
              server.clusterName = "CGBRIDGE_"+coregroup.name 
              server.cgname = coregroup.name
              server.isBridge = 1
              servers.put(server.nodeName+"/"+server.serverName,server)
              cluster = clusters.get(server.clusterName)
              if (cluster == None):
                 cluster = Cluster(server.clusterName)
                 cluster.coregroup = coregroup
                 coregroup.clusters.add(cluster)
                 clusters.put(cluster.name,cluster)
              cluster.servers.append(server)
           currentNode=currentNode+1
           if (currentNode == len(availableNodes)):
               currentNode=0
           iterations = iterations+1

def getCoregroupProtocolVersion(dmgrNodeName):
    version = "6.1.0"
    nodeMajorVersion=AdminTask.getNodeMajorVersion("-nodeName "+dmgrNodeName)
    nodeMinorVersion=AdminTask.getNodeMinorVersion("-nodeName "+dmgrNodeName)
    if (nodeMajorVersion=="6" and nodeMinorVersion=="0"):
      version="6.0.2.9"
    return version

def getHAMProtocolVersion(dmgrNodeName):
    version = None
    nodeVersion=AdminTask.getNodeBaseProductVersion("-nodeName "+dmgrNodeName).split(".")
    if (nodeVersion[0]=="6" and nodeVersion[1]=="1" and nodeVersion[3]>="19"):
       version="6.0.2.31"
    if (nodeVersion[0]=="6" and nodeVersion[1]=="0" and nodeVersion[3]>="31"):
       version="6.0.2.31"
    if (nodeVersion[0]=="7" and nodeVersion[1]=="0" and nodeVersion[3]>="1"):
       version="6.0.2.31"
    return version

#
#
#  Start off main() program
#
#

print "#######################################################"
print "## Automatic coregroup configuration"
print "## Version:  "+SCRIPT_VERSION
print "#######################################################"
print ""


if (len(sys.argv)>0):
   for arg in sys.argv:
       if (arg == '-reconfig'):
           fullReconfigure=1
       elif (arg == '-linked'):
           linkedBridges=1
       elif (arg == '-createbridges'):
           createBridgeProcesses=1
       elif (arg.startswith("-numcoregroups:")):
           parts = arg.split(":")
           numberOfCoreGroups=int(parts[1])
       elif (arg.startswith("-datastacksize:")):
           parts = arg.split(":")
           coregroupDataStackSize=int(parts[1])
       elif (arg.startswith("-bridgeHeapSize:")):
           parts = arg.split(":")
           bridgeHeapSize=int(parts[1])
       elif (arg.startswith("-nodesPerCG:")):
           parts = arg.split(":")
           nodesPerCG=int(parts[1])
       elif (arg.startswith("-numberOfServersPerCG:")):
           parts = arg.split(":")
           numberOfServersPerCG=int(parts[1])
       elif (arg == "-proxycoregroup"):
           proxyCoreGroup=1
       elif (arg == "-odrcoregroup"):
           proxyCoreGroup=1
       elif (arg == "-putUnclusteredServersInDefaultcoregroup"):
           putAllUnClusteredServersInDefaultCoreGroup = 1
       elif (arg == "-nosave"):
           save=0
       elif (arg == "-debug"):
           debug=1
       else:
           print "unrecognized option: "+arg
           print "available options:"
           print "\t-reconfig                                 do a full reconfiguration"
           print "\t-linked                                   create a ring topology of bridges"
           print "\t-createbridges                            create separate bridge processes instead of bridging in the nodeagent"
           print "\t-numcoregroups:<num>                      override to specify the number of desired coregroups"
           print "\t-datastacksize:<num>                      override to specify the datastack size in MB"
           print "\t-proxycoregroup                           put ODRs and Proxy Servers in their own coregroup"
           print "\t-odrcoregroup                             put ODRs and Proxy Servers in their own coregroup"
           print "\t-putUnclusteredServersInDefaultcoregroup  put all unclustered servers in the DefaultCoreGroup"
           print "\t-nosave                                   do not save changes"
           print "\t-debug                                    prints debug information" 
           print "\t-bridgeHeapSize:<num>                     specify coregroup bridge server heap size in MB"
           print "\t-nodesPerCG:<num>                         specify number of node agents required per coregroup" 
           print "\t-numberOfServersPerCG:<num>               specify maximum number of servers per coregroup"
           sys.exit(1)


#
# compute number of nodes
#
nodes = convertToList(AdminConfig.list("Node"))
numberOfNodes = len(nodes)
print "Number of nodes: ",numberOfNodes
wasNodes = 0
nonWasNodes = 0
numberOfServers = 0
dmgrNodeName = ""
if (debug == 1):
   print "List of servers:"
for node in nodes:
    nodeName = AdminConfig.showAttribute(node,"name")
    serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:nodeagent/")
    servers = convertToList(AdminConfig.list("Server",node))
    if (debug == 1):
       for server in servers:
           print "  " + server
    numberOfServers = numberOfServers+len(servers)
    if (serverid == None or serverid == ""):
        serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:dmgr/")
        if (serverid != None and serverid != ""):
           wasNodes = wasNodes + 1
           dmgrNodeName = nodeName
        else:
           nonWasNodes = nonWasNodes + 1
    else:
        wasNodes = wasNodes + 1
        # if we are not creating bridge processes, then modify the heap size of the nodeagents
        if (createBridgeProcesses == 0):
            modifyHeapSize(serverid,bridgeHeapSize)

print "Number of WAS nodes: ",wasNodes
print "Number of non WAS nodes: ",nonWasNodes
print "Number of servers: ",numberOfServers

#
# compute number of clusters
#

clusters = convertToList(AdminConfig.list("ServerCluster"))
numberOfClusters = len(clusters)
print "Number of clusters: ",numberOfClusters

#
# compute number of coregroups
#
if (numberOfCoreGroups == 0):
   numberOfCoreGroups = wasNodes / nodesPerCG;
   if (numberOfClusters < numberOfCoreGroups):
      numberOfCoreGroups = numberOfClusters
   numberOfCGBasedOnServers = (numberOfServers+numberOfServersPerCG) / numberOfServersPerCG
   if (numberOfCoreGroups > numberOfCGBasedOnServers):
      numberOfCoreGroups = numberOfCGBasedOnServers
if (numberOfCoreGroups <= 0):
   numberOfCoreGroups = 1

print "Desired number of coregroups: ",numberOfCoreGroups

coregroups = TreeMap()
for i in range(numberOfCoreGroups):
    coregroupname = "BridgedCoreGroup"+str(i)
    if (i == 0):
      coregroupname = "DefaultCoreGroup"
    if (proxyCoreGroup == 1 and i == 1):
      coregroupname = "BridgedCoreGroupODR"
    coregroups.put(coregroupname,CoreGroup(coregroupname))



#
# process all servers
#
servers  = TreeMap()
clusters = TreeMap()
coregroupBridges = TreeSet()
print "Retrieving existing coregroups"
coregroupIds=convertToList(AdminConfig.list("CoreGroup"))
for coregroup in coregroupIds:
    print "Existing coregroup: "+AdminConfig.showAttribute(coregroup,"name")
    cgname = AdminConfig.showAttribute(coregroup,"name")
    cg = coregroups.get(cgname)
    #if full reconfigure is selected, existing coregroups will be deleted and not be added to the coregroups list
    if (fullReconfigure == 0):
       if (cg == None):
           cg = CoreGroup(cgname)
           coregroups.put(cgname,cg)
    if (cg != None):
       cg.configid = coregroup
    cgservers = convertToList(AdminConfig.list("CoreGroupServer",coregroup))
    for cgs in cgservers:
        server = Server()
        server.nodeName = AdminConfig.showAttribute(cgs,"nodeName")
        server.serverName = AdminConfig.showAttribute(cgs,"serverName")
        server.serverType = getServerType(server.nodeName,server.serverName)
        server.cgname = cgname
        if (server.serverName.startswith("CGBRIDGE_") and fullReconfigure == 1):
            coregroupBridges.add(server)
            continue
        
        clusterName = getClusterName(server.nodeName,server.serverName,server.serverType)
        #if clusterName is null then it means this is a unclustered application server. Spread the unclustered 
        # servers into different pseudo clusters
        if (clusterName == None):
            clusterName = getClusterNameForUnClusteredServers(server.cgname, clusters)
            #print "Assinging unclustered server " + server.serverName + " to pseudo cluster " + clusterName           
        server.clusterName = clusterName
       
        if (createBridgeProcesses == 0 and (server.serverType=="NODE_AGENT" or server.serverType=="DEPLOYMENT_MANAGER")):
           server.isBridge = 1
        if (server.serverName.startswith("CGBRIDGE_")):
           server.isBridge = 1
        cluster = clusters.get(server.clusterName)
        if (cluster == None):
            cluster = Cluster(server.clusterName)
            clusters.put(cluster.name,cluster)
        foundDup=None
        for s in cluster.servers:
            if (s.nodeName == server.nodeName and s.serverName == server.serverName):
                foundDup=s
        if (foundDup == None):
            cluster.servers.append(server)
            servers.put(server.nodeName+"/"+server.serverName,server)
            # if we are doing a full reconfigure, then we don't need to remember where the servers were, put
            # everyone in DefaultCoreGroup temporarily
            if (fullReconfigure == 0):
                setExistingCoregroupForCluster(cluster,coregroups,server.cgname)
                if (cgname !="DefaultCoreGroup" and server.clusterName.startswith("NODE_AGENT")):
                   cg.nodeagents = cg.nodeagents + 1
            else:
                server.cgname = "DefaultCoreGroup"


#
# place nodeagents in coregroups first
#
for node in nodes:
    nodeName = AdminConfig.showAttribute(node,"name")
    serverName = "nodeagent"
    serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:nodeagent/")
    if (serverid == None or serverid == ""):
        serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:dmgr/")
        if (serverid != None and serverid != ""):
            server = servers.get(nodeName+"/dmgr")
            getCoregroupForCluster(clusters.get(server.clusterName),coregroups)
    else:
        server = servers.get(nodeName+"/nodeagent");
        getCoregroupForCluster(clusters.get(server.clusterName),coregroups)

if (fullReconfigure == 1):
   #Remove coregroup bridge servers
   for cgbserver in coregroupBridges:
      cgbserverid = AdminConfig.getid("/Node:"+cgbserver.nodeName+"/Server:"+cgbserver.serverName)
      print "Removing existing coregroup bridge server " + cgbserverid
      AdminConfig.remove(cgbserverid)

      
#
# create bridge processes if necessary
#
if (createBridgeProcesses == 1):
   print "Creating coregroup bridge servers"
   doCreateBridgeProcesses(bridgesPerCG,coregroups,clusters,servers)


#
# remove servers from existing coregroups
#
print "Removing servers from the existing coregroups"
removeExistingCoreGroupServers()

#
# remove existing bridged coregroups
#
print "Removing existing bridged coregroups"
removeExistingBridgedCoreGroups()


#
# remove existing policies in bridged coregroups
#
print "Removing existing policies in the bridged coregroups"
removeExistingPolicies()

if (debug == 1):
   for coregroup in coregroups.values().toArray():
       print coregroup.printString()

#
# match settings for coregroups
#
defaultCoreGroup = coregroups.get("DefaultCoreGroup")
cgpVersion = getCoregroupProtocolVersion(dmgrNodeName)
hampVersion = getHAMProtocolVersion(dmgrNodeName)
for coregroup in coregroups.values():
    if (coregroup.name != defaultCoreGroup.name):
       print "Creating coregroup '", coregroup.name, "'"
       duplicateCoreGroup(defaultCoreGroup,coregroup)
    cprop = convertToList2(AdminConfig.showAttribute(coregroup.configid,"customProperties"))
    for prop in cprop:
        pname = AdminConfig.showAttribute(prop,"name")
        if (pname == "IBM_CS_DATASTACK_MEG"):
            AdminConfig.remove(prop)
        elif (pname == "IBM_CS_WIRE_FORMAT_VERSION"):
            AdminConfig.remove(prop)
        elif (pname == "IBM_CS_HAM_PROTOCOL_VERSION"):
            AdminConfig.remove(prop)
    AdminConfig.create("Property",coregroup.configid,[["name","IBM_CS_DATASTACK_MEG"],["value",coregroupDataStackSize]],"customProperties")
    AdminConfig.create("Property",coregroup.configid,[["name","IBM_CS_WIRE_FORMAT_VERSION"],["value",cgpVersion]],"customProperties")
    if (hampVersion!=None):
        AdminConfig.create("Property",coregroup.configid,[["name","IBM_CS_HAM_PROTOCOL_VERSION"],["value",hampVersion]],"customProperties")


#print "enumerating clusters and assigning coregroups:"
for cluster in clusters.values().toArray():
    cluster.coregroup = getCoregroupForCluster(clusters.get(cluster.name),coregroups)
#    print "cluster: "+cluster.toString()+" ("+cluster.coregroup.name+")"
#    for server in cluster.servers:
#        print "\t"+server.toString()
    fixupCoreGroupServers(cluster.coregroup,cluster)

if (linkedBridges == 0 or numberOfCoreGroups < 3):
    setupCoreGroupBridgeMeshed(coregroups,servers)
else:
    setupCoreGroupBridgeLinked(coregroups,servers)


#
# setup transport buffersize for all servers for hamanager
#
fixupHaManagerTransportBufferSize()


# print server in each coregroup

print "###############################################################"
print "# Final CoreGroup configuration"
print "###############################################################"
for coregroup in coregroups.values().toArray():
    pfcoord = convertToList2(AdminConfig.showAttribute(coregroup.configid,"preferredCoordinatorServers"))
    if (len(pfcoord) == 0):
       prefcoord = ""
    else:
       prefcoord = ""
       for coord in pfcoord:
           prefcoord=prefcoord+AdminConfig.showAttribute(coord,"nodeName")+"/"+AdminConfig.showAttribute(coord,"serverName")+" "
    print "Coregroup: "+coregroup.name
    print "  preferred coordinator(s):",prefcoord, ", number of servers:",getServersInCoregroup(coregroup), "," 
    print "  servers:"
    for cluster in coregroup.clusters.toArray():
        clustername = cluster.name
        for server in cluster.servers:
            if (clustername=="WS_PROXY_SERVERS" or clustername=="WS_DEPLOYMENT_MANAGER" or clustername.startswith("WS_UNCLUSTERED")): 
               print "    "+server.serverName
            elif (clustername.startswith("NODE_AGENT:")):
              nodename = clustername[len("NODE_AGENT:"):]
              print "    "+server.serverName+"("+nodename+")"
            else:
               print "    "+server.serverName+"("+cluster.name+")"

if (save == 1):
    print "saving workspace"
    AdminConfig.save()
    print "finished."
else:
   print "Exiting with out saving changes"
