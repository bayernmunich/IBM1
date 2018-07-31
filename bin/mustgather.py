##############################################################################
###   Script for creating and collecting must gather documents.
###
###  
###   Notes: - Running the enable command will overwrite existing trace specification
###          - Enable will set log file configuration to 10 files of size 100MB each
###          - Running the disble command will change trace specification to *=info
##############################################################################
import os
import zipfile
import socket
from java.lang import System
from shutil import rmtree
import java.util.ArrayList as ArrayList
import java.util.List as List

# Log File Settings
LOGFILENUMBER=10
LOGFILESIZE=100
NOREMOTE = 0
NOPERSISTENTTRACE = 0

validCmds = ['ENABLE','DISABLE','COLLECT']
validMGs = ['404','503','504','AGENT','APC','ARFM','APPEDITION','DC','HADMGR','HMM','ODR','OPERATIONS','REPORTS','REPORTSPERF','REPOSITORY','SIP']

wasinstallroot=System.getProperty("was.install.root")
userinstallroot=System.getenv("USER_INSTALL_ROOT")
profilesDir = os.path.normpath(os.path.join(userinstallroot, os.pardir))
tempRoot=profilesDir
tempDest = os.path.join(os.path.normpath(os.path.join(tempRoot,os.pardir)), "MG_TMP")
# tempDest = os.tmpnam()
# print "tempDest="+tempDest

# get local host name
sockethostname = socket.gethostname()
hostname = sockethostname
hostdata = socket.gethostbyaddr(socket.gethostname()) 
for h in hostdata:
  hostname = h
  break

#############################################################################

################################################################
# convert to a list
################################################################
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

################################################################
# get all servers
################################################################
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

################################################################
# get all nodes
################################################################
def getAllNodes():
  return convertToList(AdminConfig.list("Node"))

################################################################
# This extracts the node name from a nodeid. A nodeid looks like
#   node(cells/cellname/nodes/nodename:node.xml#id
# so splitting it in to '/' seperated list gives
#   ['node(cells", "cellname", "nodes", "nodename", ...]
# The 4th element is the node name.
################################################################
def getNodeNameForNode(nodeId):
   t = nodeId.split("/")[3]
   t = t.split(":")[0]
   return t.split("|")[0]

################################################################
# This extracts the node name from a serverid. A serverid looks like
#   server(cells/cellname/nodes/nodename/servers/servername:server.xml#id
# so splitting it in to '/' seperated list gives
#   ['servers(cells", "cellname", "nodes", "nodename", ...]
# The 4th element is the node name.
################################################################
def getNodeNameForServer(serverId):
  return serverId.split("/")[3]

################################################################
# get the process name
################################################################
def getProcessNameForServer(serverId):
  t = serverId.split("/")[5]
  t = t.split(":")[0]
  return t.split("|")[0]

################################################################
# This sets the startup trace for a specific server.
################################################################
def saveTraceForServer(node, server, traceString):
  filename = "MG_"+node+"_"+server
  mgfile = open(filename,"w")
  mgfile.write(traceString)
  mgfile.close()
  print "Existing persistent trace saved in file "+filename

################################################################
# This sets the startup trace for a specific server.
################################################################
def setTraceForServer(server, traceString):
  if NOPERSISTENTTRACE == 0:
    print ""
    nodeName = getNodeNameForServer(server)
    name = getProcessNameForServer(server)
    traceService = AdminConfig.list("TraceService", server)
    oldtrace = AdminConfig.showAttribute(traceService, "startupTraceSpecification")
    saveTraceForServer(nodeName, name, oldtrace)
    print "Setting persistent trace for " + nodeName + "/" + name + " to " +traceString
    AdminConfig.modify(traceService, [["startupTraceSpecification", traceString]])
    trlog = AdminConfig.list("TraceLog",traceService)
    AdminConfig.modify(trlog,[['maxNumberOfBackupFiles',LOGFILENUMBER],['rolloverSize',LOGFILESIZE]])

################################################################
# This sets the startup trace for all servers in a cluster.
################################################################
def setTraceForAll(traceString):
  servers = getAllServers()
  for s in servers:
    setTraceForServer(s, traceString)

################################################################
# Look up the trace MBean for a server. QueryNames returns an empty string if the server is currently not running.
################################################################
def setRuntimeTraceForServer(server, traceString):
  nodeName = getNodeNameForServer(server)
  name = getProcessNameForServer(server)
  mbean = AdminControl.queryNames("type=TraceService,node=" + nodeName + ",process=" + name + ",*")
  if(len(mbean) > 0):
    oldtrace = AdminControl.getAttribute(mbean, "traceSpecification")
    print "Setting runtime trace for " + nodeName + "/" + name + " from " + oldtrace + " to " +traceString
    AdminControl.setAttribute(mbean, "traceSpecification", traceString)
  else:
    print "Server " + nodeName + "/" + name + " is offline so runtime trace was not set."

################################################################
# set the runtime trace for all servers
################################################################
def setRuntimeTraceForAll(traceString):
  servers = getAllServers()
  if(len(servers) == 0):
    print "No servers"
  else:
    for s in servers:
      setRuntimeTraceForServer(s, traceString)              

################################################################
### zip an entire directory
################################################################
def zipFileListInclude(srcFolder, zfile, filetypes, truncatePath):
  filelist = []
  zipFileList(srcFolder, filelist)

  more = 1
  while more == 1:			    
    more = 0
    for file in filelist:
      if os.path.isdir(file):
        filelist.remove(file)
	zipFileList(file, filelist)
	more = 1
	break

  rmLen = len(tempRoot) + 1
  if len(truncatePath) > 0:
    rmLen = rmLen + len(truncatePath) + 1

  for file in filelist:
    match = 1
    for filetype in filetypes:
      match = 0
      if (file.upper().endswith(filetype)):
        match = 1
	break
    if match == 1:
      arcname = file[rmLen:]
      zfile.write(file, arcname, zipfile.ZIP_DEFLATED)

################################################################
### zip an entire directory
################################################################
def zipFileListExclude(srcFolder, zfile, filetypes, truncatePath):
  filelist = []
  zipFileList(srcFolder, filelist)

  more = 1
  while more == 1:			    
    more = 0
    for file in filelist:
      if os.path.isdir(file):
        filelist.remove(file)
	zipFileList(file, filelist)
	more = 1
	break

  rmLen = len(tempRoot) + 1
  if len(truncatePath) > 0:
    rmLen = rmLen + len(truncatePath) + 1

  for file in filelist:
    match = 0
    for filetype in filetypes:
      if (file.upper().endswith(filetype)):
        match = 1
	break
    if match == 0:
      arcname = file[rmLen:]
      zfile.write(file, arcname, zipfile.ZIP_DEFLATED)

################################################################
### gathering list of files to zip
################################################################
def zipFileList(folder, filelist):
  if os.path.isdir(folder):
    for file in os.listdir(folder):
      f = os.path.join(folder, file)
      filelist.append(f)
  return filelist

################################################################
### gathering list of files to zip
################################################################
def importRemoteFilesInclude(dirName, filetypes):
  nodes = getAllNodes()
  for node in nodes:
    print "processing "+node
    host = AdminConfig.showAttribute(node, 'hostName')
    if (host != hostname) and (host != sockethostname) and (host != hostname.split(".")[0]) and (host != sockethostname.split(".")[0]):
      nodeName = getNodeNameForNode(node)
      mbeanStr='WebSphere:*,type=FileService'
      mbeans=convertToList(AdminControl.queryNames(mbeanStr))
      for mbean in mbeans:
        mylist = AdminControl.invoke(mbean,'listRemoteFiles',nodeName + ' ' + dirName)
        if mylist != "":
          break
      mylist2 = mylist.split(dirName)
      for fn in mylist2:
        fn = dirName + fn
        if fn != dirName:
  	  sss = fn.split("\n")    # strip 
	  fn = sss[0]
	  sss = fn.split("\r")    # strip
	  fn = sss[0]
          match = 1
          for filetype in filetypes:
	    match = 0
            if (fn.upper().endswith(filetype)):
              match = 1
	      break
          if match == 1:
            AdminControl.invoke(mbean,'importRemoteFile',nodeName + ' ' + fn + ' ' + tempDest)

################################################################
### gathering list of files to zip
################################################################
def importRemoteFilesExclude(dirName, filetypes):
  nodes = getAllNodes()
  for node in nodes:
    print "processing "+node
    host = AdminConfig.showAttribute(node, 'hostName')
    if (host != hostname) and (host != sockethostname) and (host != hostname.split(".")[0]) and (host != sockethostname.split(".")[0]):
      nodeName = getNodeNameForNode(node)
      mbeanStr='WebSphere:*,type=FileService'
      mbeans=convertToList(AdminControl.queryNames(mbeanStr))
      for mbean in mbeans:
        mylist = AdminControl.invoke(mbean,'listRemoteFiles',nodeName + ' ' + dirName)
        if mylist != "":
          break
      mylist2 = mylist.split(dirName)
      for fn in mylist2:
        fn = dirName + fn
        if fn != dirName:
  	  sss = fn.split("\n")    # strip 
	  fn = sss[0]
	  sss = fn.split("\r")    # strip
	  fn = sss[0]
          match = 0
          for filetype in filetypes:
            if (fn.upper().endswith(filetype)):
              match = 1
	      break
          if match == 0:
            AdminControl.invoke(mbean,'importRemoteFile',nodeName + ' ' + fn + ' ' + tempDest)

################################################################
### get all profile directories
################################################################
def getProfileDirs():
  profiles = []
  # print "userinstallroot="+userinstallroot
  # print "profilesDir="+profilesDir
  for file in os.listdir(profilesDir):
    profiles.append(os.path.join(profilesDir, file))

  return profiles

################################################################
### run ODRDebug
################################################################
def setHttpDebug(odr, errorCode, expr):
  odrName = getProcessNameForServer(odr)
  nodeName = getNodeNameForServer(odr)
  mbeanStr='WebSphere:*,type=ODRDebug,node=' + nodeName + ',process=' + odrName
  mbeans=convertToList(AdminControl.queryNames(mbeanStr))
  for mbean in mbeans:
    AdminControl.invoke(mbean,'setHttpDebug',errorCode + ' ' + expr + ' 2')

################################################################
##### 404 mustgather
################################################################

### enable trace for 404 mustgather
def enable_404():
  odrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all:com.ibm.ws.classify.*=all:com.ibm.ws.xd.dwlm.client.*=all:com.ibm.ws.dwlm.client.*=all:com.ibm.ws.proxy.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.odr.*=all"
  dmgrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all"
  appserverSpec="*=info:com.ibm.ws.webcontainer.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
      setHttpDebug(server, "404", "true")
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for 404 mustgather
def disable_404():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)
      setHttpDebug(server, "404", "false")

### collect doc for 404
def collect_404(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])

# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### 503 mustgather
################################################################

### enable trace for 503 mustgather
def enable_503():
  odrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all:com.ibm.ws.classify.*=all:com.ibm.ws.xd.dwlm.client.*=all:com.ibm.ws.dwlm.client.*=all:com.ibm.ws.proxy.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.odr.*=all"
  dmgrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all"
  appserverSpec="*=info:com.ibm.ws.webcontainer.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
      setHttpDebug(server, "503", "true")
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for 503 mustgather
def disable_503():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)
      setHttpDebug(server, "503", "false")

### collect doc for 503
def collect_503(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### 504 mustgather
################################################################

### enable trace for 504 mustgather
def enable_504():
  odrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all:com.ibm.ws.classify.*=all:com.ibm.ws.xd.dwlm.client.*=all:com.ibm.ws.dwlm.client.*=all:com.ibm.ws.proxy.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.odr.*=all:GenericBNF=all:HTTPChannel=all"
  dmgrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all"
  appserverSpec="*=info:com.ibm.ws.webcontainer.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for 504 mustgather
def disable_504():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for 504
def collect_504(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### agent mustgather
################################################################

### enable trace for agent mustgather
def enable_agent():
  spec="*=info:com.ibm.ws.xd.agent.*=all"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "MIDDLEWARE_AGENT"):
      setTraceForServer(server, spec)
      setRuntimeTraceForServer(server, spec)

### disable trace for agent mustgather
def disable_agent():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "MIDDLEWARE_AGENT"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for agent
def collect_agent(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### apc mustgather
################################################################

### enable trace for apc mustgather
def enable_apc():
  spec="com.ibm.apc.*=all:com.ibm.ws.xd.container.state.*=all:com.ibm.ws.odc.nd.ODCTreeImpl$Save=all:com.ibm.ws.xd.vv.nodedetect.*=all:com.ibm.ws.vm.*=all:vm.pub=all:com.ibm.vespa.vmpublisher.*=all:com.ibm.venture.*=all:cellagent=all:com.ibm.ws.xd.agent.hypervisor.*=all:com.ibm.ws.xd.taskmanagement.*=all:com.ibm.ws.taskmanagement.*=all"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "NODE_AGENT") or (stype == "XDAGENT"):
      setTraceForServer(server, spec)
      setRuntimeTraceForServer(server, spec)

### disable trace for apc mustgather
def disable_apc():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "NODE_AGENT") or (stype == "XDAGENT"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for apc
def collect_apc(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### appedition mustgather
################################################################

### enable trace for appedition mustgather
def enable_appedition():
  dmgrSpec="*=info:com.ibm.ws.management.*=all:com.ibm.websphere.management.*=all:com.ibm.ws.xd.appeditionmgr.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)

### disable trace for appedition mustgather
def disable_appedition():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for appedition
def collect_appedition(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "config")
    fileEndings = [".EAR",".JAR",".WAR"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("config", [".EAR",".JAR",".WAR"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### arfm mustgather
################################################################

### enable trace for arfm mustgather
def enable_arfm():
  odrSpec="*=info:com.ibm.ws.xd.comm.*=all:com.ibm.wsmm.comm.Stats*=all:com.ibm.wsmm.comm.NodeStat*=all:com.ibm.wsmm.grm.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.xd.arfm.*=all:com.ibm.ws.dwlm.*=all:com.ibm.wsmm.policing.*=all:com.ibm.wsmm.xdglue.*=all:com.ibm.wsmm.rqm.LowDetail=all:com.ibm.ws.dwlm.client.*=off:com.ibm.ws.odr.route.Server=all:com.ibm.ws.odc.nd.ODCTreeImpl$Save=all:com.ibm.ws.dwlm.client.*=info"
  nodeagentSpec="*=info:com.ibm.ws.xd.comm.*=all:com.ibm.wsmm.comm.Stats*=all:com.ibm.wsmm.comm.NodeStat*=all:com.ibm.wsmm.grm.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.xd.arfm.*=all:com.ibm.ws.dwlm.*=all:com.ibm.wsmm.policing.*=all:com.ibm.wsmm.xdglue.*=all:com.ibm.wsmm.rqm.LowDetail=all:com.ibm.ws.xd.hmm.*=all:com.ibm.ws.xd.admin.utils.*=all:com.ibm.ws.clustersensor.impl.*=all:com.ibm.apc.*=all:com.ibm.apc.brain.*=fine:com.ibm.ws.xd.vv.*=all:com.ibm.ws.vm.*=all:vm.pub=all:com.ibm.venture.*=all:com.ibm.ws.odc.nd.ODCTreeImpl$Save=all"
  dmgrSpec=nodeagentSpec
  appserverSpec="*=info:com.ibm.ws.xd.comm.*=all:async.pmi=all:com.ibm.wsmm.grm.model.*=all:com.ibm.ws.sip.container.util.wlm.impl.mop.*=all:detail.com.ibm.ws.sip.container.util.wlm.impl.mop.*=all:com.ibm.ws.sip.container.util.wlm.impl.mop.MOCVerbose=off:com.ibm.ws.xd.arfm.config.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "NODE_AGENT"):
      setTraceForServer(server, nodeagentSpec)
      setRuntimeTraceForServer(server, nodeagentSpec)
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for arfm mustgather
def disable_arfm():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "NODE_AGENT") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for arfm
def collect_arfm(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### dc mustgather
################################################################

### enable trace for dc mustgather
def enable_dc():
  dmgrSpec="*=info:com.ibm.ws.console.dynamiccluster.*=all: com.ibm.ws.xd.config.dc.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)

### disable trace for dc mustgather
def disable_dc():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for dc
def collect_dc(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "config")
    fileEndings = ["SERVER.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("config", ["SERVER.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### hadmgr mustgather
################################################################

### enable trace for hadmgr mustgather
def enable_hadmgr():
  odrSpec="*=info:com.ibm.ws.xd.*=all"
  dmgrSpec="*=info:com.ibm.ws.xd.admin.hadmgr.*=all:com.ibm.ws.odc.*=all:com.ibm.ws.console.hadmgr.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)

### disable trace for hadmgr mustgather
def disable_hadmgr():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for hadmgr
def collect_hadmgr(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### hmm mustgather
################################################################

### enable trace for hmm mustgather
def enable_hmm():
  dmgrSpec="*=info:com.ibm.ws.xd.hmm.*=all"
  nodeagentSpec="*=info:com.ibm.ws.xd.hmm.*=all"
  appserverSpec="*=info:com.ibm.ws.performance.tuning.*=all:NodeDetect=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "NODE_AGENT"):
      setTraceForServer(server, nodeagentSpec)
      setRuntimeTraceForServer(server, nodeagentSpec)
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for hmm mustgather
def disable_hmm():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "NODE_AGENT") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for hmm
def collect_hmm(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### odr mustgather
################################################################

### enable trace for odr mustgather
def enable_odr():
  odrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all:com.ibm.ws.classify.*=all:com.ibm.ws.xd.dwlm.client.*=all:com.ibm.ws.dwlm.client.*=all:com.ibm.ws.proxy.*=all:com.ibm.ws.xd.workprofiler.*=all:com.ibm.ws.odr.*=all"
  dmgrSpec="*=info:com.ibm.ws.odc.*=all:com.ibm.ws.wsgroup.*=all"
  appserverSpec="*=info:com.ibm.ws.webcontainer.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for odr mustgather
def disable_odr():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for odr
def collect_odr(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### visualization operations mustgather
################################################################

### enable trace for visualization operations mustgather
def enable_operations():
  odrSpec="*=info:com.ibm.ws.xd.*=all"
  dmgrSpec="*=info:com.ibm.ws.console.xdoperations.detail.operations.*=all:com.ibm.ws.console.xdoperationsdetail.summary.*=all:com.ibm.ws.console.xdoperations.util.*=all:com.ibm.ws.xd.operations.*=all"
  nodeagentSpec="*=info:com.ibm.ws.xd.pmi.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "NODE_AGENT"):
      setTraceForServer(server, nodeagentSpec); 
      setRuntimeTraceForServer(server, nodeagentSpec)

### disable trace for visualization operations mustgather
def disable_operations():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "NODE_AGENT"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for visualization operations
def collect_operations(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### visualization reports mustgather
################################################################

### enable trace for visualization reports mustgather
def enable_reports():
  odrSpec="*=info:com.ibm.ws.xd.*=all"
  dmgrSpec="*=info:com.ibm.ws.console.xdoperations.chart.*=all:com.ibm.ws.console.xdoperations.prefs.*=all:com.ibm.ws.console.xdoperations.util.*=all"
  nodeagentSpec="*=info:com.ibm.ws.xd.pmi.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "NODE_AGENT"):
      setTraceForServer(server, nodeagentSpec); 
      setRuntimeTraceForServer(server, nodeagentSpec)

### disable trace for visualization reports mustgather
def disable_reports():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "NODE_AGENT"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for visualization reports
def collect_reports(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()
  
################################################################
##### visualization reports performance mustgather
################################################################

### enable trace for visualization report performance mustgather
def enable_reportsPerf():
  odrSpec="*=info:com.ibm.ws.xd.*=all"
  dmgrSpec="*=info:com.ibm.ws.console.xdoperations.helper.*=all:com.ibm.ws.xd.visualizationengine.cacheservice.*=all"
  nodeagentSpec="*=info:com.ibm.ws.xd.pmi.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)
    elif (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "NODE_AGENT"):
      setTraceForServer(server, nodeagentSpec); 
      setRuntimeTraceForServer(server, nodeagentSpec)

### disable trace for visualization report performance mustgather
def disable_reportsPerf():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER") or (stype == "ONDEMAND_ROUTER") or (stype == "NODE_AGENT"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for visualization report performance
def collect_reportsPerf(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### repository mustgather
################################################################

### enable trace for repository mustgather
def enable_repository():
  dmgrSpec="*=info:com.ibm.ws.xd.admin.checkpoint.*=all:com.ibm.ws.management.repository.*=all:com.ibm.websphere.management.repository.*=all:com.ibm.ws.console.repositorycheckpoint.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, dmgrSpec)
      setRuntimeTraceForServer(server, dmgrSpec)

### disable trace for repository mustgather
def disable_repository():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "DEPLOYMENT_MANAGER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for repository
def collect_repository(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### per-request mustgather
################################################################

### enable trace for request mustgather
def enable_request():
  odrSpec="*=info:com.ibm.ws.proxy.channel.http.HttpProxyServiceContextImpl=all:com.ibm.ws.proxy.channel.http.HttpProxyConnectionLink=all:com.ibm.ws.proxy.filter.http.HttpFilterChain=all:com.ibm.ws.xd.dwlm.client.HttpAffinityUtil:com.ibm.ws.xd.dwlm.client.filter.HttpSessionAffinitiesResponseFilter:com.ibm.ws.xd.dwlm.client.XDTargetServerImpl=all:com.ibm.ws.proxy.cache.http.HttpCacheContextInit2Filter=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)

### disable trace for request mustgather
def disable_request():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for request
def collect_request(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
##### sip mustgather
################################################################

### enable trace for sip mustgather
def enable_sip():
  odrSpec="*=info:ODR=all:com.ibm.ws.proxy.*=all:com.ibm.ws.sip.*=all"
  appserverSpec="*=info:ODR=all:com.ibm.ws.proxy.*=all:com.ibm.ws.sip.*=all"

  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "ONDEMAND_ROUTER"):
      setTraceForServer(server, odrSpec)
      setRuntimeTraceForServer(server, odrSpec)
    elif (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, appserverSpec); 
      setRuntimeTraceForServer(server, appserverSpec)

### disable trace for sip mustgather
def disable_sip():
  spec = "*=info"
  servers=getAllServers()
  for server in servers:
    try:
      stype = AdminConfig.showAttribute(server,"serverType")
    except JavaThrowable:
      stype = "UNKNOWN"

    if (stype == "ONDEMAND_ROUTER") or (stype == "APPLICATION_SERVER"):
      setTraceForServer(server, spec); 
      setRuntimeTraceForServer(server, spec)

### collect doc for sip
def collect_sip(zipDest):
  zfile = zipfile.ZipFile(zipDest, "w")

# get local files
  profiles = getProfileDirs()
  for profile in profiles:
    srcDir = os.path.join(profile, "logs")
    fileEndings = [".LCK"]
    zipFileListExclude(srcDir, zfile, fileEndings, "")
    srcDir = os.path.join(profile, "installedFilters")
    fileEndings = ["TARGET.XML"]
    zipFileListInclude(srcDir, zfile, fileEndings, "")

# get list of remote files
  if NOREMOTE == 0:
    importRemoteFilesExclude("logs", [".LCK"])
    importRemoteFilesInclude("installedFilters", ["TARGET.XML"])
# add remote files to zip
    zipFileListInclude(tempDest, zfile, [], "MG_TMP")
    if os.path.isdir(tempDest):
      rmtree(tempDest)

  zfile.close()

################################################################
#
# Print a usage message
#
################################################################
def printUsage(msg):
  print "ERROR: "+msg+"""

  mustgather.py enables trace, collects mustgather documents, and disables trace. Existing
  persistent trace specifications are archived to a file (MG_nodename_servername), before being
  overwritten.

  NOTE: The collection phase will collect potentially large files from remote nodes. This
        may take several minutes or more, depending on the amount of data and network speed.

  Supported commands:

    enable <mustgatherType> [-NOPERSISTENTTRACE | -LOGFILENUMBER=xx | -LOGFILESIZE=xx]
    disable <mustgatherType> [-NOPERSISTENTTRACE | -LOGFILENUMBER=xx | -LOGFILESIZE=xx]
    collect <mustgatherType> <destination> [-NOREMOTE]

  Supported mustgather types:

    404 - 404 http response code
    503 - 503 http response code
    504 - 504 http response code
    agent - middleware agent
    apc - Application Placement Controller
    appedition - Application Edition Manager
    arfm - arfm
    dc - dynamic clusters
    hadmgr - High Availability Deployment Manager
    hmm - health monitoring
    odr - general issues on the odr
    operations - visualization issues with Component Stability and Operations tabs
    reports - visualization issues with Report tab
    reportsPerf - visualization issues with performance data shown on Report tab
    repository - Extended Repository Service
    request - per-request
    sip - SIP request routing

  destination: where to store zip file of collected data
  
  Options:

    -LOGFILENUMBER=xx - enable/disable option to set the number of trace log files
    -LOGFILESIZE=xx - enable/disable option to set the size of the trace logs in MB
    -NOPERSISTENTTRACE - enable/disable commands will only change running trace
    -NOREMOTE - collect command will only gather locally available files

  Examples:
  
      wsadmin -lang jython -f c:\\WebSphere\\AppServer\\bin\\mustgather.py collect odr "c:\\\\mydocs\\\\collection.zip"
      ./wsadmin.sh -lang jython -f mustgather.py collect odr "c:/mydocs/collection.zip"
    
  """
  sys.exit(1)

#========================================================================================
#
# Begin main
#
#========================================================================================

parms = []
options = []
for arg in sys.argv:
  if arg.startswith("-"):
    options.append(arg.rstrip().upper())
  else:
    parms.append(arg.rstrip())

if (len(parms) < 2):
  printUsage("missing arguments")
else:
  cmd = parms[0].upper()
  if cmd not in validCmds:
    printUsage("invalid command")
  else:
    mg = parms[1].upper()
    if mg not in validMGs:
      printUsage("invalid mustgather type")
    else:
      if cmd == 'COLLECT':
        if (len(parms) != 3):
          printUsage("destination is required for collect")
	else:
	  dest = parms[2]
          if os.path.isfile(dest):
	    printUsage("destination already exists")
	  if "-NOREMOTE" in options:
	    NOREMOTE = 1
	  else:
	    print "Collecting remote files may take several minutes, depending on the speed of the network and the amount of data."
      elif (len(parms) > 2):
        printUsage("too many arguments")
      else:
	for opt in options:
	  if opt == "-NOPERSISTENTTRACE":
	    NOPERSISTENTTRACE = 1
	  elif opt.startswith("-LOGFILESIZE="):
	    LOGFILESIZE = opt.split("=")[1]
	  elif opt.startswith("-LOGFILENUMBER="):
	    LOGFILENUMBER = opt.split("=")[1]


if cmd == 'COLLECT':
  if mg == '404':
    collect_404(dest)
  elif mg == '503':
    collect_503(dest)
  elif mg == '504':
    collect_504(dest)
  elif mg == 'AGENT':
    collect_agent(dest)
  elif mg == 'APC':
    collect_apc(dest)
  elif mg == 'APPEDITION':
    collect_appedition(dest)
  elif mg == 'ARFM':
    collect_arfm(dest)
  elif mg == 'DC':
    collect_dc(dest)
  elif mg == 'HADMGR':
    collect_hadmgr(dest)
  elif mg == 'HMM':
    collect_hmm(dest)
  elif mg == 'ODR':
    collect_odr(dest)
  elif mg == 'OPERATIONS':
    collect_operations(dest)
  elif mg == 'REPORTS':
    collect_reports(dest)
  elif mg == 'REPORTSPERF':
    collect_reportsPerf(dest)
  elif mg == 'REPOSITORY':
    collect_repository(dest)
  elif mg == 'REQUEST':
    collect_request(dest)
  elif mg == 'SIP':
    collect_sip(dest)
elif cmd == 'ENABLE':
  if mg == '404':
    enable_404()
  elif mg == '503':
    enable_503()
  elif mg == '504':
    enable_504()
  elif mg == 'AGENT':
    enable_agent()
  elif mg == 'APC':
    enable_apc()
  elif mg == 'APPEDITION':
    enable_appedition()
  elif mg == 'ARFM':
    enable_arfm()
  elif mg == 'DC':
    enable_dc()
  elif mg == 'HADMGR':
    enable_hadmgr()
  elif mg == 'HMM':
    enable_hmm()
  elif mg == 'ODR':
    enable_odr()
  elif mg == 'OPERATIONS':
    enable_operations()
  elif mg == 'REPORTS':
    enable_reports()
  elif mg == 'REPORTSPERF':
    enable_reportsPerf()
  elif mg == 'REPOSITORY':
    enable_repository()
  elif mg == 'REQUEST':
    enable_request()
  elif mg == 'SIP':
    enable_sip()
  AdminConfig.save()
elif cmd == 'DISABLE':
  if mg == '404':
    disable_404()
  elif mg == '503':
    disable_503()
  elif mg == '504':
    disable_504()
  elif mg == 'AGENT':
    disable_agent()
  elif mg == 'APC':
    disable_apc()
  elif mg == 'APPEDITION':
    disable_appedition()
  elif mg == 'ARFM':
    disable_arfm()
  elif mg == 'DC':
    disable_dc()
  elif mg == 'HADMGR':
    disable_hadmgr()
  elif mg == 'HMM':
    disable_hmm()
  elif mg == 'ODR':
    disable_odr()
  elif mg == 'OPERATIONS':
    disable_operations()
  elif mg == 'REPORTS':
    disable_reports()
  elif mg == 'REPORTSPERF':
    disable_reportsPerf()
  elif mg == 'REPOSITORY':
    disable_repository()
  elif mg == 'REQUEST':
    disable_request()
  elif mg == 'SIP':
    disable_sip()
  AdminConfig.save()



