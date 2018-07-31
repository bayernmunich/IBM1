
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

# @(#) 1.10 SERV1/ws/code/admin.scripting/src/scriptLibraries/resources/J2C/V61/AdminJ2C.py, WAS.admin.scripting, WASX.SERV1, m0847.36 4/7/08 08:41:33 [12/1/08 17:58:21]

#---------------------------------------------------------------------------------------
# AdminJ2C.py - Jython procedures for performing J2C tasks.
#---------------------------------------------------------------------------------------
#
#   This script includes the following procedures:
#       Ex1: listMessageListenerTypes
#       Ex2: listConnectionFactoryInterfaces
#       Ex3: listAdminObjectInterfaces
#       Ex4: installJ2CResourceAdapter
#       Ex5: createJ2CConnectionFactory
#       Ex6: createJ2CActivationSpec
#       Ex7: createJ2CAdminObject
#       Ex8: listJ2CResourceAdapters
#       Ex9: listJ2CConnectionFactories
#       Ex10: listJ2CActivationSpecs
#       Ex11: listJ2CAdminObjects
#       Ex12: help
#
#---------------------------------------------------------------------

import sys
import AdminUtilities

#AdminUtilities.debugNotice("Loading AdminJ2C.py name="+__name__)

# Global variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)

## Example 1 list MessageListenerTypes ##
def listMessageListenerTypes( j2cRAConfigID, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listMessageListenerTypes("+`j2cRAConfigID`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List MessageListenerType
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listMessageListenerTypes"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " Usage: AdminJ2C.listMessageListenerTypes(\""+j2cRAConfigID+"\")"
        print " Return: List of the message listener types for the specified Java 2 Connectivity (J2C) resource adapter configuration ID parameter in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        msgListenerTypes = AdminTask.listMessageListenerTypes(j2cRAConfigID)
        #print msgListenerTypes
        msgListenerTypeList = AdminUtilities.convertToList(msgListenerTypes)
        return msgListenerTypeList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 2 list ConnectionFactoryInterfaces ##
def listConnectionFactoryInterfaces( j2cRAConfigID, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listConnectionFactoryInterfaces("+`j2cRAConfigID`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List ConnectionFactoryInterfaces
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listConnectionFactoryInterfaces"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " Usage: AdminJ2C.listConnectionFactoryInterfaces(\""+j2cRAConfigID+"\")"
        print " Return: List of the Java 2 Connectivity (J2C) connection factory interfaces for the specified J2C resource adapter configuration ID parameter in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        cfInterfaces = AdminTask.listConnectionFactoryInterfaces(j2cRAConfigID)
        #print cfInterfaces
        cfInterfaceList = AdminUtilities.convertToList(cfInterfaces)
        return cfInterfaceList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 3 list AdminObjectInterfaces ##
def listAdminObjectInterfaces( j2cRAConfigID, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listAdminObjectInterfaces("+`j2cRAConfigID`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List AdminObjectInterfaces
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listAdminObjectInterfaces"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " Usage: AdminJ2C.listAdminObjectInterfaces(\""+j2cRAConfigID+"\")"
        print " Return: List of the Java 2 Connectivity (J2C) administrative object interfaces for the specified J2C resource adapter configuration ID parameter in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))
        
        aoInterfaces = AdminTask.listAdminObjectInterfaces(j2cRAConfigID)
        #print aoInterfaces
        aoInterfaceList = AdminUtilities.convertToList(aoInterfaces)
        return aoInterfaceList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 4 install J2CResourceAdapter ##
def installJ2CResourceAdapter( nodeName, rarPath, J2CRAName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "installJ2CResourceAdapter("+`nodeName`+", "+`rarPath`+", "+`J2CRAName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # install J2CResourceAdapter
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:               installingJ2CResourceAdapter"
        print " nodeName:               "+nodeName
        print " rarPath:                "+rarPath
        print " j2cRA name:             "+J2CRAName
        print " Optional attributes:"
        print "   OtherAttributesList  %s" % (otherAttrsList)
        print "     rar.desc"
        print "     rar.archivePath"
        print "     rar.classpath"
        print "     rar.nativePath"
        print "     rar.threadPoolAlias"
        print "     rar.propertiesSet"
        print "     rar.DeleteSourceRar"
        print "     rar.isolatedClassLoader"
        print "     rar.enableHASupport"
        print "     rar.HACapability"
        print ""
        if (otherAttrsList == []):
           print " Usage: AdminJ2C.installJ2CResourceAdapter(\""+nodeName+"\", \""+rarPath+"\", \""+J2CRAName+"\")"
        else:
           if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
              print " Usage: AdminJ2C.installJ2CResourceAdapter(\""+nodeName+"\", \""+rarPath+"\", \""+J2CRAName+"\", %s)" % (otherAttrsList)
           else: 
              # d714926 check if script syntax error  
              if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                 raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
              else:
                 if (otherAttrsList.find("\"") > 0):
                    otherAttrsList = otherAttrsList.replace("\"", "\'")
                 print " Usage: AdminJ2C.installJ2CResourceAdapter(\""+nodeName+"\", \""+rarPath+"\", \""+J2CRAName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the installed Java 2 Connectivity (J2C) resource adapter in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(rarPath) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["rarPath", rarPath]))

        if (len(J2CRAName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["J2CRAName", J2CRAName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        # construct required attributes
        requiredParams = ["-nodeName", nodeName, "-rarPath", rarPath, "-rar.name", J2CRAName]

        # convert string "param1=param1Value, param2=param2Value ..." to list
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        otherParamList = []
        for attrs in otherAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            otherParamList = otherParamList+attr

        finalParams = requiredParams+otherParamList

        result = AdminTask.installResourceAdapter(finalParams)

        if (AdminUtilities._AUTOSAVE_ == "true"):
           AdminConfig.save()
        return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 5 create J2C ConnectionFactory ##
def createJ2CConnectionFactory( j2cRAConfigID, j2cCFName, cfInterface, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJ2CConnectionFactory("+`j2cRAConfigID`+", "+`j2cCFName`+", "+`cfInterface`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create J2CConnectionFactory
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       createJ2CConnectionFactory"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " J2CConnectionFactory name:      "+j2cCFName
        print " ConnectionFactoryInterface      "+cfInterface
        print " jndi name:                      "+jndiName
        print " Optional attributes:"
        print "   OtherAttributesList  %s" % (otherAttrsList)
        print "     description"
        print "     authDataAlias"
        if (otherAttrsList == []):
           print " Usage: AdminJ2C.createJ2CConnectionFactory(\""+j2cRAConfigID+"\", \""+j2cCFName+"\", \""+cfInterface+"\", \""+jndiName+"\")"
        else:
           if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
              print " Usage: AdminJ2C.createJ2CConnectionFactory(\""+j2cRAConfigID+"\", \""+j2cCFName+"\", \""+cfInterface+"\", \""+jndiName+"\", %s)" % (otherAttrsList)
           else: 
              # d714926 check if script syntax error  
              if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                 raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
              else:
                 if (otherAttrsList.find("\"") > 0):
                    otherAttrsList = otherAttrsList.replace("\"", "\'")
                 print " Usage: AdminJ2C.createJ2CConnectionFactory(\""+j2cRAConfigID+"\", \""+j2cCFName+"\", \""+cfInterface+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created Java 2 Connectivity (J2C) connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        if (len(j2cCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cCFName", j2cCFName]))
            
        if (len(cfInterface) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["cfInterface", cfInterface]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # construct required parameters
        requiredParams = ["-name", j2cCFName, "-connectionFactoryInterface", cfInterface, "-jndiName", jndiName]

        # convert string "parmName=value, paramName=value ..." to list
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        otherParamList = []
        for attrs in otherAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            otherParamList = otherParamList+attr

        finalParams = requiredParams+otherParamList

        result = AdminTask.createJ2CConnectionFactory(j2cRAConfigID, finalParams)

        if (AdminUtilities._AUTOSAVE_ == "true"):
           AdminConfig.save()
        return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 6 create J2CActivationSpec ##
def createJ2CActivationSpec( j2cRAConfigID, j2cASName, msgListenerType, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJ2CActivationSpec("+`j2cRAConfigID`+", "+`j2cASName`+", "+`msgListenerType`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create J2CActivationSpec
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       createJ2CActivationSpec"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " J2CActivationSpec name:         "+j2cASName
        print " Message listener type:          "+msgListenerType
        print " jndi name:                      "+jndiName
        print " Optional attributes:"
        print "   OtherAttributesList  %s" % (otherAttrsList)
        print "     destinationJndiName"
        print "     description"
        print "     authenticationAlias"
        if (otherAttrsList == []):
           print " Usage: AdminJ2C.createJ2CActivationSpec(\""+j2cRAConfigID+"\", \""+j2cASName+"\", \""+msgListenerType+"\", \""+jndiName+"\")"
        else:
           if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
              print " Usage: AdminJ2C.createJ2CActivationSpec(\""+j2cRAConfigID+"\", \""+j2cASName+"\", \""+msgListenerType+"\", \""+jndiName+"\", %s)" % (otherAttrsList)
           else:
              # d714926 check if script syntax error  
              if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                 raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
              else:
                 if (otherAttrsList.find("\"") > 0):
                    otherAttrsList = otherAttrsList.replace("\"", "\'")
                 print " Usage: AdminJ2C.createJ2CActivationSpec(\""+j2cRAConfigID+"\", \""+j2cASName+"\", \""+msgListenerType+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created Java 2 Connectivity (J2C) activation specification in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        if (len(j2cASName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cASName", j2cASName]))

        if (len(msgListenerType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["msgListenerType", msgListenerType]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # construct required parameters
        requiredParams = ["-name", j2cASName, "-jndiName", jndiName, "-messageListenerType", msgListenerType]

        # convert string "parmName=value, paramName=value ..." to list
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        otherParamList = []
        for attrs in otherAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            otherParamList = otherParamList+attr

        finalParams = requiredParams+otherParamList

        # the msg listener type must exist on the J2CResourceAdapter to be able to create J2CActivationSpec
        result = AdminTask.createJ2CActivationSpec(j2cRAConfigID, finalParams)

        if (AdminUtilities._AUTOSAVE_ == "true"):
           AdminConfig.save()
        return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 7 create J2CAdminObject ##
def createJ2CAdminObject( j2cRAConfigID, j2cAOName, aoInterface, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJ2CAdminObject("+`j2cRAConfigID`+", "+`j2cAOName`+", "+`aoInterface`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create J2CAdminObject
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJ2C:                       createJ2CAdminObject"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " J2CAdminObject name:            "+j2cAOName
        print " AdminObjectInterface:           "+aoInterface
        print " jndi name:                      "+jndiName
        print " Optional attributes:"
        print "    otherAttributesList  %s" % (otherAttrsList)
        print "    description"
        if (otherAttrsList == []):
           print " Usage: AdminJ2C.createJ2CAdminObject(\""+j2cRAConfigID+"\", \""+j2cAOName+"\", \""+aoInterface+"\", \""+jndiName+"\")"
        else:
           if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
              print " Usage: AdminJ2C.createJ2CAdminObject(\""+j2cRAConfigID+"\", \""+j2cAOName+"\", \""+aoInterface+"\", \""+jndiName+"\", %s)" % (otherAttrsList)
           else:
              # d714926 check if script syntax error  
              if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                 raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
              else:
                 if (otherAttrsList.find("\"") > 0):
                    otherAttrsList = otherAttrsList.replace("\"", "\'")
                 print " Usage: AdminJ2C.createJ2CAdminObject(\""+j2cRAConfigID+"\", \""+j2cAOName+"\", \""+aoInterface+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created Java 2 Connectivity (J2C) administrative object in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        if (len(j2cAOName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cAOName", j2cAOName]))

        if (len(aoInterface) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["aoInterface", aoInterface]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # construct required paremeters
        requiredParams = ["-name", j2cAOName, "-adminObjectInterface", aoInterface, "-jndiName", jndiName]
        
        # convert string "parmName=value, paramName=value ..." to list
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)
        #print otherAttrsList   

        otherParamList = []
        for attrs in otherAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            otherParamList = otherParamList+attr

        finalParams = requiredParams+otherParamList

        result = AdminTask.createJ2CAdminObject(j2cRAConfigID, finalParams)

        if (AdminUtilities._AUTOSAVE_ == "true"):
           AdminConfig.save()
        return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #enfIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 8 list J2CResourceAdapters ##
def listJ2CResourceAdapters( j2cRAName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJ2CResourceAdapters("+`j2cRAName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List J2CResourceAdapter
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listJ2CResourceAdapters"
        print " Optional parameter:"
        print "   J2CResourceAdapter name:      "+j2cRAName
        if (len(j2cRAName) == 0):
            print " Usage: AdminJ2C.listJ2CResourceAdapter()"
        else:
            print " Usage: AdminJ2C.listJ2CResourceAdapter(\""+j2cRAName+"\")"
        print " Return: List of the Java 2 Connectivity (J2C) resource adapter configuration IDs that are associated with the specified J2C resource adapter name. Or, list all of the J2C resource adapter configuration IDs that are available in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
       
        J2Cs = AdminUtilities._BLANK_
        if (j2cRAName ==  AdminUtilities._BLANK_):
            J2Cs = AdminConfig.list("J2CResourceAdapter")
        else:
            J2Cs = AdminConfig.getid("/J2CResourceAdapter:"+j2cRAName+"/")
        #print J2Cs
        J2CList = AdminUtilities.convertToList(J2Cs)
        return J2CList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s %s " % (sys.exc_type, sys.exc_value, sys.exc_info)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 9 list J2CConnectionFactories ##
def listJ2CConnectionFactories( j2cRAConfigID, cfInterface, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJ2CConnectionFactories("+`j2cRAConfigID`+", "+`cfInterface`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List J2CConnectionFactories
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listJ2CConnectionFactories"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " connectionFactoryInterface:     "+cfInterface
        print " Usage: AdminJ2C.listJ2CConnectionFactories(\""+j2cRAConfigID+"\", \""+cfInterface+"\")"
        print " Return: List of Java 2 Connectivity (J2C) Connection Factory IDs associated with the specified J2C Resource Adapter configuration ID and Connection Factory Interface in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        if (len(cfInterface) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["cfInterface", cfInterface]))

        j2cCFs = AdminTask.listJ2CConnectionFactories(j2cRAConfigID, ["-connectionFactoryInterface", cfInterface])
        #print j2cCFs
        j2cCFList = AdminUtilities.convertToList(j2cCFs)
        return j2cCFList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 10 list J2CActivationSpecs  ##
def listJ2CActivationSpecs( j2cRAConfigID, msgListenerType, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJ2CActivationSpecs("+`j2cRAConfigID`+", "+`msgListenerType`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List J2CActivationSpecs
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listJ2CActivationSpecs"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " messageListenerType:            "+msgListenerType
        print " Usage: AdminJ2C.listJ2CActivationSpecs(\""+j2cRAConfigID+"\", \""+msgListenerType+"\")"
        print " Return: List of the configuration IDs for the Java 2 Connectivity (J2C) administrative specification for the specified J2C resource adapter configuration ID and message listener type in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        if (len(msgListenerType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["msgListenerType", msgListenerType]))

        j2cActSpecs = AdminTask.listJ2CActivationSpecs(j2cRAConfigID, ["-messageListenerType", msgListenerType])
        #print j2cActSpecs
        j2cActSpecList = AdminUtilities.convertToList(j2cActSpecs)
        return j2cActSpecList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else: 
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #enfIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 11 list J2CAdminObjects  ##
def listJ2CAdminObjects( j2cRAConfigID, aoInterface, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJ2CAdminObjects("+`j2cRAConfigID`+", "+`aoInterface`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List J2CAdminObjects
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJ2C:                       listJ2CAdminObjects"
        print " J2CResourceAdapter configID:    "+j2cRAConfigID
        print " adminObjectInterface:           "+aoInterface
        print " Usage: AdminJ2C.listJ2CAdminObjects(\""+j2cRAConfigID+"\", \""+aoInterface+"\")"
        print " Return: List of the Java 2 Connectivity (J2C) Admin Objects configuration IDs for the specified J2C Resource Adapter configuration ID and Admin Object Interface in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(j2cRAConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cRAConfigID", j2cRAConfigID]))

        if (len(aoInterface) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["aoInterface", aoInterface]))

        j2cRAs = AdminTask.listJ2CAdminObjects(j2cRAConfigID, ["-adminObjectInterface", aoInterface])
        #print j2cRAs
        j2cRAList = AdminUtilities.convertToList(j2cRAs)
        return j2cRAList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 12 Online help ##
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
        #print " AdminJ2C:         		Help "
        #print " Script procedure:              "+procedure
        #print " Usage: AdminJ2C.help(\""+procedure+"\")"
        #print " Return: Receive help information for the specified AdminJ2C script library function, or provide help information of all of the AdminJ2C script library if parameters are not passed"
        #print "---------------------------------------------------------------"
        #print " "
        #print " "
        bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
        resourceBundle = AdminUtilities.getResourceBundle(bundleName)

        if (len(procedure) == 0):
            message = resourceBundle.getString("ADMINJ2C_GENERAL_HELP")
        else:
            procedure = "ADMINJ2C_HELP_"+procedure.upper()
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
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef



