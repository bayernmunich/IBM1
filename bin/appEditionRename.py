#
# This script renames the edition of an application 
#
# See the usage() method below.
#

import sys, httplib, base64, jarray, re
import java.lang.System as System
import java.util.HashSet as Set
import time


def renameInitialize(toEdition):

   global newEdition, cellName

   #
   # Normalize edition names
   #
   newEdition = normalizeEditionName(toEdition)

   #
   # Get the name of the cell and the cell directory
   #
   cellName = AdminConfig.showAttribute(AdminConfig.list("Cell"),"name")


def renameEditionForCluster(cluster,isTest,exApps):
   print "renameEditionForCluster, '"+cluster+"'"
   
   try:
       allApps=AdminApp.list("WebSphere:cell="+cellName+",cluster="+cluster)
       renameEditionForApps(allApps,isTest,exApps)
   except:
       print "No available applications for the cluster '"+cluster+"'"   

def renameEditionForServer(node,server,isTest,exApps):
   try:
       apps=AdminApp.list("WebSphere:cell="+cellName+",node="+node+",server="+server)
       renameEditionForApps(apps,isTest,exApps)
   except:
       print "No available applications for "+node+"/"+server         

def renameEditionForApps(apps,isTest,exApps):
   
   if (apps=='' or len(apps) ==0):
      print "No applications were found"
      return
   
   renamedApps=Set()
   
   # ensure app is not renamed to app that already exists by checking existing apps
   existingApps=Set()   
   
   for appLongName in apps.splitlines():
      existingApps.add(appLongName)

   for appLongName in apps.splitlines():
      print "Processing application: " + appLongName
      #
      # Split the long name into two parts: appName and appEdition
      #
      appParts = appLongName.split("-edition")
      appName = appParts[0]
      if (len(appParts) > 1):
         appEdition = appParts[1]
      else:
         appEdition = ""
      newLongName=appName+"-edition"+newEdition
      
      #
      # Split the long name into two parts: appName and appEdition
      #
      if (appEdition == newEdition):
         print "Edition already set to '"+appEdition+"' for application '"+appLongName+"'"
      elif ((not exApps == '') and appLongName in exApps ):
         print "Excluding application: '"+appLongName+"'"
      else:
         try:
            if ((not renamedApps.contains(newLongName)) and (not existingApps.contains(newLongName))):
                if(isTest):    
                    print "TEST:  Edition would be set edition to '"+newEdition+"' for application '"+appLongName+"'"
                    renamedApps.add(newLongName)
                else:                
                    AdminApp.rename(appLongName, newLongName)                
                    print "Set edition to '"+newEdition+"' for application '"+appLongName+"'"
                    #print "Delay to allow configuration to be updated"
                    #time.sleep(10)
                    renamedApps.add(newLongName)
            else:
                print "Can not rename '"+appLongName+"'. Edition '"+newEdition+"' already exists for '"+appName+"'"
         except Exception:
            print "failed to rename application '"+appLongName+"' to edition '"+newEdition+"': "	     



def normalizeEditionName(edition):
   if edition == '_':
      return ""
   else:
      return edition
   
def nodeSync():
    print "Synchronizing changes to all nodes ..."
    try:
        # Sync to each node
        syncs = AdminControl.queryNames("type=NodeSync,process=nodeagent,*")
        for sync in syncs.splitlines():
           try:
              result = AdminControl.invoke(sync, "sync", "")
           except:
              print "Node synchronization failure: "+sync
        print "Synchronization to all nodes is complete"
    except:
        print "Node synchronization failed"
		
#
# Print a usage message
#
def usage(msg):
  print "Usage: "+msg+"""
  Supported commands:
    -renameForCluster <cluster> <newEdition>
       All applications deployed to <cluster> will have the edition renamed to <newEdition>
    -renameForServer <node> <server> <newEdition>
       All applications deployed to <server> on <node> will have the edition renamed to <newEdition>
  where arguments are:
    <newEdition> New edition name
    <cluster> Name of target cluster
    <node> Name of node
    <server> Name of server on <node>
  """
  sys.exit(1)



#
# Get argument number 'count'; print a usage message if it doesn't exist.
#
def getArg(name,count):
  if(len(sys.argv) <= count):
    usage("too few arguments; argument "+name+" not found")
  return sys.argv[count].rstrip()

def argExists(name):
  for arg in sys.argv:  
      if (arg == name):
         return 1
  return 0  
  
def getValue(name):
  for arg in sys.argv:  
      if (arg.startswith(name)):
         parts = arg.split("=")
         if (len(parts) > 1):          
            vals=parts[1].rstrip()
            return vals.split(",")         
  return ''    
#========================================================================================
#
# Begin main
#
#========================================================================================

cmd = str(getArg('<command>',0))

# Set of excluded used that will not be renamed
excludedApps=getValue('-excludedApps')

# Indicates if rename command should only display the applications that will be renamed.  
# The applications will not be renamed
isTest=argExists('-test')

if (cmd == '-renameForCluster'):
   renameInitialize(getArg('<newEdition>',2))
   renameEditionForCluster(getArg('<cluster>',1),isTest,excludedApps)
   if(not isTest):
       print "Saving..."   
       AdminConfig.save()
       nodeSync()
       time.sleep(100)
elif (cmd == '-renameForServer'):  
   renameInitialize(getArg('<newEdition>',3))
   renameEditionForServer(getArg('<node>',1),getArg('<server>',2),isTest,excludedApps)
   if(not isTest):
       print "Saving..."   
       AdminConfig.save()   
       nodeSync()
else:
   usage("invalid command: "+cmd)
