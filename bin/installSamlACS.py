#------------------------------------------------------------------------------
# Saml SP application deployment/undeployment script
#  install:
# wsadmin.sh -f installSamlACS.py install nodeName serverName
# wsadmin.sh -f installSamlACS.py install clusterName
#
#  uninstall:
# wsadmin.sh -f installSamlACS.py remove
#------------------------------------------------------------------------------
import sys

#------------------------------------------------------------------------------
# Get the directory, as a string, where WAS is installed.
#------------------------------------------------------------------------------
def getWASHome(cell, node):
	varMap = AdminConfig.getid("/Cell:" + cell + "/Node:" + node + "/VariableMap:/")
	entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
	eList = entries.splitlines()
	for entry in eList:
		name =  AdminConfig.showAttribute(entry, "symbolicName")
		if name == "WAS_INSTALL_ROOT":
			value = AdminConfig.showAttribute(entry, "value")
			return value
	#failover
	return java.lang.System.getenv('WAS_HOME')


#------------------------------------------------------------------------------
# Get the WAS installableApps directory.
#
# The WAS installableApps directory is always located at <WAS_HOME>/installableApps 
#------------------------------------------------------------------------------
def getinstallableAppsDir(cell, node):
	fileSep = getFileSep(node)
	return getWASHome(cell, node) + fileSep + "installableApps"

#------------------------------------------------------------------------------
# Get the directory, as a string, of the WebSphereSamlSP.ear application.
#
# The WebSphereSamlSP.ear is located in <WAS_HOME>/installableApps/WebSphereSamlSP.ear
#------------------------------------------------------------------------------
def getAppDir(cell, node):
	fileSep = getFileSep(node)
	return getinstallableAppsDir(cell, node) + fileSep + "WebSphereSamlSP.ear"

#------------------------------------------------------------------------------
# Get the file separator character
#
# This gets the file separator for the node in which we plan to install the
# application.  Therefore we can't just use the value that python on Java gives
# us.  Instead, check the platform of the node, and use "\" for windows and
# "/" for everything else.
#------------------------------------------------------------------------------
def getFileSep(node): 
	os = AdminTask.getNodePlatformOS("-nodeName " + node)
	if os == 'windows':
		return '\\'
	else:
		return '/'

#------------------------------------------------------------------------------
# deploy
# Deploy the WebSphereSamlSP.ear using the AdminApp install command.
#------------------------------------------------------------------------------
def deployACSApplication(cell, node, server):
	appDir  = getAppDir(cell, node)
	try:
		print "Deploying WebSphereSamlSP.ear"
		AdminApp.install(appDir, ['-node', node, '-server', server, '-appname', 'WebSphereSamlSP', '-usedefaultbindings'])
		
	
	
	except:
		error = str(sys.exc_info()[1])
		if error.count("7279E") > 0: # catch WASX7279E (app with given name already exists)
			print "Application is already installed."
		else:
			print "Exception occurred during installSamlACS(" + cell +", " + node + ", " + server + "):", error
		return 0
	return 1

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
# deploy
# Deploy the WebSphereSamlSP.ear using the AdminApp install command in cluster.
#------------------------------------------------------------------------------
def deployACSApplicationInCluster(cluster):
	appDir = java.lang.System.getenv('WAS_HOME') + "/installableApps/WebSphereSamlSP.ear"

	try:
		print "Deploying WebSphereSamlSP.ear"
		AdminApp.install(appDir, ['-cluster', cluster, '-appname', 'WebSphereSamlSP', '-usedefaultbindings'])
		
	
	
	except:
		error = str(sys.exc_info()[1])
		if error.count("7279E") > 0: # catch WASX7279E (app with given name already exists)
			print "Application is already installed."
		else:
			print "Exception occurred during installSamlACS(" + cell +", " + node + ", " + server + "):", error
		return 0
	return 1

#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------
def printUsage():
	print "Usage: wsadmin -f installSamlACS.py install appServer_NodeName appServer_ServerName"
	print "  or:  wsadmin -f installSamlACS.py install clusterName"
	print "  or:  wsadmin -f installSamlACS.py remove"
	print ""

#------------------------------------------------------------------------------
# Install the application
#------------------------------------------------------------------------------
def doInstall(nodeName,serverName):
	topology = getCellNodeServer()
	if topology == None:
		sys.stderr.write("Could not find suitable server\n")
		if failOnError == "true":
			sys.exit(105)
	else:
		cell = topology[0]
		#node = topology[1]
		#server = topology[2]
		type = topology[3]
                node = nodeName
                server = serverName

		#retVal = deployACSApplication(cell, node, server, type)
                retVal = deployACSApplication(cell, node, server)
		if retVal == 1:
			AdminConfig.save()
		else:
			print "Skipping Config Save"
			if failOnError == "true":
				sys.exit(109)


#------------------------------------------------------------------------------
# Uninstall the application
#------------------------------------------------------------------------------
def doRemove():
	AdminApp.uninstall("WebSphereSamlSP")
	AdminConfig.save()
	

#------------------------------------------------------------------------------
# Install the application in cluster environment
#------------------------------------------------------------------------------
def doClusterInstall(clusterName):
        retVal = deployACSApplicationInCluster(clusterName)
	if retVal == 1:
		AdminConfig.save()
	else:
		print "Skipping Config Save"
		if failOnError == "true":
	        	sys.exit(109)

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

failOnError = "false" 

if len(sys.argv) < 1 or len(sys.argv) > 3:
	sys.stderr.write("Invalid number of arguments\n")
	printUsage()
	sys.exit(101)	
else:
	mode = sys.argv[0]
        if mode == "install":
                if len(sys.argv) == 2:
                        clusterName = sys.argv[1]
		        print "Installing Saml ACS service..."
		        doClusterInstall(clusterName)
                elif len(sys.argv) == 3:
                        nodeName = sys.argv[1]
                        serverName = sys.argv[2]
		        print "Installing Saml ACS service..."
		        doInstall(nodeName,serverName)
                else:
                        sys.stderr.write("Invalid number of arguments\n")
	                printUsage()
	                sys.exit(101)    
	elif mode == "remove":
                print "Removing Saml ACS service..."
		doRemove()
	else:
		sys.stderr.write("Invalid command:  " + mode + "\n")
		printUsage()			
		if failOnError == "true":
			sys.exit(103)

