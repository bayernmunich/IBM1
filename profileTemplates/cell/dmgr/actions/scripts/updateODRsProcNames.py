#
# For z/OS node only.
# On the given node, update all the ODR servers old Control and Servant startCommand
# to the current new Control and Servant startCommand
#

import sys, java
start=java.lang.System.currentTimeMillis()
lineSeparator = java.lang.System.getProperty('line.separator')

#
# Stolen from some other random augmentation script, this makes a list from
# the sort of thing that AdminConfig.list() and so on return.
#
def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split(lineSeparator)
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def printHelp():
    print """
  DESCRIPTION
      updateODRsProcNames.py: this script takes the node name as input: <node_name>
      "e.g.:     updateODRsProcNames.py  mynode
   """
    return 1

#=======================================================================================================================================================
#
# Main updateODRsProcNames.py execution logic:
#
#=======================================================================================================================================================

if(len(sys.argv) == 1):
    nodeName = sys.argv[0]
    print "INFO: nodename="+nodeName
else:
    printHelp()

currentTime=java.lang.System.currentTimeMillis()
tmpODR = "odr" + str(currentTime)

print "creating a temporary odr: " + tmpODR + " on node: " + nodeName
AdminTask.createOnDemandRouter(nodeName, '[-name '+tmpODR+' -templateName odr_zos]')

controlStartCommand = AdminTask.showProcessDefinition('[-serverName '+tmpODR+' -nodeName '+nodeName+' -processType Control -propertyName startCommand]')
print "new controlStartCommand="+controlStartCommand

servantStartCommand = AdminTask.showProcessDefinition('[-serverName '+tmpODR+' -nodeName '+nodeName+' -processType Servant -propertyName startCommand]')
print "new servantStartCommand="+servantStartCommand

print "searching for ODRs"
servers=convertToList(AdminConfig.list("Server"))
for server in servers:
    parts = server.split('/')
    nname = parts[3]
    if (nname == nodeName):
       try:
          stype = AdminConfig.showAttribute(server,"serverType")
       except JavaThrowable:
          stype = "UNKNOWN"
       if (stype == "ONDEMAND_ROUTER"):
          sname = AdminConfig.showAttribute(server,"name")
          if (sname != tmpODR):
             print "updating odr: "+sname+" control startCommand: "+controlStartCommand
             AdminTask.setProcessDefinition('[-serverName '+sname+' -nodeName '+nname+' -processType Control -startCommand ['+controlStartCommand+']]')
             print "updating odr: "+sname+" servant startCommand: "+servantStartCommand
             AdminTask.setProcessDefinition('[-serverName '+sname+' -nodeName '+nname+' -processType Servant -startCommand ['+servantStartCommand+']]')

print "deleting temporary odr: " + tmpODR + " on node: " + nodeName
AdminTask.deleteServer("-serverName "+tmpODR+" -nodeName "+nodeName)

print "saving the config changes"
AdminConfig.save();
