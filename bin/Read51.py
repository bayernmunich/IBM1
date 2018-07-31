import sys, java
import java.lang.Throwable as JavaThrowable
from java.util import HashMap
from java.util import LinkedList
from java.io import File
from com.ibm.ws.legacycell.structures import *
from com.ibm.ws.legacycell.xmlutils import *
from com.ibm.ws.legacycell.jdk142 import *
from com.ibm.ws.legacycell.jdkcommon import *
from com.ibm.ws.legacycell import *
from com.ibm.ws.legacycell.exceptions import *
from java.lang import System

# init
lineSeperator = java.lang.System.getProperty('line.separator')
last = len(sys.argv)
workDir = sys.argv[last - 1]
mappingData = workDir + "/bin/Mappings.dat"
cMap = HashMap()
factory = XMLUtilFactory.instance()
writer = factory.get142DomWriter()
ignore = LinkedList()
tList = LinkedList()
parser = RuleParser()

############# Map(Context) Population #############################

#DESC : Populate Context mapping
def populateContext():
   f = open(mappingData, "r")
   lines = f.readlines()
   for line in lines:
      words = line.split('*')
      if len(words) == 0:
         continue
      app = words[0]
      context = words[1]
      cMap.put(app, context)

############ Init/Reset Ignore List ####################################

def initIgnoreList():
   ignore.add("jmsserver")
   ignore.add("nodeagent")
   ignore.add("dmgr")
   ignore.add("filetransfer")
   ignore.add("adminconsole")
   ignore.add("dmgr")


############ Main #################################################

rules = parser.parse(workDir + "/bin/Rules.xml")
populateContext()
initIgnoreList()
print ""
print "------------------------------------------------------------"
print "Starting to read WAS 5.1 Information"
print ""


# Discover & record server/cluster configurations

cells = AdminConfig.list("Cell").split(lineSeperator)
print "Scanning Cells"
for cell in cells:
  cellName = AdminConfig.showAttribute(cell, 'name')
  nodes = AdminConfig.list("Node").split(lineSeperator)
  print "Scanning Nodes for cell - " + cellName + "..."
  if len(nodes) == 0:
     continue
  for node in nodes:
     name = AdminConfig.showAttribute(node, 'name')
     index = AdminConfig.getid('/Node:' + name + '/ServerIndex:/')
     host = AdminConfig.showAttribute(index, 'hostName')
     map = AdminConfig.getid('/Node:' + name +'/VariableMap:/')
     vsList = AdminConfig.list('VariableSubstitutionEntry', map).split(lineSeperator)
     for vse in vsList:
        id = AdminConfig.showAttribute(vse, 'symbolicName')
        if id == 'WAS_INSTALL_ROOT':
           install = AdminConfig.showAttribute(vse, 'value')
     servers = AdminConfig.list("Server", node).split(lineSeperator)
     print "Scanning Servers on node - " + name + "..."
     if len(servers) == 0:
        continue
     for server in servers:
        exclude = rules.getExclusionRulesForType("Cluster")
        sName = AdminConfig.showAttribute(server, "name")
        clusterName = AdminConfig.showAttribute(server, 'clusterName')
        cName = str(clusterName)
        httpTransports = AdminConfig.list("HTTPTransport", server)
        if len(httpTransports) == 0:
           continue
        httpList = httpTransports.split(lineSeparator)
        serv = ForeignServer(sName, name, install, host)
        rule = ExclusionRule('Cluster', 'name', cName)
        for http in httpList:
           ssl = AdminConfig.showAttribute(http, "sslEnabled")
           if ssl == "true":
              id = 'HTTPS'
           else:
              id = 'HTTP'
           address = AdminConfig.showAttribute(http, "address")
           httpHost = AdminConfig.showAttribute(address, "host")
           port = AdminConfig.showAttribute(address, "port")
           transport = TransportDefinition(id, httpHost, port)
           serv.addTransportDefinition(transport)
        if cName != 'None' and not exclude.contains(rule):
           cServer = ClusteredForeignServer(cName, "123456789", serv)
           if not ignore.contains(cName):
              writer.addClusteredServerEntry(cServer, 0)
           continue
        # ignore check should be placed at beginning for efficiency
        if not ignore.contains(sName):
           writer.addServerEntry(serv, 0)


# Discover & record installed applications

apps = AdminApp.list().split(lineSeperator)

module = "MODULE"
exclude = rules.getExclusionRulesForType("Application")
for app in apps:
   clusterTargets = LinkedList()
   serverTargets = LinkedList()
   sServers = ""
   context = cMap.get(app)
   if context != "None":
       dep = AdminConfig.getid('/Deployment:' + app + '/')
       server = AdminConfig.getid('/Deployment:' + app + '/ServerTarget:/')
       cluster = AdminConfig.getid('/Deployment:' + app + '/ClusteredTarget:/')
       if cluster != "":
          cTargets = cluster.split(lineSeperator)
          for target in cTargets:
             cName = AdminConfig.showAttribute(target, 'name')
             clusterTarget = ClusteredTarget(cName)
             clusterTargets.add(clusterTarget)
       if server != "":
          sTargets = server.split(lineSeperator)
          for target in sTargets:
             sName = AdminConfig.showAttribute(target, 'name')
             nName = AdminConfig.showAttribute(target, 'nodeName')
             serverTarget = ServerTarget(nName, sName)
             serverTargets.add(serverTarget)
       application = Application(app, clusterTargets, serverTargets)
       
       rule = ExclusionRule('Application', 'name', app)
       if not ignore.contains(app) and not exclude.contains(rule):
          writer.addApplicationEntry(application, 0)
   else :
       print " Application " + app + " not found in Mappings.dat"
       print " You may need to run the utility to update the file"

# Discover Module Mappings
# Could incorporate into the scripting above most likely, but
# separated for readability and maintenance

for app in apps:
   context = cMap.get(app)
   if context != "None":
       dep = AdminConfig.getid('/Deployment:' + app + '/')
       webMods = AdminConfig.getid('/Deployment:' + app + '/ApplicationDeployment:/WebModuleDeployment:/')
       mods = webMods.split(lineSeparator)
       for mod in mods:
          sTargets = LinkedList()
          cTargets = LinkedList()
          uri = AdminConfig.showAttribute(mod, 'uri')
          context = cMap.get(app + "$" + uri)
          targs = AdminConfig.showAttribute(mod, 'targetMappings')
          targets = targs.split(lineSeparator)
          for tg in targets:
             trim = tg[1:len(tg) - 1]
             targ = AdminConfig.showAttribute(trim, 'target')  
             if targ.find('ServerTarget') != -1:
                tName = AdminConfig.showAttribute(targ, 'name')
                tNode = AdminConfig.showAttribute(targ, 'nodeName')
                sTarget = ServerTarget(tNode, tName)
                sTargets.add(sTarget)
             if targ.find('ClusteredTarget') != -1:
                cName = AdminConfig.showAttribute(targ, 'name')
                cTarget = ClusteredTarget(cName)
                cTargets.add(cTarget)
          mapping = ModuleMapping(app, uri, context, cTargets, sTargets)
          if not ignore.contains(app):
             writer.addModuleMappingEntry(mapping, 0)
   else:
       print " Module's Parent Application - " + app + " - not found in Mappings.dat"
       print " You may need to run the utility to update the file"

try:
   writer.writeToFile(File(workDir + '/bin/servers.xml'))
except XMLSerializationException, e:
   print "\nError Serializing File - " + e.getCause().toString()
   System.exit(1)

print ""
print "WAS 5.1 Scan Complete"
