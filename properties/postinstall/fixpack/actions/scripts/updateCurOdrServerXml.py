#
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

def getServerType(serverTemplate):
    tokens = serverTemplate.split("/")
    idx = 0
    for token in tokens:
#      serverTemplate is of the form 'defaultXD(templates/servertypes/APPLICATION_SERVER/servers/defaultXD|server.xml#Server_1210548827522)'
#      return third token 
       if (idx == 2): 
         return token
       idx=idx+1
    return None

def printHelp():
    print """
  DESCRIPTION
      updateCurOdrServerXml.py: this script takes the jvm bit flag as input: <is64BitJvm>
      "e.g.:     updateCurOdrServerXml.py  true/false
   """
    return 1

#=======================================================================================================================================================
#
# Main updateCurOdrServerXml.py execution logic:
#
#=======================================================================================================================================================

is64BitJvm = "false"
isDmgr = "false"
isCustomOrDefault = "false"
if (len(sys.argv) > 0):
  for arg in sys.argv:
    if (arg.startswith("-is64BitJvm:")):
      parts = arg.split(":")
      if (parts[1] == "true"):
        is64BitJvm = parts[1]
    elif (arg.startswith("-isDmgr:")):
      parts = arg.split(":")
      if (parts[1] == "true"):
        isDmgr = parts[1]
    elif (arg.startswith("-isCustomOrDefault:")):
      parts = arg.split(":")
      if (parts[1] == "true"):
        isCustomOrDefault = parts[1]
else:
    printHelp()

print "isDmgr -->",isDmgr
print "isCustomOrDefault -->",isCustomOrDefault
print "is64BitJvm -->",is64BitJvm

if (isDmgr == "true"):
  print "Add generic JVM argument '-agentlib:HeapDefect or HeapDetect64' to ODR or VE server templates"
  serverTemplates1 = AdminConfig.listTemplates("Server","defaultXD")
  serverTemplates2 = AdminConfig.listTemplates("Server","odr")
  serverTemplates3 = serverTemplates1 + lineSeparator + serverTemplates2
  serverTemplates = convertToList(serverTemplates3)
  for serverTemplate in serverTemplates:
    serverType = getServerType(serverTemplate)
    serverTemplateName = AdminConfig.showAttribute(serverTemplate,"name")
    if ((serverType == "APPLICATION_SERVER" and (serverTemplateName == "defaultXD" or serverTemplateName == "defaultXDZOS")) or
        (serverType == "ONDEMAND_ROUTER")):
       procDefs = convertToList(AdminConfig.showAttribute(serverTemplate, "processDefinitions"))
       for procDef in procDefs:
           if (procDef.find("JavaProcessDef") != -1):
              jvmEntries = AdminConfig.showAttribute(procDef, "jvmEntries")
              if (len(jvmEntries)>0 and jvmEntries[0]=='[' and jvmEntries[len(jvmEntries)-1]==']'):
              	  jvmEntries = jvmEntries[1:len(jvmEntries)-1]
              genericArgs = AdminConfig.showAttribute(jvmEntries, "genericJvmArguments")
              if (is64BitJvm == "true"):
                if (genericArgs.find("-agentlib:HeapDetect64") == -1):
                   genericArgs = "-agentlib:HeapDetect64 " + genericArgs
                   AdminConfig.modify(jvmEntries, [["genericJvmArguments", genericArgs]])
              else:
                if (genericArgs.find("-agentlib:HeapDetect") == -1):
                   genericArgs = "-agentlib:HeapDetect " + genericArgs
                   AdminConfig.modify(jvmEntries, [["genericJvmArguments", genericArgs]])


print "saving the config changes"
AdminConfig.save();
