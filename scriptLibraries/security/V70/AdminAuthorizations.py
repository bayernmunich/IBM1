
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
#---------------------------------------------------------------------------------------------------
# AdminAuthorizations.py - Jython procedures for performing security authorization group operations.
#---------------------------------------------------------------------------------------------------
#
#   This script library includes the following authorization group procedures:
#      Ex1:  createAuthorizationGroup
#      Ex2:  addResourceToAuthorizationGroup
#      Ex3:  mapUsersToAdminRole
#      Ex4:  mapGroupsToAdminRole
#      Ex5:  listAuthorizationGroups
#      Ex6:  listAuthorizationGroupsForUserID
#      Ex7:  listAuthorizationGroupsForGroupID
#      EX8:  listAuthorizationGroupsOfResource
#      Ex9:  listUserIDsOfAuthorizationGroup
#      Ex10: listGroupIDsOfAuthorizationGroup
#      Ex11: listResourcesOfAuthorizationGroup
#      Ex12: listResourcesForUserID
#      Ex13: listResourcesForGroupID
#      Ex14: deleteAuthorizationGroup
#      Ex15: removeUsersFromAdminRole
#      Ex16: removeGroupsFromAdminRole
#      Ex17: removeResourceFromAuthorizationGroup
#      Ex18: removeUserFromAllAdminRoles
#      Ex19: removeGroupFromAllAdminRoles
#      Ex20: help
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


## Example 1 Create a new authorization group ##
def createAuthorizationGroup( authGroup, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createAuthorizationGroup("+`authGroup`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create an authorization group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            Create a new authorization group"
                print " Authorization Group name:       "+authGroup
                print " Usage: AdminAuthorizations.createAuthorizationGroup(\""+authGroup+"\")"
                print " Return: The configuration ID of the new authorization group. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                else:
                   ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                   # Check if authorization group exists
                   if (len(ag) > 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [authGroup]))
                   #endIf
                #endIf
                
                # create an authorization group
                authgroup = AdminTask.createAuthorizationGroup(['-authorizationGroupName', authGroup])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return authgroup
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


## Example 2 Add a resource instance to an existing authorization group ##
def addResourceToAuthorizationGroup( authGroup, resourceName, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addResourceToAuthorizationGroup("+`authGroup`+", "+`resourceName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Add a resource instance to an existing authorization group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:                    Add a resource to an authorization group"
                print " Authorization group name:               "+authGroup
                print " Resource name (ResourceType=ResourceName):"+resourceName
                print " Usage: AdminAuthorizations.addResourceToAuthorizationGroup(\""+authGroup+"\", \""+resourceName+"\") "
                print " Return: If the command is successful, a value of 1 is returned. "
                print "----------------------------------------------------------------"
                print " "
                print " "
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                   
                if (resourceName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resourceName", resourceName]))

                # check if authorization group exist
                ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                # Check if authorization group exists
                if (len(ag) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf

                # Add resource to an existing authorization group
                AdminTask.addResourceToAuthorizationGroup(['-authorizationGroupName', authGroup, '-resourceName', resourceName])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
   
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
        return 1  # succeed
#endDef


## Example 3 Map user ids to administrator role ##
def mapUsersToAdminRole( authGroup, roleName, userids, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "mapUsersToAdminRole("+`authGroup`+", "+`roleName`+", "+`userids`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Map user IDs to administrative role
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:                    Map user ids to administrative role"
                print " Authorization group name:               "+authGroup
                print " Administrative role name:               "+roleName
                print " User IDs:                               "+userids
                print " Usage: AdminAuthorizations.mapUsersToAdminRole(\""+authGroup+"\", \""+roleName+"\", \""+userids+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "----------------------------------------------------------------"
                print " "
                print " "
                result = "false"
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                
                if (roleName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["roleName", roleName]))
                   
                if (userids == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["userids", userids]))

                # check if authorization group exists
                ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                # Check if authorization group exists
                if (len(ag) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf
                
                # Map users to admin role
                result = AdminTask.mapUsersToAdminRole(['-authorizationGroupName', authGroup, '-roleName', roleName, '-userids', userids])
                 
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


## Example 4 Map group ids to administrative role ##
def mapGroupsToAdminRole( authGroup, roleName, groupids, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "mapGroupsToAdminRole("+`authGroup`+", "+`roleName`+", "+`groupids`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Map group IDs to administrative role
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            Map group ids to administrative role"
                print " Authorization group name:       "+authGroup
                print " Administrative role name:       "+roleName
                print " Group IDs:                      "+groupids
                print " Usage: AdminAuthorizations.mapGroupsToAdminRole(\""+authGroup+"\", \""+roleName+"\", \""+groupids+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                result = "false"
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                
                if (roleName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["roleName", roleName]))
                   
                if (groupids == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["groupids", groupids]))

                # check if authorization group exist
                ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                # Check if authorization group exists
                if (len(ag) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf

                # Map groups to admin role
                result = AdminTask.mapGroupsToAdminRole(['-authorizationGroupName', authGroup, '-roleName', roleName, '-groupids', groupids])
              
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


## Example 5 List existing authorization groups ##
def listAuthorizationGroups(failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listAuthorizationGroups("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List the existing authorization groups
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:  List authorization groups"
                print " Usage: AdminAuthorizations.listAuthorizationGroups() "
                print " Return: List of the authorization group names. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                    
                # List authorization groups
                authGroups = AdminTask.listAuthorizationGroups()
                                
                # Convert Jython string to list
                authGroups = AdminUtilities.convertToList(authGroups)
                return authGroups 
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


## Example 6 List authorization groups to which a given user has access ##
def listAuthorizationGroupsForUserID(userid, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listAuthorizationGroupsForUserID("+`userid`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List authorization groups to which a given user has access
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:    List authorization groups to which a given user has access"
                print " User ID:                "+userid
                print " Usage: AdminAuthorizations.listAuthorizationGroupsForUserID(\""+userid+"\") "
                print " Return: List of the authorization groups to which specified user has access and has the granted role. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (userid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["userid", userid]))

                # List authorization groups that user has access and the role has granted
                authGroups = AdminTask.listAuthorizationGroupsForUserID(['-userid', userid])
                
                # Separate the authGroup table by individual role
                roleTable = authGroups[1:len(authGroups) -1].split("], ")
                
                # Get the role-authGroup mapping list
                roleAuthGroupList = []
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf  
                    
                    # Find role name and authorization group name 
                    rolename = role[0:role.find("=")]
                    authgroup = role[len(rolename)+2:len(role)-1]
                    
                    if (len(authgroup) > 0):
                       AdminUtilities.infoNotice("The user " +userid+" has granted " + rolename + " role in authorization group [" + authgroup + "]")
                       AdminUtilities.infoNotice(" ")
                       roleAuthGroupList.append(role)
                    #endif   
                #endFor
                return roleAuthGroupList
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


## Example 7 List authorization groups to which a given user group has access ##
def listAuthorizationGroupsForGroupID(groupid, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listAuthorizationGroupsForGroupID("+`groupid`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List authorization groups to which a given group has access
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:    List authorization groups to which a given group has access"
                print " Group ID:               "+groupid
                print " Usage: AdminAuthorizations.listAuthorizationGroupsForGroupID(\""+groupid+"\") "
                print " Return: List of the authorization groups to which a specified user group has access. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (groupid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["groupid", groupid]))

                # List authorization groups that group has access and the role has granted
                authGroups = AdminTask.listAuthorizationGroupsForGroupID(['-groupid', groupid])
                
                # Separate the authGroup table by individual role
                roleTable = authGroups[1:len(authGroups) -1].split("], ")
                
                # Get the role-authGroup list
                roleAuthGroupList = []
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf  
                    
                    # Find role name and authorization group name 
                    rolename = role[0:role.find("=")]
                    authgroup = role[len(rolename)+2:len(role)-1]
                    
                    if (len(authgroup) > 0):
                       AdminUtilities.infoNotice("The group " +groupid+" has granted " + rolename + " role in authorization group [" + authgroup + "]")
                       AdminUtilities.infoNotice(" ")
                       roleAuthGroupList.append(role)
                    #endif   
                #endFor
                return roleAuthGroupList
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


## Example 8 List authorization groups for a given resource ##
def listAuthorizationGroupsOfResource(resourceName, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listAuthorizationGroupsOfResource("+`resourceName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List authorization group for a given resource
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:    List authorization groups for a given resource"
                print " Resource name:          "+resourceName
                print " Usage: AdminAuthorizations.listAuthorizationGroupsOfResource(\""+resourceName+"\") "
                print " Return: List of the authorization groups for a given resource. "
                print "---------------------------------------------------------------"
                print " "
                print " "  
                
                # check the required argument
                if (resourceName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resourceName", resourceName]))

                # List authorization groups for a given resource
                authGroups = AdminTask.listAuthorizationGroupsOfResource(['-resourceName', resourceName])
                
                # Convert Jython string to list
                authGroupList = AdminUtilities.convertToList(authGroups)
                
                # Loop through each authorization group in the list
                AdminUtilities.infoNotice("The resource name " + resourceName + " is in following authorization groups: ")
                for authGroup in authGroupList:
                    AdminUtilities.infoNotice(authGroup)
                    AdminUtilities.infoNotice(" ")
                #endFor
                return authGroupList 
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


## Example 9 List user IDs within the given authorization group ##
def listUserIDsOfAuthorizationGroup(authGroup, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listUserIDsOfAuthorizationGroup("+`authGroup`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List user ids within a given authorization group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            List user ids within a given authorization group"
                print " Authorization group name:       "+authGroup
                print " Usage: AdminAuthorizations.listUserIDsOfAuthorizationGroup(\""+authGroup+"\") "
                print " Return: List of the users and roles in a specified authorization group. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                userGroupRoleList = []
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                else:
                   ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                   # Check if authorization group exists
                   if (len(ag) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                   #endIf
                #endIf

                # List user IDs within a given authorization group
                userids = AdminTask.listUserIDsOfAuthorizationGroup(['-authorizationGroupName', authGroup])
                
                # Separate the userid table by individual role
                roleTable = userids[1:len(userids) -1].split("], ")
                
                # Get the user-role mapping list
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf  
                    
                    # Find role name and user IDs 
                    roleName = role[0:role.find("=")]
                    id = role[len(roleName)+2:len(role)-1]
                    
                    if (len(id) > 0):
                       AdminUtilities.infoNotice("The user [" +id+ "] has granted " + roleName + " role in authorization group: " + authGroup)
                       AdminUtilities.infoNotice(" ")
                       userGroupRoleList.append(role)
                    #endif   
                   
                #endIf   
                return userGroupRoleList
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


## Example 10 List group IDs within the given authorization group ##
def listGroupIDsOfAuthorizationGroup(authGroup, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listGroupIDsOfAuthorizationGroup("+`authGroup`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List group ids within a given authorization group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            List group ids within a given authorization group"
                print " Authorization group name:       "+authGroup
                print " Usage: AdminAuthorizations.listGroupIDsOfAuthorizationGroup(\""+authGroup+"\") "
                print " Return: List of the user groups and roles in a specified authorization group. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                userGroupRoleList = []
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                else:
                   ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                   # Check if authorization group exists
                   if (len(ag) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                   #endIf
                #endIf

                # List group ids within a given authorization group
                groupids = AdminTask.listGroupIDsOfAuthorizationGroup(['-authorizationGroupName', authGroup])
                
                # Separate the userid table by individual role
                roleTable = groupids[1:len(groupids) -1].split("], ")
                
                # Get the group-role mapping list
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf  
                    
                    # Find role name and group IDs 
                    roleName = role[0:role.find("=")]
                    id = role[len(roleName)+2:len(role)-1]
                    
                    if (len(id) > 0):
                       AdminUtilities.infoNotice("The group [" +id+ "] has granted " + roleName + " role in authorization group: " + authGroup)
                       AdminUtilities.infoNotice(" ")
                       userGroupRoleList.append(role)
                    #endIf
                #endFor   
                return userGroupRoleList
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


## Example 11 List resources within the given authorization group ##
def listResourcesOfAuthorizationGroup(authGroup, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listResourcesOfAuthorizationGroup("+`authGroup`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List resources within a given authorization group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            List resources within a given authorization group"
                print " Authorization group name:       "+authGroup
                print " Usage: AdminAuthorizations.listResourcesOfAuthorizationGroup(\""+authGroup+"\") "
                print " Return: List of the resources to which a specified authorization group has access. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                resources = []
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                else:
                   ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                   # Check if authorization group exists
                   if (len(ag) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                   #endIf
                #endIf

                # List resources within a given authorization group
                resources = AdminTask.listResourcesOfAuthorizationGroup(['-authorizationGroupName', authGroup])
                
                # Convert Jython string to list
                resources = AdminUtilities.convertToList(resources)
                
                # Loop through each resource in the list
                AdminUtilities.infoNotice("The authorization group " + authGroup + " has following resources: ")
                for aResource in resources:
                    AdminUtilities.infoNotice(aResource)
                #endFor
                   
                return resources 
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


## Example 12 List resources that a given user has access to ##
def listResourcesForUserID(userid, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listResourcesForUserID("+`userid`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List resources to which a given user has access to
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:    List resources that a given user has access"
                print " User ID:                "+userid
                print " Usage: AdminAuthorizations.listResourcesForUserID(\""+userid+"\") "
                print " Return: List of the resources to which a specified user has access. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required arguments
                if (userid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["userid", userid]))

                # List resources for a given user
                resources = AdminTask.listResourcesForUserID(['-userid', userid])
                
                # Separate the resource table by individual role
                roleTable = resources[1:len(resources) -1].split("], ")
                
                # Get the resource-role mapping list
                resourceRoleList = []
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf   
            
                    # Find role name and resource names 
                    roleName = role[0:role.find("=")]
                    resource = role[len(roleName)+2:len(role)-1]
                    
                    if (len(resource) > 0):
                       AdminUtilities.infoNotice("The user " +userid+" has granted " + roleName + " role and has access to resources:")
                       AdminUtilities.infoNotice(" ")
                       
                       # Print individual resource
                       if (resource.find(",") >0):
                          resource = resource[0:len(resource)].split(", ")
                          for res in resource:
                              AdminUtilities.infoNotice(res)
                          #endFor
                       else:
                          AdminUtilities.infoNotice(resource)
                       #endIf
                       resourceRoleList.append(role)
                    #endIf
                #endFor
                return resourceRoleList
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


## Example 13 List resources that a given group has access ##
def listResourcesForGroupID(groupid, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listResourcesForGroupID("+`groupid`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List resources to which a given group has access
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:    List resources that a given group has access"
                print " Group ID:               "+groupid
                print " Usage: AdminAuthorizations.listResourcesForGroupID(\""+groupid+"\") "
                print " Return: List of the resources to which a specified user group has access. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required arguments
                if (groupid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["groupid", groupid]))

                # List resources for a given user group
                resources = AdminTask.listResourcesForGroupID(['-groupid', groupid])
                
                # Separate the resource table by individual role
                roleTable = resources[1:len(resources) -1].split("], ")
                
                # Get the resource-role list
                resourceRoleList = []
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf   
            
                    # Find role name and resource names 
                    roleName = role[0:role.find("=")]
                    resource = role[len(roleName)+2:len(role)-1]
                    
                    if (len(resource) > 0):
                       AdminUtilities.infoNotice("The group " +groupid+" has granted " + roleName + " role and has access to resources:")
                       AdminUtilities.infoNotice(" ")
                       
                       # Print individual resource
                       if (resource.find(",") >0):
                          resource = resource[0:len(resource)].split(", ")
                          for res in resource:
                              AdminUtilities.infoNotice(res)
                          #endFor
                       else:
                          AdminUtilities.infoNotice(resource)
                       #endIf
                       
                       resourceRoleList.append(role)
                    #endIf
                #endFor
                return resourceRoleList
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

 
## Example 14 Delete an existing authorization group ##
def deleteAuthorizationGroup( authGroup, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteAuthorizationGroup("+`authGroup`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete an existing authorization group
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            Delete an authorization group"
                print " Authorization group name:       "+authGroup
                print " Usage: AdminAuthorizations.deleteAuthorizationGroup(\""+authGroup+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "----------------------------------------------------------------"
                print " "
                print " "
                result = "false"
                
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                else:
                   authgroup = AdminConfig.getid("/AuthorizationGroup:"+authGroup+"/")
                   if (len(authgroup) == 0):
                        raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf
                
                # Delete an authorization group
                result = AdminTask.deleteAuthorizationGroup(['-authorizationGroupName', authGroup])
                  
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


## Example 15 Remove previously mapped users from administrative role in authorization group ##
def removeUsersFromAdminRole( authGroup, roleName, userids, failonerror=AdminUtilities._BLANK_ ):  
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "removeUsersFromAdminRole("+`authGroup`+", "+`roleName`+", "+`userids`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Remove users from administrative role in authorization group 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            Remove users from admin role in authorization group"
                print " Authorization group name:       "+authGroup
                print " Administrative role name:       "+roleName
                print " User IDs:                       "+userids
                print " Usage: AdminAuthorizations.removeUsersFromAdminRole(\""+authGroup+"\", \""+roleName+"\", \""+userids+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                result = "false"
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                
                if (roleName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["roleName", roleName]))
                   
                if (userids == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["userids", userids]))
                
                # check if authorization group exists
                ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                if (len(ag) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf
                
                # Remove users from admin role in authorization group
                result = AdminTask.removeUsersFromAdminRole(['-authorizationGroupName', authGroup, '-roleName', roleName, '-userids', userids])
                
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


## Example 16 Remove previously mapped groups from administrative role in authorization group ##
def removeGroupsFromAdminRole( authGroup, roleName, groupids, failonerror=AdminUtilities._BLANK_ ): 
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "removeGroupsFromAdminRole("+`authGroup`+", "+`roleName`+", "+`groupids`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Remove groups from administrative role in authorization group 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            Remove groups from admin role in authorization group"
                print " Authorization group name:       "+authGroup
                print " Administrative role name:       "+roleName
                print " Group IDs:                      "+groupids
                print " Usage: AdminAuthorizations.removeGroupsFromAdminRole(\""+authGroup+"\", \""+roleName+"\", \""+groupids+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                result = "false"
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                
                if (roleName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["roleName", roleName]))
                   
                if (groupids == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["groupids", groupids]))

                # check if authorization group exists
                ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                if (len(ag) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf
                
                # Remove groups from admin role in authorization group
                result = AdminTask.removeGroupsFromAdminRole(['-authorizationGroupName', authGroup, '-roleName', roleName, '-groupids', groupids])
                
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


## Example 17 Remove resource from authorization group ##
def removeResourceFromAuthorizationGroup( authGroup, resourceName, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "removeResourceFromAuthorizationGroup("+`authGroup`+", "+`resourceName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Remove resource from authorization group 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:                    Remove resource from authorization group"
                print " Authorization group name:               "+authGroup
                print " Resource name (ResourceType=ResourceName):"+resourceName
                print " Usage: AdminAuthorizations.removeResourceFromAuthorizationGroup(\""+authGroup+"\", \""+resourceName+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                result = "false"
                
                # check the required arguments
                if (authGroup == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authGroup", authGroup]))
                
                if (resourceName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resourceName", resourceName]))
                
                ag = AdminConfig.getid("/AuthorizationGroup:" +authGroup+"/")
                # Check if authorization group exists
                if (len(ag) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["authGroup", authGroup]))
                #endIf
                
                resources = listAuthorizationGroupsOfResource(resourceName)
                if (len(resources) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["resourceName", resourceName]))

                # Remove resource from authorization group
                result = AdminTask.removeResourceFromAuthorizationGroup(['-authorizationGroupName', authGroup, '-resourceName', resourceName])
               
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


## Example 18 Remove a user from all administrative roles in authorization groups##
def removeUserFromAllAdminRoles ( userid, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "removeUserFromAllAdminRoles("+`userid`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Remove a user from all administrative roles in authorization groups 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:            Remove a user from all administrative roles in authorization groups"
                print " User ID:                        "+userid
                print " Usage: AdminAuthorizations.removeUserFromAllAdminRoles(\""+userid+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (userid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["userid", userid]))

                # check if user id is in the authorization group
                ags = listAuthorizationGroupsForUserID(userid)
                if (len(ags) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["userid", userid]))
             
                # Get the role-authorizationGroup mapping table
                authGroups = AdminTask.listAuthorizationGroupsForUserID(['-userid', userid])
                
                # Separate the role-authGroup table by individual role
                roleTable = authGroups[1:len(authGroups) -1].split("], ")
                
                # Loop through each role in role table 
                result = "false"
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf  
                    
                    # Find role name and authorization group name 
                    rolename = role[0:role.find("=")]
                    authgroup = role[len(rolename)+2:len(role)-1]
                    if (len(authgroup) > 0):
                       # Delete user from authorization groups, if there are more than one authgroup, delete user from each authgroup  
                       if (authgroup.find(",") >0):
                          agList = authgroup[0:len(authgroup)].split(", ")
                          for ag in agList:
                              AdminUtilities.infoNotice("Remove user " +userid+ " from role "+rolename+ " in authorization group " + ag)
                              result = AdminTask.removeUsersFromAdminRole(['-authorizationGroupName', ag, '-roleName', rolename, '-userids', userid])
                          #endFor    
                       else:
                          AdminUtilities.infoNotice("Remove user " +userid+ " from role " +rolename+ " in authorization group " + authgroup)
                          result = AdminTask.removeUsersFromAdminRole(['-authorizationGroupName', authgroup, '-roleName', rolename, '-userids', userid])
                       #endIf
                    #endif   
                #endFor
                
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


## Example 19 Remove a group from all administrative roles in authorization groups##
def removeGroupFromAllAdminRoles ( groupid, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "removeGroupFromAllAdminRoles("+`groupid`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Remove a group from all administrative roles in authorization groups 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminAuthorizations:    Remove a group from all admin roles in authorization groups"
                print " Group ID:               "+groupid
                print " Usage: AdminAuthorizations.removeGroupFromAllAdminRoles(\""+groupid+"\") "
                print " Return: If the command is successful, a true value is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (groupid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["groupid", groupid]))

                # check if group id in the authorization group
                ags = listAuthorizationGroupsForGroupID(groupid)
                if (len(ags) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["groupid", groupid]))

                # Get the role-authorizationGroup mapping table
                authGroups = AdminTask.listAuthorizationGroupsForGroupID(['-groupid', groupid])
                
                # Separate the role-authGroup table by individual role
                roleTable = authGroups[1:len(authGroups) -1].split("], ")
                
                # Loop through each role in role table 
                result = "false"
                for role in roleTable:
                    if (len(role) > 2 and role[len(role)-1] != "]"):
                       role = role + "]"
                    #endIf  
                    
                    # Find role name and authorization group name 
                    rolename = role[0:role.find("=")]
                    authgroup = role[len(rolename)+2:len(role)-1]
                    if (len(authgroup) > 0):
                       # Delete user from authorization groups, if there are more than authgroup, delete user from each authgroup 
                       if (authgroup.find(",") >0):
                          agList = authgroup[0:len(authgroup)].split(", ")
                          for ag in agList:
                              AdminUtilities.infoNotice("Remove group " +groupid+ " from role "+rolename+ " in authorization group " + ag)
                              result = AdminTask.removeGroupsFromAdminRole(['-authorizationGroupName', ag, '-roleName', rolename, '-groupids', groupid])
                          #endFor    
                       else:
                          AdminUtilities.infoNotice("Remove group " +groupid+ " from role " +rolename+ " in authorization group " + authgroup)
                          result = AdminTask.removeGroupsFromAdminRole(['-authorizationGroupName', authgroup, '-roleName', rolename, '-groupids', groupid])
                       #endIf
                    #endif   
                #endFor
                
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


## Example 20 Online help ##
def help(procedure="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf

        try:
                #--------------------------------------------------------------------
                # Provide the online help  
                #--------------------------------------------------------------------
                #print "---------------------------------------------------------------"
                #print " AdminAuthorizations:            Help "
                #print " Script procedure:               "+procedure
                #print " Usage: AdminAuthorizations.help(\""+procedure+"\")"
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)
                
                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINAUTHORIZATIONS_GENERAL_HELP")
                else:
                   procedure = "ADMINAUTHORIZATIONS_HELP_"+procedure.upper()
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

