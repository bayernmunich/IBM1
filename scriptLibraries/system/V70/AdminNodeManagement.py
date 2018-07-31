
###############################################################################
# Licensed Material - Property of IBM 
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) Copyright IBM Corp. 2007, 2008 - All Rights Reserved. 
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
#AdminNodeManagement.py - Jython procedures for node execution
#------------------------------------------------------------------------------
#
#This script includes the following node execution
#       Ex1: listNodes
#       Ex2: doesNodeExist
#       Ex3: isNodeRunning
#       Ex4: stopNode
#       Ex5: stopNodeAgent
#       Ex6: restartNodeAgent
#       Ex7: restartActiveNodes
#       Ex8: syncNode
#       Ex9: syncActiveNodes
#       Ex10: configureDiscoveryProtocolOnNode
#       Ex11: help
#
#---------------------------------------------------------------------

import sys
import AdminUtilities

# Global variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)

## Example 1 list nodes ##
def listNodes( nodeName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listNodes("+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:            List nodes"
        print " Optional parameter:"
        print " nodeName:                       "+nodeName
        if (len(nodeName) == 0):
            print " Usage: AdminNodeManagement.listNodes()"
        else:
            print " Usage: AdminNodeManagement.listNodes(\""+nodeName+"\")"
            print " Return: List the specified node or list all of the nodes if a node is not specified. "
        print "---------------------------------------------------------------"
        print " "
        print " "
         
        nodes = AdminUtilities._BLANK_
        if (nodeName == AdminUtilities._BLANK_):
            nodes = AdminConfig.list("Node")
        else:
            nodes = AdminConfig.getid("/Node:"+nodeName+"/")
            
        nodeList = AdminUtilities.convertToList(nodes)
        return nodeList 
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 2 does node exist  ##
def doesNodeExist( nodeName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "doesNodeExist("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:            Verify whether a node exists"
        print " nodeName:                       "+nodeName
        print " Usage: AdminNodeManagement.doesNodeExist(\""+nodeName+"\")"
        print " Return: If the node exists, a true value is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "
          
        node = AdminConfig.getid("/Node:"+nodeName+"/")
        if len(node) == 0:
            return "false"
        else:
            return "true"
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 3 is node running  ##
def isNodeRunning( nodeName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "isNodeRunning("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:        Verify whether the node is running"
        print " nodeName:                   "+nodeName
        print " Usage: AdminNodeManagement.isNodeRunning(\""+nodeName+"\")"
        print " Return: If a node is running, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "

        servers = AdminControl.queryNames("node="+nodeName+",type=NodeAgent,*")
        if len(servers) == 0:
            return -1
        else:
            return 1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 4 stop node  ##
def stopNode( nodeName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "stopNode("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:        Stop a node"
        print " nodeName:                   "+nodeName
        print " Usage: AdminNodeManagement.stopNode(\""+nodeName+"\")"
        print " Return: If the command is successfully invoked, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        dp = AdminControl.queryNames("type=DeploymentManager,*")
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(dp) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["DeploymentManager", "DeploymentManager"]))
        else:
            AdminControl.invoke(dp, "stopNode", nodeName)
            result = AdminControl.queryNames("type=Server,node="+nodeName+",*")
            if len(result) == 0:
               return 1
            else:
               print result
               return -1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 5 stop nodeagent  ##
def stopNodeAgent( nodeName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "stopNodeAgent("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:    Stop the node agent"
        print " nodeName:               "+nodeName
        print " Usage: AdminNodeManagement.stopNodeAgent(\""+nodeName+"\")"
        print " Return: If the command is successfully invoked, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "
          
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        dp = AdminControl.queryNames("type=DeploymentManager,*")
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(dp) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["DeploymentManager", "DeploymentManager"]))
        else:
            AdminControl.invoke(dp, "stopNodeAgent", nodeName)
            result = AdminControl.queryNames("type=Server,node="+nodeName+",name=nodeagent,*")
            if len(result) == 0:
                return 1
            else:
                print result
                return -1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 6 restart nodeagent  ##
def restartNodeAgent( nodeName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "restartNodeAgent("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:    Restart the node agent"
        print " nodeName:               "+nodeName
        print " Usage: AdminNodeManagement.restartNodeAgent(\""+nodeName+"\")"
        print " Return: If the command is successfully invoked, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "
        
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        na = AdminControl.queryNames("node="+nodeName+",type=NodeAgent,*")
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(na) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["NodeAgent", nodeName]))
        else:
            result = AdminControl.invoke(na, "restart", "[true true]")
            print result
            return 1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 7 restart active nodes  ##
def restartActiveNodes( failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "restartActiveNodes("+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:        Restart active nodes"
        print " Usage: AdminNodeManagement.restartActiveNodes()"
        print " Return: If the command is successfully invokved, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "

        dp = AdminControl.queryNames("type=DeploymentManager,*")
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(dp) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["DeploymentManager", "DeploymentManager"]))
        else:
            result = AdminControl.invoke(dp, "restartActiveNodes", "[true true]")
            print result
            return 1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 8 sync node  ##
def syncNode( nodeName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "syncNode("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:          Synchronize the nodes"
        print " nodeName:                     "+nodeName
        print " Usage: AdminNodeManagement.syncNode(\""+nodeName+"\")"
        print " Return: If the command is successfully invoked, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "
      
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        ns = AdminControl.queryNames("node="+nodeName+",type=NodeSync,*")
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(ns) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["NodeSync", nodeName]))
        else:
            result = AdminControl.invoke(ns, "sync")
            print result
            if (result == "true"):
                return 1
            else:
                return -1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 9 sync active nodes  ##
def syncActiveNodes( failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "syncActiveNodes("+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:        Synchronize the active nodes"
        print " Usage: AdminNodeManagement.syncActiveNodes()"
        print " Return: If the command is successfully invoked, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "

        dp = AdminControl.queryNames("type=DeploymentManager,*")
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(dp) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["DeploymentManager", "DeploymentManager"]))
        else:
            result = AdminControl.invoke(dp, "syncActiveNodes", "true")
            print result
            return 1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 10 configure discovery protocol on node  ##
def configureDiscoveryProtocolOnNode( nodeName, discProtocol, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureDiscoveryProtocolOnNode("+`nodeName`+", "+`discProtocol`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List nodes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminNodeManagement:        Configure the discovery protocol on a node"
        print " nodeName:                   "+nodeName
        print " discoveryProtocol:          "+discProtocol
        print " Usage: AdminNodeManagement.configureDiscoveryProtocolOnNode(\""+nodeName+", "+discProtocol+"\")"
        print " Return: If the command is successful, a value of 1 is returned. "
        print "---------------------------------------------------------------"
        print " "
        print " "
        
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(discProtocol) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["discProtocol", discProtocol]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        node = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(node) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        AdminConfig.modify(node, [["discoveryProtocol", discProtocol]])
        
        if (AdminUtilities._AUTOSAVE_ == "true"):
           AdminConfig.save()

        print AdminConfig.showall(node)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 11 Online help ##
def help(procedure="", failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "help("+`procedure`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Provide the online help
        #--------------------------------------------------------------------
        #print "---------------------------------------------------------------"
        #print " AdminNodeManagement:         Help "
        #print " Script procedure:            "+procedure
        #print " Usage: AdminNodeManagement.help(\""+procedure+"\")"
        #print "---------------------------------------------------------------"
        #print " "
        #print " "

        if (len(procedure) == 0):
            message = resourceBundle.getString("ADMINNODEMANAGEMENT_GENERAL_HELP")
        else:
            procedure = "ADMINNODEMANAGEMENT_HELP_"+procedure.upper()
            message = resourceBundle.getString(procedure)
        #endIf
        return message
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
            return -1
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


