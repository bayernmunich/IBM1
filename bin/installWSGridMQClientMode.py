#------------------------------------------------------------------------------
# Script to install/configure JobSchedulerMDI application. 
# 
#------------------------------------------------------------------------------

import sys, os
import java.lang.System  as  jsys

lineSeparator  = jsys.getProperty('line.separator')
fileSeparator  = jsys.getProperty('file.separator')

defaultQualifier      = "com.ibm.ws.grid"
appName               = "JobSchedulerMDILP"
prefix		      = "com.ibm.ws.grid"
scriptName            = "installWSGridMQClientMode.py"

#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------

def usage( msg ):
    print ""
    print scriptName + " : " + msg
    print ""
    print "Usage: wsadmin " + scriptName + " {-install|-remove}" 
    print "                                  {<deployment target>}"
    print "                                  [<MQ config>]"
    print ""
    print "    <deployment target> = "
    print "         {-node <nodeName> -server <serverName> | -cluster <clusterName>}"
    print ""
    print "    <MQ config> = "
    print "         -qmgr <queue manager name>"
    print "         -qhost <queue manager host>"
    print "         -qport <queue manager port>"
    print "         -svrconn <server-connection channel>"
    print "         -inqueue <input queue name>"
    print "         -outqueue <output queue name>"
    print ""
    print "    Notes:"
    print "      1. <MQ config> is required when -install is specified."
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
    qmgrName      = ""
    qmgrHost      = ""
    qmgrPort      = ""
    channelName   = ""
    inQueueName   = ""
    outQueueName  = ""

    i = 0

    while i < len(sys.argv):

        if sys.argv[i] == "-install":
            actionType = setOpt(actionType, "install")
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
        elif sys.argv[i] == "-qmgr":
            i += 1
            qmgrName = setArg(qmgrName, i)
        elif sys.argv[i] == "-qhost":
            i += 1
            qmgrHost = setArg(qmgrHost, i)
        elif sys.argv[i] == "-qport":
            i += 1
            qmgrPort = setArg(qmgrPort, i)
        elif sys.argv[i] == "-svrconn":
            i += 1
            channelName = setArg(channelName, i)
        elif sys.argv[i] == "-inqueue":
            i += 1
            inQueueName = setArg(inQueueName, i)
        elif sys.argv[i] == "-outqueue":
            i += 1
            outQueueName = setArg(outQueueName, i)	    
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
        usage("missing -install or -remove")

    if actionType == "install":
      if qmgrName == "":
        usage("missing -qmgr")
      if qmgrHost == "":
        usage("missing -qhost")
      if channelName == "":
        usage("missing -channel")
      if inQueueName == "":
        usage("missing -inqueue")
      if outQueueName == "":
        usage("missing -outqueue")

    return (actionType, clusterName, nodeName, serverName, qmgrName, qmgrHost, qmgrPort, channelName, inQueueName, outQueueName)

#------------------------------------------------------------------------------
# Get the directory, as a string, where WAS is installed.
#------------------------------------------------------------------------------
def getWASHome(cell, cluster, node):
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

    return java.lang.System.getenv('WAS_HOME')

#------------------------------------------------------------------------------
# Get a tuple containing the cell, node, server name, and type
#------------------------------------------------------------------------------
def getCellNodeServer():
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

def install(wasHome, cell, cluster, node, server, appName):

    systemApps  = "$(WAS_INSTALL_ROOT)" + fileSeparator + "systemApps"
    earPath     = wasHome + fileSeparator + "systemApps" + fileSeparator + appName + ".ear"
    options = [ 
                 "-usedefaultbindings",
                 "-nocreateMBeansForResources",
                 "-zeroEarCopy",
                 "-skipPreparation",
                 "-appname",                         appName, 
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

    #save()

    #startApplication(appName)

    print ""
    print scriptName + " INFO: installed " + appName + " to " + msg 


#------------------------------------------------------------------------------
# Start the application 
#------------------------------------------------------------------------------

def startApplication(appName):
 
    print "starting JobSchedulerMDILP"
    
    topology = getCellNodeServer()
    
    if topology[3] != "APPLICATION_SERVER":
	appManager = AdminControl.completeObjectName( "WebSphere:*,type=AppManagement,process=dmgr" )       
	parameters = "[ " +  appName + " null null ]"
	signature = "[ java.lang.String java.util.Hashtable java.lang.String ]"
	AdminControl.invoke( appManager, 'startApplication', parameters, signature )


#------------------------------------------------------------------------------
# Uninstall the JobSchedulerMDILP
#------------------------------------------------------------------------------

def uninstall(appName):
    try: 
        AdminApp.uninstall(appName)
        result = "removed"
    except:
        result = ""

    #if result == "removed":
        #save()

#------------------------------------------------------------------------------
# create the JMS resources
#------------------------------------------------------------------------------
def createResources(target,cfName,inputName,outputName,qmgrName,qmgrHost,qmgrPort,chName,inMQ,outMQ):

    createConnectionFactory(target,cfName,qmgrName,qmgrHost,qmgrPort,chName)
    createQueue(target,inputName,qmgrName,inMQ,qmgrHost,qmgrPort,chName,"JMS")
    createQueue(target,outputName,qmgrName,outMQ,qmgrHost,qmgrPort,chName,"MQ")

#------------------------------------------------------------------------------
# create the JMS resources
#------------------------------------------------------------------------------
def removeResources(target,connectionFactory,inputName,outputName):

    removeConnectionFactory(target,connectionFactory)
    removeQueue(target,inputName)
    removeQueue(target,outputName)

#------------------------------------------------------------------------------
# create the JMS Connection Factory
#------------------------------------------------------------------------------
def createConnectionFactory(target,cfName,qmgrName,qmgrHost,qmgrPort,chName):

    scope = AdminConfig.getid( target + "JMSProvider:WebSphere MQ JMS Provider" )
    name = ['name', cfName]
    jndi = ['jndiName', 'jms/'+cfName]
    desc = ['description',"This example ConnectionFactory uses the CLIENT transport type to connect to a Queue Manager on a remote system."]
    qmgr = ['queueManager', qmgrName]
    host = ['host', qmgrHost]
    port = ['port', qmgrPort]
    channel = ['channel', chName]
    transport = ['transportType', 'CLIENT']

    options = [name, jndi, desc, qmgr, host, port, channel, transport]
    # This was using the first template non-xa [0]
    template=AdminConfig.listTemplates('MQConnectionFactory').split(lineSeparator)[2]
    AdminConfig.createUsingTemplate('MQConnectionFactory', scope, options, template)
    print scriptName + " INFO: created MQ connection factory " + cfName
	#save()

#------------------------------------------------------------------------------
# remove the JMS Connection Factory
#------------------------------------------------------------------------------
def removeConnectionFactory(target,connectionFactory):

    result = ""

    try:
        scope = AdminConfig.getid( target )
        factoryList=AdminConfig.list("MQConnectionFactory",scope).split(lineSeparator)
        for factory in factoryList: 
		  if factory != "": 
			name=AdminConfig.showAttribute(factory,"name")
			if name == connectionFactory:
				AdminConfig.remove(factory)
		        	result = "removed"
				break
    except:
        result = ""

    if result == "removed":
        print scriptName + " INFO: removed MQ connection factory " + connectionFactory
        #save()

#------------------------------------------------------------------------------
# create the JMS Queue
#------------------------------------------------------------------------------
def createQueue(target,qname,qmgr,baseQ,qmgrHost,qmgrPort,chName,client):

    scope = AdminConfig.getid( target + "JMSProvider:WebSphere MQ JMS Provider" )
    name = ['name', qname]
    jndi = ['jndiName', "jms/"+qname]
    qmgr = ['baseQueueManagerName', qmgr]
    qn = ['baseQueueName', baseQ]
    qhost = ['queueManagerHost', qmgrHost]
    port = ['queueManagerPort',qmgrPort]
    channel = ['serverConnectionChannelName', chName]
    target = ['targetClient',client]
    options = [name, jndi, qmgr, qn, qhost, port, channel, target]
    template=AdminConfig.listTemplates('MQQueue').split(lineSeparator)[0]
    AdminConfig.createUsingTemplate('MQQueue', scope, options, template)
    print scriptName + " INFO: created JMS queue " + qname
    #save()

#------------------------------------------------------------------------------
# remove the JMS Queue
#------------------------------------------------------------------------------
def removeQueue(target,qname):

    result = ""

    try:
        scope = AdminConfig.getid( target )
	queueList=AdminConfig.list("MQQueue",scope).split(lineSeparator)
	for queue in queueList: 
		if queue != "": 
			name=AdminConfig.showAttribute(queue,"name")
			if name == qname:
				AdminConfig.remove(queue)
		        	result = "removed"
				break	

    except:

        result = ""

    if result == "removed":
        print scriptName + " INFO: removed MQ queue " + qname
        #save()

#------------------------------------------------------------------------------
# Create Listener Ports for cluster
#------------------------------------------------------------------------------
def createListenerPorts(cluster,node,server,connectionFactory,jmsQueue):

	if cluster != "":
		target = "/ServerCluster:" + cluster + "/"
		clusterID= AdminConfig.getid(target)
		clusterMembers= AdminConfig.list("ClusterMember",clusterID)
		clusterMemberList = clusterMembers.split(lineSeparator)

		for clusterMember in clusterMemberList:
			memberID = clusterMember.rstrip()
			memberName = AdminConfig.showAttribute(memberID, "memberName")
			memberNode = AdminConfig.showAttribute(memberID, "nodeName")
			target = "/Node:" + memberNode + "/Server:" + memberName + "/"
			serverID= AdminConfig.getid(target)
			createListenerPort(serverID,connectionFactory,jmsQueue)
		#end for
	else:
		target = "/Node:" + node + "/Server:" + server + "/"
		serverID= AdminConfig.getid(target)
		createListenerPort(serverID,connectionFactory,jmsQueue)
	#save()

#------------------------------------------------------------------------------
# Create Message Service Listener Port for server
#------------------------------------------------------------------------------
def createListenerPort(server,connectionFactory,queue):

	mls = AdminConfig.list('MessageListenerService', server)
	name= ['name', 'JobSchedulerListenerPort']
	cfJndiName= ['connectionFactoryJNDIName', "jms/"+connectionFactory]
	qJndiName= ['destinationJNDIName', "jms/"+queue]
	options= [name, qJndiName, cfJndiName]
	new = AdminConfig.create('ListenerPort', mls, options)
	AdminConfig.create('StateManageable', new, [['initialState', 'START']])

	sname= AdminConfig.showAttribute(server,'name')
        print scriptName + " INFO: added JobSchedulerListenerPort to server " + sname

#------------------------------------------------------------------------------
# Remove Listener Ports from cluster
#------------------------------------------------------------------------------
def removeListenerPorts(cluster,node,server,connectionFactory):

	if cluster != "":
		target = "/ServerCluster:" + cluster + "/"
		clusterID= AdminConfig.getid(target)
		clusterMembers= AdminConfig.list("ClusterMember",clusterID)
		clusterMemberList = clusterMembers.split(lineSeparator)

		for clusterMember in clusterMemberList:
			memberID = clusterMember.rstrip()
			memberName = AdminConfig.showAttribute(memberID, "memberName")
			memberNode = AdminConfig.showAttribute(memberID, "nodeName")
			target = "/Node:" + memberNode + "/Server:" + memberName + "/"
			serverID= AdminConfig.getid(target)
			removeListenerPort(serverID,connectionFactory)
		#end for
	else:
		target = "/Node:" + node + "/Server:" + server + "/"
		serverID= AdminConfig.getid(target)
		removeListenerPort(serverID,connectionFactory)
	#save()

#------------------------------------------------------------------------------
# Remove Message Service Listener Port from server
#------------------------------------------------------------------------------
def removeListenerPort(server,connectionFactory):

	ports = AdminConfig.list('ListenerPort', server).split(lineSeparator)

	for port in ports:
		if port != "": 
			name= AdminConfig.showAttribute(port,'name')
			if name == 'JobSchedulerListenerPort': 
				AdminConfig.remove(port)
				sname= AdminConfig.showAttribute(server,'name')
	        		print scriptName + " INFO: removed JobSchedulerListenerPort from server " + sname
				break

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

if len(sys.argv) < 1 or len(sys.argv) > 17:
	usage( "too many or too few arguments" )

args = getArgs()

action        = args[0]
cluster       = args[1]
node          = args[2]
server        = args[3]
qmgr          = args[4]
qhost         = args[5]
qport         = args[6]
channel       = args[7]
inQueue       = args[8]
outQueue      = args[9]

cell = AdminControl.getCell()
wasHome = getWASHome(cell,cluster,node)

inputQueue        = prefix + ".ListenerPortIncomingQueue"
outputQueue       = prefix + ".MQProviderOutputQueue"
connectionFactory = prefix + ".ListenerPortConnectionFactory"

if cluster != "":
    target = "/ServerCluster:" + cluster + "/"
else:
    target = "/Node:" + node + "/Server:" + server + "/"

if qport == "":
    qport = "1414"

print ""
print scriptName + " is performing " + action + " using "
print ""

print "  Target cluster or server : " + target
print "  MDI application name     : " + appName
print "  JMS connection factory   : " + connectionFactory
print "  JMS input queue name     : " + inputQueue
print "  JMS output queue name    : " + outputQueue
print "  Listener port name       : JobSchedulerListenerPort"

if action == "install":

    print "  MQ queue manager             : " + qmgr
    print "  MQ queue manager host        : " + qhost
    print "  MQ queue manager port        : " + qport
    print "  MQ server connection channel : " + channel
    print "  MQ input queue               : " + inQueue
    print "  MQ output queue              : " + outQueue

    install(wasHome,cell,cluster,node,server,appName)
    print "Done installing "+appName
    createResources(target,connectionFactory,inputQueue,outputQueue,qmgr,qhost,qport,channel,inQueue,outQueue)
    createListenerPorts(cluster,node,server,connectionFactory,inputQueue)
    save()
    print "Install complete."
else:
	print ""
	uninstall(appName)
	removeResources(target,connectionFactory,inputQueue,outputQueue)
	removeListenerPorts(cluster,node,server,connectionFactory)
	save()
	print "Remove complete."
