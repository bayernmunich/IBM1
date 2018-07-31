#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for creating dynamic clusters
#
# author: Anil Ambati (aambati@us.ibm.com)

import sys
import java.util.HashSet as HashSet
import java.util.Properties as Properties
import javax.management.ObjectName as ObjectName

###################################################
# Parameters controlling execution of the script
###################################################

SCRIPT_VERSION="02/16/10"
dcName = None
ngName = None
opMode = "automatic"
defaultMode = "manual"
localCluster = "default"
numVerticalInstance = 0
isolationGroup = ""
strictIsolationEnabled = "false"
maxInstances = -1
minInstances = 1
minNodes = 1
maxNodes = -1
membershipPolicy = None
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
   if (exist == "true"):
     print "Node group " + ngName + " already exists. Skipping its creation..."
     return
      
   nodes = convertToList(AdminConfig.list("Node"))
   nodesForNG = HashSet()
   for node in nodes:
      nodeName = AdminConfig.showAttribute(node,"name")
      nodeagentid = AdminConfig.getid("/Node:"+nodeName+"/Server:nodeagent/")
      if (nodeagentid != None and nodeagentid != ""):
        nodeservers = convertToList(AdminConfig.list("Server", node))
        addNode = 1
        for server in nodeservers:
           serverType = AdminConfig.showAttribute(server,"serverType")
           if (serverType == "ONDEMAND_ROUTER"):
              addNode = 0
              break
        if (addNode == 1):
          nodesForNG.add(nodeName)
   print "Creating node group " + ngName
   AdminTask.createNodeGroup(ngName)
   for nd in nodesForNG:
      AdminTask.addNodeGroupMember(ngName, ["-nodeName", nd]) 
   
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
  
def createDynamicCluster(idx):
    suffix = "_" + str(idx)
    clusterName = dcName + suffix
    # don't create cluster if it already exists
    exist = doesClusterExist(clusterName)
    if (exist == "true"):
      print "Dynamic cluster " + clusterName + " already exists. Skipping its creation..."
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
        attrsProps.put("serverInactivityTime", str(serverInactivityTime))
    attrsProps.put("maxNodes",maxNodes)
    attrsProps.put("minNodes",minNodes)
    if (membershipPolicy == None):
        memPolicy = "node_nodegroup ="
        memPolicy = memPolicy +  "\'" + ngName +"\'"
        clusterProperties = Properties()
        clusterProperties.put("templateName","defaultXD")
        localCluster = AdminControl.invoke_jmx(ObjectName(mbean),"createDynamicCluster",
                            [clusterName,attrsProps,clusterProperties,memPolicy],
                            ["java.lang.String","java.util.Properties","java.util.Properties","java.lang.String"])
    else:
        localCluster = AdminTask.createDynamicCluster(clusterName,'[-membershipPolicy membershipPolicy  -dynamicClusterProperties [[numVerticalInstances numVer] [operationalMode defaultMode] [isolationGroup isolationGroup] [strictIsolationEnabled strictIsolationEnabled] [maxInstances maxInstances] [minInstances minInstances][maxNodes maxNodes] [minNodes minNodes]]' ) 
    #    membershipPolicy = ngpolicy1 + ngName + ngpolicy2

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
ngNameSpecified = 0
createNodeGroup = 0

if (len(sys.argv)>0):
   for arg in sys.argv:
       if (arg.startswith("-ngName:")):
           if (ngNameSpecified == 1):
               print "The node group name has already been specified by -ngName or -createNodeGroup.  Please only specify 1 node group."
               exit(1)
           parts = arg.split(":")
           ngName=parts[1]
           ngNameSpecified = 1
       elif (arg.startswith("-dcPrefix:")):
           parts = arg.split(":")
           dcName=parts[1]
           dcNameSpecified = 1
       elif (arg.startswith("-numClusters:")):
           parts = arg.split(":")
           noOfDCs=int(parts[1])
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
       elif (arg.startswith("-maxNodes:")):
           parts = arg.split(":")
           if (parts[1] != ""):
              try:
                maxNodes = int(parts[1])
              except ValueError:
                print "Maximum nodes must be a number"
                sys.exit(1)
       elif (arg.startswith("-createNodeGroup:")):
           if (ngNameSpecified == 1):
               print "The node group name has already been specified by -ngName or -createNodeGroup.  Please only specify 1 node group."
               exit(1)
           parts = arg.split(":")
           if (parts[1] != ""): 
              ngName=parts[1]
              ngNameSpecified = 1
              createNodeGroup = 1
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
           print "\t-dcPrefix:<dynamic cluster prefix>                   Prefix for the dynamic clusters to be created"
           print "\t-numClusters:<nunber of dynamic clusters>            Number of dynamic clusters to be created"
           print "\t-opMode:<operational mode>                           Operational mode for the dynamic cluster. Valid values are 'manual' , 'automatic'"
           print "\t-numVerticalInstances:<number of vertical instances> Number of vertical instances on each node"
           print "\t-strictIsolation:<true/false>                        Strict isolation"
           print "\t-isolationGroup:<isolation group>                    Isolation group"
           print "\t-maxInstances:<max instances>                        Maximum number of cluster instances"
           print "\t-minInstances:<min instances>                        Minimum number of cluster instances"
           print "\t-serverInactivityTime:<time in minutes>              Server inactivity is the time in minutes to wait for activity to occur before stopping instance"
           print "\t-createNodeGroup:<node group name>                   Create a new node group with the specified name (cannot be used with -ngName)"
           print "\t-maxNodes:<maximum number of nodes>                  Maximum number of nodes that this dynamic cluster can contain"
           sys.exit(1)

if (ngNameSpecified == 0 or dcNameSpecified == 0):
   print "-dcPrefix:<dynamic cluster prefix> and (-ngName:<node group name> or -createNodeGroup:<node group name>) options must be specified"
   sys.exit(1)
   
if (minInstances > maxInstances and maxInstancesSpecified == 1):
   print "Minimum instances must be less than or equal to maximum instances"
   sys.exit(1)

if (minInstances == 0):
   print "Number of minimum instances is specified as 0. This will enable lazy start feature for the dynamic cluster."

if (isolationGroupSpecified == 1 and strictIsolationSpecified == 1):
   print "Both -isolationGroup and -strictIsolation cannot be specify. Please specify either -isolationGroup or -strictIsolation"
   sys.exit(1)

if (createNodeGroup == 1):
   createNG()
   print "Saving node group"
   AdminConfig.save()
   syncAndSaveNodes()

for i in range(noOfDCs):
  createDynamicCluster(i)
  syncAndSaveNodes()
  localSuffix = "_" + str(i)
  localClusterName = dcName + localSuffix  
  modifyOperationalMode(localClusterName)
  
print "Saving workspace"
AdminConfig.save()
syncAndSaveNodes()
print "Done."

