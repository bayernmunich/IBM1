import javax.management.ObjectName as ObjectName
import java.util.Properties as Properties

#
# Script to manage an ODR or a cluster of ODRs
#

#
# Convert an ODR to an ODR cluster
#
def convertToCluster(odrNodeName,odrServerName,clusterName):
  AdminTask.createCluster(["-clusterConfig", ["-clusterName", clusterName, "-clusterType", "ONDEMAND_ROUTER"], "-convertServer", ["-serverNode", odrNodeName, "-serverName", odrServerName]])
  AdminConfig.save()
  print "Converted ODR '"+odrServerName+"' on node '"+odrNodeName+"' to cluster '"+clusterName+"'"

#
# Create an ODR cluster named 'clusterName' on node group 'nodeGroupName'
#
def createDynamicCluster(clusterName,nodeGroupName):
  mbean = AdminControl.queryNames("WebSphere:*,process=dmgr,type=DynamicClusterConfigManager")
  dynamicClusterProps = Properties()
  #dynamicClusterProps.put("numVerticalInstances",numVerticalInstance)
  #dynamicClusterProps.put("operationalMode",defaultMode)
  #dynamicClusterProps.put("isolationGroup",isolationGroup)
  #dynamicClusterProps.put("strictIsolationEnabled",strictIsolationEnabled)
  #dynamicClusterProps.put("maxInstances",maxInstances)
  #dynamicClusterProps.put("minInstances",minInstances)
  #dynamicClusterProps.put("maxNodes",maxNodes)
  #dynamicClusterProps.put("minNodes",minNodes)
  clusterProps = Properties()
  #clusterProps.put("templateName","defaultXD")

  AdminControl.invoke_jmx(ObjectName(mbean),"createODRDynamicCluster",
                             [nodeGroupName,clusterName,dynamicClusterProps,clusterProps],
                             ["java.lang.String","java.lang.String","java.util.Properties","java.util.Properties"])
  AdminConfig.save()
  print "Created ODR dynamic cluster '"+clusterName+"' on nodes in node group '"+nodeGroupName+"'"

#
# Create and add a new ODR to an existing ODR cluster
#
def addToCluster(odrNodeName,odrServerName,clusterName):
  AdminTask.createClusterMember(["-clusterName", clusterName, "-memberConfig", ["-memberNode", odrNodeName, "-memberName", odrServerName]])
  AdminConfig.save()
  print "Added ODR '"+odrServerName+"' on node '"+odrNodeName+"' to cluster '"+clusterName+"'"

#
# Insert a multi-cluster routing rule
#
def insertMultiClusterRoutingRule(odrServerOrCluster,protocol,ruleNumber,condition,multiClusterAction,multiClusterSpecification):
  odrSpec = processOdrPathWithClusterOption(odrServerOrCluster)
  AdminTask.addRoutingRule(odrSpec + [ "-protocol", protocol, "-priority", ruleNumber, "-expression", condition, "-actionType", "permit", "-multiclusterAction", multiClusterAction, "-routingLocations", multiClusterSpecification])
  AdminConfig.save()
  print "Inserted multi-cluster routing rule #"+str(ruleNumber)

#
# Insert a redirect routing rule
#
def insertRedirectRoutingRule(odrServerOrCluster,ruleNumber,condition,redirectURL):
  odrSpec = processOdrPathWithClusterOption(odrServerOrCluster)
  AdminTask.addRoutingRule(odrSpec + [ "-protocol", "HTTP", "-priority", ruleNumber, "-expression", condition, "-actionType", "redirect", "-redirectURL", redirectURL])
  AdminConfig.save()
  print "Inserted redirect routing rule #"+str(ruleNumber)

#
# Insert a reject routing rule
#
def insertRejectRoutingRule(odrServerOrCluster,protocol,ruleNumber,condition,errorCode):
  odrSpec = processOdrPathWithClusterOption(odrServerOrCluster)
  AdminTask.addRoutingRule(odrSpec + [ "-protocol", protocol, "-priority", ruleNumber, "-expression", condition, "-actionType", "reject", "-errorcode", errorCode])
  AdminConfig.save()
  print "Inserted reject routing rule #"+str(ruleNumber)

#
# Insert a routing rule for serving HTML from the ODR's hard drive (not from the cache)
#
def insertLocalContentRoutingRule(odrServerOrCluster,ruleNumber,condition,localPath):
  odrSpec = processOdrPathWithClusterOption(odrServerOrCluster)
  AdminTask.addRoutingRule(odrSpec + [ "-protocol", "HTTP", "-priority", ruleNumber, "-expression", condition, "-actionType", "localResource", "-localResourcePath", localPath])
  AdminConfig.save()
  print "Inserted routing rule #"+str(ruleNumber)

#
# Remove a routing rule
#
def removeRoutingRule(odrServerOrCluster,protocol,ruleNumber):
  odrSpec = processOdrPathWithClusterOption(odrServerOrCluster)
  AdminTask.removeRoutingRule(odrSpec + ["-protocol", protocol, "-priority", ruleNumber])
  AdminConfig.save()
  print "Removed routing rule #"+str(ruleNumber)

#
# List the routing rules
#
def listRoutingRules(odrServerOrCluster,protocol):
  odrSpec = processOdrPathWithClusterOption(odrServerOrCluster)
  Rules=AdminTask.listRoutingRules(odrSpec + [ "-protocol", protocol])
  print Rules

#
# Insert a rule into a rule set at a particular ruleNumber
#
def insertCustomLogRule(odrServerOrCluster,ruleSetName,ruleNumber,condition,value):
  ruleSet=getRuleSet(getOdrConfigId(odrServerOrCluster),ruleSetName)
  ruleList=getRuleList(ruleSet)
  ruleNumber=min(ruleNumber,len(ruleList)+1)
  exprList=[]
  valueList=[]
  for rule in ruleList:
    expr=AdminConfig.showAttribute(rule,"expression")
    actionList=AdminConfig.showAttribute(rule,"actions").replace("[","").replace("]","").split(" ")
    for action in actionList:
       val=AdminConfig.showAttribute(action,"value")
    exprList.append(expr)
    valueList.append(val)
    AdminConfig.remove(rule)
  insertIndex = ruleNumber - 1
  for index in range(0,min(insertIndex,len(ruleList))):
    createRule(odrServerOrCluster,ruleSet,ruleSetName,index+1,exprList[index],valueList[index])
  createRule(odrServerOrCluster,ruleSet,ruleSetName,ruleNumber,condition,value)
  for index in range(insertIndex,len(ruleList)):
    createRule(odrServerOrCluster,ruleSet,ruleSetName,index+2,exprList[index],valueList[index])
  AdminConfig.save()
  print "Inserted '"+str(ruleSetName)+" rule #"+str(ruleNumber)

def createRule(odrServerOrCluster,ruleSet,type,ruleNum,condition,value):
   rule=AdminConfig.create("Rule",ruleSet,[["name",ruleNum],["priority",ruleNum],["expression",condition]])
   eles=odrServerOrCluster.split(":")
   if (len(eles) == 1):
     AdminTask.addActionToRule(["-clustername", odrServerOrCluster, "-rulesetName", type, "-ruleName", ruleNum,"-actionName", ruleNum, "-actionType", type, "-actionValue", value])
   else:
     AdminTask.addActionToRule(["-odrname", eles[1], "-nodename", eles[0], "-rulesetName", type, "-ruleName", ruleNum,"-actionName", ruleNum, "-actionType", type, "-actionValue", value])
  
#
# Remove rule number 'ruleNumber' from the rule set
#
def removeCustomLogRule(odrServerOrCluster,ruleSetName,ruleNumber):
  ruleSet=getRuleSet(getOdrConfigId(odrServerOrCluster),ruleSetName)
  ruleList=getRuleList(ruleSet)
  rule=getRule(ruleSet,ruleNumber)
  if (rule == ""):
    fatal("rule #"+str(ruleNumber)+" was not found")
  AdminConfig.remove(rule)
  exprList=[]
  valueList=[]
  for index in range(ruleNumber,len(ruleList)):
    rule=ruleList[index]
    expr=AdminConfig.showAttribute(rule,"expression")
    actionList=AdminConfig.showAttribute(rule,"actions").replace("[","").replace("]","").split(" ")
    for action in actionList:
       value=AdminConfig.showAttribute(action,"value")
    exprList.append(expr)
    valueList.append(value)
    AdminConfig.remove(rule)
  for index in range(ruleNumber,len(ruleList)):
    createRule(odrServerOrCluster,ruleSet,ruleSetName,index,exprList[index-ruleNumber],valueList[index-ruleNumber])
  AdminConfig.save()
  print "Removed "+str(ruleSetName)+" rule #"+str(ruleNumber)

#
# Get a list of rules.  Remove empty rules.
#
def getRuleList(ruleSet):
  ruleList=AdminConfig.showAttribute(ruleSet,"rules").replace("[","").replace("]","").split(" ")
  for rule in ruleList:
    if (rule == ""):
      ruleList.remove(rule)
  return ruleList

#
# List the rules in a particular rule set
#
def listCustomLogRules(odrServerOrCluster,ruleSetName):
  ruleSet=getRuleSet(getOdrConfigId(odrServerOrCluster),ruleSetName)
  ruleList=getRuleList(ruleSet)
  for rule in ruleList:
    priority=AdminConfig.showAttribute(rule,"priority")
    condition=AdminConfig.showAttribute(rule,"expression")
    value="None"
    actionList=AdminConfig.showAttribute(rule,"actions").replace("[","").replace("]","").split(" ")
    for action in actionList:
       value=AdminConfig.showAttribute(action,"value")
    print priority+": condition='"+condition+"' value='"+value+"'"

#
# Get a rule from a rule set
#
def getRule(ruleSet,ruleNumber):
  ruleList=AdminConfig.showAttribute(ruleSet,"rules").replace("[","").replace("]","").split(" ")
  for rule in ruleList:
    priority=AdminConfig.showAttribute(rule,"priority")
    if (priority == str(ruleNumber)):
       return rule
  return ""

#
# Get a rule set
#
def getRuleSet(odrConfigId,ruleSetName,createIfNoExist=1):
  ruleSet=AdminConfig.getid(odrConfigId+"Ruleset:"+ruleSetName+"/")
  if (ruleSet == ""):
    if createIfNoExist != 0:
      odrConfig=AdminConfig.getid(odrConfigId)
      ruleSet=AdminConfig.create("Ruleset", odrConfig, [["name", ruleSetName], ["type", "HTTP"], ["defaultContinue", "true"]])
    else:
      usage("rule set '"+ruleSetName+"' does not exist")
  return ruleSet

#
# Get the ODR config ID for an ODR or ODR cluster
#
def getOdrConfigId(odrServerOrCluster):
  eles=odrServerOrCluster.split(":")
  if (len(eles) == 1):
     id="/ServerCluster:"+odrServerOrCluster+"/"
     cfg=AdminConfig.getid(id)
     if (cfg == ""):
        usage("'"+odrServerOrCluster+"' is not an existing cluster")
     return id
  elif (len(eles) == 2):
     id="/Node:"+eles[0]+"/Server:"+eles[1]+"/"
     cfg=AdminConfig.getid(id)
     if (cfg == ""):
        usage("'"+odrServerOrCluster+"' is not an existing ODR")
     return id
  else:
     usage("'"+odrServerOrCluster+"' is neither '<node>:<server>' nor '<cluster>' format");

#
# Set the 'odrNodeName' and 'odrServerName' globals given an ODR path
#
def processOdrPath():
  global odrNodeName, odrServerName
  odrPath=getOdrPath()
  eles=odrPath.split(":")
  if (len(eles) != 2):
    usage("'"+odrPath+"' is not of format <node:odr>")
  odrNodeName = eles[0]
  odrServerName = eles[1]

#
# Return the arguments needed to specify the ODR or ODR cluster to act on
#
def processOdrPathWithClusterOption(odrServerOrCluster):
  eles=odrServerOrCluster.split(":")
  if (len(eles) == 1):
     return ["-clustername ", odrServerOrCluster ] 
  elif (len(eles) == 2):
      return ["-nodename", eles[0], "-odrname", eles[1] ] 
  else:
     usage("'"+odrServerOrCluster+"' is neither '<node>:<server>' nor '<cluster>' format");


#
# A fatal error occurred
#
def fatal(msg): 
  print msg   
  sys.exit(1)

#
# Print a usage message
#
def usage(msg): 
  print "ERROR: "+msg+"""
  Supported commands:
    convertToCluster <node:odr> <cluster>
       Convert an existing ODR on node 'node' with name 'odr' to an ODR cluster named <cluster>
    createDynamicCluster <cluster> <nodeGroup>
       Create an ODR dynamic cluster named '<cluster>' on nodes in node group '<nodeGroup>'
    addToCluster <node:odr> <cluster>
       Create a new ODR on node 'node' with name 'odr' and add it to ODR cluster 'cluster'
    insertMultiClusterRoutingRule <odrServerOrCluster> <protocolFamily> <ruleNumber> <condition> <multiClusterAction> <multiClusterSpecification>
       Insert a multi-cluster routing rule
    insertRedirectRoutingRule <odrServerOrCluster> <ruleNumber> <condition> <redirectURL>
       Insert a redirect routing rule
    insertRejectRoutingRule <odrServerOrCluster> <protocolFamily> <ruleNumber> <condition> <errorCode>
       Insert a reject routing rule to return a specific error status code
    insertLocalContentRoutingRule <odrServerOrCluster> <ruleNumber> <condition> <localPath>
       Convenience method to insert an ODR routing rule specifically for serving local static HTML from the ODR's file system
    removeRoutingRule <odrServerOrCluster> <protocolFamily> <ruleNumber>
       Remove the ODR routing rule specified by the protocol family and rule number
    listRoutingRules <odrServerOrCluster> <protocolFamily>
       List the ODR routing rules for the specified protocol family
    insertCustomLogRule <odrServerOrCluster> <ruleNumber> <condition> <logFileFormat>
       Insert a custom log rule into the list at position <ruleNumber>.
    removeCustomLogRule <odrServerOrCluster> <ruleNumber>
       Remove the custom log rule number <ruleNumber>.
    listCustomLogRules <odrServerOrCluster>
       List the custom log rules associated with an ODR or ODR cluster
  where arguments are:
    <node:odr> is the name of the node and ODR (e.g. 'mynode:myodr')
    <cluster> is the name of a cluster
    <odrServerOrCluster> is either <node:odr> or <cluster>
    <protocolFamily> is either "HTTP" or "SIP"
    <ruleNumber> is the number of the rule, from 1 to the total number of rules
    <condition> is the condition (i.e. boolean expression) which must evaluate
        to true in order to trigger the associated custom logging
    <multiClusterAction> is one of "Failover",
        "WLOR" (Weighted Least Outstanding Requests), or "WRR" (Weighted Round Robin)
    <multiClusterSpecification> is a specification of multiple clusters in one of the following formats:
       1) cluster=<cellName>/<clusterName>
            to specify a specific cluster
       2) server=<cellName>/<nodeName>/<serverName>
            to specify a specific server
       3) module=<cellName>/<applicationName>/<editionName>/<moduleName>
            to specify all servers to which this module is deployed
    <redirectURL> is the URL to redirect the request to
    <errorCode> is the error return code to return for a reject routing rule
    <logFileFormat> is specification denoting the file name and format of the log entry
    <localPath> is the directory from which to serve local static content
  """
  sys.exit(1)

#
# Get argument number 'count'; print a usage message if it doesn't exist.
#
def getarg(count,argName):
  if(len(sys.argv) <= count):
    usage("too few arguments; missing "+argName)
  return sys.argv[count].rstrip()

def getOdrPath():
  return getarg(1,"<odrServerOrCluster>")

#========================================================================================
#
# Begin main
#
#========================================================================================

global LOG
LOG="log"

command = getarg(0,"command name")
if (command == 'convertToCluster'):
  processOdrPath()
  convertToCluster(odrNodeName,odrServerName,getarg(2,"<cluster>"))
elif (command == 'createDynamicCluster'):
  createDynamicCluster(getarg(1,"<cluster>"),getarg(2,"<nodeGroup>"))
elif (command == 'addToCluster'):
  processOdrPath()
  addToCluster(odrNodeName,odrServerName,getarg(2,"<cluster>"))
elif (command == 'insertMultiClusterRoutingRule'):
  insertMultiClusterRoutingRule(getarg(1,"<odrServerOrCluster>"),getarg(2,"<protocolFamily>"),getarg(3,"<ruleNumber>"),getarg(4,"<condition>"),getarg(5,"<multiClusterAction>"),getarg(6,"<multiClusterSpecification>"))
elif (command == 'insertRedirectRoutingRule'):
  insertRedirectRoutingRule(getarg(1,"<odrServerOrCluster>"),getarg(2,"<ruleNumber>"),getarg(3,"<condition>"),getarg(4,"<redirectURL>"))
elif (command == 'insertRejectRoutingRule'):
  insertRejectRoutingRule(getarg(1,"<odrServerOrCluster>"),getarg(2,"<protocolFamily>"),getarg(3,"<ruleNumber>"),getarg(4,"<condition>"),getarg(5,"<errorCode>"))
elif (command == 'insertLocalContentRoutingRule'):
  insertLocalContentRoutingRule(getarg(1,"<odrServerOrCluster>"),getarg(2,"<ruleNumber>"),getarg(3,"<condition>"),getarg(4,"<localPath>"))
elif (command == 'removeRoutingRule'):
  removeRoutingRule(getarg(1,"<odrServerOrCluster>"),getarg(2,"<protocolFamily>"),int(getarg(3,"<ruleNumber>")))
elif (command == 'listRoutingRules'):
  listRoutingRules(getarg(1,"<odrServerOrCluster>"),getarg(2,"<protocolFamily>"))
elif (command == 'insertCustomLogRule'):
  insertCustomLogRule(getOdrPath(),LOG,int(getarg(2,"<ruleNumber>")),getarg(3,"<condition>"),getarg(4,"<logFileFormat>"))
elif (command == 'removeCustomLogRule'):
  removeCustomLogRule(getOdrPath(),LOG,int(getarg(2,"<ruleNumber>")))
elif (command == 'listCustomLogRules'):
  listCustomLogRules(getOdrPath(),LOG)
else:
  usage("'"+command+"' is an unknown command")
