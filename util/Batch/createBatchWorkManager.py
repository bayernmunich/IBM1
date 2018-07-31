
import os
import sys

lineSep = java.lang.System.getProperty('line.separator')



def createBatchWM(cell, node, server):
	try:
		print "Creating WorkManager"
		serverId = AdminConfig.getid('/Cell:'+cell+'/Node:'+node+'/Server:'+server)
		wmProvider = AdminConfig.list('WorkManagerProvider', serverId)
		wmProvider = AdminConfig.getid('/Cell:'+cell+'/Node:'+node+'/Server:'+server+'/WorkManagerProvider:/')
		print "WorkManagerProvider " + wmProvider
		AdminResources.createWorkManagerAtScope('/Cell:'+cell+'/Node:'+node+'/Server:'+server, "BatchWorkManager", "wm/BatchWorkManager", "5", "1", "10", "5", wmProvider, [['description', 'Batch Work Manager'], ['isGrowable', 'true']])
		print "created WorkManager"
	except java.lang.Throwable, t:
		print "Exception occurred during createBatchWM(" + cell +", " + node + ", " + server + "):", sys.exc_info()
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
	print "Defaulting to server1. Please specify a server with the \'-server\' option to configure wm/BatchWorkManager on a different server."
        server = "server1"
else:
        print "creating ws/BatchWorkManager"
        
        
print "Cell:  " + cell + ", Node:  " + node + ", Server:  " + server
	
if server != None and cell != None and node != None:
	retVal = createBatchWM(cell, node, server)
	if retVal == 1:
		print "Saving Config ..."
		AdminConfig.save()
		print "Saved Config"
	else:
		print "Skipping Config Save"
