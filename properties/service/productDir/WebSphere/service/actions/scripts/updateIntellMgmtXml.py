#
# On the given node, update all the webserver intellmgmt.xml and plugin-cfg.xml files
# to the new retryInterval units (seconds, not milliseconds)
# For 8.5.5.0:8.5.5.2 to 8.5.5.3:8.5.5.X upgrades (9.X should use xd.op.migration action)
#

import sys, java, re, os, xml, javax
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

#
# Convert results from AdminConfig.show() into a dictionary
# They look like:
#  [maxRetries -1]
#  [retryInterval 60]
# Returns a dictionary of the values
#
def convertToDict(indict):
    outdict={};
    clist = indict.split(lineSeparator)
    for elem in clist:
        if (len(elem)>0 and elem[0]=='[' and elem[len(elem)-1]==']'):
            elem = elem[1:len(elem)-1] # remove the [] surrounding the line
            key, value = elem.split(" ", 1) # split on first space, everything else is value
            outdict[key] = value
    return outdict

#
# Parse server data element from the kind returned by AdminConfig.list()
# Looks like:
#  serverName(cells/cellName/nodes/nodeName/servers/serverName|server.xml#WebServer_12345)
# Returns a dictionary of cell, node, server
#
def parseServer(inelem):
    m = re.match(r".*\(cells/(?P<cell>.*)/nodes/(?P<node>.*)/servers/(?P<server>.*)\|.*\)", inelem);
    if (m is not None):
        return m.groupdict()

#
# Generate a string of the form:
#  (cells/cellName/nodes/nodeName/servers/serverName|file)
#
def getConfigObjectString(cell, node, server, file):
    return "(cells/" + cell + "/nodes/" + node + "/servers/" + server + "|" + file + ")"

#
# Get an absolute path to the given file for the given cell/node/server, on the current profile
#
def getConfigFilename(cell, node, server, file):
    return os.path.normpath(profilePath + "/config/cells/" + cell + "/nodes/" + node + "/servers/" + server + "/" + file)

#
# Get the XML document from the given XML file
# Due to old Jython (2.1, where 2.5 has more parsers available), this is a port of Java version
# from XD/ws/code/xd.op.migration/src/com/ibm/websphere/migration/helper/FileHelper.java
# Uses the Java Document API
#

def getXMLDocument(filename):
    # Create a builder factory
    factory = javax.xml.parsers.DocumentBuilderFactory.newInstance()
    factory.setValidating(0) # False
    factory.setIgnoringComments(1) # True
    factory.setIgnoringElementContentWhitespace(1) # True
    factory.setNamespaceAware(1) # True, needed on jdk1.6
    # Create the builder and parse the file
    doc = factory.newDocumentBuilder().parse(java.io.File(filename))
    return doc

def printHelp():
    print """
  DESCRIPTION
      updateIntellMgmtXml.py: this script requires -isDmgr:true/false and -profilePath:absolutePath
   """
    return 1

#=======================================================================================================================================================
#
# Main updateIntellMgmtXml.py execution logic:
#
#=======================================================================================================================================================

isDmgr = "false"
profilePath = ""
if (len(sys.argv) > 0):
  for arg in sys.argv:
    if (arg.startswith("-isDmgr:")):
      parts = arg.split(":")
      if (parts[1] == "true"):
        isDmgr = parts[1]
    elif (arg.startswith("-profilePath:")):
      parts = arg.split(":", 1)
      if (len(parts[1]) > 0):
        profilePath = parts[1]
else:
    printHelp()

print "isDmgr -->",isDmgr
print "profilePath -->",profilePath

if (isDmgr == "true"):
    # Iterate over every web server
    webserverListRaw = AdminConfig.list('WebServer')
    webserverList = convertToList(webserverListRaw)
    for webserverConfigName in webserverList:
        webserver = parseServer(webserverConfigName) # parse out cell/node/server
        intellmgmtURL = getConfigFilename(webserver['cell'], webserver['node'], webserver['server'], "intellmgmt.xml")
        print "Found webserver: " + webserver['server'] + " on node " + webserver['node']
        # Check whether intellmgmt.xml exists and has properties
        if (os.path.exists(intellmgmtURL)):
            print "    Found intellmgmt.xml"
            # If it exists, parse out retryInterval via XML utility functions (as AdminConfig is not working for this file in NONE connection type)
            intellmgmtDoc = getXMLDocument(intellmgmtURL)
            intellmgmt = intellmgmtDoc.getElementsByTagNameNS("http://www.ibm.com/websphere/appserver/schemas/5.0/intellmgmt.xmi", "IntelligentManagement").item(0)
            if (intellmgmt.hasAttribute('retryInterval')):
                retryInterval = int(intellmgmt.getAttribute('retryInterval'))
                print "    Found retryInterval: " + str(retryInterval)
                # If retryInterval >= 1000, divide it and save it via AdminTask (as AdminConfig does not support IntelligentManagement manipulation)
                if (retryInterval >= 1000):
                    retryIntervalNew = retryInterval / 1000;
                    print "    Modifying retryInterval to " + str(retryIntervalNew);
                    AdminTask.modifyIntelligentManagement('[-node ' + webserver['node'] + ' -webserver ' + webserver['server'] + ' -retryInterval ' + str(retryIntervalNew) + ']');

print "Saving the config changes"
AdminConfig.save();
