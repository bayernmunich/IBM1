import sys
import os

lineSep = java.lang.System.getProperty('line.separator')

def convertToList(inlist):
	outlist=[]

	if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
		inlist = inlist[1:len(inlist)-1]
		clist = inlist.split(" ")
	else:
		clist = inlist.split("\n")
	for elem in clist:
		elem=elem.rstrip()
		if (len(elem)>0):
			outlist.append(elem)
	return outlist 
	
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
  print sys.argv[i]
  if sys.argv[i] == "-server": 
    server = sys.argv[i + 1]	
  i = i + 1

if server == None:
  print "Defaluting to server1. Please specify a server with the \'-server\' option to configure grid scheduler and endpoint on a different server."
  server = "server1"
else:
  print "configuring scheduler and endpoint on the provided server"
        
if server != None and cell != None and node != None:
  gs = convertToList(AdminConfig.list('GridScheduler'))
  print gs[0]
  target = 'WebSphere:cell=' + cell + ',node=' + node + ',server=' + server
  print target
  AdminConfig.modify(gs[0], [['deploymentTarget', target]])
  AdminConfig.save()
  print "Saved"
else:
  print "Unable to set the deploymentTarget since either cell, node, or server is None"
