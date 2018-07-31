#------------------------------------------------------------------------------
# Script to install/configure JobSchedulerMDILP application. 
# 
#------------------------------------------------------------------------------

import sys, os
import java.lang.System  as  jsys
from java.net import InetAddress as InetAddress
from java.lang import System as System

lineSeparator  = jsys.getProperty('line.separator')
fileSeparator  = jsys.getProperty('file.separator')

defaultQualifier      = "com.ibm.ws.grid"
appName               = "JobSchedulerMDILP"
prefix		      = "com.ibm.ws.grid"
scriptName            = "installWSGridMQ.py"
mqlibVar	      = "WSGRID_MQLIB"

# Define False, True
(False,True)=(0,1)

# determine if we are on z or not. 
def isZOS():
    if System.getProperty("os.name")=="z/OS":
        return True
  
    return False  


#------------------------------------------------------------------------------
# Determine if we are on a host that is different than the one we are connected to.
# (If this is the case, which can happen with certain network configs on Z/OS, the commands
#  have to change a bit in order to still work. )
#------------------------------------------------------------------------------
def isOnDifferentHost():
  
    node=AdminControl.getNode()
    nodeId=AdminConfig.getid("/Node:"+node+"/")
    targetHostname= AdminConfig.showAttribute(nodeId,'hostName')    
    try:
        localHostname= InetAddress.getLocalHost().getCanonicalHostName()
    except: 
        localHostname="cannot_be_determined"
        
    if (localHostname.lower()) != (targetHostname.lower()):
        print "localHostname is: "  + localHostname
        print "targetHostname is: "  + targetHostname        
        if localHostname == "cannot_be_determined":
             print "isOnDifferentHost returns false because hostname cannot be determined"
             return False    
        else: 
             return True
        

#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------

def usage( msg ):
    print ""
    print scriptName + " : " + msg
    print ""
    print "Usage: wsadmin " + scriptName + " {<installation options>}" 
    print "                                  {<deployment target>}"
    print "                                  [<MQ config>]"
    print ""
    print "    <installation options> "
    print "          -install | -install <APP | MQ> "
    print "          -remove | -remove <APP | MQ>"
    print ""
    print "    <deployment target> = "
    print "         {-node <nodeName> -server <serverName> | -cluster <clusterName>}"
    print ""
    print "    <MQ config> = "
    print "         -qmgr <queue manager name>"
    print "         -inqueue <input queue name>"
    print "         -outqueue <output queue name>"
    print ""
    print "    Notes:"
    print "       1. -install option without APP/MQ parameter performs Application install and MQ install. "
    print "       2. -remove option without APP/MQ parameter performs Application remove and MQ remove." 
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
# Process the passed arguments
#------------------------------------------------------------------------------
def getArgs():


    actionType    = ""
    clusterName   = ""
    nodeName      = ""
    serverName    = ""
    qmgrName      = ""
    inQueueName   = ""
    outQueueName  = ""
    installOption = ""

    i = 0

    while i < len(sys.argv):

        if sys.argv[i] == "-install":
	    actionType = setOpt(actionType, "install")
	    i += 1
	    installOption = setArg(installOption, i)
	    if installOption.startswith('-'):
	        i -=1
	        installOption = ""
	    elif installOption not in ['APP', 'app', 'MQ', 'mq']:
	        usage("missing APP | MQ on -install option")
	elif sys.argv[i] == "-remove":
	    actionType = setOpt(actionType, "remove")
	    i += 1
   	    installOption = setArg(installOption, i)
	    if installOption.startswith('-'):
	        i -=1
	        installOption = ""
	    elif installOption not in ['APP', 'app', 'MQ', 'mq']:
        	usage("missing APP | MQ on -remove option")
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
        elif sys.argv[i] == "-inqueue":
            i += 1
            inQueueName = setArg(inQueueName, i)
        elif sys.argv[i] == "-outqueue":
            i += 1
            outQueueName = setArg(outQueueName, i)	    
        else:
            usage( "unrecognized argument: " + sys.argv[i] )

        i += 1

    if actionType == "":
        usage("missing -install or -remove")
        
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

    if installOption == "" or installOption in ['MQ', 'mq']:
        if qmgrName == "":
            usage ("missing -qmgr")
        if inQueueName == "":
            usage ("missing -inqueue")
        if outQueueName == "":
	    usage ("missing -outqueue")
			
    return (actionType, installOption, clusterName, nodeName, serverName, qmgrName, inQueueName, outQueueName)

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
    #earPath = "/tmp/JobSchedulerMDILP.ear"  # for testing remote install. 
    print "earPath is " + earPath

    options = [ 
                 "-usedefaultbindings",
                 "-nocreateMBeansForResources",
                 "-skipPreparation",
                 "-zeroEarCopy",                 
                 "-appname",                         appName, 
                 "-installed.ear.destination",       systemApps,
                 "-cell",                            cell, 
              ]
              
     # don't use the skipPreparation option if we think we're not on same host as target. 
     # TODO: since determining hostnames can be tricky, probably need to only do this if we're on Z as well, call isZOS
    if isOnDifferentHost() and isZOS(): 
        print "Adjusting install because wsadmin appears to be at different IP from target"
        jsys.setProperty("com.ibm.websphere.management.application.dfltbndng.mdb.preferexisting", "true")
        options = [ 
                     "-usedefaultbindings",
                     "-nocreateMBeansForResources",                     
                     "-zeroEarCopy",                 
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
def createResources(target,cfName,qName,qmgrName,baseQ):

    createConnectionFactory(target,cfName,qmgrName)
    createQueue(target,qName,qmgrName,baseQ)

#------------------------------------------------------------------------------
# create the JMS resources
#------------------------------------------------------------------------------
def removeResources(target,connectionFactory,jmsQueue):

    removeConnectionFactory(target,connectionFactory)
    removeQueue(target,jmsQueue)

#------------------------------------------------------------------------------
# create the JMS Connection Factory
#------------------------------------------------------------------------------
def createConnectionFactory(target,cfName,qmgrName):

	scope = AdminConfig.getid( target + "JMSProvider:WebSphere MQ JMS Provider" )
	name = ['name', cfName]
	jndi = ['jndiName', 'jms/'+cfName]
	qmgr = ['queueManager', qmgrName]
	options = [name, jndi, qmgr]
	template=AdminConfig.listTemplates('MQConnectionFactory').split(lineSeparator)[0]
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
def createQueue(target,qname,qmgr,baseQ):

	scope = AdminConfig.getid( target + "JMSProvider:WebSphere MQ JMS Provider" )
	name = ['name', qname]
	jndi = ['jndiName', "jms/"+qname]
	qmgr = ['baseQueueManagerName', qmgr]
	qn = ['baseQueueName', baseQ]
	options = [name, jndi, qmgr, qn]
	template=AdminConfig.listTemplates('MQQueue').split(lineSeparator)[0]
	AdminConfig.createUsingTemplate('MQQueue', scope, options, template)
	print scriptName + " INFO: created JMS queue " + qname
	#save()

#------------------------------------------------------------------------------
# create the JMS Queue
# createQueue(target,jmsInQueue,qmgrName,inQueue, 'JMS')
#------------------------------------------------------------------------------
def createQueue(target,qname,qmgr,baseQ,cTarget):

	scope = AdminConfig.getid( target + "JMSProvider:WebSphere MQ JMS Provider" )
	name = ['name', qname]
	jndi = ['jndiName', "jms/"+qname]
	qmgr = ['baseQueueManagerName', qmgr]
	qn = ['baseQueueName', baseQ]
        targetClient = ['targetClient', cTarget]
	options = [name, jndi, qmgr, qn, targetClient]
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
def removeListenerPorts(cluster,node,server,connectionFactory,jmsQueue):

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
			removeListenerPort(serverID,connectionFactory,jmsQueue)
		#end for
	else:
		target = "/Node:" + node + "/Server:" + server + "/"
		serverID= AdminConfig.getid(target)
		removeListenerPort(serverID,connectionFactory,jmsQueue)
	#save()

#------------------------------------------------------------------------------
# Remove Message Service Listener Port from server
#------------------------------------------------------------------------------
def removeListenerPort(server,connectionFactory,queue):

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
# Update WebSphere Variables
#------------------------------------------------------------------------------
def updateVariables(cluster,node,qmgr,qname,mqroot):

	# mqlibVar is variable name for mqlib value 
	mqlibVal=mqroot+"/java/lib"

	jvmopts="WAS_SERVER_ONLY_default_jvm_options"
	libpath1="WAS_SERVER_ONLY_control_region_libpath"
	libpath2="WAS_SERVER_ONLY_server_region_libpath"

	pathValue= ":${"+mqlibVar+"}"
	jvmoptValue= " -Dcom.ibm.ws.grid.qmgr.name="+qmgr+" -Dcom.ibm.ws.grid.output.queue="+qname
	jvmOpt="-Dws.ext.dirs"

	if cluster != "":
		target = "/ServerCluster:" + cluster + "/"
		clusterID= AdminConfig.getid(target)
		clusterMembers= AdminConfig.list("ClusterMember",clusterID)
		clusterMemberList = clusterMembers.split(lineSeparator)

		for clusterMember in clusterMemberList:
			memberID = clusterMember.rstrip()
			memberNode = AdminConfig.showAttribute(memberID, "nodeName")
			print scriptName + " INFO: updating variables for node "+memberNode
			target = "/Node:" + memberNode + "/"
			nodeID= AdminConfig.getid(target)
			# create mqlib variable
			addWebSphereVariable(memberNode, mqlibVar, mqlibVal)
			# append variables
			appendWebSphereVariable(nodeID, libpath1, pathValue)
			appendWebSphereVariable(nodeID, libpath2, pathValue)
			appendWebSphereVariable(nodeID, jvmopts, jvmoptValue)
			appendJvmOption(nodeID,jvmOpt,pathValue) 

		#end for
	else:
		print scriptName + " INFO: updating variables for node "+node
		target = "/Node:" + node + "/"
		nodeID= AdminConfig.getid(target)
		# create mqlib variable
		addWebSphereVariable(node, mqlibVar, mqlibVal)		
		# append variables
		appendWebSphereVariable(nodeID, libpath1, pathValue)
		appendWebSphereVariable(nodeID, libpath2, pathValue)
		appendWebSphereVariable(nodeID, jvmopts, jvmoptValue)
		appendJvmOption(nodeID,jvmOpt,pathValue) 

	#save()

#------------------------------------------------------------------------------
# add WebSphere Variable
#------------------------------------------------------------------------------
def addWebSphereVariable(nodeName, varName, varValue):

	map= AdminConfig.getid("/Node:"+nodeName+"/VariableMap:/")

	name= ["symbolicName",varName]
	value= ["value",varValue]
	descr= ["description","WSGrid configuration variable"]
	opt= [name,value,descr]

	AdminConfig.create("VariableSubstitutionEntry",map,opt)
	print scriptName + " INFO: created node "+nodeName+" variable "+varName+" with "+varValue

#------------------------------------------------------------------------------
# append WebSphere Variable
#------------------------------------------------------------------------------
def appendWebSphereVariable(node, varName, appendValue):

	varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",node).split(lineSeparator)

	for varSubst in varSubstitutions:

		getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
		getVarValue = AdminConfig.showAttribute(varSubst, "value")
		if getVarName == varName:
			newVarValue= getVarValue+appendValue
			AdminConfig.modify(varSubst,[["value", newVarValue]])
			nodeName= AdminConfig.showAttribute(node,'name')
        		print scriptName + " INFO: appended node "+nodeName+" variable "+varName+" with "+appendValue
			break


#------------------------------------------------------------------------------
# append ext dirs in default jvm options 
#------------------------------------------------------------------------------
def appendJvmOption(nodeID,jvmOpt,optVal):

	optVarName="WAS_SERVER_ONLY_default_jvm_options"

	varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",nodeID).split(lineSeparator)

	for varSubst in varSubstitutions:
		getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
		getVarValue = AdminConfig.showAttribute(varSubst, "value")
		if getVarName == optVarName:
			symbols= getVarValue.split(" ")
			jvmOpts=""
			for i in range(0,len(symbols)):
				symbol= symbols[i]
				compare=symbol[0:13]
				if compare == jvmOpt: 
					symbol=symbol+optVal
					print scriptName + " INFO: appending "+optVal+" to "+jvmOpt
				jvmOpts=jvmOpts+" "+symbol
			AdminConfig.modify(varSubst,[["value", jvmOpts]])
			break	

#------------------------------------------------------------------------------
# Update WebSphere Variables
#------------------------------------------------------------------------------
def removeVariables(cluster,node):
	
	if cluster != "":
		target = "/ServerCluster:" + cluster + "/"
		clusterID= AdminConfig.getid(target)
		clusterMembers= AdminConfig.list("ClusterMember",clusterID)
		clusterMemberList = clusterMembers.split(lineSeparator)

		for clusterMember in clusterMemberList:
			memberID = clusterMember.rstrip()
			memberNode = AdminConfig.showAttribute(memberID, "nodeName")
			print scriptName + " INFO: updating variables for node "+memberNode
			target = "/Node:" + memberNode + "/"
			nodeID= AdminConfig.getid(target)
			removeVariableGroup(nodeID)
		#end for
	else:
		print scriptName + " INFO: updating variables for node "+node
		target = "/Node:" + node + "/"
		nodeID= AdminConfig.getid(target)	
		removeVariableGroup(nodeID)


#------------------------------------------------------------------------------
# remove variable group
#------------------------------------------------------------------------------
def removeVariableGroup(nodeID):

	# remove WSGRID_MQLIB
	# remove -Dcom.ibm.ws.grid.qmgr.name and -Dcom.ibm.ws.grid.output.queue from 
	#	WAS_SERVER_ONLY_default_jvm_options
	# remove ${WSGRID_MQLIB} from 
	#	WAS_SERVER_ONLY_default_jvm_options
	#	WAS_SERVER_ONLY_control_region_libpath	
	#	WAS_SERVER_ONLY_server_region_libpath

	varName="WSGRID_MQLIB"
	removeWebSphereVariable(nodeID, varName)

	varName= "WAS_SERVER_ONLY_default_jvm_options"
	removeValue= "-Dcom.ibm.ws.grid.qmgr.name="
	removeWebSphereVariableValue(nodeID, varName, removeValue, " ")

	varName= "WAS_SERVER_ONLY_default_jvm_options"
	removeValue= "-Dcom.ibm.ws.grid.output.queue="
	removeWebSphereVariableValue(nodeID, varName, removeValue, " ")

	varName= "WAS_SERVER_ONLY_control_region_libpath"
	removeValue= "${WSGRID_MQLIB}"
	removeWebSphereVariableValue(nodeID, varName, removeValue, ":")

	varName= "WAS_SERVER_ONLY_server_region_libpath"
	removeValue= "${WSGRID_MQLIB}"
	removeWebSphereVariableValue(nodeID, varName, removeValue, ":")

	removeValue= "${WSGRID_MQLIB}"
	removeVariableValueFromExtDirs(nodeID, removeValue)

#------------------------------------------------------------------------------
# remove WebSphere Variable
#------------------------------------------------------------------------------
def removeWebSphereVariable(nodeID, varName):

	varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",nodeID).split(lineSeparator)

	for varSubst in varSubstitutions:
		getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
		if getVarName == varName:
			AdminConfig.remove(varSubst)
        		print scriptName + " INFO: removing variable "+varName+" from node "+nodeName
			break

#------------------------------------------------------------------------------
# remove value from WebSphere Variable
#------------------------------------------------------------------------------
def removeWebSphereVariableValue(nodeID, varName, removeValue, delimiter):

	varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",nodeID).split(lineSeparator)

	for varSubst in varSubstitutions:
		getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
		getVarValue = AdminConfig.showAttribute(varSubst, "value")
		if getVarName == varName:
			print scriptName + " INFO: removing "+removeValue+" from "+varName
			updateVal= removeFromString(getVarValue,removeValue,delimiter)
			AdminConfig.modify(varSubst,[["value", updateVal]])
			break	

#------------------------------------------------------------------------------
# remove value from zOS ext dirs 
#------------------------------------------------------------------------------
def removeVariableValueFromExtDirs(nodeID, removeValue):

	varName= "WAS_SERVER_ONLY_default_jvm_options"
	option= "-Dws.ext.dirs"
	delimiter= ":"

	varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",nodeID).split(lineSeparator)

	for varSubst in varSubstitutions:
		getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
		getVarValue = AdminConfig.showAttribute(varSubst, "value")
		if getVarName == varName:
			# getVarName = WAS_SERVER_ONLY_default_jvm_options
			# getVarValue = -Dprop1=val1 -Dprop2=val2 -Dprop3=val3
			symbols= getVarValue.split(" ")
			updateVal=""
			for i in range(0,len(symbols)):
				symbol= symbols[i]
				compare=symbol[0:len(option)]
				if compare == option: 					
					tempVal= removeValueFromOption(symbol, removeValue, delimiter)
				else: 
					tempVal= symbol

				if updateVal == "":
					updateVal= tempVal
				else:
					updateVal=updateVal+" "+tempVal

			print scriptName + " INFO: removing "+removeValue+" from "+option
			AdminConfig.modify(varSubst,[["value", updateVal]])	
			break	

#------------------------------------------------------------------------------
# remove value from jvm options
#------------------------------------------------------------------------------
# option= -Dws.ext.dirs=dir1:dir2:dir3 ...
# removeValue= dir2
# delimiter= :
def removeValueFromOption(option, removeValue, delimiter):

	optionParts = option.split("=")
	optionValue= optionParts[1]
	updateVal= removeFromString(optionValue,removeValue,delimiter)	
	retVal= optionParts[0]+"="+updateVal

	return retVal

#------------------------------------------------------------------------------
# remove value from string
#------------------------------------------------------------------------------
def removeFromString(stringVar, removeValue, delimiter):

	symbols= stringVar.split(delimiter)
	updateVal=""
	for i in range(0,len(symbols)):
		symbol= symbols[i]
		compare=symbol[0:len(removeValue)]
		if compare != removeValue: 
			if updateVal == "":
				updateVal=symbol
			else:
				updateVal=updateVal+delimiter+symbol

	return updateVal

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

if len(sys.argv) < 1 or len(sys.argv) > 14:
	usage( "too many or too few arguments" )
    


args = getArgs()

action        = args[0]
installOption = args[1]
cluster       = args[2]
node          = args[3]
server        = args[4]
qmgr          = args[5]
inQueue       = args[6]
outQueue      = args[7]

cell = AdminControl.getCell()
wasHome = getWASHome(cell,cluster,node)

connectionFactory 	= prefix + ".ListenerPortConnectionFactory"
jmsInQueue		= prefix + ".ListenerPortIncomingQueue"
jmsOutQueue = prefix + ".MQProviderOutputQueue"

if cluster != "":
    target = "/ServerCluster:" + cluster + "/"
else:
    target = "/Node:" + node + "/Server:" + server + "/"

print ""
print scriptName + " is performing " + action + " using "
print ""

print "  Target cluster or server : " + target
print "  MDI application name     : " + appName
print "  JMS connection factory   : " + connectionFactory
print "  JMS input queue name     : " + jmsInQueue
print "  JMS output queue name     : " + jmsOutQueue
print "  Listener port name       : JobSchedulerListenerPort"
print "  MQ queue manager         : " + qmgr
print "  MQ input queue           : " + inQueue
print "  MQ output queue          : " + outQueue


if action == "install":
	print ""
	if installOption in ['APP', 'app']:
		if qmgr != "" or inQueue != "" or outQueue != "":
				print ""
				print "INFO:  MQ information ignored when doing application only install(-install APP option)"
				print ""
		install(wasHome,cell,cluster,node,server,appName)
		print "Done installing "+appName
	elif installOption in ['MQ', 'mq']:
        	createConnectionFactory(target,connectionFactory,qmgr);
        	createQueue(target,jmsInQueue,qmgr,inQueue, 'JMS')
        	createQueue(target,jmsOutQueue,qmgr,outQueue, 'MQ')
		createListenerPorts(cluster,node,server,connectionFactory,jmsInQueue)
	else:
		install(wasHome,cell,cluster,node,server,appName)
		print "Done installing "+appName
	        createConnectionFactory(target,connectionFactory,qmgr);
	        createQueue(target,jmsInQueue,qmgr,inQueue, 'JMS')
	        createQueue(target,jmsOutQueue,qmgr,outQueue, 'MQ')
		createListenerPorts(cluster,node,server,connectionFactory,jmsInQueue)
	
	save()
	print "Install complete."
else:
	print ""
	if installOption in ['APP', 'app']:
		if qmgr != "" or inQueue != "" or outQueue != "":
			print ""
			print "INFO:  MQ information ignored when doing application only remove(-remove APP option)"
			print ""
		uninstall(appName)
	elif installOption in ['MQ', 'mq']:
 		removeConnectionFactory(target,connectionFactory)       
		removeQueue(target, jmsInQueue)
        	removeQueue(target, jmsOutQueue)
		removeListenerPorts(cluster,node,server,connectionFactory,jmsInQueue)
	else:
		uninstall(appName)
	 	removeConnectionFactory(target,connectionFactory)       
		removeQueue(target, jmsInQueue)
	        removeQueue(target, jmsOutQueue)
		removeListenerPorts(cluster,node,server,connectionFactory,jmsInQueue)
		
	save()
	print "Remove complete."

