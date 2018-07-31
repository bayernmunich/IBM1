#=======================================================================================================================================================
#(C) Copyright IBM Corp. 2012 - All Rights Reserved.
#DISCLAIMER:
#The following source code is sample code created by IBM Corporation.
#This sample code is provided to you solely for the purpose of assisting you
#in the  use of  the product. The code is provided 'AS IS', without warranty or
#condition of any kind. IBM shall not be liable for any damages arising out of your
#use of the sample code, even if IBM has been advised of the possibility of
#such damages.
#=======================================================================================================================================================

#=======================================================================================================================================================
# This file contains a series of operations to create share library for the WCG 8.0.0.x Scheduler servers and WCG 8.0.0.x Endpoint
#
#=======================================================================================================================================================

import sys
lineSeparator = java.lang.System.getProperty("line.separator")
fileSeparator = java.lang.System.getProperty("file.separator")


#----------------------------
# print help 
#----------------------------
def printHelp():
	print """
	Show help:
		>> wsadmin -lang jython -f configureCGSharedLib.py --help
	
	Configure shared library to all target:
		>> wsadmin -lang jython -f configCGSharedLib.py -sharedLibraryName libName -sharedLibraryPath sharedLibpath

	Example:
		wsadmin -lang jython -f configCGSharedLib.py -sharedLibrayName spiSharedLib -sharedLibraryPath c:/sharedLib/spi.jar
		
	Configure shared library to specific cluster target(s):
		>> wsadmin -lang jython -f configCGSharedLib.py -sharedLibraryName libName -sharedLibraryPath sharedLibpath -clusterList cluster1,cluster2
		
	Example:
		wsadmin -lang jython -f configCGSharedLib.py -sharedLibrayName spiSharedLib -sharedLibraryPath c:/sharedLib/spi.jar -clusterList Cluster1,Cluster2	

	NOTE:  When specifying the clusterList parameters, entries must be comma delimited with no spaces. 
	
	Configure shared library to specific standalone server target:
		>> wsadmin -lang jython -f configCGSharedLib.py -sharedLibraryName libName -sharedLibraryPath sharedLibpath -serverList server1
			
	Example:
		wsadmin -lang jython -f configCGSharedLib.py -sharedLibrayName spiSharedLib -sharedLibraryPath c:/sharedLib/spi.jar -serverList server1	

	You may have to modify wsadmin to wsadmin.sh or wsadmin.bat, depending upon your operating environment
	"""

def getArgs():

	#print "in getArgs"
	i = 0
	sharedLibName = ""
	sharedLibPath = ""
	clusterString = ""
	serverString = ""
	clusterList = []
	serverList = []

	while i < len(sys.argv):
		if sys.argv[i] == "-sharedLibraryName":
			i += 1
			sharedLibName = sys.argv[i]
			#print "sharedLibName = " + sharedLibName
			
		elif sys.argv[i] == "-sharedLibraryPath":
			i += 1
			sharedLibPath = sys.argv[i]
			#print "sharedLibPath = " + sharedLibPath
			
		elif sys.argv[i] == "-clusterList":
			i += 1
			input = len(sys.argv) - i
			if input == 0:
				print "Invalid argument - no list parameters specified"
				raise SystemExit()
			elif input == 1:
				clusterString = sys.argv[i]
				clusterList = clusterString.split(",")
			else:
				print "Invalid argument - whitespace encountered in cluster parameter list"
				raise SystemExit()
					
		elif sys.argv[i] == "-serverList":
			i += 1
			input = len(sys.argv) - i
			if input == 0:
				print "Invalid argument - no list parameters specified"
				raise SystemExit()
			elif input == 1:
				serverString = sys.argv[i]
				serverList = serverString.split(",")
			else:
				print "Invalid argument - whitespace encountered in server parameter list"
				raise SystemExit()
		else:
			print "Unrecognized argument: " + sys.argv[i]

		i += 1

	return (sharedLibName, 	sharedLibPath, clusterList, serverList)	
	
def getTargets():
    
	#print "Getting PGCController targets..."
	targetList = []
	try:
		list = AdminConfig.list('Deployment')
        	results = list.split(lineSeparator)
		for result in results: 
            		appls = result.split("(")        
			name = appls[0].split("_")
			if name[0] == "PGCController":
	        		output = AdminApp.view(appls[0], ["-MapModulesToServers"])
            			lines = output.split(lineSeparator)
		            	for line in lines:
					server = line.split(":  ")
					if server[0] == "Server":
						targets = server[1].split("+")
						for target in targets:
							targetList.append(target[10:len(target)])
		                   		break
	except:
		pass

	#print "Getting LongRunningScheduler targets..."

	try:
		output = AdminApp.view("LongRunningScheduler", ["-MapModulesToServers"])
		lines = output.split(lineSeparator)	
		for line in lines:
			server = line.split(":  ")	    
			if server[0] == "Server":
				targets = server[1].split("+")	 		
				for target in targets:
					targetList.append(target[10:len(target)])
				break
	except:
		pass

	#print targetList        
	
	return targetList


#---------------------------
# get cluster
#---------------------------
def getClusterList():
	print "Getting cluster list "
	
	targets = getTargets()
	
	clusterList = []
	for target in targets:
		servers = target.split(",")
		for server in servers:
			type = server.split("=")
			if type[0] == "cluster":
				clusterList.append(type[1])

	return clusterList

def getServerList():
	print "Getting server list "
	serverList = []
	
	targets = getTargets()
	for target in targets:
		servers = target.split(",")
		sName = ""
		nName = ""
		for server in servers:
			type = server.split("=")
			if type[0] == "node":
				nName = type[1]
			elif type[0] == "server":
				sName = type[1]
		if sName != "":
			serverList.append((nName, sName))

	return serverList


def getDynamicClusterMembers(dynamicClusterName):
	endpointList = []
	
	clusterId = AdminConfig.getid("/ServerCluster:"+dynamicClusterName+"/")
	if clusterId == "":
		print "Server Cluster name does not exist...correct the input value and re-run..."
		raise SystemExit()
		
	clusterMembers = AdminConfig. list("ClusterMember", clusterId).split(lineSeparator)
	for clusterMember in clusterMembers:      
		nodeName = AdminConfig.showAttribute(clusterMember, "nodeName")
		serverName = AdminConfig.showAttribute(clusterMember, "memberName")
		endpointList.append((nodeName,serverName))
	

	return endpointList
	
def getDynamicServerMembers(serverList):
	endpointList = []

	for server in serverList:
	
		serverInfo = AdminControl.completeObjectName("WebSphere:type=Server,name=" + server + ",*")
		nodeName = AdminControl.getAttribute(serverInfo, 'nodeName')
		
		if serverInfo == "":
			print "Server name does not exist...correct the input value and re-run..."
			raise SystemExit()
			
		endpointList.append((nodeName, server))
	
	return endpointList

#---------------------------
# check for existing shared lib
#---------------------------
def checkListForLib(sharedLibName, libList):
	
	libraryId = "" 
	
	tmpList = libList.split()
	for library in tmpList:
		tmpValue = library[0:len(sharedLibName)]
		if tmpValue == sharedLibName:
			libraryId = library
			
	return libraryId

def configSharedLib(sharedLibPath, sharedLibName, cellName, nodeName, serverName):
	

	#1.Identify the server and assign it to the server variable
	tmp = "/Cell:" + cellName + "/Node:" + nodeName + "/Server:" + serverName + "/"
	
	print "configSharedLib for " + tmp

	serv = AdminConfig.getid(tmp)
	#print serv

	#2. Check if the input shared library and classpath already exist.
	print "Checking to see if shared library exists..."
	library = AdminConfig.list('Library', serv)
	libraryFound = checkListForLib(sharedLibName, library)
	
	if libraryFound:
		#2.1 Shared Library already exists.
		print "Specified shared library already exists..."
		
		#2.2 Check to see if the incoming classpath is different
		print "Checking for classpath update..."
		classpath = AdminConfig.showAttribute(libraryFound, "classPath");	
		if classpath == sharedLibPath:
			#2.3 Classpath is the same - no update required
			print "Classpath is already defined... No update needed..." 
		else:
			#2.4 Classpath is different - update it
			print "Classpath is different... Performing update..."
			AdminConfig.modify(library, [['classPath', '']])
			AdminConfig.modify(library, [['classPath', sharedLibPath]])
	else:
		#2.5 Create the new shared library in the server since one didnt exist
		print "New shared library and classpath will be created..."
		library = AdminConfig.create('Library', serv, [['name', sharedLibName], ['classPath', sharedLibPath]])
		
	
	#3.Identify the application server from the server and assign it to the appServer variable 
	appServer = AdminConfig.list('ApplicationServer', serv)
	#print appServer
	
	#4. Identify the class loader in the application server and assign it to the classLoader variable
	classLoad = AdminConfig.showAttribute(appServer, 'classloaders')
	cleanClassLoaders = classLoad[1:len(classLoad)-1]
	if cleanClassLoaders == "":
		#	
		#4.1 case no existing class loader. create new one
		#
		print "No existing class loader for this server. Create one..."
		classLoader1 = AdminConfig.create('Classloader', appServer, [['mode',  'PARENT_FIRST']])
		#
		#5. Associate the shared library that you created with the application server through the class loader.
		#
		AdminConfig.create('LibraryRef', classLoader1, [['libraryName', sharedLibName], ['sharedClassloader', 'True']])
	else:
		#
		#4.2 case using existing class loader. 	
      	        #    
		print "There's an existing class loader for this server..."		
		classLoader1 = cleanClassLoaders.split(' ')[0]
		#
		#5.Associate the shared library that you created with the application server through the class loader.
		#
		AdminConfig.create('LibraryRef', classLoader1, [['libraryName', sharedLibName], ['sharedClassloader', 'True']])
	        #print "done configSharedLib"

#----------------------------
# Config for cluster servers 
# and standalone server
#----------------------------
def configureSharedLibForAllCGServers(sharedLibPath, sharedLibName, clusterList, serverList):
	#assume there's only 1 cell
	cellObj = AdminConfig.list("Cell")
	cName = AdminConfig.showAttribute(cellObj, "name")
	
	processClusters = 1
	processServers = 1
	
	# if we get a specific list (server or cluster) only process that type of entity
	if clusterList:
		processServers = 0
	if serverList:
		processClusters = 0
		
	#server clusters
	if processClusters == 1:
		if clusterList:
			clusters = clusterList
		else:
			clusters = getClusterList()
	
		for cluster in clusters:
			#print "cluster name = " + cluster
	
			endpointList = getDynamicClusterMembers(cluster)
			for nName, sName in endpointList:
				#print "nName = " + nName + " sName = " + sName
				configSharedLib(sharedLibPath, sharedLibName, cName, nName, sName)
		if not clusters:
			print "No Cluster servers found..."

	if processServers == 1:
		#standalone server
		if serverList:
			servers = getDynamicServerMembers(serverList)
		else:
			servers = getServerList()
	
		for nName, sName in servers:
			#print "nName = " + nName + " sName = " + sName
			configSharedLib(sharedLibPath, sharedLibName, cName, nName, sName)
	
		if not servers:
			print "No Standalone servers found..."

#----------------------------
# Main entry
#----------------------------
if len(sys.argv) > 0:
	option = sys.argv[0]
	if option == "--help":
		printHelp()
	else:
		args = getArgs()	
	
		sharedLibName = args[0]
		sharedLibPath = args[1]
		clusterList = args[2]
		serverList = args[3]
	
		if sharedLibPath == ""  or sharedLibName == "":
			print "Exit"
		else:
			if clusterList or serverList:
				print "Configuring shared library for specified CG JobScheduler servers and Endpoint servers..."
			else:
				print "Configuring shared library for all CG JobScheduler servers and Endpoint servers..."
				
			configureSharedLibForAllCGServers(sharedLibPath, sharedLibName, clusterList, serverList)
			
			if AdminConfig.hasChanges():
				print "Saving workspace..."
				AdminConfig.save()
			else:
				print "No changes made to workspace..."

