###############################################################################
# "This program may be used, executed, copied, modified and distributed without
# royalty for the purpose of developing, using, marketing, or distributing."
#
# (C) COPYRIGHT International Business Machines Corp., 2010
# All Rights Reserved * Licensed Materials - Property of IBM
###############################################################################
#******************************************************************************
# File Name:   setMaintMode.py
# Description: This file will setup the maintenance mode for a node or a server.
#		
#		
# Author: xxxxxxxxxxxx
#
# History: 	
#		
#******************************************************************************	
import sys
import os

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

def printHelp(bad): 
    print "\nerror: "+bad
    print "Select option then accompanying parameters:"
    print "\tsetNodeMaintenanceMode"
    print "\t\t-nodeName:<node name>                    Node Name"
    print "\t\t-mode:<on, off>                          Maintenance Mode"
    print "\tsetServerMaintenanceMode"
    print "\t\t-nodeName:<node name>                    Node Name"
    print "\t\t[-serverName:<server name>]              Server Name; if omitted, all servers on the node"
    print "\t\t-mode:<break, affinity, stop, off>       Maintenance Mode"
    sys.exit(1)

#======================================================================
#
# Main execution logic:
#
#======================================================================

if(len(sys.argv) > 0):
  option = sys.argv[0]
  ignore = 0

  if (option == 'setServerMaintenanceMode'):
    nodeName = ''
    serverName = ''
    mode = "off"

    for arg in sys.argv:
      if (ignore == 0):
        ignore = 1
      elif (arg.startswith("-nodeName:")):
        parts = arg.split(":")
        nodeName=parts[1]
      elif (arg.startswith("-serverName:")):
        parts = arg.split(":")
        serverName=parts[1]
      elif (arg.startswith("-mode:")):
        parts = arg.split(":")
        mode=parts[1]
      else:
        printHelp(arg)

    # If no node was identified, error.
    if (nodeName == ''):
      printHelp("nodeName")
      
    # If no server name was specified, operate on ALL the servers on the given node, except nodeagents.
    if (serverName == ''):
    #  printHelp("serverName")
      allNodes=convertToList(AdminConfig.list("Node"))
      # Select the node matching the provided node name
      node=''
      for inode in allNodes:
         # print "Looking for node "+nodeName+" in node "+inode
         inodeName = AdminConfig.showAttribute(inode,"name")
         if (inodeName == nodeName):
            # print "That's the one!"
            node=inode;
            break
      # allServers=AdminConfig.list("Server",nodeName)
      if (node==''):
        # Did not find the named node.  
        print "Could not find node "+nodeName+".  Check your configuration and the spelling of the node name and try again.  Terminating."
        sys.exit(1) 

      # Get all the servers under the node we found.
      servers=convertToList(AdminConfig.list("Server",node))
      for server in servers:
	serverName=AdminConfig.showAttribute(server,"name")
        # Skip the nodeagent - doesn't make sense to put it in/out of maintenance mode.
	if (serverName=="nodeagent"):
          continue
        if (mode == 'off'):
          atParms = "[-name "+serverName+"]"
          print "Turning off maintenance mode for "+serverName+" on "+nodeName
          AdminTask.unsetMaintenanceMode(nodeName, atParms)
        else:
          atParms = "[-name "+serverName+" -mode "+mode+"]"
          print "Setting maintenance mode to "+mode+" for "+serverName+" on "+nodeName
          AdminTask.setMaintenanceMode(nodeName, atParms)
    else:
         # Operating on only a single server.  
	 if (mode == 'off'):
	    atParms = "[-name "+serverName+"]"
	    print "Turning off maintenance mode for "+serverName+" on "+nodeName
	    AdminTask.unsetMaintenanceMode(nodeName, atParms)
	 else:
	    atParms = "[-name "+serverName+" -mode "+mode+"]"
	    print "Setting maintenance mode to "+mode+" for "+serverName+" on "+nodeName
	    AdminTask.setMaintenanceMode(nodeName, atParms)

  elif (option == 'setNodeMaintenanceMode'):
    nodeName = ''
    for arg in sys.argv:
      if (ignore == 0):
        ignore = 1
      elif (arg.startswith("-nodeName:")):
        parts = arg.split(":")
        nodeName=parts[1]
      elif (arg.startswith("-mode:")):
        parts = arg.split(":")
        mode=parts[1]
      else:
        printHelp(arg)

    # A node name must be specified. If not, error.
    if (nodeName == ''):
      printHelp("nodeName")

    if (mode == 'on'):
      mbeanStr='WebSphere:*,type=NodeGroupManager'
      mbeans=convertToList(AdminControl.queryNames(mbeanStr))
      for mbean in mbeans:
        print('Invoking mbean for on')
        AdminControl.invoke(mbean, "setMaintenanceMode", '[%s %s %s]' % (nodeName, 'true', 'true'))
        break
    elif (mode == 'off'):
      mbeanStr='WebSphere:*,type=NodeGroupManager'
      mbeans=convertToList(AdminControl.queryNames(mbeanStr))
      for mbean in mbeans:
        print('Invoking mbean for off')
        AdminControl.invoke(mbean, "setMaintenanceMode", '[%s %s %s]' % (nodeName, 'false', 'true'))
        break
    else:
      printHelp(mode)
      
  else:
    printHelp(option)
else:
  printHelp("no args")

#===========================================================================================
#  Save Configuration
#===========================================================================================
print "Saving configuration changes"
AdminConfig.save()
print "Done"
