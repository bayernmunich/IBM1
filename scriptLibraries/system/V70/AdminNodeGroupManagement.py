
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
# AdminNodeGroupManagement.py - Jython procedures for performing node group management tasks.
#------------------------------------------------------------------------------
#
#   This script includes the following node group management procedures:
#      Ex1:  listNodeGroups
#      Ex2:  listNodeGroupMembers
#      Ex3:  listNodeGroupProperties
#      EX4:  createNodeGroup
#      Ex5:  createNodeGroupProperty
#      Ex6:  addNodeGroupMember
#      Ex7:  modifyNodeGroup
#      Ex8:  modifyNodeGroupProperty
#      Ex9:  deleteNodeGroup
#      Ex10: deleteNodeGroupMember
#      Ex11: deleteNodeGroupProperty
#      Ex12: checkIfNodeGroupExists
#      Ex13: checkIfNodeExists
#      Ex14: help
#
#---------------------------------------------------------------------


#--------------------------------------------------------------------
# Set global constants
#--------------------------------------------------------------------
import sys
import java
import AdminUtilities 

# Setting up Global Variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)


## Example 1 List available node groups in the configuration or where a given node resides ##
def listNodeGroups( nodeName="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listNodeGroups("+`nodeName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List node groups
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminNodeGroupManagement:       List node groups"
                print " Optional parameter: "
                print "         Node name:              "+nodeName
                print " Usage: AdminNodeGroupManagement.listNodeGroups(\""+nodeName+"\")"
                print " Return: List the node groups to which a given node belongs or list all of the node groups if a node is not specified. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                nodeGroups = []
                
                # check the required argument
                if (nodeName == ""):
                   nodegroups = AdminTask.listNodeGroups()
                else:
                   node = AdminConfig.getid("/Node:"+nodeName+"/")
                   if (len(node) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                   #endIf
                   
                   # List available node groups
                   nodegroups = AdminTask.listNodeGroups(nodeName)
                #endIf
                
                # Convert Jython string to list
                nodegroups = AdminUtilities.convertToList(nodegroups)
                return nodegroups 
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 2 List nodes in the cell or the node group ##
def listNodeGroupMembers( nodeGroupName="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listNodeGroupMembers("+`nodeGroupName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List all nodes in the cell or a given node group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminNodeGroupManagement:       List nodes for a given node group"
                print " Optional parameter: "
                print "         Node group name:        "+nodeGroupName
                print " Usage: AdminNodeGroupManagement.listNodeGroupMembers(\""+nodeGroupName+"\")"
                print " Return: List the nodes in a specified node group. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                paramList = []
                if (len(nodeGroupName) > 0):
                   nodeGroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                   if (len(nodeGroup) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))
                   else:   
                      paramList = ['-nodeGroup', nodeGroupName]
                   #endIf   
                #endIf
                   
                # List nodes in the cell or a given node group
                nodes = AdminTask.listNodes(paramList)
                
                # Convert Jython string to list
                nodes = AdminUtilities.convertToList(nodes)
                return nodes 
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 3 List all custom properites on a node group ##
def listNodeGroupProperties( nodeGroupName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listNodeGroupProperties("+`nodeGroupName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List custom properties of a node group
                #--------------------------------------------------------------------
                print "-----------------------------------------------------------------"
                print " AdminNodeGroupManagement:       List custom properties of a node group"
                print " Node group name:                "+nodeGroupName
                print " Usage: AdminNodeGroupManagement.listNodeGroupProperties(\""+nodeGroupName+"\") "
                print " Return: List the custom properties for a specified node group. "
                print "-----------------------------------------------------------------"
                print " "
                print " "
                nodeGroupProperties = []
                
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                else:
                   nodeGroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                   if (len(nodeGroup) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))
                #endIf
                   
                # List node group properties
                nodeGroupProperties = AdminTask.listNodeGroupProperties(nodeGroupName)
                nodeGroupProperties = AdminUtilities.convertToList(nodeGroupProperties)
                
                return nodeGroupProperties
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef
  

## Example 4 Create a new node group ##
def createNodeGroup( nodeGroupName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createNodeGroup("+`nodeGroupName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create a new node group
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------------"
                print " AdminNodeGroupManagement:       Create a new node group"
                print " New node group name:            "+nodeGroupName
                print " Usage: AdminNodeGroupManagement.createNodeGroup(\""+nodeGroupName+"\") "
                print " Return: The configuration ID of the new node group. "
                print "----------------------------------------------------------------------"
                print " "
                print " "
                nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                nodeGroup = ""
                
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                else:
                   nodeGroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                   if (len(nodeGroup) > 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [nodeGroupName]))
                #endIf

                # Create a node group
                nodeGroup = AdminTask.createNodeGroup(nodeGroupName)
                 
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
                
                return nodeGroup
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 5 Create a custom property on a node group ##
def createNodeGroupProperty( nodeGroupName, propName, propValue, propDesc, required, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createNodeGroupProperty("+`nodeGroupName`+", "+`propName`+", "+`propValue`+", "+`propDesc`+", "+`required`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create a new node group custom property
                #--------------------------------------------------------------------
                print "-----------------------------------------------------------------"
                print " AdminNodeGroupManagement:               Create custom property on a node group"
                print " Node group name:                        "+nodeGroupName
                print " Custom property name:                   "+propName
                print " Custom property value:                  "+propValue
                print " Optional parameters: "
                print "         Custom property description:    "+propDesc
                print "         Is required property:           "+required
                print " Usage: AdminNodeGroupManagement.createNodeGroupProperty(\""+nodeGroupName+"\", \""+propName+"\", \""+propValue+"\", \""+propDesc+"\", \""+required+"\") "
                print " Return: The configuration ID of the new node group property."
                print "-----------------------------------------------------------------"
                print " "
                print " "
                newProp = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                   
                if (propName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propName", propName]))
                   
                if (propValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propValue", propValue]))
                
                nodeGroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                if (len(nodeGroup) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))
                
                properties = AdminTask.listNodeGroupProperties(nodeGroupName)
                for prop in properties:
                    name = prop[0:prop.find("=")]
                    value = prop[prop.find("=")+1:len(prop)]
                    if (name == propName and value == propValue):
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propName]))
                    #endIf
                #endFor
                       
                # Construct required parameters
                requiredParamList = ['-name', propName, '-value', propValue]

                # Construct optional parameters
                optionalParamList = []
                if (len(propDesc) != 0):
                   optionalParamList = ['-description', propDesc]
                #endIf
                      
                if (len(required) != 0):
                   optionalParamList = ['-required', required]
                #endIf
                paramList = requiredParamList + optionalParamList
                
                # Create node group custome properties
                newProp = AdminTask.createNodeGroupProperty(nodeGroupName, paramList)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return newProp
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 6 Add node member to a node group ##
def addNodeGroupMember( nodeGroupName, nodeName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addNodeGroupMember("+`nodeGroupName`+", "+`nodeName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Add new node memeber to a node group
                #--------------------------------------------------------------------
                print "-----------------------------------------------------------------"
                print " AdminNodeGroupManagement:       Add a node member to a node group"
                print " Node group name:                "+nodeGroupName
                print " Node name:                      "+nodeName
                print " Usage: AdminNodeGroupManagement.addNodeGroupMember(\""+nodeGroupName+"\", \""+nodeName+"\") "
                print " Return: The configuration ID of the added node group member. "
                print "-----------------------------------------------------------------"
                print " "
                print " "
                nodeGroupMember = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                   
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                if (len(nodegroup) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))

                node = AdminConfig.getid("/Node:"+nodeName)
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                else:
                   nodes = AdminTask.listNodes(['-nodeGroup', nodeGroupName])
                   nodes = AdminUtilities.convertToList(nodes)
                   for n in nodes:
                       if (n == nodeName):
                           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [nodeName]))
                       #endIf
                   #endFor
                #endIf
                
                # Add node to node group 
                nodeGroupMember = AdminTask.addNodeGroupMember(nodeGroupName, ['-nodeName', nodeName])
                  
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
                
                return nodeGroupMember
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 7 Modify a node group configuration ##
def modifyNodeGroup( nodeGroupName, shortName, description, failonerror=AdminUtilities._BLANK_ ): 
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "modifyNodeGroup("+`nodeGroupName`+", "+`shortName`+", "+`description`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Modify a node group configuration
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------------"
                print " AdminNodeGroupManagement:       Modify a node group configuration"
                print " Node group name:                "+nodeGroupName
                print " Optional parameters: "
                print "         Short name:             "+shortName
                print "         Description:            "+description
                print " Usage: AdminNodeGroupManagement.modifyNodeGroup(\""+nodeGroupName+"\", \""+shortName+"\", \""+description+"\") "
                print " Return: The configuration ID of the modified node group. "
                print "----------------------------------------------------------------------"
                print " "
                print " "
                nodeGroup = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                else:
                   nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                   if (len(nodegroup) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                #endIf   
                
                # Construct optional parameters
                optionalParamList = []
                if (len(shortName) != 0):
                   optionalParamList = ['-shortName', shortName]
                #endIf
                      
                if (len(description) != 0):
                   optionalParamList = ['-description', description]
                #endIf
                   
                # Modify node group 
                nodeGroup = AdminTask.modifyNodeGroup(nodeGroupName, optionalParamList)
                 
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
 
                return nodeGroup
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 8 Modify a node group custom property ##
def modifyNodeGroupProperty( nodeGroupName, propName, propValue, propDesc, required, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "modifyNodeGroupProperty("+`nodeGroupName`+", "+`propName`+", "+`propValue`+", "+`propDesc`+", "+`required`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Modify a node group property
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------------"
                print " AdminNodeGroupManagement:              Modify a node group property"
                print " Node group name:                        "+nodeGroupName
                print " Custom property name:                   "+propName
                print " Optional parameters: "
                print "         Custom property value:          "+propValue
                print "         Custom property description:    "+propDesc
                print "         Custom property required:       "+required
                print " Usage: AdminNodeGroupManagement.modifyNodeGroupProperty(\""+nodeGroupName+"\", \""+propName+"\", \""+propValue+"\", \""+propDesc+"\", \""+required+"\") "
                print " Return: The configuration ID of the modified node group property. "
                print "----------------------------------------------------------------------"
                print " "
                print " "
                
                prop = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))

                if (propName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propName", propName]))

                nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                if (len(nodegroup) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))
                
                properties = AdminTask.listNodeGroupProperties(nodeGroupName)
                properties = AdminUtilities.convertToList(properties)
                found = 0
                for p in properties:
                    name = p[0:p.find("=")]
                    if (name == propName):
                       found = 1
                    #endIf
                #endFor
                if (found == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["propName", propName]))
                #endIf

                # Construct optional parameters
                optionalParamList = []
                if (len(propValue) != 0):
                   optionalParamList = ['-value', propValue]
                #endIf
                      
                if (len(propDesc) != 0):
                   optionalParamList = ['-description', propDesc]
                #endIf
                      
                if (len(required) != 0):
                   optionalParamList = ['-required', required]
                #endIf
                paramList = ['-name', propName] + optionalParamList

                # Modify node group property
                prop = AdminTask.modifyNodeGroupProperty(nodeGroupName, paramList)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return prop
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 9 Delete a node group ##
def deleteNodeGroup( nodeGroupName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteNodeGroup("+`nodeGroupName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a node group
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------"
                print " AdminNodeGroupManagement:   Delete a node group"
                print " Node group:                 "+nodeGroupName
                print " Usage: AdminNodeGroupManagement.deleteNodeGroup(\""+nodeGroupName+"\") "
                print " Return: The configuration ID of the deleted node group. "
                print "----------------------------------------------------------------"
                print " "
                print " "
                result = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                else:
                   nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                   if (len(nodegroup) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))
                #endIf   
                
                result = AdminTask.removeNodeGroup(nodeGroupName)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 10 Delete a node group member##
def deleteNodeGroupMember( nodeGroupName, nodeName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteNodeGroupMember("+`nodeGroupName`+", "+`nodeName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a node group member
                #--------------------------------------------------------------------
                print "-------------------------------------------------------------------"
                print " AdminNodeGroupManagement:   Delete a node group member"
                print " Node group name:            "+nodeGroupName
                print " Node name to delete:        "+nodeName
                print " Usage: AdminNodeGroupManagement.deleteNodeGroupMember(\""+nodeGroupName+"\", \""+nodeName+"\") "
                print " Return: The configuration ID of the deleted node group member. "
                print "-------------------------------------------------------------------"
                print " "
                print " "
                result = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                   
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                if (len(nodegroup) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))

                node = AdminConfig.getid("/Node:"+nodeName)
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                else:
                   found = 0
                   nodes = AdminTask.listNodes(['-nodeGroup', nodeGroupName])
                   nodes = AdminUtilities.convertToList(nodes)
                   for n in nodes:
                       if (n == nodeName):
                          found = 1
                       #endIf
                   #endFor
                   if (found == 0):
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # Delete a node group member
                result = AdminTask.removeNodeGroupMember(nodeGroupName, ['-nodeName', nodeName] )
                 
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
  
                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 11 Delete a node group property ##
def deleteNodeGroupProperty( nodeGroupName, propName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteNodeGroupProperty("+`nodeGroupName`+", "+`propName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a node group property
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminNodeGroupManagement:       Delete a node group property"
                print " Node group name:                "+nodeGroupName
                print " Property name to delete:        "+propName
                print " Usage: AdminNodeGroupManagement.deleteNodeGroupProperty(\""+nodeGroupName+"\", \""+propName+"\") "
                print " Return: The configuration ID of the deleted node group property. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                result = ""
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                   
                if (propName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propName", propName]))

                nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                if (len(nodegroup) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))
                
                properties = AdminTask.listNodeGroupProperties(nodeGroupName)
                properties = AdminUtilities.convertToList(properties)  
                
                found = 0
                for p in properties:
                    name = p[0:p.find("=")]
                    if (name == propName):
                       found = 1
                    #endIf
                #endFor
                if (found == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["propName", propName]))
                #endIf

                # Delete a node group property
                result = AdminTask.removeNodeGroupProperty(nodeGroupName, ['-name', propName] )
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 12 Does node group exist ##
def checkIfNodeGroupExists ( nodeGroupName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "checkIfNodeGroupExists("+`nodeGroupName`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # Check if node group exists
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminNodeGroupManagement:       Check if node group exists"
                print " Node group name:                "+nodeGroupName
                print " Usage: AdminNodeGroupManagement.checkIfNodeGroupExists(\""+nodeGroupName+"\")"
                print " Return: If the node group exists, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                nodeGroupExists = "false"
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                else:
                   nodeGroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName+"/")
                   if (len(nodeGroup) > 0):
                      nodeGroupExists = "true"
                #endIf    
                return nodeGroupExists
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 13 Does node exist in node group##
def checkIfNodeExists ( nodeGroupName, nodeName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "checkIfNodeExists("+`nodeGroupName`+", "+`nodeName`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # Check if node member exists
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminNodeGroupManagement:       Check if node exists in node group"
                print " Node group name:                "+nodeGroupName
                print " Node name:                      "+nodeName
                print " Usage: AdminNodeGroupManagement.checkIfNodeExists(\""+nodeGroupName+"\", \""+nodeName+"\")"
                print " Return: If the node exists in the node group, a true value is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                nodeExists = "false"
                
                # check the required arguments
                if (nodeGroupName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeGroupName", nodeGroupName]))
                   
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                nodegroup = AdminConfig.getid("/NodeGroup:"+nodeGroupName)
                if (len(nodegroup) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeGroupName", nodeGroupName]))

                node = AdminConfig.getid("/Node:"+nodeName)
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf

                nodes = listNodeGroupMembers(nodeGroupName)
                if (len(nodes) > 0):
                   for node in nodes:
                       if (node == nodeName):
                          AdminUtilities.infoNotice("Found node member: " + nodeName)
                          nodeExists = "true"
                          break
                       #endIf
                   #endFor  
                #endIf         
                return nodeExists
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


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
                #print " AdminNodeGroupManagement:       Help "
                #print " Script procedure:               "+procedure
                #print " Usage: AdminNodeGroupManagement.help(\""+procedure+"\")"
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)
                
                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINNODEGROUPMANAGEMENT_GENERAL_HELP")
                else:
                   procedure = "ADMINNODEGROUPMANAGEMENT_HELP_"+procedure.upper()
                   message = resourceBundle.getString(procedure)
                #endIf
                return message
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        #AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef 
