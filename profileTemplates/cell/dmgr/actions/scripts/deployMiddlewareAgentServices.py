
import sys
import os

lineSep = java.lang.System.getProperty('line.separator')


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


def getMiddlewareAgentServicesDir(cell, node):
	fileSep = getFileSep(node)
	return getSystemAppsDir(cell, node) + fileSep + "MiddlewareAgentServices.ear"

def getFileSep(node): 
	os = AdminTask.getNodePlatformOS("-nodeName " + node)
	if os == 'windows':
		return '\\'
	else:
		return '/'


def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split("\"")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist
   

def deployMiddlewareAgentServices(cell, node, server):
	massDir = getMiddlewareAgentServicesDir(cell, node)
	print "Deploying MiddlewareAgentServices.ear"
	AdminApp.install(massDir, ['-node', node, '-server', server, '-nocreateMBeansForResources', '-usedefaultbindings', '-appname', 'MiddlewareAgentServices'])


#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------
           
cell = None
dmgrNode = None
dmgrServer = None

# set cell and node name 
cellObj = AdminConfig.list("Cell")
cell = AdminConfig.showAttribute(cellObj, "name")

nodes = convertToList(AdminConfig.list("Node", cellObj))
for node in nodes:
    nodeName = AdminConfig.showAttribute(node,"name")
    serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:nodeagent/")
    if (serverid == None or serverid == ""):
        serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:dmgr/")
        if (serverid != None and serverid != ""):
           dmgrNode = nodeName

localNode = java.lang.System.getenv('WAS_NODE')

#run this only on Deployment Manager node, otherwise simply return       
if dmgrNode == localNode:
   
	dmgrServer = "dmgr"

	print "Installing MiddlewareAgentServices on the deployment manager"
        
	print "Cell:  " + cell + ", Node:  " + dmgrNode + ", Server:  " + dmgrServer
	
	if dmgrServer != None and cell != None and dmgrNode != None:
		deployMiddlewareAgentServices(cell, dmgrNode, dmgrServer)
		print "Saving workspace..."
		AdminConfig.save()
		print "Finished."
else:
	print "Skipping MiddlewareAgentServices installation step because this is not a deployment manager" 