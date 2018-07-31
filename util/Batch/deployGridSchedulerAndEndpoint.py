import sys
import os

lineSep = java.lang.System.getProperty('line.separator')

defaultGridJDCProviderName = "Default Grid Derby JDBC Provider (XA)"

def getCellLevelJDBCProvider():
        providerName = "Derby JDBC Provider 40 Only (XA)"
        cellid = AdminConfig.getid("/Cell:/")
        providers = AdminConfig.listTemplates("JDBCProvider")
        providersList = providers.split(lineSeparator)
	
        for provider in providersList:
		pname = AdminConfig.showAttribute(provider, "name")
		if (pname == providerName):
			return provider
	return None


def createCellLevelJDBCProvider():
	# create a new provider if one doesn't exist already
	provider = getCellLevelJDBCProvider()
	if (provider <> None):
		name = ["name", defaultGridJDCProviderName]
                desc = ["description", "Default Grid Derby JDBC Provider (XA) for Scheduler and Grid Endpoint"]
		jdbcAttrs = [name, desc]
                cellid = AdminConfig.getid("/Cell:/")
		newProvider = AdminConfig.createUsingTemplate("JDBCProvider", cellid, jdbcAttrs, provider)
		print("new JDBC provider created... " + newProvider)
	        return newProvider
        return provider
	
 	   
def createDefaultDataSource(provider, dsName, dsJNDIName):
	dss = AdminConfig.list("DataSource")
    	dsList = dss.split(lineSeparator)
    
    	for ds in dsList:
           if (ds <> ""):
		existingDSJNDIName = AdminConfig.showAttribute(ds, "jndiName")
		if (existingDSJNDIName == dsJNDIName):
			print("datasource already exists... skipping creation :" + ds)
			return ds
                        
	name = ["name", dsName]
	jndiName = ["jndiName", dsJNDIName]
	
	if (dsName == "PGC"):
		desc = ["description", "Job scheduler data source"]
	else :
		desc = ["description", "Grid endpoint data source"]
	
	dsAttrs = [name, jndiName, desc]
	newDS = AdminConfig.create("DataSource", provider, dsAttrs)
        #PGC db name is LRSCHED
        if (dsName == "PGC"):
           updateDSCustomProperty(newDS, "LRSCHED")
        else:
	   updateDSCustomProperty(newDS, dsName)

	return newDS

def updateDSCustomProperty(newDS, dsName):
	propSet = AdminConfig.showAttribute(newDS, "propertySet")
        print("new data source " + newDS)
        if (propSet == None):
                print("propSet is None")
                rpsAttrs = []
                propSet = AdminConfig.create("J2EEResourcePropertySet", newDS, rpsAttrs)
        else :
                print("property set... " + propSet)
                
        dbPath = "${USER_INSTALL_ROOT}/gridDatabase/" + dsName
	name = ["name", "databaseName"]
        value = ["value", dbPath]
	rpAttrs = [name, value]
	AdminConfig.create("J2EEResourceProperty", propSet, rpAttrs)

def removeCellLevelJDBCProvider():
        provider = getCellLevelJDBCProvider()
        if (provider <> None):
                AdminConfig.remove(provider)
        return
	
def removeDefaultDataSource(provider, dsName):
	return


def getWASHome(cell, node):
	varMap = AdminConfig.getid("/Cell:" + cell + "/Node:" + node + "/VariableMap:/")
	entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
	eList = entries.split(lineSep)
	for entry in eList:
		name =  AdminConfig.showAttribute(entry, "symbolicName")
		if name == "WAS_INSTALL_ROOT":
			value = AdminConfig.showAttribute(entry, "value")
			return value
	#failover
	return java.lang.System.getenv('WAS_HOME')



def getSystemAppsDir(cell, node):
	fileSep = getFileSep(node)
	return getWASHome(cell, node) + fileSep + "systemApps"


def getSchedDir(cell, node):
	fileSep = getFileSep(node)
	return getSystemAppsDir(cell, node) + fileSep + "LongRunningScheduler.ear"

def getPGCProxyControllerDir(cell, node):
	fileSep = getFileSep(node)
	return getSystemAppsDir(cell, node) + fileSep + "PGCProxyController.ear"


def getEndpointDir(cell, node):
	fileSep = getFileSep(node)
	return getSystemAppsDir(cell, node) + fileSep + "PGCController.ear"


def getFileSep(node): 
	os = AdminTask.getNodePlatformOS("-nodeName " + node)
	if os == 'windows':
		return '\\'
	else:
		return '/'


def setClassLoaderOrder():

	print "in setClassLoaderOrder"

	#get configuration ID for LongRunningScheduler
	configId = AdminConfig.getid("/Deployment:LongRunningScheduler/")   		

	#return if can not find config id
	if configId == None or configId == "":
		print "Could not find config id for LongRunningScheduler"
		return -1

	#get the list of web module of this application
	webModules = AdminConfig.list("WebModuleDeployment", configId)

	iehsModule=""
	webModulesList = webModules.split(lineSep)
	for entry in webModulesList:
		uri = AdminConfig.showAttribute(entry,"uri")
		if "iehs.war" == uri:
			#print "found iehs.war"
			iehsModule = entry
			break
	
	#return if can not find web module that we need	
	if iehsModule == "":
		print "Failed to find IEHS module"
		return -1
			
	classldr = AdminConfig.showAttribute(iehsModule, "classloader")
	#print classldr
	
	#if no existing classloader config object, create one
	#change mode to PARENT_LAST
	if classldr == "" or classldr == None:
		AdminConfig.create("Classloader",iehsModule,'[[mode PARENT_LAST]]')
	else:
		AdminConfig.modify(classldr , [['mode', 'PARENT_LAST']])

	AdminConfig.save()
	
	#print AdminConfig.showall(iehsModule);
	return 1


def deployScheduler(cell, node, server):
	schedDir  = getSchedDir(cell, node)
	sysAppDir  = getSystemAppsDir(cell, node)
	try:
		print "Deploying LongRunningScheduler.ear"
		appListString = AdminApp.list("WebSphere:cell=" + cell + ",node=" + node + ",server=" + server)
		appList = appListString.splitlines()
		if "LongRunningScheduler" in appList:
			print "Scheduler is already installed."
			return 1
		AdminApp.install(schedDir, ['-node', node, '-server', server, '-appname', 'LongRunningScheduler', '-usedefaultbindings', '-zeroEarCopy', '-installed.ear.destination', sysAppDir, '-MapRolesToUsers', '[["lradmin" Yes Yes "" ""]]'])
		
		#Do virtual host mapping
		print "Mapping LongRunningScheduler to default_host"
		AdminApp.edit('LongRunningScheduler', ['-MapWebModToVH', [['.*', '.*', 'default_host']]])

		#set classLoader order for web module iehs to PARENT_LAST
		setClassLoaderOrder()

	except:
		print "Exception occurred during deployScheduler(" + cell +", " + node + ", " + server + "):", sys.exc_info()
		return -1
	return 1

def deployPGCProxyController(cell, node, server):
	schedDir  = getPGCProxyControllerDir(cell, node)
	sysAppDir  = getSystemAppsDir(cell, node)
	try:
		print "Deploying PGCProxyController.ear"
		appListString = AdminApp.list("WebSphere:cell=" + cell + ",node=" + node + ",server=" + server)
		appList = appListString.splitlines()
		if "PGCProxyController" in appList:
			print "PGCProxyController is already installed."
			return 1
		AdminApp.install(schedDir, ['-node', node, '-server', server, '-appname', 'PGCProxyController', '-usedefaultbindings', '-zeroEarCopy', '-installed.ear.destination', sysAppDir])
		
		#Do virtual host mapping
		print "Mapping PGCProxyController to default_host"
		AdminApp.edit('PGCProxyController', ['-MapWebModToVH', [['.*', '.*', 'default_host']]])

		#set classLoader order for web module iehs to PARENT_LAST
		setClassLoaderOrder()

	except:
		print "Exception occurred during deployScheduler(" + cell +", " + node + ", " + server + "):", sys.exc_info()
		return -1
	return 1

def deployEndpoint(cell, node, server):
	endpointDir  = getEndpointDir(cell, node)
	sysAppDir  = getSystemAppsDir(cell, node)
	try:
		print "Deploying PGCController.ear"
		appListString = AdminApp.list("WebSphere:cell=" + cell + ",node=" + node + ",server=" + server)
		appList = appListString.splitlines()
		if "PGCController" in appList:
			print "Endpoint is already installed."
			return 1
		AdminApp.install(endpointDir, ['-node', node, '-server', server, '-appname', 'PGCController', '-usedefaultbindings', '-zeroEarCopy', '-installed.ear.destination', sysAppDir])
		
		#Do virtual host mapping
		print "Mapping PGCController to default_host"
		AdminApp.edit('PGCController', ['-MapWebModToVH', [['.*', '.*', 'default_host']]])
	except:
		print "Exception occurred during deployEndpoint(" + cell +", " + node + ", " + server + "):", sys.exc_info()
		return -1
	return 1




#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

cell = None
node = None
server = None

# set cell and node name 
cellObj = AdminConfig.list("Cell")
cell = AdminConfig.showAttribute(cellObj, "name")

nodeObj = AdminConfig.list("Node", cellObj)
node = AdminConfig.showAttribute(nodeObj,"name")



# Try to get server from command-line arguments
i = 0
while i < len(sys.argv):
	if sys.argv[i] == "-server": 
		server = sys.argv[i + 1]	
	i = i + 1

if server == None:
	print "Defaulting to server1. Please specify a server with the \'-server\' option to configure grid scheduler and endpoint on a different server."
        server = "server1"
else:
        print "configuring scheduler and endpoint on the provided server"
        
print "Cell:  " + cell + ", Node:  " + node + ", Server:  " + server
	
# create JDBCProvider and data source for PGC and LRSCHED
print("Creating Default Derby JDBC Provider ... ")
provider = createCellLevelJDBCProvider()

print("Creating Derby DataSource for PGC ... ")
createDefaultDataSource(provider, "PGC", "jdbc/pgc")

print("Creating Derby DataSource for LRS ... ")
createDefaultDataSource(provider, "LRSCHED", "jdbc/lrsched")	

if server != None and cell != None and node != None:
    
    retVal = deployScheduler(cell, node, server)
    if retVal == 1:
        retVal = deployEndpoint(cell, node, server)
        if retVal == 1:
            retVal = deployPGCProxyController(cell, node, server)
        else:
            print "Skipping PGC Proxy Controller installation"
    else:
        print "Skipping Endpoint and PGC Proxy installation"
    if retVal == 1:
        print "Saving Config..."
        AdminConfig.save()
        print "Saved Config"
    else:
        print "Skipping Config save"
