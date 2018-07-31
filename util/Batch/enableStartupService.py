
import os
import sys

lineSep = java.lang.System.getProperty('line.separator')



def enableStartupService(cell, node, server):
	try:
		print "Enabling StartupService"
		serverId = AdminConfig.getid('/Cell:'+cell+'/Node:'+node+'/Server:'+server)
		sbService = AdminConfig.list('StartupBeansService', serverId)
                print "startupBeansService " + sbService
		if sbService == None:
			print "error accessing startup bean service for server " + server
			return 0
		AdminConfig.modify(sbService, [['enable', 'true']])
		print "enabled startupbean service for server"
	except java.lang.Throwable, t:
		print "Exception occurred during enableStartupService(" + cell +", " + node + ", " + server + "):", sys.exc_info()
                print t
		return 0
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

# Try to get a node, cell, and server from command-line arguments
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
	
if server != None and cell != None and node != None:
	retVal = enableStartupService(cell, node, server)
	if retVal == 1:
		print "Saving Config ..."
		AdminConfig.save()
		print "Saved Config"
	else:
		print "Skipping Config Save"
