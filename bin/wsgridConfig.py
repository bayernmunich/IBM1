import sys, os
import java.lang.System  as  jsys

lineSeparator  = jsys.getProperty('line.separator')
fileSeparator  = jsys.getProperty('file.separator')

defaultBusName        = "JobSchedulerBus"
defaultQualifier      = "com.ibm.ws.grid"
defaultFileStoreRoot  = "/tmp"
defaultAppName        = "JobSchedulerMDI"

scriptName            = "wsgridConfig.py"

#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------

def usage( msg ):
    print ""
    print scriptName + " : " + msg
    print ""
    print "Usage: wsadmin " + scriptName + " -install -cluster <clusterName> -providers <providerList>"
    print "  or   wsadmin " + scriptName + " -reinstallMDI -cluster <clusterName>"
    print "  or   wsadmin " + scriptName + " -reinstallMDI -node <nodeName> -server <serverName>"
    print "  or   wsadmin " + scriptName + " -remove  -cluster <clusterName>"
    print "  or   wsadmin " + scriptName + " -install -node <nodeName> -server <serverName> -providers <providerList>"
    print "  or   wsadmin " + scriptName + " -remove  -node <nodeName> -server <serverName>"
    print ""
    print "  -install is assumed if -remove is not specified"
    print ""
    print "  required parameters"
    print ""
    print "    either  -cluster <clusterName> "
    print "      or    -node <nodeName> and -server <serverName>"
    print ""
    print "      where <clusterName> specifies the target cluster "
    print "        or  <nodeName> and <serverName> specifies the target node and server "
    print "      which will host the " + defaultAppName + " application and where the"
    print "        JMS artifacts and " + defaultBusName + " are to be created"
    print ""
    print "    -providers <providerList> (required for -install)"
    print ""
    print "      where <providerList> identifies a list of providerEndpoints in the format:"
    print "        hostname1,portnumber1[;hostname2,portnumber2...]"
    print "      where portnumber identifies the SIB_ENDPOINT_ADDRESS or SIB_ENDPOINT_SECURE_ADDRESS port"
    print "        of the application server where the JMS artifacts are to be created"
    print ""
    print "      if -cluster is specified (the JMS artifacts and " + defaultBusName + " will be created on a cluster)"
    print "        then an entry must be defined for every member in the cluster"
    print ""
    print "      example: yourhost.com,7278;yourhost.com,7279"
    print ""
    print "  optional parameter (-install or -remove): "
    print ""
#    print "    -qualifier <qualifier>         : qualifier to use when creating or removing the JMS artifacts (connection"
#    print "                                     factory, queues, activation spec) - default is: " + defaultQualifier
#    print "    -appname <appName>             : application name to use when installing or uninstalling the Job Scheduler"
#    print "                                     Message Driven Interface application - default is: " + defaultAppName
    print "    -bus <busName>                 : name of the created or removed job scheduler bus - default is: " + defaultBusName
    print ""
    print "  optional parameter (-install only): "
    print ""
    print "    -filestoreroot <fileStoreRoot> : directory where the JMS log, permanent store, and temporary store "
    print "                                     files are created - default is: " + defaultFileStoreRoot + fileSeparator + "<busName>"
#    print "    -wmqserver <wmqServer>         : the name of the WebSphere MQ server to add to the bus.  This is the name specified in"
#    print "                                     the -name parameter when creating the WebSphere MQ server"
#    print "    -wmqqueue <wmqQueue>           : the name of the WebSphere MQ queue used to store messages sent to the destination"
#    print "                                     identified by the WebSphere MQ server <wmqServer>.  <wmqQueue> is the name allocated to"
#    print "                                     the WebSphere MQ queue by WebSphere MQ administration.  Required if -wmqServer is specified"
    print ""

    sys.exit(101)

#------------------------------------------------------------------------------
# Save the configuration
#------------------------------------------------------------------------------
def save():
    print "saving config..."
    AdminConfig.save()
    print "Done saving.."
    topology = getCellNodeServer();
   
    if topology[3] != "APPLICATION_SERVER":
	dmgrbean = AdminControl.queryNames("type=DeploymentManager,*")
        AdminControl.invoke(dmgrbean, "syncActiveNodes", "true")
    print scriptName + " INFO: Configuration was saved and synchronized to the active nodes"

#------------------------------------------------------------------------------
# Set the variable to the passed value if it has not already been set
#------------------------------------------------------------------------------
def setOpt(oldValue, newValue):
    if oldValue != "":
        usage( "duplicate option" )
    else:
        return newValue

#------------------------------------------------------------------------------
# Set the variable to the next arg value if it has not already been set
#------------------------------------------------------------------------------
def setArg(oldValue, argIndex):
    if oldValue != "":
        usage( "duplicate argument" )
    elif argIndex == len(sys.argv):
        usage( "missing value" )
    else:
        return sys.argv[argIndex]

#------------------------------------------------------------------------------
# Process the passed arguements
#------------------------------------------------------------------------------
def getArgs():

    actionType    = ""
    clusterName   = ""
    nodeName      = ""
    serverName    = ""
    busName       = ""
    endpoints     = ""
    qualifier     = ""
    fileStoreRoot = ""
    appName       = ""
    wmqServer     = ""
    wmqQueue      = ""
    

    providers     = ""

    i = 0

    while i < len(sys.argv):

        if sys.argv[i] == "-install":
            actionType = setOpt(actionType, "install")
        elif sys.argv[i] == "-reinstallMDI":
            actionType = setOpt(actionType, "reinstallMDI")
        elif sys.argv[i] == "-remove":
            actionType = setOpt(actionType, "remove")
        elif sys.argv[i] == "-cluster":
            i += 1
            clusterName = setArg(clusterName, i)
        elif sys.argv[i] == "-node":
            i += 1
            nodeName = setArg(nodeName, i)
        elif sys.argv[i] == "-server":
            i += 1
            serverName = setArg(serverName, i)
        elif sys.argv[i] == "-bus":
            i += 1
            busName = setArg(busName, i)
        elif sys.argv[i] == "-providers":
            i += 1
            providers = setArg(providers, i)
        elif sys.argv[i] == "-filestoreroot":
            i += 1
            fileStoreRoot = setArg(fileStoreRoot, i)	
#        elif sys.argv[i] == "-qualifier":
#            i += 1
#            qualifier = setArg(qualifier, i)
#        elif sys.argv[i] == "-appname":
#            i += 1
#            appName = setArg(appName, i)
#        elif sys.argv[i] == "-wmqserver":
#            i += 1
#            wmqServer = setArg(wmqServer, i)
#        elif sys.argv[i] == "-wmqqueue":
#            i += 1
#            wmqQueue = setArg(wmqQueue, i)
        else:
            usage( "unrecognized argument: " + sys.argv[i] )

        i += 1

    if clusterName == "":
        if nodeName == "":
            if serverName == "":
                usage( "either -cluster or -node and -server required" )

    if clusterName != "":
        if nodeName != "":
            usage( "conflicting parameters: -node with -cluster" )
        elif serverName != "":
            usage( "conflicting parameters: -server with -cluster" )
    elif nodeName == "":
        usage( "missing -node" )
    elif serverName == "":
        usage( "missing -server" )

    if actionType == "":
        actionType = "install"

    if actionType == "remove":

        if providers != "":
            usage( "conflicting parameters: -providers with -remove" )
        elif fileStoreRoot != "":
            usage( "conflicting parameters: -filestoreroot with -remove" )
        elif wmqServer != "":
            usage( "conflicting parameters: -wmqserver with -remove" )
        elif wmqQueue != "":
            usage( "conflicting parameters: -wmqqueue with -remove" )

    if actionType == "install":
       if providers == "":
          usage( "missing -providers" )
       else:
          endpoints = validateProviders(providers)
    
    if wmqServer != "":
        if wmqQueue == "":
            usage( "-wmqServer requires -wmqQueue" )

    if wmqQueue != "":            
        if wmqServer == "":
            usage( "-wmqQueue requires -wmqServer" )

    if busName == "":
        busName = defaultBusName

    if qualifier == "":
        qualifier = defaultQualifier

    if fileStoreRoot == "":
        fileStoreRoot = defaultFileStoreRoot + fileSeparator + busName

    if appName == "":
        appName = defaultAppName

    return (actionType, clusterName, nodeName, serverName, busName, endpoints, qualifier, fileStoreRoot, appName, wmqServer, wmqQueue)

#------------------------------------------------------------------------------
# Validate the passed provider argument
#------------------------------------------------------------------------------
def validateProviders(providers):
    print "INFO: validating providers.." + providers
    providerList = providers.split( ";" )
    providerEndpoints = ""

    try:

        for provider in providerList:

            providerItem = provider.split( "," )
            providerHost = providerItem[0]
            providerPort = providerItem[1]

            if providerEndpoints != "":
                providerEndpoints += ","

            providerEndpoints += providerItem[0]
            providerEndpoints += ":"
            providerEndpoints += providerItem[1]

    except:

        usage( "invalid -providers argument" )

    return providerEndpoints

#------------------------------------------------------------------------------
# Get the directory, as a string, where WAS is installed.
#------------------------------------------------------------------------------
def getWASHome(cell, cluster, node):
    print "INFO: Getting WASHOME" 
    nodeName = node;
    if nodeName == "":
        topology = getCellNodeServer()
        nodeName = topology[1]
    varMap = AdminConfig.getid("/Cell:" + cell + "/Node:" + nodeName + "/VariableMap:/")
    entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
    eList = entries.splitlines()
    for entry in eList:
        name =  AdminConfig.showAttribute(entry, "symbolicName")
        if name == "WAS_INSTALL_ROOT":
            value = AdminConfig.showAttribute(entry, "value")
            return value
    print " WASHOME = " + java.lang.System.getenv('WAS_HOME')
    return java.lang.System.getenv('WAS_HOME')
#------------------------------------------------------------------------------
# Get  WAS install root of DMRG
#------------------------------------------------------------------------------
def getDMGRWASHome():
    print "INFO: Getting WASHOME of DMGR" 
    print " WASHOME = " + java.lang.System.getenv('WAS_HOME')
    return java.lang.System.getenv('WAS_HOME')

#------------------------------------------------------------------------------
# Get a tuple containing the cell, node, server name, and type
#------------------------------------------------------------------------------
def getCellNodeServer():
    print "INFO: getting cell/node/server..." 
    servers = AdminConfig.list("Server").splitlines()
    for serverId in servers:
        serverName = serverId.split("(")[0]
        server = serverId.split("(")[1]  #remove name( from id
        server = server.split("/")
        cell = server[1]
        node = server[3]
        cellId = AdminConfig.getid("/Cell:" + cell + "/")
        cellType = AdminConfig.showAttribute(cellId, "cellType")
        if cellType == "DISTRIBUTED":
            if AdminConfig.showAttribute(serverId, "serverType") == "DEPLOYMENT_MANAGER":
                return (cell, node, serverName, "DEPLOYMENT_MANAGER") 
        elif cellType == "STANDALONE":
            if AdminConfig.showAttribute(serverId, "serverType") == "APPLICATION_SERVER":
                return (cell, node, serverName, "APPLICATION_SERVER") 
    return None	


#------------------------------------------------------------------------------
# Install the application
#------------------------------------------------------------------------------

def install(wasHome, cell, cluster, node, server, appname):

    print "INFO: Installing JobSchedulerMDI..." 
    systemApps  = "$(WAS_INSTALL_ROOT)" + fileSeparator + "systemApps"
    earPath     = wasHome + fileSeparator + "systemApps" + fileSeparator + defaultAppName + ".ear"

    options = [ 
                 "-usedefaultbindings",
                 "-nocreateMBeansForResources",
                 "-zeroEarCopy",
                 "-skipPreparation",

                 "-appname",                         appname, 
                 "-installed.ear.destination",       systemApps,
                 "-cell",                            cell, 
              ]

    if cluster != "":

        options.append( "-cluster" )
        options.append( cluster )

        msg = "cluster " + cluster

    else:

        options.append( "-node" )
        options.append( node )
        options.append( "-server" )
        options.append( server )

        msg = "node/server " + node + "/" + server

    AdminApp.install(earPath, options)

    save()

    startApplication(appname)

    if appname != defaultAppName:
        msg = msg + " using application name " + appname

    print ""
    print scriptName + " INFO: installed " + defaultAppName + " to " + msg 


#------------------------------------------------------------------------------
# Start the application 
#------------------------------------------------------------------------------

def startApplication(appname):
 
    print "starting JobSchedulerMDI"
    
    topology = getCellNodeServer()
    
    if topology[3] != "APPLICATION_SERVER":
	appManager = AdminControl.completeObjectName( "WebSphere:*,type=AppManagement,process=dmgr" )       
	parameters = "[ " +  appname + " null null ]"
	signature = "[ java.lang.String java.util.Hashtable java.lang.String ]"
	AdminControl.invoke( appManager, 'startApplication', parameters, signature )


#------------------------------------------------------------------------------
# Uninstall the JobSchedulerMDI
#------------------------------------------------------------------------------

def uninstall(appname):
    print "INFO: uninstalling JobSchedulerMDI " + appname
    try: 
        AdminApp.uninstall(appname)
        result = "removed"
    except:
        result = ""

    if result == "removed":
        save()

#------------------------------------------------------------------------------
# create the bus
#------------------------------------------------------------------------------
def createBus(busName):
    print "createBus " + busName
    AdminTask.createSIBus ( "-bus " + busName )
    print scriptName + " INFO: created SIB " + busName
   #save() 

#------------------------------------------------------------------------------
# create the bus
#------------------------------------------------------------------------------
def removeBus(busName):
    print "removeBus " + busName
    try:
        AdminTask.deleteSIBus ( "-bus " + busName )
        result = "removed"
    except:
        result = ""

    if result == "removed":
        print scriptName + " INFO: removed SIB " + busName
       #save() 

#------------------------------------------------------------------------------
# create the bus member
#------------------------------------------------------------------------------
def createBusMember(bus, cluster, node, server, fileStoreRoot, target, wmqServer):
    print "INFO: Creating SIB member..." 
    options = [ 
                  "-fileStore" , 
                  "-bus" , bus ,
                  "-logDirectory"            , fileStoreRoot + fileSeparator + "Log",
                  "-permanentStoreDirectory" , fileStoreRoot + fileSeparator + "Perm-Store",
                  "-temporaryStoreDirectory" , fileStoreRoot + fileSeparator + "Temp-Store"
              ]

    msg = target

    if wmqServer != "":

        options.append( "-wmqServer" )
        options.append( wmqServer )

        msg = "WebSphere MQ Server " + wmqServer

    elif cluster != "":

        options.append( "-cluster" )
        options.append( cluster )

    else:

        options.append( "-node" )
        options.append( node )
        options.append( "-server" )
        options.append( server )

    AdminTask.addSIBusMember( options )
    print scriptName + " INFO: created SIB member on target " + msg
   #save() 

#------------------------------------------------------------------------------
# create the bus destination
#------------------------------------------------------------------------------
def createBusDestination(bus, cluster, node, server, destination, wmqServer, wmqQueue):
    print "INFO: Creating SIB destination..." 
    options = [
                "-type"    ,  "QUEUE",
                "-bus"     ,  bus,
                "-name"    ,  destination
              ]

    if wmqServer != "":

        options.append( "-wmqServer" )
        options.append( wmqServer )
        options.append( "-wmqQueueName" )
        options.append( wmqQueue )

    elif cluster != "":

        options.append( "-cluster" )
        options.append( cluster )

    else:

        options.append( "-node" )
        options.append( node )
        options.append( "-server" )
        options.append( server )

    AdminTask.createSIBDestination( options )
    print scriptName + " INFO: created SIB destination " + destination
   #save() 

#------------------------------------------------------------------------------
# create the job scheduler bus
#------------------------------------------------------------------------------
def schedulerBus(bus,target,cluster,node,server,fileStoreRoot,inputQueue,outputQueue,wmqServer,wmqQueue):

    print "INFO: Create scheduler Bus..." 
    createBus(bus)
    createBusMember(bus, cluster, node, server, fileStoreRoot, target, wmqServer)
    createBusDestination(bus, cluster, node, server, inputQueue,  wmqServer, wmqQueue)
    createBusDestination(bus, cluster, node, server, outputQueue, wmqServer, wmqQueue)

#------------------------------------------------------------------------------
# create the JMS resources
#------------------------------------------------------------------------------
def setResources(bus,target,endpoints,connectionFactory,inputQueue,outputQueue,activationSpec):

    print "INFO: Create resources..." 
    createConnectionFactory(bus,target,endpoints,connectionFactory)
    createQueue(bus,target,inputQueue)
    createQueue(bus,target,outputQueue)
    createActivationSpec(bus,target,activationSpec,inputQueue)

#------------------------------------------------------------------------------
# create the JMS resources
#------------------------------------------------------------------------------
def removeResources(target,connectionFactory,inputQueue,outputQueue,activationSpec):
    print "INFO: Removing resources..." 

    removeConnectionFactory(target,connectionFactory)
    removeQueue(target,inputQueue)
    removeQueue(target,outputQueue)
    removeActivationSpec(target,activationSpec)


#------------------------------------------------------------------------------
# remove the JMS Connection Factory
#------------------------------------------------------------------------------
def removeConnectionFactory(target,connectionFactory):

    result = ""
    print "INFO: Removing JMS Connection Factory " + connectionFactory
    try:

        scope = AdminConfig.getid( target )
        factories = AdminTask.listSIBJMSConnectionFactories(scope)
        factoryList = factories.split(lineSeparator)

        for factory in factoryList:
            factoryName = factory.split("(")[0]
            if factoryName == connectionFactory:
                AdminTask.deleteSIBJMSConnectionFactory( factory );
                result = "removed"

    except:

        result = ""

    if result == "removed":
        print scriptName + " INFO: removed JMS connection factory " + connectionFactory
        save()

#------------------------------------------------------------------------------
# create the JMS Connection Factory
#------------------------------------------------------------------------------
def createConnectionFactory(bus,target,endpoints,connectionFactory):
    print "INFO: Creating JMS Connection Factory " + connectionFactory
    options = [
                "-busName"            ,  bus,
                "-targetType"         ,  "BusMember",
                "-name"               ,  connectionFactory,
                "-jndiName"           ,  "jms/" + connectionFactory,
                "-providerEndPoints"  ,  endpoints
              ]

    scope = AdminConfig.getid( target )
    AdminTask.createSIBJMSConnectionFactory( scope, options );
    print scriptName + " INFO: created JMS connection factory " + connectionFactory
   #save() 

#------------------------------------------------------------------------------
# remove the JMS Queue
#------------------------------------------------------------------------------
def removeQueue(target,name):
    print "INFO: Removing JMS Queue " + name
    result = ""

    try:

        scope = AdminConfig.getid( target )
        queues = AdminTask.listSIBJMSQueues( scope )
        queueList = queues.split( lineSeparator )

        for queue in queueList:
            queueName = queue.split("(")[0]
            if queueName == name:
                AdminTask.deleteSIBJMSQueue( queue );
                result = "removed"

    except:

        result = ""

    if result == "removed":
        print scriptName + " INFO: removed JMS queue " + name
       #save() 

#-------------------------------------------------------------------
# remove directory
#-------------------------------------------------------------------
	

ERROR_STR= """Error removing %(path)s, %(error)s """


def rmgeneric(path, __func__):

    try:
        __func__(path)
        print 'Removed ', path
    except OSError, (errno, strerror):
        print ERROR_STR % {'path' : path, 'error': strerror }

            
def removeall(path):

    if not os.path.isdir(path):
        return
    
    files=os.listdir(path)

    for x in files:
        fullpath=os.path.join(path, x)
        if os.path.isfile(fullpath):
            f=os.remove
            rmgeneric(fullpath, f)
        elif os.path.isdir(fullpath):
            removeall(fullpath)
            f=os.rmdir
            rmgeneric(fullpath, f)
	    
    

#------------------------------------------------------------------------------
# create the JMS Queue
#------------------------------------------------------------------------------
def createQueue(bus,target,name):
    print "INFO: Creating Queue " + name
    options = [
                "-busName"    ,  bus,
                "-name"       ,  name, 
                "-queueName"  ,  name,
                "-jndiName"   ,  "jms/" + name
              ]

    scope = AdminConfig.getid( target )
    AdminTask.createSIBJMSQueue( scope, options );
    print scriptName + " INFO: created JMS queue " + name
   #save() 

#------------------------------------------------------------------------------
# remove the JMS Activation Spec
#------------------------------------------------------------------------------
def removeActivationSpec(target,activationSpec):

    result = ""
    print "INFO: Removing JMS Activation Spec " + activationSpec
    try:

        scope = AdminConfig.getid( target )
        specs = AdminTask.listSIBJMSActivationSpecs( scope )
        specList = specs.split( lineSeparator )

        for spec in specList:
            specName = spec.split("(")[0]
            if specName == activationSpec:
                AdminTask.deleteSIBJMSActivationSpec( spec );
                result = "removed"

    except:

        result = ""

    if result == "removed":
        print scriptName + " INFO: removed JMS activation spec " + activationSpec
       #save() 

#------------------------------------------------------------------------------
# create the JMS Activation Spec
#------------------------------------------------------------------------------
def createActivationSpec(bus,target,activationSpec,inputQueue):
    print "Creating JMS Activation Spec" 
    options = [
                "-busName"             ,  bus,
                "-name"                ,  activationSpec, 
                "-jndiName"            ,  "eis/" + activationSpec,
                "-destinationJndiName" ,  "jms/" + inputQueue
              ]

    scope = AdminConfig.getid( target )
    AdminTask.createSIBJMSActivationSpec( scope, options );
    print scriptName + " INFO: created JMS activation spec " + activationSpec
   #save() 

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

if len(sys.argv) < 1 or len(sys.argv) > 13:
	usage( "too many or too few arguments" )

args = getArgs()

action        = args[0]
cluster       = args[1]
node          = args[2]
server        = args[3]
bus           = args[4]
endpoints     = args[5]
prefix        = args[6]
fileStoreRoot = args[7]
appname       = args[8]
wmqServer     = args[9]
wmqQueue      = args[10]


cell = AdminControl.getCell()
#wasHome = getWASHome(cell,cluster,node)
wasHome = getDMGRWASHome()

inputQueue         =  prefix  +  ".InputQueue"
outputQueue        =  prefix  +  ".OutputQueue"
connectionFactory  =  prefix  +  ".ConnectionFactory"
activationSpec     =  prefix  +  ".ActivationSpec"

if cluster != "":
    target = "/ServerCluster:" + cluster + "/"
else:
    target = "/Node:" + node + "/Server:" + server + "/"

print ""
print scriptName + " is performing " + action + " using "
print ""

print "  target cluster or server : " + target
print "  MDI application name     : " + appname
print "  JMS connection factory   : " + connectionFactory
print "  JMS activation spec      : " + activationSpec
print "  JMS input queue name     : " + inputQueue
print "  JMS output queue name    : " + outputQueue

if action == "install":
    print "  Installing WSGrid"
    print "  JMS file store root      : " + fileStoreRoot
    print "  SIB identifier           : " + bus
    print "  endpoint provider list   : " + endpoints

    if wmqServer != "":
        print "  WebSphere MQ Server      : " + wmqServer
        print "  WebSphere MQ Queue       : " + wmqQueue

    print ""

    install(wasHome,cell,cluster,node,server,appname)
    print "Done installing JobSchedulerMDI"
    schedulerBus(bus,target,cluster,node,server,fileStoreRoot,inputQueue,outputQueue,wmqServer,wmqQueue)
    setResources(bus,target,endpoints,connectionFactory,inputQueue,outputQueue,activationSpec)
    save()
    print "Install complete."

elif action == "reinstallMDI":
    print "  Reinstalling JobSchedulerMDI"
   
    print ""
    uninstall(appname)
    install(wasHome,cell,cluster,node,server,appname)
    print "Done reinstalling JobSchedulerMDI"
    save()
    print "ReinstallMDI complete."
else:
    print "  Uninstalling WSGrid"
    print "  SIB identifier           : " + bus
    print ""

    uninstall(appname)
    removeBus(bus)

    #fileStoreRoot is not an accepted arg for the remove option so the follow three lines do nothing
    #removeall(fileStoreRoot)
    #func = os.rmdir
    #rmgeneric(fileStoreRoot,func)
    removeResources(target,connectionFactory,inputQueue,outputQueue,activationSpec)
    save()
    print "Remove complete."
