
###############################################################################
# Licensed Material - Property of IBM 
# 5724-I63, 5724-H88, (C) Copyright IBM Corp. 2005 - All Rights Reserved. 
# US Government Users Restricted Rights - Use, duplication or disclosure 
# restricted by GSA ADP Schedule Contract with IBM Corp. 
#
# DISCLAIMER:
# The following source code is sample code created by IBM Corporation.
# This sample code is provided to you solely for the purpose of assisting you 
# in the  use of  the product. The code is provided 'AS IS', without warranty or 
# condition of any kind. IBM shall not be liable for any damages arising out of your
# use of the sample code, even if IBM has been advised of the possibility of
# such damages.
###############################################################################

#
#------------------------------------------------------------------------------
# AdminCusterManagement.py - Jython procedures for performing cluster management tasks.
#------------------------------------------------------------------------------
#
#   This script includes the following cluster management procedures:
#      Ex1:  listClusters
#      Ex2:  listClusterMembers
#      Ex3:  createClusterWithoutMember
#      Ex4:  createClusterWithFirstMember
#      EX5:  createClusterMember
#      Ex6:  createFirstClusterMemberWithTemplate
#      Ex7:  createFirstClusterMemberWithTemplateNodeServer
#      Ex8:  deleteCluster
#      Ex9:  deleteClusterMember
#      Ex10: startAllClusters
#      Ex11: startSingleCluster
#      Ex12: stopAllClusters
#      Ex13: stopSingleCluster
#      Ex14: rippleStartAllClusters
#      Ex15: rippleStartSingleCluster
#      Ex16: immediateStopAllClusters
#      Ex17: immediateStopSingleCluster
#      Ex18: checkIfClusterExists
#      Ex19: checkIfClusterMemberExists
#      Ex20: help
#
#---------------------------------------------------------------------


#--------------------------------------------------------------------
# Set global constants
#--------------------------------------------------------------------

import sys
import java
import AdminUtilities 

# Global variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)


## Example 1 List all clusters ##
def listClusters(failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listClusters("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # List server clusters
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: List server clusters"
                print " Usage: AdminClusterManagement.listClusters()"
                print " Return: List of the clusters in the cell."
                print "---------------------------------------------------------------"
                print " "
                print " "
                clusters = AdminConfig.list("ServerCluster")
                
                if (len(clusters) > 0):
                   # Convert Jython string to list
                   clusters = AdminUtilities.convertToList(clusters)
                
                   # Loop on each cluster
                   for aCluster in clusters:
                       AdminUtilities.infoNotice("cluster is found: " + aCluster)
                   #endFor
                #endIf
                return clusters
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 2 List cluster members of a given cluster ##
def listClusterMembers( clusterName, failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listClusterMembers("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # List server cluster members
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         List server cluster members"
                print " Cluster name:                   "+clusterName
                print " Usage: AdminClusterManagement.listClusterMembers(\""+clusterName+"\")"
                print " Return: List of the cluster members in the specified cluster."
                print "---------------------------------------------------------------"
                print " "
                print " "
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf
                
                members = []
                # Retrieve cluster name
                clusterName = AdminConfig.showAttribute(cluster, "name")
                
                # Obtain cluster server members
                members = AdminConfig.showAttribute(cluster, "members")
                
                # Convert Jython string to list
                members = AdminUtilities.convertToList(members)
                   
                # Loop on each server member
                if len(members) > 0:
                   AdminUtilities.infoNotice("cluster " + clusterName + " has %s members" % (len(members)))
                   for member in members:
                       mname = AdminConfig.showAttribute(member, "memberName")
                       AdminUtilities.infoNotice("Cluster member: " + mname)
                   #endFor
                #endIf
                return members   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 3 Create a new cluster without any member ##
def createClusterWithoutMember( clusterName, failonerror=AdminUtilities._BLANK_ ):  
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createClusterWithoutMember("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create a new server cluster without server member
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------------------"
                print " AdminClusterManagement:         Create a new server cluster without member"
                print " New cluster name:               "+clusterName
                print " Usage: AdminClusterManagement.createClusterWithoutMember(\""+clusterName+"\") "
                print " Return: The configuration ID of the new cluster."
                print "----------------------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) > 0):
                      # cluster exists 
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [clusterName]))
                #endIf

                # Create cluster without server members
                cluster = AdminTask.createCluster(['-clusterConfig', ['-clusterName', clusterName]])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
                
                return cluster
                
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
  #endDef

#endDef


## Example 4 Create a new cluster with first member##
def createClusterWithFirstMember( clusterName, clusterType, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):  
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createClusterWithFirstMember("+`clusterName`+", "+`clusterType`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create a new server cluster and convert a server to the first cluster member
                #--------------------------------------------------------------------
                print "-------------------------------------------------------------------------"
                print " AdminClusterManagement:                 Create a new server cluster and convert a server to first cluster member"
                print " New cluster name:                       "+clusterName
                print " Cluster type (i.e. APPLICATION_SERVER): "+clusterType
                print " Node name (node to be converted to first cluster member):       "+nodeName
                print " Server name (server to be converted to first cluster member):   "+serverName
                print " Usage: AdminClusterManagement.createClusterWithFirstMember(\""+clusterName+"\", \""+clusterType+"\", \""+nodeName+"\", \""+serverName+"\") "
                print " Return: The configuration ID of the new cluster."
                print "-------------------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
               
                if (clusterType == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterType", clusterType]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                
                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                # check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                if (len(cluster) > 0):
                   # cluster exists 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [clusterName]))
                #endIf

                # check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf

                # check if server exists
                server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
                if (len(server) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
                #endIf
                
                # create a new cluster with first member
                cluster = AdminTask.createCluster(['-clusterConfig', ['-clusterName', clusterName, '-clusterType', clusterType], '-convertServer', ['-serverNode', nodeName, '-serverName', serverName]])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return cluster
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
  #endDef

#endDef
  

## Example 5 Create a cluster server member ##
def createClusterMember( clusterName, nodeName, newMember, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createClusterMember("+`clusterName`+", "+`nodeName`+", "+`newMember`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create a new cluster member
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------------"
                print " AdminClusterManagement:         Create a new cluster server member"
                print " Cluster name:                   "+clusterName
                print " Member node name:               "+nodeName
                print " New member name:                "+newMember
                print " Usage: AdminClusterManagement.createClusterMember(\""+clusterName+"\", \""+nodeName+"\", \""+newMember+"\") "
                print " Return: The configuration ID of the new cluster member."
                print "-----------------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (newMember == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["newMember", newMember]))

                # check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf

                # check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf

                # create a new cluster member
                clusterMember = AdminTask.createClusterMember(['-clusterName', clusterName, '-memberConfig', ['-memberNode', nodeName, '-memberName', newMember]])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
                
                return clusterMember
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef

  
## Example 6 Create first cluster member using template name ##
def createFirstClusterMemberWithTemplate( clusterName, nodeName, newMember, templateName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createClusterMemberWithTemplate("+`clusterName`+", "+`nodeName`+", "+`newMember`+", "+`templateName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create first cluster member using template name
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Create first cluster member using template name"
                print " Cluster name:                   "+clusterName
                print " Member node name:               "+nodeName
                print " New member name:                "+newMember
                print " Template name (template name to use when creating first cluster member):        "+templateName
                print " Usage: AdminClusterManagement.createFirstClusterMemberWithTemplate(\""+clusterName+"\", \""+nodeName+"\", \""+newMember+"\", \""+templateName+"\") "
                print " Return: The configuration ID of the new cluster member."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (newMember == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["newMember", newMember]))
                
                if (templateName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateName", templateName]))

                # check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf

                # check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # Invoke command using Jython list syntax
                clusterMember = AdminTask.createClusterMember(['-clusterName', clusterName, '-memberConfig', ['-memberNode', nodeName, '-memberName', newMember], '-firstMember', ['-templateName', templateName]])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return clusterMember
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef

  
## Example 7 Create first cluster member using templateServerNode and templateServerName##
def createFirstClusterMemberWithTemplateNodeServer( clusterName, nodeName, newMember, templateNode, templateServer, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createFirstClusterMemberWithTemplateNodeServer("+`clusterName`+", "+`nodeName`+", "+`newMember`+", "+`templateNode`+", "+`templateServer`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create first cluster member using template node and server information
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Create first cluster server member using templateServerNode and templateServerName"
                print " Cluster name:           "+clusterName
                print " Member node name:       "+nodeName
                print " New member name:        "+newMember
                print " Template node name:     "+templateNode
                print " Template server name:   "+templateServer
                print " Usage: AdminClusterManagement.createFirstClusterMemberWithTemplateNodeServer(\""+clusterName+"\", \""+nodeName+"\", \""+newMember+"\", \""+templateNode+"\", \""+templateServer+"\") "
                print " Return: The configuration ID of the new cluster member."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (newMember == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["newMember", newMember]))
                
                if (templateNode == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateNode", templateNode]))

                if (templateServer == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateServer", templateServer]))

                # check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf

                # check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # check if server exists                
                server = AdminConfig.getid("/Node:"+templateNode+"/Server:"+templateServer)
                if (len(server) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["templateServer", templateServer]))
                #endIf
                
                # Invoke command using Jython list syntax
                clusterMember = AdminTask.createClusterMember(['-clusterName', clusterName, '-memberConfig', ['-memberNode', nodeName, '-memberName', newMember], '-firstMember', ['-templateServerNode', templateNode, '-templateServerName', templateServer]])
               
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return clusterMember
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 8 Delete a cluster ##
def deleteCluster( clusterName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteCluster("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a cluster
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Delete a cluster"
                print " Cluster name:                   "+clusterName
                print " Usage: AdminClusterManagement.deleteCluster(\""+clusterName+"\") "
                print " Return: If the command is successful, the ADMG9228I message is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                   #endIf
                #endIf

                # Delete a cluster
                result = AdminTask.deleteCluster(['-clusterName', clusterName])
               
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef
  

## Example 9 Delete a cluster member ##
def deleteClusterMember( clusterName, nodeName, serverMember, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteClusterMember("+`clusterName`+", "+`nodeName`+", "+`serverMember`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete cluster member
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Delete cluster member"
                print " Cluster name:                   "+clusterName
                print " Node name:                      "+nodeName
                print " Server member name:             "+serverMember
                print " Usage: AdminClusterManagement.deleteClusterMember(\""+clusterName+"\", \""+nodeName+"\", \""+serverMember+"\") "
                print " Return: If the command is successful, the ADMG9239I message is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverMember == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverMember", serverMember]))

                # check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf
                
                # check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # check if server member exists
                s = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverMember)
                if (len(s) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverMember", serverMember]))
                #endIf
                
                # Invoke command using Jython list syntax
                result = AdminTask.deleteClusterMember(['-clusterName', clusterName, '-memberNode', nodeName, '-memberName', serverMember])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 10 Start all clusters in the cell##
def startAllClusters( failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "startAllClusters("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Start all clusters
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Start all clusters"
                print " Usage: AdminClusterManagement.startAllClusters() "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")

                cls = AdminConfig.list("ServerCluster")
                if (len(cls) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ServerCluster"]))
                else:
                   # Identify the clusterMgr MBean
                   clusterMgr = AdminControl.queryNames("cell="+cellName+",type=ClusterMgr,*")
                
                   # Refresh the list of clusters
                   AdminControl.invoke(clusterMgr, "retrieveClusters")
                
                   # Obtain the list of cluster MBeans
                   clusters = AdminControl.queryNames("cell="+cellName+",type=Cluster,*")
                   if (len(clusters) == 0):
                      # cluster mbean is not running
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", Cluster]))
                   #endIf
                   
                   # Convert Jython string to list
                   clusters = AdminUtilities.convertToList(clusters)
                
                   # Start each cluster when cluster is stopped in the cluster list
                   for aCluster in clusters:
                       if (AdminControl.getAttribute(aCluster, "state") != "websphere.cluster.stopped"):
                          AdminUtilities.infoNotice("Cluster: " +  aCluster + "  started already.")                   
                       else:
                          AdminUtilities.infoNotice("Start cluster: " + aCluster)
                          AdminControl.invoke(aCluster, "start")
                       #endIf
                   #endFor
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef
  

## Example 11 Start the cluster ##
def startSingleCluster(clusterName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "startSingleCluster("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Start a cluster
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Start a cluster"
                print " Cluster name:                   "+clusterName
                print " Usage: AdminClusterManagement.startSingleCluster(\""+clusterName+"\") "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                   #endIf
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Identify the clusterMgr MBean
                clusterMgr = AdminControl.queryNames("cell="+cellName+",type=ClusterMgr,*")
                
                # Refresh the list of clusters
                AdminControl.invoke(clusterMgr, "retrieveClusters")
                
                # Obtain the list of cluster MBeans
                cluster = AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+",*")
                
                # Start the cluster when the cluster is stopped
                if (AdminControl.getAttribute(cluster, "state") != "websphere.cluster.stopped"):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6043E", ["Cluster", clusterName]))
                else:
                   AdminUtilities.infoNotice("Start cluster: " + cluster)
                   AdminControl.invoke(cluster, "start")
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 12 Stop all running clusters in the cell##
def stopAllClusters( failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "stopAllClusters("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Stop all running clusters
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Stop all running clusters"
                print " Usage: AdminClusterManagement.stopAllClusters() "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")

                cls = AdminConfig.list("ServerCluster")
                if (len(cls) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ServerCluster"]))
                else:
                   # Obtain the list of cluster MBeans
                   clusters = AdminControl.queryNames("cell="+cellName+",type=Cluster,*")
                   if (len(clusters) == 0):
                      # cluster mbean is not running
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", Cluster]))
                   #endIf
                   
                   # Convert Jython string to list
                   clusters = AdminUtilities.convertToList(clusters)

                   # Stop each running cluster in the cluster list
                   for aCluster in clusters:
                      if (AdminControl.getAttribute(aCluster, "state") != "websphere.cluster.running"):
                         AdminUtilities.infoNotice("Cluster: " +  aCluster + "  stopped already.")  
                      else:    
                         AdminUtilities.infoNotice("Stop the running cluster: " + aCluster)
                         AdminControl.invoke(aCluster, "stop")
                      #endIf
                   #endFor
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 13 Stop a specific cluster##
def stopSingleCluster( clusterName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "stopSingleCluster("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Stop a cluster
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement:         Stop a cluster"
                print " Cluster name:                   "+clusterName
                print " Usage: AdminClusterManagement.stopSingleCluster(\""+clusterName+"\") "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                   #endIf
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Obtain the list of cluster MBeans
                cluster = AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+",*")
                
                # Stop the running cluster 
                if (AdminControl.getAttribute(cluster, "state") != "websphere.cluster.running"):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", clusterName]))
                else:
                   AdminUtilities.infoNotice("Stop cluster: " + cluster)
                   AdminControl.invoke(cluster, "stop")
                #endIf
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 14 Ripple start all clusters in the cell##
def rippleStartAllClusters( failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "rippleStartAllClusters("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Ripple start all clusters
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Ripple start all clusters (stop and restart all clusters)"
                print " Usage: AdminClusterManagement.rippleStartAllClusters() "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")

                cls = AdminConfig.list("ServerCluster")
                if (len(cls) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ServerCluster"]))
                else:
                   # Identify the clusterMgr MBean
                   clusterMgr = AdminControl.queryNames("cell="+cellName+",type=ClusterMgr,*")
                
                   # Refresh the list of clusters
                   AdminControl.invoke(clusterMgr, "retrieveClusters")
                
                   # Obtain the list of cluster MBeans
                   clusters = AdminControl.queryNames("cell="+cellName+",type=Cluster,*")
                   if (len(clusters) == 0):
                      # cluster mbean is not running
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", Cluster]))
                   #endIf
                   
                   # Convert Jython string to list
                   clusters = AdminUtilities.convertToList(clusters)
                
                   # Ripple start each running cluster in the cluster list
                   for aCluster in clusters:
                      if (AdminControl.getAttribute(aCluster, "state") != "websphere.cluster.running"):
                         AdminUtilities.infoNotice("Cluster: " +  aCluster + "  is not running.  Cannot ripple start.")  
                      else:   
                         AdminUtilities.infoNotice("Ripple start cluster: " + aCluster)
                         AdminControl.invoke(aCluster, "rippleStart")
                      #endIf
                   #endFor
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 15 Ripple start a specific cluster ##
def rippleStartSingleCluster( clusterName, failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "rippleStartSingleCluster("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Ripple start a cluster
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Ripple start the specific cluster (stop and restart cluster members of the cluster)"
                print " Cluster name:           "+clusterName
                print " Usage: AdminClusterManagement.rippleStartSingleCluster(\""+clusterName+"\") "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                   #endIf
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Identify cluster MBbean
                cluster = AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+",*")
                
                # Ripple start the running cluster
                if (AdminControl.getAttribute(cluster, "state") != "websphere.cluster.running"):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", clusterName]))
                else:
                   AdminUtilities.infoNotice("Ripple start cluster: " + cluster)
                   AdminControl.invoke(cluster, "rippleStart")
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 16 Immediate stop all running clusters in the cell##
def immediateStopAllClusters( failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "immediateStopAllClusters("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Immediate stop all running clusters
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Immediate stop all running clusters"
                print " Usage: AdminClusterManagement.immediateStopAllClusters() "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
               
                cls = AdminConfig.list("ServerCluster")
                if (len(cls) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ServerCluster"]))
                else:
                   # Obtain the list of cluster MBeans
                   clusters = AdminControl.queryNames("cell="+cellName+",type=Cluster,*")
                   if (len(clusters) == 0):
                      # cluster mbean is not running
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", Cluster]))
                   #endIf
                   
                   # Convert Jython string to list
                   clusters = AdminUtilities.convertToList(clusters)
                
                   # Stop each running cluster immediately in the cluster list
                   for aCluster in clusters:
                      if (AdminControl.getAttribute(aCluster, "state") != "websphere.cluster.running"):
                         AdminUtilities.infoNotice("Cluster: " +  aCluster + "  stopped already.")  
                      else:
                         AdminUtilities.infoNotice("Stop running cluster immediately: " + aCluster)
                         AdminControl.invoke(aCluster, "stopImmediate")
                      #endIf
                   #endFor
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 17 Immediate stop a specific cluster ##
def immediateStopSingleCluster( clusterName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "immediateStopSingleCluster("+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Start clusters
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Immediate stop a cluster"
                print " Cluster name:           "+clusterName
                print " Usage: AdminClusterManagement.immediateStopSingleCluster(\""+clusterName+"\") "
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check  the required arguments
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                   #endIf
                #endIf

                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")

                # Identify the cluster MBean
                cluster = AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+",*")
                
                # Stop the running cluster immediately
                if (AdminControl.getAttribute(cluster, "state") != "websphere.cluster.running"):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", clusterName]))
                else:
                   AdminUtilities.infoNotice("Stop cluster immediately " + cluster)
                   AdminControl.invoke(cluster, "stopImmediate")
                #endIf   
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 18 Check if cluster exists ##
def checkIfClusterExists ( clusterName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "checkIfClusterExists("+`clusterName`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # Check if cluster exists
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Check if cluster exists"
                print " Cluster Name:           "+clusterName
                print " Usage: AdminClusterManagement.checkIfClusterExists(\""+clusterName+"\")"
                print " Return: If the cluster exists, a true value is returned.  Otherwise, a false value is returned" 
                print "---------------------------------------------------------------"
                print " "
                print " "
                clusterExists = "false"
                
                # check  the required argument
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))

                cluster = AdminConfig.getid("/ServerCluster:"+clusterName+"/")
                if (len(cluster) > 0):
                   clusterExists = "true"
                #endIf    
                return clusterExists
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 19 Check if server member exists in the cluster##
def checkIfClusterMemberExists ( clusterName, serverMember, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "checkIfClusterMemberExists("+`clusterName`+", "+`serverMember`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # Check if cluster server member exists
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminClusterManagement: Check if server member exists in cluster"
                print " Cluster Name:           "+clusterName
                print " Server member name:     "+serverMember
                print " Usage: AdminClusterManagement.checkIfClusterMemberExists(\""+clusterName+"\", \""+serverMember+"\")"
                print " Return: If the cluster member exists, a true value is returned.  Otherwise, a false value is returned" 
                print "---------------------------------------------------------------"
                print " "
                print " "
                clusterMemberExists = "false"
                
                # check  the required argument
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                
                if (serverMember == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverMember", serverMember]))

                # check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:" +clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf
                
                # Obtain list of cluster server members
                members = listClusterMembers(clusterName)
                
                # Loop through cluster server member list and check if serverMember exists
                if len(members) > 0:
                    for member in members:
                        memName = AdminConfig.showAttribute(member, "memberName")
                        if (memName == serverMember):
                             clusterMemberExists = "true"
                             break
                          #endIf
                      #endFor
                   #endIf
                #endIf
                return clusterMemberExists
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef
  

## Example 20 Online help ##
def help(procedure="", failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
               failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "help("+`procedure`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Provide the online help
                #--------------------------------------------------------------------
                #print "---------------------------------------------------------------"
                #print " AdminClusterManagement:         Help "
                #print " Script procedure:               "+procedure
                #print " Usage: AdminClusterManagement.help(\""+procedure+"\")"
                #print " Return: Receive help information for the specified script library function."
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)
                
                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINCLUSTERMANAGEMENT_GENERAL_HELP")
                else:
                   procedure = "ADMINCLUSTERMANAGEMENT_HELP_"+procedure.upper()
                   message = resourceBundle.getString(procedure)
                #endIf
                return message
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        #AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef

