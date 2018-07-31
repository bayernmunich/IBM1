#============================================
# Console message related functions
#============================================

#
# Print a usage message
#
def usage(msg = ''):
  if msg != '': print "ERROR: "+msg

  if command == 'addRemoteCell':
    print """
    addRemoteCell <webServerNode>:<webServerName> <remoteCellHost> <remoteCellPort> <importCertificates> [-u <remoteCellUserId>] [-w <remoteCellPassword>] [-e <enableRemoteCellConnectors>] [-r <remoteCellId>]
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
        <remoteCellHost> Hostname for remote cell
        <remoteCellPort> Port for remote cell
        <importCertificates> true or false
        [remoteCellUserId] Login credentials for the remote cell
        [remoteCellPassword] Login credentials for the remote cell
        [enableRemoteCellConnectors] true or false
        [remoteCellId] Unique cell identifier for a remote cell (defaults to cellname)
    """
  elif command == 'deleteRemoteCell':
    print """
    deleteRemoteCell <webServerNode>:<webServerName> <remoteHost> <remotePort> <deleteCertificates>
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
        <remoteHost> Hostname for remote cell
        <remotePort> Port for remote cell
        <deleteCertificates> true or false
    """
  elif command == 'disable':
    print """
    disable <webServerNode>:<webServerName>
       Disable intelligent management for a web server
       args:
         <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
    """
  elif command == 'enable':
    print """
    enable <webServerNode>:<webServerName> [-i <retryInterval>] [-r <maxRetries>] [-x <cellId>] [-e <enableRoutingToAdminConsole>]
       Enable intelligent management for a web server
       args:
         <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
         [retryInterval] Time in seconds between connection attempts
         [maxRetries] Maximum number of times to attempt to connect (positive integer or "infinite")
         [cellId] Unique Cell Identifier for the local cell
         [enableRoutingToAdminConsole] True or False to enable or disable admin traffic through the Intelligent Management enabled WebSphere plugin         
    """
  elif command == 'listRemoteCells':
    print """
    listRemoteCells <webServerNode>:<webServerName>
       args:
         <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
    """
  elif command == 'modify':
    print """
    modify <webServerNode>:<webServerName> [-i <retryInterval>] [-r <maxRetries>] [-x <cellId>] [-e <enableRoutingToAdminConsole>]
       args:
         <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
         [retryInterval] Time in seconds between connection attempts
         [maxRetries] Maximum number of times to attempt to connect (positive integer or "infinite")
         [cellId] Unique Cell Identifier for the local cell
         [enableRoutingToAdminConsole] True or False to enable or disable admin traffic through the Intelligent Management enabled WebSphere plugin         
    """
  elif command == 'modifyConnectorCluster':
    print """
    modifyConnectorCluster <webServerNode>:<webServerName> [-o <host>] [-t <port>] [-d <enable>] [-i <retryInterval>] [-r <maxRetries>] [-x <cellId>] [-e <enableRoutingToAdminConsole>]
       args:
         <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
         [host] Host name of connectorcluster
         [port] Port number of connectorcluster    
         [enable] Enables or Disables connectorcluster         
         [retryInterval] Time in seconds between connection attempts
         [maxRetries] Maximum number of times to attempt to connect (positive integer or "infinite")
         [cellId] Unique Cell Identifier for the local cell
         [enableRoutingToAdminConsole] True or False to enable or disable admin traffic through the Intelligent Management enabled WebSphere plugin
    """         
    
  elif command == 'modifyRemoteCell':
    print """
    modifyRemoteCell <webServerNode>:<webServerName> <remoteCellHost> <remoteCellPort> [-e <enableRemoteCellConnectors>] [-r <remoteCellId>]
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
        <remoteCellHost> Hostname for remote cell
        <remoteCellPort> Port for remote cell
        [enableRemoteCellConnectors] true or false
        [remoteCellId] Unique cell identifier for the remote cell (defaults to cellname)
    """
  elif command == 'addConditionalTraceRule':
    print """
    addConditionalTraceRule <webServerNode>:<webServerName> [-x <traceCondition>] [-s <traceSpecification>]
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
        [traceCondition]
        [traceSpecification]
    """
  elif command == 'setDefaultTraceRule':
    print """
    setDefaultTraceRule <webServerNode>:<webServerName> [-s <traceSpecification>]
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
        [traceSpecification]
    """
  elif command == 'removeConditionalTraceRule':
    print """
    removeConditionalTraceRule <webServerNode>:<webServerName>
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
    """
  elif command == 'listTraceRules':
    print """
    listTraceRules <webServerNode>:<webServerName>
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
    """
  elif command == 'refreshRemoteCell':
    print """
    refreshRemoteCell <webServerNode>:<webServerName> <remoteCellHost> <remoteCellPort> [-u <remoteCellUserId>] [-w <remoteCellPassword>]
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
        <remoteCellHost> Hostname for remote cell
        <remoteCellPort> Port for remote cell
        [remoteCellUserId] Login credentials for the remote cell
        [remoteCellPassword] Login credentials for the remote cell
    """
  elif command == 'refreshLocalCell':
    print """
    refreshLocalCell <webServerNode>:<webServerName>
      args:
        <webServerNode>:<webServerName> The node and web server name being configured separated by a colon (e.g. mynode:mywebserver)
    """
  elif command == 'generatePlugin':
    print """
    generatePlugin <dmgrRoot> <cellName> <nodeName> <webServerName>
      args:
        <dmgrRoot> Profile directory for the Deployment Manager (no trailing slash)
        <cellName> Cell name for the cell containing the web server being configured
        <nodeName> Node name for the node containing the web server being configured
        <webServerName> Server name for the web server being configured
    """
  else:
    print """
    Supported commands:
    
    addRemoteCell <webServerNode>:<webServerName> <remoteCellHost> <remoteCellPort> <importCertificates> [-u <remoteCellUserId>] [-w <remoteCellPassword>] [-e <enableRemoteCellConnectors>] [-r <remoteCellId>]
    deleteRemoteCell <webServerNode>:<webServerName> <remoteHost> <remotePort> <deleteCertificates>
    disable <webServerNode>:<webServerName>
    enable <webServerNode>:<webServerName> [-i <retryInterval>] [-r <maxRetries>] [-x <cellId>] [-e <enableRoutingToAdminConsole>]
    listRemoteCells <webServerNode>:<webServerName>
    modify <webServerNode>:<webServerName> [-i <retryInterval>] [-r <maxRetries>] [-x <cellId>] [-e <enableRoutingToAdminConsole>]
    modifyConnectorCluster <webServerNode>:<webServerName> [-o <host>] [-t <port>] [-d <enable>] [-i <retryInterval>] [-r <maxRetries>] [-x <cellId>] [-e <enableRoutingToAdminConsole>]    
    modifyRemoteCell <webServerNode>:<webServerName> <remoteCellHost> <remoteCellPort> [-e <enableRemoteCellConnectors>] [-r <remoteCellId>]
    addConditionalTraceRule <webServerNode>:<webServerName> [-x <traceCondition>] [-s <traceSpecification>]
    setDefaultTraceRule <webServerNode>:<webServerName> [-s <traceSpecification>]
    removeConditionalTraceRule <webServerNode>:<webServerName>
    listTraceRules <webServerNode>:<webServerName>
    refreshLocalCell <webServerNode>:<webServerName>    
    refreshRemoteCell <webServerNode>:<webServerName> <remoteCellHost> <remoteCellPort> [-u <remoteCellUserId>] [-w <remoteCellPassword>]
    generatePlugin <dmgrRoot> <cellName> <nodeName> <webServerName>
        
    """
  
  sys.exit(1)

#
# Set the 'odrNodeName' and 'odrServerName' globals given an ODR path
#
def processWebServerId():
  global nodeName, webServerName
  webServerId = getarg(1,"<webServerNode>:<webServerName>")
  
  elements = webServerId.split(":")
  
  if (len(elements) != 2):
    usage("'"+webServerId+"' is not of format <webServerNode>:<webServerName>")
    
  nodeName = elements[0]
  webServerName = elements[1]


#
# Get argument number 'count'; print a usage message if it doesn't exist.
#
def getarg(count,argName):
  if(len(sys.argv) <= count):
    usage("too few arguments; missing "+argName)
  return sys.argv[count].rstrip()

#
# Get argument number 'count'; print a usage message if it doesn't exist.
#
def getoptionalarg(tag, name):
  global optionalArgs
  
  return optionalArgs.get(tag, '')

def getoptionalargs(start):
  args = {}
  
  i = start
  while (i < len(sys.argv)):
    flag = sys.argv[i].strip()
    arg = sys.argv[i+1].strip()
    args[flag] = arg
    i = i + 2
  
  return args

def addOptionalArg(args, arg, argname):
  if not arg == '':
    args.append(argname)
    args.append(arg)

#
# 
#
def addRemoteCellToIntelligentManagement(nodeName, webServerName, remoteCellHost, remoteCellPort, importCertificates, enable, userId, password, cellId):
  args = ["-node", nodeName,
    "-webserver", webServerName,
    "-host", remoteCellHost,
    "-port", remoteCellPort,
    "-importCertificates", importCertificates]
  
  addOptionalArg(args, enable, '-enable')
  addOptionalArg(args, userId, '-userid')
  addOptionalArg(args, password, '-password')
  addOptionalArg(args, cellId, '-cellIdentifier')
  
  result = AdminTask.addRemoteCellToIntelligentManagement(args)
  AdminConfig.save()
  
  print "Added remote cell at %s:%s to Intelligent Management on %s:%s" % (remoteCellHost, remoteCellPort, nodeName, webServerName)

def deleteRemoteCellFromIntelligentManagement(nodeName, webServerName, remoteHost, remotePort, deleteCertificates):
  args = ['-node', nodeName, '-webserver', webServerName, '-host', remoteHost, '-port', remotePort, '-deleteCertificates', deleteCertificates]
  
  result = AdminTask.deleteRemoteCellFromIntelligentManagement(args)
  AdminConfig.save()
  
  print "Removed cell at %s:%s from web server %s:%s" % (remoteHost, remotePort, nodeName, webServerName)

def disableIntelligentManagement(nodeName, webServerName):
  result = AdminTask.disableIntelligentManagement([
    "-node", nodeName,
    "-webserver", webServerName])
  AdminConfig.save()
  
  print "Disabled Intelligent Management on %s:%s" % (nodeName, webServerName)

def enableIntelligentManagement(nodeName, webServerName, retryInterval, maxRetries, cellId , enableRoutingToAdminConsole):
  args = ["-node", nodeName, "-webserver", webServerName]
  
  addOptionalArg(args, retryInterval, '-retryInterval')
  addOptionalArg(args, maxRetries, '-maxRetries')
  addOptionalArg(args, cellId, '-cellIdentifier')
  addOptionalArg(args, enableRoutingToAdminConsole, '-enableRoutingToAdminConsole')
  result = AdminTask.enableIntelligentManagement(args)
  AdminConfig.save()
  
  print "Enabled Intelligent Management on  %s:%s" % (nodeName, webServerName)

def listRemoteCellsFromIntelligentManagement(nodeName, webServerName):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  result = AdminTask.listRemoteCellsFromIntelligentManagement(args)
  
  print result

def modifyIntelligentManagement(nodeName, webServerName, retryInterval, maxRetries, cellId , enableRoutingToAdminConsole):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  addOptionalArg(args, retryInterval, '-retryInterval')
  addOptionalArg(args, maxRetries, '-maxRetries')
  addOptionalArg(args, cellId, '-cellIdentifier')
  addOptionalArg(args, enableRoutingToAdminConsole, '-enableRoutingToAdminConsole')  
  result = AdminTask.modifyIntelligentManagement(args)
  AdminConfig.save()
  
  print "Modified Intelligent Management on %s:%s to have a maximum number of retries: %s at an interval of: %s for connectorCluster %s having dmgrTrafficEnbaled %s" % (nodeName, webServerName, maxRetries, retryInterval,cellId ,enableRoutingToAdminConsole)

def modifyIntelligentManagementConnectorCluster(nodeName, webServerName, host , port , enable, retryInterval, maxRetries, cellId , enableRoutingToAdminConsole):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  addOptionalArg(args, host, '-host')
  addOptionalArg(args, port, '-port')
  addOptionalArg(args, enable, '-enable')  
  addOptionalArg(args, retryInterval, '-retryInterval')
  addOptionalArg(args, maxRetries, '-maxRetries')
  addOptionalArg(args, cellId, '-cellIdentifier')
  addOptionalArg(args, enableRoutingToAdminConsole, '-enableRoutingToAdminConsole')
  
  result = AdminTask.modifyIntelligentManagementConnectorCluster(args)
  AdminConfig.save()
  
  print "Modified Intelligent Management on %s:%s  for connectorCluster %s with host:port of %s:%s to have a maximum number of retries: %s at an interval of: %s with dmgrTrafficEnabled %s" % (nodeName, webServerName, cellId, host, port, maxRetries, retryInterval,enableRoutingToAdminConsole)
  

def modifyRemoteCellForIntelligentManagement(nodeName, webServerName, remoteHost, remotePort, enable, cellId):
  args = ["-node", nodeName,
    "-webserver", webServerName,
    "-host", remoteHost,
    "-port", remotePort]
    
  addOptionalArg(args, enable, '-enable')
  addOptionalArg(args, cellId, '-cellIdentifier')
  
  result = AdminTask.modifyRemoteCellForIntelligentManagement(args)
  AdminConfig.save()
  
  print "Modified remote cell connection for %s:%s" % (nodeName, webServerName)

def addConditionalTraceRuleForIntelligentManagement(nodeName, webServerName, traceCondition, traceSpec):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  addOptionalArg(args, traceCondition, '-condition')
  addOptionalArg(args, traceSpec, '-spec')
  
  result = AdminTask.addConditionalTraceRuleForIntelligentManagement(args)
  
  AdminConfig.save()
  
  print "Added the conditional trace rule on %s:%s" % (nodeName, webServerName)

def setDefaultTraceRuleForIntelligentManagement(nodeName, webServerName, traceSpec):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  addOptionalArg(args, traceSpec, '-spec')
  
  result = AdminTask.setDefaultTraceRuleForIntelligentManagement(args)
  
  AdminConfig.save()
  
  print "Added the default trace rule on %s:%s" % (nodeName, webServerName)  

def removeConditionalTraceRuleForIntelligentManagement(nodeName, webServerName):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  result = AdminTask.removeConditionalTraceRuleForIntelligentManagement(args)
  
  AdminConfig.save()
  
  print "Removed the conditional trace rule on %s:%s" % (nodeName, webServerName) 
   
def listTraceRulesForIntelligentManagement(nodeName, webServerName):
  args = ['-node', nodeName, '-webserver', webServerName]
  
  result = AdminTask.listTraceRulesForIntelligentManagement(args)
  
  AdminConfig.save()
  
  print result

def refreshCellForIntelligentManagement(nodeName, webServerName, local, remoteHost, remotePort, username, password):
  args = ["-node", nodeName,
    "-webserver", webServerName]

  if local == 'true':
    addOptionalArg(args, 'true', '-local')
  else:
    addOptionalArg(args, remoteHost, '-host')
    addOptionalArg(args, remotePort, '-port')
    addOptionalArg(args, username, '-userid')
    addOptionalArg(args, password, '-password')
  
  result = AdminTask.refreshCellForIntelligentManagement(args)
  AdminConfig.save()
  if local == 'true':
    print "Refreshed local cell on %s:%s" % (nodeName, webServerName)
  else:
    print "Refreshed remote cell at %s:%s on %s:%s" % (remoteHost, remotePort, nodeName, webServerName)



def generatePlugin(dmgrRoot, cellName, nodeName, webServerName):
  mbean = AdminControl.queryNames("WebSphere:*,process=dmgr,type=PluginCfgGenerator")
  args = '[%s/config %s %s %s false]' % (dmgrRoot, cellName, nodeName, webServerName)
  result = AdminControl.invoke(mbean, 'generate', args, '[java.lang.String java.lang.String java.lang.String java.lang.String java.lang.Boolean]')
  AdminConfig.save()
  
  print "Generated the plugin configuration: %s/config/cells/%s/nodes/%s/servers/%s/plugin-cfg.xml" % (dmgrRoot, cellName, nodeName, webServerName)


#========================================================================================
#
# Begin main
#
#========================================================================================
if __name__ == '__main__':
  global LOG
  LOG="log"
  
  command = ''
  command = getarg(0,"command name")
  global optionalArgs
  
  if (command == 'help'):
    usage('')
  elif (command == 'addRemoteCell'):
    processWebServerId()
    optionalArgs = getoptionalargs(5)
    addRemoteCellToIntelligentManagement(
      nodeName,
      webServerName,
      getarg(2, '<remoteCellHost>'),
      getarg(3, '<remoteCellPort>'),
      getarg(4, '<importCertificates>'),
      getoptionalarg('-e', '[enableRemoteCellConnectors]'),
      getoptionalarg('-u', '[remoteCellUserId]'),
      getoptionalarg('-w', '[remoteCellPassword]'),
      getoptionalarg('-r', '[remoteCellId]'))
  elif (command == 'deleteRemoteCell'):
    processWebServerId()
    deleteRemoteCellFromIntelligentManagement(
      nodeName,
      webServerName,
      getarg(2, '<remoteHost>'),
      getarg(3, '<remotePort>'),
      getarg(4, '<deleteCertificates>'))
  elif (command == 'disable'):
    processWebServerId()
    disableIntelligentManagement(
      nodeName,
      webServerName)
  elif (command == 'enable'):
    processWebServerId()
    optionalArgs = getoptionalargs(2)
    enableIntelligentManagement(
      nodeName,
      webServerName,
      getoptionalarg('-i', "[retryInterval]"),
      getoptionalarg('-r', "[maxRetries]"),
      getoptionalarg('-x', '[cellId]'),
      getoptionalarg('-e', '[enableRoutingToAdminConsole]'))
  elif (command == 'listRemoteCells'):
    processWebServerId()
    listRemoteCellsFromIntelligentManagement(
      nodeName,
      webServerName)
  elif (command == 'modify'):
    processWebServerId()
    optionalArgs = getoptionalargs(2)
    modifyIntelligentManagement(
      nodeName,
      webServerName,
      getoptionalarg('-i', '[retryInterval]'),
      getoptionalarg('-r', '[maxRetries]'),
      getoptionalarg('-x', '[cellId]'),
      getoptionalarg('-e', '[enableRoutingToAdminConsole]'))
  elif (command == 'modifyConnectorCluster'):
    processWebServerId()
    optionalArgs = getoptionalargs(2)
    modifyIntelligentManagementConnectorCluster(
      nodeName,
      webServerName,
      getoptionalarg('-o', '[host]'),
      getoptionalarg('-t', '[port]'),
      getoptionalarg('-d', '[enable]'),      
      getoptionalarg('-i', '[retryInterval]'),
      getoptionalarg('-r', '[maxRetries]'),
      getoptionalarg('-x', '[cellId]'),
      getoptionalarg('-e', '[enableRoutingToAdminConsole]'))
  elif (command == 'modifyRemoteCell'):
    processWebServerId()
    optionalArgs = getoptionalargs(4)
    modifyRemoteCellForIntelligentManagement(
      nodeName,
      webServerName,
      getarg(2, '<remoteHost>'),
      getarg(3, '<remotePort>'),
      getoptionalarg('-e', '[enableCellConnections]'),
      getoptionalarg('-r', '[remoteCellId]'))
  elif (command == 'addConditionalTraceRule'):
    processWebServerId()
    optionalArgs = getoptionalargs(2)
    addConditionalTraceRuleForIntelligentManagement(
      nodeName,
      webServerName,
      getoptionalarg('-x', '[traceCondition]'),
      getoptionalarg('-s', '[traceSpecification]'))
  elif (command == 'setDefaultTraceRule'):
    processWebServerId()
    optionalArgs = getoptionalargs(2)
    setDefaultTraceRuleForIntelligentManagement(
      nodeName,
      webServerName,
      getoptionalarg('-s', '[traceSpecification]'))
  elif (command == 'removeConditionalTraceRule'):
    processWebServerId()
    removeConditionalTraceRuleForIntelligentManagement(
      nodeName,
      webServerName)
  elif (command == 'listTraceRules'):
    processWebServerId()
    listTraceRulesForIntelligentManagement(
      nodeName,
      webServerName)
  elif (command == 'refreshRemoteCell'):
    processWebServerId()
    optionalArgs = getoptionalargs(4)
    refreshCellForIntelligentManagement(
      nodeName,
      webServerName,
      'false',
      getarg(2, '<remoteCellHost>'),
      getarg(3, '<remoteCellPort>'),
      getoptionalarg('-u', '[remoteCellUserId]'),
      getoptionalarg('-w', '[remoteCellPassword]'))
  elif (command == 'refreshLocalCell'):
    processWebServerId()
    optionalArgs = getoptionalargs(4)
    refreshCellForIntelligentManagement(
      nodeName,
      webServerName,
      'true',
      '',
      '',
      '',
      '')    
  elif (command == 'generatePlugin'):
    generatePlugin(
      getarg(1, '<dmgrRoot>'),
      getarg(2, '<cellName>'),
      getarg(3, '<nodeName>'),
      getarg(4, '<webServerName>'))
  else:
    usage("'"+command+"' is an unknown command")
