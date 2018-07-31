#------------------------------------------------------------------------------
# Admin console deployment/undeployment script
#
# Installing the console:
# wsadmin.sh -f deployConsole.py install
#
# Uninstalling the console:
# wsadmin.sh -f deployConsole.py remove
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
# Get the WAS systemApps directory.
#
# The WAS systemApps directory is always located at <WAS_HOME>/systemApps 
#------------------------------------------------------------------------------
def getSystemAppsDir(cell, node):
	fileSep = getFileSep(node)
	return getWASHome(cell, node) + fileSep + "systemApps"

#------------------------------------------------------------------------------
# Get the directory, as a string, of the isclite.ear application.
#
# The isclite.ear is located in <WAS_HOME>/systemApps/isclite.ear
#------------------------------------------------------------------------------
def getISCDir(cell, node):
	fileSep = getFileSep(node)
	return getSystemAppsDir(cell, node) + fileSep + "isclite.ear"

#------------------------------------------------------------------------------
# Get the file separator character
#
# This gets the file separator for the node in which we plan to install the
# console.  Therefore we can't just use the value that python on Java gives
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
# updateDeploymentXml 
# sharedLibBypass = true
# Console doesn't work with enableSecurityIntegration=true
# Default cookie path should be /ibm
#------------------------------------------------------------------------------
def updateDeploymentXml():
	try:
		print "Updating deployment.xml"
		isclite = AdminConfig.getid("/Deployment:isclite/")
		iscliteDepObject = AdminConfig.showAttribute(isclite, "deployedObject")
		prop = [['name', 'com.ibm.ws.classloader.sharedLibBypass'], ['value', 'true'], ['required', 'false']]
		AdminConfig.create("Property", iscliteDepObject, prop)
		attr1 = ['enableSecurityIntegration', 'false']
		attrs = [attr1]
		sessionMgr = [['sessionManagement', attrs]]
		configs = AdminConfig.showAttribute (iscliteDepObject, "configs")
		appConfig = configs[1:len(configs)-1] 
		SM = AdminConfig.showAttribute (appConfig, 'sessionManagement') 
		AdminConfig.modify (SM, attrs)
		kuke = AdminConfig.showAttribute (SM, 'defaultCookieSettings')
		kukeAttrs = [['path', '/ibm']]
		AdminConfig.modify(kuke, kukeAttrs)
		return 1
	except:
		print "Error during updateDeploymentXml():", sys.exc_info()
		return 0	

#------------------------------------------------------------------------------
# setupIEHSClassloader 
# Set the classloader for IEHS to PARENT_LAST
#------------------------------------------------------------------------------
def setupIEHSClassloader():
	print "Setting IEHS classloader to PARENT_LAST"
	isclite = AdminConfig.getid("/Deployment:isclite/")
	iscliteDepObject = AdminConfig.showAttribute(isclite, "deployedObject")
	modules =  AdminConfig.list("WebModuleDeployment", iscliteDepObject).splitlines()
	for module in modules:
		if AdminConfig.showAttribute(module, "uri") == "iehs.war":
			AdminConfig.modify(module, [['classloaderMode', 'PARENT_LAST']])
			return 1
	#return 0 for failure
	return 0	

#------------------------------------------------------------------------------
# setCellVar 
#------------------------------------------------------------------------------
def setCellVar(cell):
	try:
		varMap = AdminConfig.getid("/Cell:" + cell + "/VariableMap:/")
		prop = [[['symbolicName', 'WAS_CELL_NAME'], ['value', cell]]]
		AdminConfig.modify(varMap, [['entries', prop]])	
		return 1
	except:
		print "Error during setCellVar(" + cell + "):", sys.exc_info()
		return 0



#------------------------------------------------------------------------------
# deployAdminConsole
# Deploy the isclite.ear using the AdminApp install command, and then map it
# to the admin_host virtual host.
#------------------------------------------------------------------------------
def deployAdminConsole(cell, node, server, type):
	iscDir  = getISCDir(cell, node)
	sysAppDir  = getSystemAppsDir(cell, node)
	try:
		print "Deploying isclite.ear"
		AdminApp.install(iscDir, ['-node', node, '-server', server, '-appname', 'isclite', '-usedefaultbindings', '-copy.sessionmgr.servername', server, '-zeroEarCopy', '-skipPreparation', '-installed.ear.destination', '$(WAS_INSTALL_ROOT)/systemApps'])
		
        #Do virtual host mapping
		print "Mapping isclite to admin_host"
		AdminApp.edit('isclite', ['-MapWebModToVH', [['.*', '.*', 'admin_host']]])
	except:
		error = str(sys.exc_info()[1])
		if error.count("7279E") > 0: # catch WASX7279E (app with given name already exists)
			print "Admin console is already installed."
		else:
			print "Exception occurred during deployAdminConsole(" + cell +", " + node + ", " + server + "):", error
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
			elif AdminConfig.showAttribute(serverId, "serverType") == "ADMIN_AGENT":
				return (cell, node, serverName, "ADMIN_AGENT") 
	return None	
		

#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------
def printUsage():
	print "Usage: wsadmin deployConsole.py install"
	print "  or:  wsadmin deployConsole.py remove"
	print ""

#------------------------------------------------------------------------------
# Install the admin console
#------------------------------------------------------------------------------
def doInstall():
	topology = getCellNodeServer()
	if topology == None:
		sys.stderr.write("Could not find suitable server\n")
		if failOnError == "true":
			sys.exit(105)
	else:
		cell = topology[0]
		node = topology[1]
		server = topology[2]
		type = topology[3]

		retVal = deployAdminConsole(cell, node, server, type)
		if retVal == 1:
			retVal = updateDeploymentXml()
		#if retVal == 1:
		#	retVal = setCellVar(cell)
		if retVal == 1:
			retVal = setupIEHSClassloader()
		if retVal == 1:
			AdminConfig.save()
		else:
			print "Skipping Config Save"
			if failOnError == "true":
				sys.exit(109)


#------------------------------------------------------------------------------
# Uninstall the admin console
#------------------------------------------------------------------------------
def doRemove():
	AdminApp.uninstall("isclite")
	AdminConfig.save()
	

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

failOnError = "false" 

if len(sys.argv) < 1 or len(sys.argv) > 2:
	sys.stderr.write("Invalid number of arguments\n")
	printUsage()
	sys.exit(101)	
else:
	if len(sys.argv) == 2:
		if sys.argv[1] == "-failonerror":
			failOnError = "true"
			print "failonerror is enabled"
		else:
			sys.stderr.write("Invalid option:  " + sys.argv[1] + "\n")
			printUsage()			
			sys.exit(102)

	mode = sys.argv[0]
	if mode == "install":
		print "Installing Admin Console..."
		doInstall()
	elif mode == "remove":
		print "Removing Admin Console..."
		doRemove()
	else:
		sys.stderr.write("Invalid command:  " + mode + "\n")
		printUsage()			
		if failOnError == "true":
			sys.exit(103)

