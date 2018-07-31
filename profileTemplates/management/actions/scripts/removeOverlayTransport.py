
import sys, java
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
# Removes named endpoints with any of the given names from all serverentries
# on the given node
#
def removeNeps(node,targetNames):
  serverEntries = convertToList(AdminConfig.list("ServerEntry",node))
  for serverEntry in serverEntries:
    serverName = AdminConfig.showAttribute(serverEntry,"serverName")
    print "Processing server",serverName
    namedEndPoints = convertToList(AdminConfig.list("NamedEndPoint",serverEntry))
    for namedEndPoint in namedEndPoints:
      endPointName = AdminConfig.showAttribute(namedEndPoint,"endPointName")
      if endPointName in targetNames:
        print "Removing "+endPointName
        try:
          AdminConfig.remove(namedEndPoint)
        except:
          print "Exception removing " + endPointName + " from " + serverName
          continue

# Do it for all nodes and all serverentries, because why not

nodes = convertToList(AdminConfig.list("Node"))
for node in nodes:
  nodeName = AdminConfig.showAttribute(node,"name")
  print "Processing node",nodeName  		
  removeNeps(node,["OVERLAY_TCP_LISTENER_ADDRESS","OVERLAY_UDP_LISTENER_ADDRESS"])

AdminConfig.save()


