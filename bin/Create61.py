import sys, java
from java.util import LinkedList
from java.util import HashMap
from java.io import File
from com.ibm.ws.legacycell.structures import *
from com.ibm.ws.legacycell.xmlutils import *
from com.ibm.ws.legacycell.jdk142 import *
from com.ibm.ws.legacycell.jdkcommon import *
from com.ibm.ws.legacycell import *
from com.ibm.ws.legacycell.exceptions import *
from com.ibm.ws.legacycell.security import *
from java.net import Inet4Address
from java.net import UnknownHostException
from java.util import Iterator
from java.lang import System

################## Fields #################################

# init
encrypt = "false"
save = "false"
lineSeparator = java.lang.System.getProperty('line.separator')
map = HashMap()
agentMap = HashMap()
installedApps = LinkedList()
clusters = LinkedList()
decryptor = DesEncryptor()
adminUser = sys.argv[0]
adminPass = sys.argv[1]
encrypt = sys.argv[2]
save = sys.argv[3]
if encrypt == "true":
    adminUser = decryptor.decodeString(adminUser)
    adminPass = decryptor.decodeString(adminPass)

# Needed in some instances where security values were added
# as empty strings - arg parser doesn't treat the empties as
# an arg, so specific placing gets thrown off
# (Shouldn't be needed with new Code) - will remove after verification
workDir = sys.argv[len(sys.argv) - 1]


############# List(Node) Population ########################

#DESC : Finds all nodes that are XDAgents
def populateXDNodes():
   nodes = AdminConfig.list("Node").split(lineSeparator)
   for node in nodes:
     nName = AdminConfig.showAttribute(node, 'name')
     hostName = AdminConfig.showAttribute(node, 'hostName')
     servers = AdminConfig.list("Server", node).split(lineSeparator)
     for server in servers:
        sName = AdminConfig.showAttribute(server, 'name')
        if sName == 'middlewareagent':
           agentMap.put(hostName, nName)
           print "Detected middleware agent node - " + nName + " with hostname of " + hostName
   print ""

############## Check for IP to Host Name conversion ########

def resolveHostForIP(host):
   
   hostName = "NONE"
   # Correction for if the entry in the server.xml is an IP address
   try:
      hName = Inet4Address.getByName(host)
      hostName = hName.getHostName()
      print "  Resolved Host " + host + " to " + hostName
      if hostName != host:
         return hostName
   except UnknownHostException, e:
      print "  Couldn't resolve " + host + " to a host name"

   # Correction for if the entries in the list are IP addresses
   iterator = agentMap.keySet().iterator()
   while iterator.hasNext():
      try:
         agentHost = iterator.next()
         hName = Inet4Address.getByName(agentHost)
         hName = hName.getHostName()
         if checkForSimilarity(host, hName):
            print "  Detected match for IP of " + host + " and MiddleWare Agent " + agentHost
            return agentHost
      except UnknownHostException, e:
         print "   Error resolving Host - UnkownHostException"
   return host

############# Check for Similarity Logic ##################

def checkForSimilarity(hostOne, hostTwo):
   partsOne = hostOne.split('.')
   partsTwo = hostTwo.split('.')  
   if (hostOne == hostTwo):
      return 1
   if (hostOne == partsTwo[0]):
      return 1
   if (partsOne[0] == hostTwo):
      return 1
   if (partsOne[0] == partsTwo[0]):
      return 1
   return 0

############# Check for Node short-name ###################

# Returns original input if no mapping is found

def checkForShortName(host):
   hostName = host
   shortName = "NOTFOUND"
   iterator = agentMap.keySet().iterator()
   while iterator.hasNext():
      agentHost = iterator.next()
      parts = agentHost.split('.')
      short = parts[0]
      if short == host:
         #print "  Mapped short-name Host " + host + " to MiddleWare Agent on " + agentHost
         return agentHost
   
   # Correction for if the entry in server.xml was a short name
   parts = host.split('.')
   short = parts[0]
   iterator = agentMap.keySet().iterator()
   while iterator.hasNext():
      agentHost = iterator.next()
      if short == agentHost:
         print "  Mapped host " + host + " to MiddleWare Agent on " + agentHost
         # Add to list for performance in future?
         return short
   #print "  No [Short-Name <-> Fully-Qualified-Name] mapping detected"
   return host

############# Resolve Host Logic ##########################

def resolveHost(host):

# I've noticed that sometimes a node gets it's host set to the short
# name version, but the xdagent will use the fully-qualified name, so we
# need to handle this case

# I have also added support for the raw IP form

   # Try to check if we don't need IP-to-host resolution first
   # No point in going to DNS if we don't have to
   hostName = checkForShortName(host)
   if hostName != host:
      return hostName

   # Must have been either invalid address or IP form
   hostName = resolveHostForIP(host)
   
   # Need to possibly do a check for short-name <-> full name again
   if not agentMap.containsKey(hostName):
      hostName = checkForShortName(hostName)
   
   if hostName != host:
      return hostName
   
   return hostName


################### Check Node/Host Map Logic ############

# This is the entry point for finding a mapping between a 5.1
# node and the 6.1 agent node

def checkHostMapping(host, node):
   if agentMap.containsKey(host):
      agentNode = agentMap.get(host)
      map.put(node, agentNode)
      return 1
   else:
      print "MiddleWare Agent for Host " + host + " not found - attempting to resolve host"
      fullHost = resolveHost(host)
      if agentMap.containsKey(fullHost):
         agentNode = agentMap.get(fullHost)
         print "  Adding resolved mapping for future reference"
         agentMap.put(host, agentNode)
         map.put(node, agentNode)
         return 1
      else:
         print '  Error : Could not find ' + host + ' as a registered middleware agent'
         print "  Please make sure your middleware agent for machine " + host + " is federated"
         return 0
      



############# Create Server Logic ##########################

def createServer(server):
   host = server.getHost()
   name = server.getName()
   node = server.getNode()
   path = server.getInstall()
   http = server.getTransport("HTTP").getPort()
   https = server.getTransport("HTTPS").getPort()
   create = 0
   agentNode = ""
   
   found = checkHostMapping(host, node)
   if found:
      agentNode = map.get(node)
      print "Creating Server - WAS5x" + name + " on node - " + agentNode
      serv = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/')
      if serv == "":
         #AdminTask.createForeignServer(agentNode, '[-name WAS5x' + name + ' -templateName was5x ]')
         AdminTask.createExtWasAppServer(agentNode, '[-name WAS5x' + name + ' -templateName was5x ]')
         serv = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/')
         commands = AdminConfig.list('NamedProcessDef', serv).split(lineSeparator)
         for command in commands:
            AdminConfig.remove(command)
         startAtts = [["name", "start"], ["workingDirectory", ""], ['executableName', path + '/bin/startServer.sh'], ['executableArguments', name], ['osnames', 'unix'], ['pidVarName', 'NonWinAgentPIDVar']]
         stopAtts = [["name", "stop"], ["workingDirectory", ""], ['executableName', path + '/bin/stopServer.sh'], ['executableArguments', name], ['osnames', 'unix'], ['usernameVal', adminUser], ['passwordVal', adminPass]]
         AdminConfig.create('NamedProcessDef', serv, startAtts, 'processDefinitions')
         AdminConfig.create('NamedProcessDef', serv, stopAtts, 'processDefinitions')
         startAtts = [["name", "start"], ["workingDirectory", ""], ['executableName', path + '\bin\startServer.bat'], ['executableArguments', name], ['osnames', 'windows'], ['pidVarName', 'WINAgentPIDVar']]
         stopAtts = [["name", "stop"], ["workingDirectory", ""], ['executableName', path + '\bin\stopServer.bat'], ['executableArguments', name], ['osnames', 'windows'], ['usernameVal', adminUser], ['passwordVal', adminPass]]
         AdminConfig.create('NamedProcessDef', serv, startAtts, 'processDefinitions')
         AdminConfig.create('NamedProcessDef', serv, stopAtts, 'processDefinitions')
         vars = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/VariableMap:/')
         atts = [['symbolicName', 'WINAgentPIDVar'], ['value', path + '\logs\\' + name + '\\' + name + '.pid']]
         AdminConfig.create('VariableSubstitutionEntry', vars, atts)
         atts = [['symbolicName', 'NonWinAgentPIDVar'], ['value', path + '/logs/' + name + '/' + name + '.pid']]
         AdminConfig.create('VariableSubstitutionEntry', vars, atts)
         varList = AdminConfig.list('VariableSubstitutionEntry', vars).split(lineSeparator)
         for var in varList:
            varName = AdminConfig.showAttribute(var, 'symbolicName')
            if varName == "WAS51_HOME":
               AdminConfig.remove(var)
         atts = [['symbolicName', 'WAS51_HOME'], ['value', path]]
         AdminConfig.create('VariableSubstitutionEntry', vars, atts)
         httpPort = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/ForeignServer:/DescriptivePropertyGroup:/DescriptivePropertyGroup:endpoint/DescriptivePropertyGroup:transport.http/DiscoverableDescriptiveProperty:port/')
         AdminConfig.modify(httpPort, [['value', http]])

         httpEnabled = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/ForeignServer:/DescriptivePropertyGroup:/DescriptivePropertyGroup:endpoint/DescriptivePropertyGroup:transport.http/DiscoverableDescriptiveProperty:enabled/')
         AdminConfig.modify(httpEnabled, [['value', 'true']])

         httpsPort = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/ForeignServer:/DescriptivePropertyGroup:/DescriptivePropertyGroup:endpoint/DescriptivePropertyGroup:transport.https/DiscoverableDescriptiveProperty:port/')
         AdminConfig.modify(httpsPort, [['value', https]])

         httpsEnabled = AdminConfig.getid('/Node:' + agentNode + '/Server:WAS5x' + name + '/ForeignServer:/DescriptivePropertyGroup:/DescriptivePropertyGroup:endpoint/DescriptivePropertyGroup:transport.https/DiscoverableDescriptiveProperty:enabled/')
         AdminConfig.modify(httpsEnabled, [['value', 'true']])
      else:
         print "  Server already Exists"
         return 1
   return 0
         

############# Create Clustered Server Logic ################

def createDynamicCluster(name):
   print "createCluster"
   AdminTask.createDynamicCluster(name, '[-membershipPolicy "node_nodegroup = \'DefaultNodeGroup\'"]')

def createClusteredServer(cServer):
   host = cServer.getHost()
   name = cServer.getClusterName()
   server = cServer.getName()
   node = cServer.getNode()
   path = cServer.getInstall()
   uniqueId = cServer.getUniqueId()
   create = 0
   
   found = checkHostMapping(host, node)
   if found:
      agentNode = map.get(node)
      cluster = AdminConfig.getid('/DynamicCluster:' + name + '/')
      print "Creating Clustered Server - WAS5x" + server
      exists = createServer(cServer.getServer())
      if not exists:
         if cluster == "":
            print "Creating Dynamic Cluster - " + name + " and added Server - WAS5x" + server
            AdminTask.createDynamicClusterFromForeignServers(name, '[-foreignServers [[' + agentNode + ' WAS5x' + server + ']]]')
            clusterMember = AdminConfig.getid('/ClusterMember:WAS5x' + server + '/')
            AdminConfig.modify(clusterMember, [['uniqueId', uniqueId]])
            return ""
         clusters.add(name)
         print "Added Server - WAS5x" + server + " to Dynamic Cluster - " + name
         AdminTask.addForeignServersToDynamicCluster(name, '[-foreignServers [[' + agentNode + ' WAS5x' + server + ']]]')
         clusterMember = AdminConfig.getid('/ClusterMember:WAS5x' + server + '/')
         AdminConfig.modify(clusterMember, [['uniqueId', uniqueId]])
      else:
         print "  Detected that specified server already exists"


############# Register Application Logic ##################

def registerApplication(app):

   print "Registering Application - " + app.toString()
   #-clusterTargets [[ clusterName1 ][ clusterName2 ]]
   #-serverTargets [[node server]]

   clusterString = ' -clusterTargets ['
   serverString = ' -serverTargets ['

   sTargets = app.getServerTargets()
   cTargets = app.getClusterTargets()
   install = 1
   server = 0
   clusterUsed = 0
   name = app.getName()
   exists = AdminConfig.getid('/MiddlewareApp:' + name + '/')

   # Check if object isn't already present
   if exists == "":
      index = 0
      # Process server targets
      while index < sTargets.size():
         target = sTargets.get(index)
         node = target.getNode()
         # Make sure knowledge of 5.1 node and mapping was already recorded
         if (map.containsKey(node)):
            xdagentNode = map.get(node)
            server = target.getName()
            serverString = serverString + '[ ' + xdagentNode + ' WAS5x' + server + ']'
            server = 1
         else:
            print "We could not find a node mapping for Node - " + node
            print " This is most likely because a server creation for that node failed"
            print " Make sure you have the middleware agent from that machine federated"
            install = 0
         index += 1

      index = 0
      # Process cluster targets
      while index < cTargets.size():
         target = cTargets.get(index)
         cluster = target.getClusterName()
         if clusters.contains(cluster):
            clusterUsed = 1
            clusterString = clusterString + '[' + cluster + ']'
         else:
            print "We could not find a record of cluster " + cluster + " being created"         
            print " This is most likely because the cluster creation failed above"
            print " Make sure the middleware agents of your cluster's machines are federated"
            install = 0
         index += 1

      # Cap target strings
      clusterString = clusterString + ']'
      serverString = serverString + ']'
   
      # Go through only if all targets are accounted for
      if install:
         installedApps.add(name)
         if server and not clusterUsed:
            AdminTask.registerApp('[-app ' + name + ' -edition v1 ' + serverString + ']')
         if not server and clusterUsed:
            AdminTask.registerApp('[-app ' + name + ' -edition v1 ' + clusterString + ']')
         if server and clusterUsed:
            AdminTask.registerApp('[-app ' + name + ' -edition v1 ' + clusterString + ' ' + serverString + ']')
      else:
         print " Error detected above for application " + name + ".  Aborting registration"
   else:
      print "  This Application is already installed"

############# Map Web Module Logic ########################


def mapModule(mod):
   
   print "Currently Mapping - " + mod.toString()
   app = mod.getAppName()
   uri = mod.getUri()
   context = mod.getContext()
   cTargets = mod.getClusteredTargets()
   sTargets = mod.getServerTargets()
   cluster = ""
   server = ""
   node = ""
   exists = AdminConfig.getid('/MiddlewareWebModule:' + uri + '/')

   # Make sure module isn't already registered
   if exists == "":
       
      # Make sure parent app was installed successfully
      # I wonder about modules registered stand-alone
      # This check might need to be modified to handle that
      if installedApps.contains(app):
         # Check for target presence
         # Could probably contain isClustered() on data model to simplify
         if (cTargets.size() >= 1):
            target = cTargets.get(0)
            cluster = target.getClusterName()
         if (sTargets.size() >= 1):
            target = sTargets.get(0)
            server = target.getName()
            node = target.getNode()
   
         if (cluster != "" and server != ""):

             AdminTask.addMiddlewareAppWebModule('[-app ' + app + ' -edition v1 -moduleName ' + uri + ' -cluster ' + cluster + '-node ' + node  + ' -server WAS5x' + server + '  -virtualHost default_host -contextRoot ' + context + ']')

         if (cluster != "" and server == ""):

            AdminTask.addMiddlewareAppWebModule('[-app ' + app + ' -edition v1 -moduleName ' + uri + ' -cluster ' + cluster + ' -virtualHost default_host -contextRoot ' + context + ']')

         if (cluster == "" and server != ""):

            AdminTask.addMiddlewareAppWebModule('[-app ' + app + ' -edition v1 -moduleName ' + uri + ' -node ' + node  + ' -server WAS5x' + server + ' -virtualHost default_host -contextRoot ' + context + ']')
         #
         # Setup necessary work classes
         #try:
         #   appName = app
         #   app = AdminConfig.getid("/MiddlewareApp:" + appName + "/")
         #   wcs = AdminConfig.list("WorkClass", app).split(lineSeparator)
         #   for wc in wcs:
         #      AdminConfig.remove(wc)
         #   wclassAttributes = [["matchAction","permit:"+appName+"-edition v1"],["name","Default_HTTP_WC"],["type","HTTPWORKCLASS"],["description","This is the default workclass."]]
         #   workclass = AdminConfig.create("WorkClass",app,wclassAttributes)
         #   
         #   wcModuleAttributes = [["moduleName", uri],["matchExpression","*"],["id","Default_HTTP_WC:!:"+appName+":!:" + uri]]
         #   wcModule = AdminConfig.create("WorkClassModule",workclass,wcModuleAttributes)
         #except Exception, e:
         #   print e
      else:
         print "Could not find a record of application " + app + " being installed"
         print " Aborting module registration for " + uri
   else:
      print "  App is already installed and module is already mapped"


################# Cleanup Logic ##############################

def deleteServer(server):
   name = server.getName()
   node = server.getNode()
   # We should have a 5.1 <--> 6.1 Agent node mapping at this point
   if map.containsKey(node):
      node = map.get(node)
      # User might have deleted via external source (i.e. UI) so check for presence first
      exists = AdminConfig.getid('/Node:' + node + '/Server:WAS5x' + name + '/')
      if exists != "":
         print "Cleaning up Server - WAS5x" + name
         AdminTask.deleteServer('[-serverName WAS5x' + name + ' -nodeName ' + node + ']')
      print node

def deleteApplication(app):
   name = app.getName()
   # User might have deleted via external source so check for presence first
   exists = AdminConfig.getid('/MiddlewareApp:' + name + '/')
   if exists != "":
      print "Cleaning up Application - " + name
      AdminTask.unregisterApp('[-app ' + name + ' -edition v1 ]')

def deleteClusteredServer(server):
   clusterName = server.getClusterName()
   name = server.getName()
   node = server.getNode()
   if map.containsKey(node):
      node = map.get(node)
      # User might have deleted via external source so check for presence first
      exists = AdminConfig.getid('/Node:' + node + '/Server:WAS5x' + name + '/')
      if exists != "":
         print "Removed Server - WAS5x" + name + " from Cluster " + clusterName
         AdminTask.removeForeignServersFromDynamicCluster(clusterName, '[-foreignServers [[' + node + ' WAS5x' + name+ ']]]')
         deleteServer(server.getServer())
   dc = AdminConfig.getid('/DynamicCluster:' + clusterName + '/')
   list = AdminConfig.list('ClusterMember', dc)
   if list == "":
      print "Cleaning up Dynamic Cluster - " + clusterName
      AdminTask.deleteDynamicCluster(clusterName)

################### Core Logic/Main #######################


populateXDNodes()

try :
   factory = XMLUtilFactory.instance()
   parser = factory.get142DomParser()
   parser.parseConfiguration(File(workDir + '/servers.xml'))
   additions = parser.getAdditionEntries()
   deletions = parser.getDeletionEntries()
except ParsingException, e:
   print "\nError Parsing XML Data - " + e.getCause().toString()
   print "Exiting due to Critical Error"
   System.exit(1)
#------------------------------------------------------

print "\nCreating Servers"
print "-------------------------------------------------"

# Should change while loops to 'for i in range(list.size)'

index = 0;
servers = additions.getForeignServers()
while index < servers.size():
   createServer(servers.get(index))
   index += 1


print "\nCreating Clusters"
print "-------------------------------------------------"

index = 0;
cServers = additions.getClusteredForeignServers()
while index < cServers.size():
   createClusteredServer(cServers.get(index))
   index += 1

print "\nRegistering Applications"
print "-------------------------------------------------"

index = 0;
apps = additions.getApplications()
while index < apps.size():
   registerApplication(apps.get(index))
   index += 1

print "\nMapping Modules"
print "-------------------------------------------------"

index = 0;
mods = additions.getModuleMappings()
while index < mods.size():
   mapModule(mods.get(index))
   index += 1


# Call for cleanup if needed

# I was going to originally add isDeletion() logic to the model.  I
# could have then moved the call points to a handle<Object>() method
# which would replace the create<Object>() method and would be responsible
# for both additions and deletions.
#
# I seperated out the entries and call points, however, for end-user
# readability and configuration.

print "\nCleaning up unecessary configurations"
print "-------------------------------------------------"

index = 0;
servers = deletions.getForeignServers()
while index < servers.size():
   deleteServer(servers.get(index))
   index += 1

index = 0;
apps = deletions.getApplications()
while index < apps.size():
   deleteApplication(apps.get(index))
   index += 1

index = 0;
clusters = deletions.getClusteredForeignServers()
while index < clusters.size():
   deleteClusteredServer(clusters.get(index))
   index += 1

if save == "true":
   AdminConfig.save()
else:
   print "Trial Mode Enabled - No Changes Were Persisted"



