##############################################################################
# ARFM MustGather Trace Spec 6.1.0.3+
##############################################################################
#
# trace spec for ODRs
#
ODRSPEC="*=info:com.ibm.ws.xd.comm.*=all:com.ibm.wsmm.comm.Stats*=all:com.ibm.wsmm.comm.NodeStat*=all:com.ibm.wsmm.grm.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.xd.arfm.*=all:com.ibm.ws.dwlm.*=all:com.ibm.wsmm.policing.*=all:com.ibm.wsmm.xdglue.*=all:com.ibm.wsmm.rqm.LowDetail=all:com.ibm.ws.dwlm.client.*=off:com.ibm.ws.odr.route.Server=all:com.ibm.ws.odc.nd.ODCTreeImpl$Save=all:com.ibm.ws.dwlm.client.*=info"
#
# trace spec for nodeagents
#
NODEAGENTSPEC="*=info:com.ibm.ws.xd.comm.*=all:com.ibm.wsmm.comm.Stats*=all:com.ibm.wsmm.comm.NodeStat*=all:com.ibm.wsmm.grm.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.xd.arfm.*=all:com.ibm.ws.dwlm.*=all:com.ibm.wsmm.policing.*=all:com.ibm.wsmm.xdglue.*=all:com.ibm.wsmm.rqm.LowDetail=all:com.ibm.ws.xd.hmm.*=all:com.ibm.ws.xd.admin.utils.*=all:com.ibm.ws.clustersensor.impl.*=all:com.ibm.apc.*=all:com.ibm.apc.brain.*=fine:com.ibm.vespa.*=fine:com.ibm.ws.xd.vv.*=all:com.ibm.ws.vm.*=all:vm.pub=all:com.ibm.venture.*=all:com.ibm.ws.odc.nd.ODCTreeImpl$Save=all"
#
# trace spec for dmgrs
#
DMGRSPEC=NODEAGENTSPEC
#
# trace spec for appservers
#
APPSERVERSPEC="*=info:com.ibm.ws.xd.comm.*=all:async.pmi=all:com.ibm.wsmm.grm.model.*=all:com.ibm.ws.sip.container.util.wlm.impl.mop.*=all:detail.com.ibm.ws.sip.container.util.wlm.impl.mop.*=all:com.ibm.ws.sip.container.util.wlm.impl.mop.MOCVerbose=off:com.ibm.ws.xd.arfm.config.*=all"

BACKUPFILES=10
TRACEFILESIZE=100

#############################################################################
#############################################################################

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def getAllServers():
	servers = convertToList(AdminConfig.list("Server"))
	dynamicClusters = convertToList(AdminTask.listDynamicClusters())
	for dynamicCluster in dynamicClusters:
		for server in servers:
			serverName = AdminConfig.showAttribute(server, "name")
			if dynamicCluster == serverName:
				servers.remove(server)
				break
	return servers

# This extracts the node name from a serverid. A serverid looks like
#   server(cells/cellname/nodes/nodename/servers/servername:server.xml#id
# so splitting it in to '/' seperated list gives
#   ['servers(cells", "cellname", "nodes", "nodename", ...]
# The 4th element is the node name.

def getNodeNameForServer(serverId):
  return serverId.split("/")[3]

def getProcessNameForServer(serverId):
  t = serverId.split("/")[5]
  t = t.split(":")[0]
  return t.split("|")[0]

# This sets the startup trace for a specific server.

def setTraceForServer(server, traceString):
  nodeName = getNodeNameForServer(server)
  name = getProcessNameForServer(server)
  traceService = AdminConfig.list("TraceService", server)
  print "Setting persistent trace for " + nodeName + "/" + name
  AdminConfig.modify(traceService, [["startupTraceSpecification", traceString]])
  trlog = AdminConfig.list("TraceLog",traceService)
  AdminConfig.modify(trlog,[['maxNumberOfBackupFiles',BACKUPFILES],['rolloverSize',TRACEFILESIZE]])

# This sets the startup trace for all servers in a cluster.

def setTraceForAll(traceString):
  servers = getAllServers()
  for s in servers:
    setTraceForServer(s, traceString)

# Look up the trace MBean for a server. QueryNames returns an empty string if the server is currently not running.

def setRuntimeTraceForServer(server, traceString):
  nodeName = getNodeNameForServer(server)
  name = getProcessNameForServer(server)
  mbean = AdminControl.queryNames("type=TraceService,node=" + nodeName + ",process=" + name + ",*")
  if(len(mbean) > 0):
    print "Setting runtime trace for " + nodeName + "/" + name
    AdminControl.setAttribute(mbean, "traceSpecification", traceString)
  else:
    print "Server " + nodeName + "/" + name + " is offline so runtime trace was not set."


def setRuntimeTraceForAll(traceString):
  servers = getAllServers()
  if(len(servers) == 0):
    print "No servers"
  else:
    for s in servers:
      setRuntimeTraceForServer(s, traceString)

if (len(sys.argv) > 0):
   CMD=sys.argv[0].rstrip()
   if (CMD == 'enable'):
     ODRSPEC=ODRSPEC
   elif (CMD == 'disable'):
     ODRSPEC="*=info"
     NODEAGENTSPEC=ODRSPEC
     DMGRSPEC=ODRSPEC
     APPSERVERSPEC=ODRSPEC
   else:
      print "Usage: arfmMustgather.py {enable|disable}"
      sys.exit(1)

servers=getAllServers()
for server in servers:
   try:
      stype = AdminConfig.showAttribute(server,"serverType")
   except JavaThrowable:
      stype = "UNKNOWN"
   if (stype == "DEPLOYMENT_MANAGER"):
       setTraceForServer(server,DMGRSPEC)
       setRuntimeTraceForServer(server,DMGRSPEC)
   elif (stype == "ONDEMAND_ROUTER"):
       setTraceForServer(server,ODRSPEC)
       setRuntimeTraceForServer(server,ODRSPEC)
   elif (stype == "NODE_AGENT"):
       setTraceForServer(server,NODEAGENTSPEC)
       setRuntimeTraceForServer(server,NODEAGENTSPEC)
   elif (stype == "APPLICATION_SERVER"):
       setTraceForServer(server,APPSERVERSPEC); 
       setRuntimeTraceForServer(server,APPSERVERSPEC)

AdminConfig.save()
