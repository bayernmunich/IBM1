
###############################################################################
# Licensed Material - Property of IBM 
# 5724-I63, 5724-H88, (C) Copyright IBM Corp. 2007 - All Rights Reserved. 
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

# @(#) 1.9 SERV1/ws/code/admin.scripting/src/scriptLibraries/resources/JDBC/V61/AdminJDBC.py, WAS.admin.scripting, WAS70.SERV1, cf030902.23 3/26/08 17:40:19 [1/16/09 19:43:14]

#---------------------------------------------------------------------------------------
# AdminJDBC.py - Jython procedures for performing JDBCProvider and DataSource tasks.
#---------------------------------------------------------------------------------------
#
#   This script includes the following procedures:
#       Ex1:    createJDBCProvider
#       Ex2:    createJDBCProviderUsingTemplate
#       Ex3:    listJDBCProviderTemplates
#       Ex4:    createDataSource
#       Ex5:    createDataSourceUsingTemplate
#       Ex6:    listDataSourceTemplates
#       Ex7:    listJDBCProviders
#       Ex8:    listDataSources
#       Ex9:    help
#       Ex10:   createJDBCProviderAtScope
#       Ex11:   createJDBCProviderUsingTemplateAtScope 
#       Ex12:   createDataSourceAtScope
#       Ex13:   createDataSourceUsingTemplateAtScope
#
#

import sys
import AdminUtilities

#AdminUtilities.debugNotice("Loading AdminJDBC.py name="+__name__)

# Global variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)

## Example 1 create JDBCProvider ##
def createJDBCProvider( nodeName, serverName, JDBCName, implClassName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJDBCProvider("+`nodeName`+", "+`serverName`+", "+`JDBCName`+", "+`implClassName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JDBCProvider
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:              creating JDBCProvider"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print " JDBC provider:              "
        print "    name                     "+JDBCName
        print "    implClassName            "+implClassName
        print " Optional attributes:        "
        print "     otherAttributesList:  %s" % otherAttrsList
        print "       classpath                "
        print "       description              "
        print "       isolatedClassLoader      "
        print "       nativepath               "
        print "       propertySet              "
        print "       providerType             "
        print "       xa                       "
        print "  "
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createJDBCProvider(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+implClassName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createJDBCProvider(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+implClassName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createJDBCProvider(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+implClassName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created JDBC Provider listJ2CActivationSpecs in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(implClassName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["implClassName", implClassName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # construct required attributes
        requiredAttrs = [["name", JDBCName], ["implementationClassName", implClassName]]
        
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            jdbc = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/")
            if (len(jdbc) == 0):
                result = AdminConfig.create("JDBCProvider", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JDBCName]))
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
  

  
## Example 2 create JDBCProvider using template ##
def createJDBCProviderUsingTemplate( nodeName, serverName, templateID, JDBCName, implClassName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJDBCProviderUsingTemplate("+`nodeName`+", "+`serverName`+", "+`templateID`+", "+`JDBCName`+", "+`implClassName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JDBCProvider using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:              creating JDBCProvider using template"
        print " Scope:"
        print "    node                       "+nodeName
        print "    server                     "+serverName
        print " JDBC provider:                "
        print "    templateID                 "+templateID
        print "    name                       "+JDBCName
        print "    implClassName              "+implClassName
        print " Optional attributes:"
        print "     otherAttributesList:    %s" % otherAttrsList 
        print "       classpath            "
        print "       description          "
        print "       isolatedClassLoader  "
        print "       nativepath           "
        print "       propertySet          "
        print "       providerType         "
        print "       xa                   "
        print " "  
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createJDBCProviderUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+templateID+"\", "+JDBCName+"\", \""+implClassName+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createJDBCProviderUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+templateID+"\", "+JDBCName+"\", \""+implClassName+"\",  %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createJDBCProviderUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+templateID+"\", "+JDBCName+"\", \""+implClassName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created JDBC Provider listJ2CActivationSpecs in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(implClassName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["implClassName", implClassName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # construct required attributes
        requiredAttrs = [["name", JDBCName], ["implementationClassName", implClassName]]
        
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)
        
        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            jdbc = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/")
            if (len(jdbc) == 0):
                result = AdminConfig.createUsingTemplate("JDBCProvider", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JDBCName]))
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
 
  
## Example 3 list JDBCProvider templates ##
def listJDBCProviderTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJDBCProviderTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list JDBCProvider templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:          listJDBCProviderTemplates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJDBC.listJDBCProviderTemplate()"
        else:
            print " Usage: AdminJDBC.listJDBCProviderTemplate(\""+templateName+"\")"
        print " Return: List of the configuration IDs for the Java Database Connectivity (JDBC) provider templates of the requested template name. Or, list all of the available JDBC provider configuration IDs if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
       
        templates = AdminUtilities._BLANK_
        newList = []
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("JDBCProvider")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("JDBCProvider", templateName)
            templateList = AdminUtilities.convertToList(templates)
            if len(templateList) > 0:
                for template in templateList:
                    templName = AdminConfig.showAttribute(template, "name")
                    if (templName == templateName):
                        newList.append(template)
       
        return newList
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
  
  
## Example 4 create DataSource ##
def createDataSource( nodeName, serverName, JDBCName, datasourceName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createDataSource("+`nodeName`+", "+`serverName`+", "+`JDBCName`+", "+`datasourceName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create DataSource
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:                  creating DataSource"
        print " Scope:"
        print "    node                       "+nodeName
        print "    server                     "+serverName
        print " JDBC provider:"
        print "    name                       "+JDBCName
        print " DataSource:"
        print "    name                       "+datasourceName
        print " Optional attributes:"
        print "     otherAttributesList:    %s" % otherAttrsList
        print "       authDataAlias"
        print "       authMechanismPreference"
        print "       category"
        print "       connectionPool"
        print "       datasourceHelperClassname"
        print "       description"
        print "       diagnoseConnectionUsage"
        print "       jndiName"
        print "       logMissingTransactionContext"
        print "       manageCachedHandles"
        print "       mapping"
        print "       preTestConfig"
        print "       properties"
        print "       propertySet"        
        print "       providerType"
        print "       relationalResourceAdapter"
        print "       statementCacheSize"
        print "       xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createDataSource(\""+nodeName+ "\, \""+serverName+"\", \""+JDBCName+"\", \""+datasourceName+"\)"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createDataSource(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+datasourceName+"\", %s )"  %(otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createDataSource(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created data source in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
        
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(datasourceName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["datasourceName", datasourceName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jdbcExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/")
        if (len(jdbcExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JDBCName", JDBCName]))

        # construct required attributes
        requiredAttrs = [["name", datasourceName]]
        
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JDBCProvider="+JDBCName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            dsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/DataSource:"+datasourceName+"/")
            if (len(dsExist) == 0):
                result = AdminConfig.create("DataSource", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [datasourceName]))
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
 

## Example 5 create DataSourceUsingTemplate ##
def createDataSourceUsingTemplate( nodeName, serverName, JDBCName, templateID, datasourceName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createDataSourceUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JDBCName`+", "+`templateID`+", "+`datasourceName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create DataSource Using Template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:                  creating DataSource using template"
        print " Scope:"
        print "    node                       "+nodeName
        print "    server                     "+serverName
        print " JDBC provider:"
        print "    name                       "+JDBCName
        print " DataSource:"
        print "    templateID                 "+templateID
        print "    name                       "+datasourceName
        print " Optional attributes:"
        print "     otherAttributesList:    %s" % otherAttrsList
        print "       authDataAlias"
        print "       authMechanismPreference"
        print "       category"
        print "       connectionPool"
        print "       datasourceHelperClassname"
        print "       description"
        print "       diagnoseConnectionUsage"
        print "       jndiName"
        print "       logMissingTransactionContext"
        print "       manageCachedHandles"
        print "       mapping"
        print "       preTestConfig"
        print "       properties"
        print "       propertySet"
        print "       providerType"
        print "       relationalResourceAdapter"
        print "       statementCacheSize"
        print "       xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createDataSourceUsingTemplate(\""+nodeName+ "\, \""+serverName+"\", \""+JDBCName+"\", \""+templateID+"\", \""+datasourceName+"\)"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createDataSourceUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+templateID+"\", \""+datasourceName+"\", %s )"  %(otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createDataSourceUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JDBCName+"\", \""+templateID+"\", \""+datasourceName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created data source in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(datasourceName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["datasourceName", datasourceName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jdbcExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/")
        if (len(jdbcExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JDBCName", JDBCName]))

        # construct required attributes
        requiredAttrs = [["name", datasourceName]]
        
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)    
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JDBCProvider="+JDBCName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            dsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+JDBCName+"/DataSource:"+datasourceName+"/")
            if (len(dsExist) == 0):
                result = AdminConfig.createUsingTemplate("DataSource", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [datasourceName]))
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

 
## Example 6 list DataSource templates ##
def listDataSourceTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listDataSourceTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list DataSource templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:          listDataSourceTemplates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJDBC.listDataSourceTemplate(\""+templateName+"\")"
        else:
            print " Usage: AdminJDBC.listDataSourceTemplate(\""+templateName+"\")"
        print " Return: List the configuration IDs of the requested data source template name or list all of the available data source template configuration IDs if a data source template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
 
        templates = AdminUtilities._BLANK_
        newList = []
        if (templateName == AdminUtilities._BLANK_): 
            templates = AdminConfig.listTemplates("DataSource")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("DataSource", templateName)
            templateList = AdminUtilities.convertToList(templates)
            if len(templateList) > 0:
                for template in templateList:
                    templName = AdminConfig.showAttribute(template, "name")
                    if (templName == templateName):
                        newList.append(template)
       
        return newList
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
  
     
## Example 7 list JDBCProviders ##
def listJDBCProviders( JDBCName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJDBCProviders("+`JDBCName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List JDBCProviders
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:              listJDBCProviders"
        print " Optional parameter:"
        print " JDBC provider name:     "+JDBCName
        if (len(JDBCName) == 0):
            print " Usage: AdminJDBC.listJDBCProvider()"
        else:
            print " Usage: AdminJDBC.listJDBCProvider(\""+JDBCName+"\")"
        print " Return: List the JDBC provider configuration IDs of the requested Java Database Connectivity (JDBC) name or list all of the available JDBC provider configuration IDs if a JDBC name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        jdbcs = AdminUtilities._BLANK_
        if (JDBCName == ""):
            jdbcs = AdminConfig.list("JDBCProvider")
        else:
            jdbcs = AdminConfig.getid("/JDBCProvider:"+JDBCName+"/")
        #print jdbcs
        newList = AdminUtilities.convertToList(jdbcs)
        return newList
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


## Example 8 list DataSources ##
def listDataSources( datasourceName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listDataSources("+`datasourceName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List DataSources
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:               listDataSources"
        print " Optional parameter:"
        print " DataSource name:         "+datasourceName
        if (len(datasourceName) == 0):
            print " Usage: AdminJDBC.listDataSources()"
        else:
            print " Usage: AdminJDBC.listDataSources(\""+datasourceName+"\")"
        print " Return: List the Data source connection configuration ID of the requested data source name or list all of the available data source connection configuration IDs if a data source connection name is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
          
        dss = AdminUtilities._BLANK_ 
        if (datasourceName == AdminUtilities._BLANK_):
            dss = AdminConfig.list("DataSource")
        else:
            dss = AdminConfig.getid("/DataSource:"+datasourceName+"/")
        #print dss
        dsList = AdminUtilities.convertToList(dss)
        return dsList
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


## Example 9 Online help ##
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
        #print " AdminJDBC:           Help "
        #print " Script procedure:               "+procedure
        #print " Usage: AdminJDBC.help(\""+procedure+"\")"
        #print " Return: Receive help information for the specified AdminJDBC script library function or provide help information for all of the AdminJDBC script library functions if parameters are not passed"
        #print "---------------------------------------------------------------"
        #print " "
        #print " "
        bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
        resourceBundle = AdminUtilities.getResourceBundle(bundleName)

        if (len(procedure) == 0):
            message = resourceBundle.getString("ADMINJDBC_GENERAL_HELP")
        else:
            procedure = "ADMINJDBC_HELP_"+procedure.upper()
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


##  New Script functions to support different scope
########################################################################################################################################################################################################################################
########################################################################################################################################################################################################################################
## Example 10 create JDBCProvider at scope##
def createJDBCProviderAtScope( scope, databaseType, providerType, implType, name, otherAttrsList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf  
    msgPrefix = "createJDBCProviderAtScope("+`scope`+", "+`databaseType`+", "+`providerType`+", "+`implType`+", "+`name`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JDBCProviderAtScope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:              creating JDBCProvider at scope"
        print " Scope:"
        print "     scope                         "+scope 
        print " JDBC provider:"
        print "     databaseType                  "+databaseType
        print "     providerType                  "+providerType
        print "     implementationType            "+implType
        print "     name                          "+name        
        print " Optional attributes:"
        print "     otherAttributesList:          %s" % otherAttrsList
        print "       description                   "
        print "       implementationClassName       "
        print "       classpath                     "
        print "       nativePath                    "
        print "       isolated                      "
        print "  "   
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createJDBCProviderAtScope(\""+scope+"\", \""+databaseType+"\" , \""+providerType+"\", \""+implType+"\", \""+name+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createJDBCProviderAtScope(\""+scope+"\", \""+databaseType+"\", \""+providerType+"\", \""+implType+"\", \""+name+"\", %s)" % otherAttrsList
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createJDBCProviderAtScope(\""+scope+"\", \""+databaseType+"\", \""+providerType+"\", \""+implType+"\", \""+name+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created JDBC Provider in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
        
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
            
        if (len(databaseType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["databaseType", databaseType]))

        if (len(providerType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["providerType", providerType]))

        if (len(implType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["implementationType", implType])) 

        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["implementationType", implType])) 

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                    
        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)
        scopeId=AdminConfig.getid(scopeFormatted) 
        
        #Validation step        
        #Make sure that the scope exists
        if(len(scopeId) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        AdminUtilities.debugNotice("scopeFormatted="+scopeFormatted)
        AdminUtilities.debugNotice("scopeId="+scopeId)
        
        #Make sure that the JDBCProvider does not already exist    
        doesJDBCProviderExist=AdminConfig.getid(scopeFormatted+"JDBCProvider:"+name+"/")
        
        if(len(doesJDBCProviderExist)>0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", ["JDBCProvider: \""+ scope+"JDBCProvider:"+name+"\""])) 
        
        #Validate to make sure that for the given databaseType, the providerType passed in is valid
        providerTypeExists=AdminConfig.listTemplates("JDBCProvider",databaseType)
        providerTypeFound="false"
        
        #providerTypeExistsList=providerTypeExists.split("\n")
        providerTypeExistsList=AdminUtilities.convertToList(providerTypeExists)

        for aJDBCProvider in providerTypeExistsList:            
            aProviderType=AdminConfig.showAttribute(aJDBCProvider,"providerType")
            if(aProviderType!="" and aProviderType==providerType):
                providerTypeFound="true"
                break

        if(providerTypeFound=="false"):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["providerType", providerType]))

        lowerCaseScope=scopeFormatted.lower()
        
        serverName=""
        nodeName=""
        clusterName=""
        cellName=""
        finalScope=""
        
        #Look for the server context
        serverIndex=lowerCaseScope.find("/server:")
        if(serverIndex!=-1):
            serverName=scopeFormatted[(serverIndex+8):((len(scopeFormatted)-1))] 
            #We have found the server Name, just set the finalScope to the ServerName
            if(serverName!=""):
                #We have the server name, we have to check to see if a Node name was specified 
                #in case there are multiple servers with the same name but in different Nodes
                nodeIndex=lowerCaseScope.find("/node:")
                
                #There was a node specified, make sure that it's part of the finalScope
                if(nodeIndex!=-1):
                    nodeName=scopeFormatted[(nodeIndex+6):((serverIndex))]
                    if(nodeName!=""):
                        finalScope="Node="+nodeName+","
                        
                finalScope=finalScope+"Server="+serverName
        #No server was specified Check to see if a Node, Cluster, or Cell is specified
        else:
            #Check for Node scope
            nodeIndex=lowerCaseScope.find("/node:")
            if(nodeIndex!=-1):
                nodeName=scopeFormatted[(nodeIndex+6):((len(scopeFormatted)-1))] 
                #We have found the Node name, just set the fnailScope to the nodeName
                if(nodeName!=""):
                    finalScope="Node="+nodeName
            #Check for Cluster then Cell scope
            else:
                #Check for the Cluster which can use the key word ServerCluster or Cluster
                clusterIndex=lowerCaseScope.find("/servercluster:")
                if(clusterIndex!=-1):
                    clusterName=scopeFormatted[(clusterIndex+15):((len(scopeFormatted)-1))]
                else:
                    clusterIndex=lowerCaseScope.find("/cluster:")
                    if(clusterIndex!=-1):
                        clusterName=scopeFormatted[(clusterIndex+9):((len(scopeFormatted)-1))]
                if(clusterName!=""):
                    finalScope="ServerCluster="+clusterName
                #Only the cluster was specified
                else:                    
                    cellIndex=lowerCaseScope.find("/cell:")
                    if(cellIndex!=-1):
                        cellName=scopeFormatted[(cellIndex+6):((len(scopeFormatted)-1))]
                        if(cellName!=""):
                            finalScope="Cell="+cellName
         
        AdminUtilities.debugNotice("finalScope="+finalScope)
        
        #prepare for AdminTask command call        
        requiredParameters = [["scope", finalScope], ["databaseType", databaseType], ["providerType", providerType], ["implementationType",implType], ["name", name]]
        
        if (len(otherAttrsList) > 0):
           AdminUtilities.debugNotice("otherAttrsList="+str(otherAttrsList))
    
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)  
        
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []

        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]] 
            finalParameters = finalParameters+attr

        result=AdminTask.createJDBCProvider(finalParameters)
 
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



## Example 11 create JDBCProvider using template at scope##
def createJDBCProviderUsingTemplateAtScope( scope, templateID, JDBCName, implClassName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJDBCProviderUsingTemplateAtScope("+`scope`+", "+`templateID`+", "+`JDBCName`+", "+`implClassName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JDBCProvider using template at scope
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJDBC:              Creating JDBCProvider using template at scope"
        print " Scope:"
        print "    scope                 "+scope
        print " JDBC provider:"
        print "    templateID            "+templateID
        print "    name                  "+JDBCName
        print "    implClassName         "+implClassName
        print " Optional attributes:"
        print "    otherAttributesList:  %s" % otherAttrsList
        print "      classpath             "
        print "      description           "
        print "      isolatedClassLoader   "
        print "      nativepath            "
        print "      propertySet           "
        print "      providerType          "
        print "      xa                    "
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createJDBCProviderUsingTemplateAtScope(\""+scope+"\", \""+templateID+"\", "+JDBCName+"\", \""+implClassName+"\")"
        else:        
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createJDBCProviderUsingTemplateAtScope(\""+scope+"\", \""+templateID+"\", \""+JDBCName+"\", \""+implClassName+"\", %s)" % (otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createJDBCProviderUsingTemplateAtScope(\""+scope+"\", \""+templateID+"\", \""+JDBCName+"\", \""+implClassName+"\", \""+str(otherAttrsList)+"\")" 
        print " Return: The configuration ID of the created JDBC Provider in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
        
        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)
        scopeId=AdminConfig.getid(scopeFormatted)                 
        
        AdminUtilities.debugNotice("scopeId="+scopeId)
        AdminUtilities.debugNotice("scopeFormatted="+scopeFormatted)      
        
        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope])) 

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scopeId) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope])) 

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(implClassName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["implClassName", implClassName]))
        
        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        if (len(scopeId) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        # construct required attributes
        requiredAttrs = [["name", JDBCName], ["implementationClassName", implClassName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        parentIDs = scopeId
        parentIDList = AdminUtilities.convertToList(parentIDs)
        
        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            jdbc = AdminConfig.getid(scopeFormatted+"JDBCProvider:"+JDBCName+"/")
            if (len(jdbc) == 0):
                result = AdminConfig.createUsingTemplate("JDBCProvider", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JDBCName]))
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


## Example 12 create DataSource at scope ##
def createDataSourceAtScope( scope, JDBCName, datasourceName, jndiName, dataStoreHelperClassName, dbName, otherAttrsList=[], resourceAttrsList=[],  failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createDataSourceAtScope("+`scope`+", "+`JDBCName`+", "+`datasourceName`+", "+`jndiName`+", "+`dataStoreHelperClassName`+", "+`dbName`+ ", "+`otherAttrsList`+", "+`resourceAttrsList`+", ` "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create DataSource At scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:                  create DataSource at scope"
        print " Scope:"
        print "    scope                                   "+scope
        print " JDBC provider:"
        print "    name                                    "+JDBCName
        print " DataSource:"        
        print "    name                                    "+datasourceName
        print "    jndiName                                "+jndiName
        print "    dataStoreHelperClassName                "+dataStoreHelperClassName 
        print " Database:"
        print "    databaseName (URL for Oracle)           "+dbName   
        print " Optional attributes:"
        print "    otherAttributesList:                    %s" % otherAttrsList
        print "      category                                "
        print "      componentManagedAuthenticationAlias     "
        print "      containerManagedPersistence             "
        print "      description                             "
        print "      xaRecoveryAuthAlias                     "
        print "    ResourceAttributesList:                 %s" % resourceAttrsList
        print "      DB2 database:"
        print "         driverType                           "
        print "         portNumber                           "
        print "         serverName                           "
        print "      Informix database:"
        print "         portNumber                           "
        print "         serverName                           "
        print "         ifxIFXHOST                           "
        print "         informixLockModeWait                 "
        print "      Sybase database:"
        print "         portNumber                           "
        print "         serverName                           "
        print "      SQLServer database:"
        print "         portNumber                           "
        print "         serverName                           "
        print " "        
        print " Return: The configuration ID of the created data source in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        if (len(otherAttrsList) == 0 and len(resourceAttrsList) == 0):
            print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+ "\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\")"
        else:
            if(len(otherAttrsList) > 0 and len(resourceAttrsList) == 0):
                if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                   print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\",  %s)"  %(otherAttrsList)
                else:
                   # d714926 check if script syntax error  
                   if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                   else:
                      if (otherAttrsList.find("\"") > 0):
                         otherAttrsList = otherAttrsList.replace("\"", "\'")
                      print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\",  \""+str(otherAttrsList)+"\")" 
            elif (len(otherAttrsList) == 0 and len(resourceAttrsList) > 0):
                if (str(resourceAttrsList).startswith("[[") > 0 and str(resourceAttrsList).startswith("[[[",0,3) == 0):
                   print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\", \""+"\", %s)" % (resourceAttrsList)
                else:
                   # d714926 check if script syntax error  
                   if (str(resourceAttrsList).startswith("[",0,1) > 0 or str(resourceAttrsList).startswith("[[[",0,3) > 0):  
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [resourceAttrsList]))
                   else:
                      if (resourceAttrsList.find("\"") > 0):
                         resourceAttrsList = resourceAttrsList.replace("\"", "\'")
                      print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\", \""+"\", \""+str(resourceAttrsList)+"\")" 
            else:
                if ((str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0) and 
                    (str(resourceAttrsList).startswith("[[") > 0 and str(resourceAttrsList).startswith("[[[",0,3) == 0)):
                   print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\", %s %c %s)" % (otherAttrsList,",",resourceAttrsList) 
                else: 
                   # d714926 check if script syntax error  
                   if ((str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0) or  
                       (str(resourceAttrsList).startswith("[",0,1) > 0 or str(resourceAttrsList).startswith("[[[",0,3) > 0)):
                       # d714926 check if script syntax error  
                       if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                       else:
                          # d714926 check if script syntax error  
                          if (str(resourceAttrsList).startswith("[",0,1) > 0 or str(resourceAttrsList).startswith("[[[",0,3) > 0):
                             raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [resourceAttrsList]))
                   else:
                       if (otherAttrsList.find("\"") > 0):
                          otherAttrsList = otherAttrsList.replace("\"", "\'")
                       if (resourceAttrsList.find("\"") > 0):
                          resourceAttrsList = resourceAttrsList.replace("\"", "\'")
                       print " Usage: AdminJDBC.createDataSourceAtScope(\""+scope+"\", \""+JDBCName+"\", \""+datasourceName+"\", \""+jndiName+"\", \""+dataStoreHelperClassName+"\", \""+dbName+"\", \""+str(otherAttrsList)+"\", \""+str(resourceAttrsList)+"\")"

        # checking required parameters non-empty
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
            
        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(datasourceName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["datasourceName", datasourceName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(dataStoreHelperClassName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["dataStoreHelperClassName", dataStoreHelperClassName]))

        if (len(dbName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["dbName", dbName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        #validate scope
        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope) 

        scopeId=AdminConfig.getid(scopeFormatted)
        if(scopeId==""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope])) 

        AdminUtilities.debugNotice("scopeFormatted="+scopeFormatted)
        AdminUtilities.debugNotice("scopeId="+scopeId)

        #get the JDBCProvider id
        jdbcProvId = AdminConfig.getid(scopeFormatted+"JDBCProvider:"+JDBCName)
        
        #Validate that the JDBCProvider exists
        if (len(jdbcProvId) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JDBCProvider", JDBCName])) 
        
        #prepare for AdminTask command call
        requiredParameters = [["name", datasourceName],["jndiName", jndiName],["dataStoreHelperClassName", dataStoreHelperClassName]]
        
        #convert to list format
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList) 
        resourceAttrsList=AdminUtilities.convertParamStringToList(resourceAttrsList)
        
        finalAttrsList = requiredParameters+otherAttrsList
        
        #build required and optional command parameters 
        finalParamList=[]
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParamList = finalParamList+attr
        
        finalParameters = []
        
	useStringParams = "false"
	if (dbName.find(",") > 0):
	    useStringParams = "true"
        #construct step -configureResourceProperties
        if (dataStoreHelperClassName.find("Oracle") < 0):
	   if (useStringParams != "true"):
              resProp = "-configureResourceProperties, [[databaseName java.lang.String \""+dbName+"\"]"
	   else:
	      resProp = "-configureResourceProperties [[databaseName java.lang.String \""+dbName+"\"]"
        else:
	   if (useStringParams != "true"):
              resProp = "-configureResourceProperties, [[URL java.lang.String \""+dbName+"\"]"
	   else:
              resProp = "-configureResourceProperties [[URL java.lang.String \""+dbName+"\"]"
        
        for attrs in resourceAttrsList:
            if (dataStoreHelperClassName.find("Oracle") < 0 and dataStoreHelperClassName.find("Derby") < 0):
               if (attrs[0] == "driverType" or attrs[0] == "portNumber" or attrs[0] == "informixLockModeWait"):
                  if (str(resourceAttrsList).startswith("[[") == 0):
                     attr = "[" + attrs[0]+ " java.lang.Integer " + attrs[1] + "]"
                  else:
                     attr = "[" + str(attrs[0])+ " java.lang.Integer " + str(attrs[1]) + "]"
               else:
                  if (str(resourceAttrsList).startswith("[[") == 0):
                     attr = "[" + attrs[0]+ " java.lang.String " + attrs[1] + "]"
                  else:
                     attr = "[" + str(attrs[0])+ " java.lang.String " + str(attrs[1]) + "]"
               resProp = resProp + " " + str(attr)
        resProp = resProp + "]"
        resPropList = []
        
        #convert to list
	if (useStringParams != "true"):
            resProp = resProp.strip().split(",")
            for f in resProp:
            	resPropList.append(f)
	else:
	    resPropList.append(resProp)
        #print resPropList
        if (dataStoreHelperClassName.find("GenericDataStoreHelper") < 0): 
           finalParameters = finalParamList + resPropList
        else:
           finalParameters = finalParamList
        
	stringFinalParams = AdminUtilities.convertParamListToString(finalParameters)
        if (useStringParams != "true"):
           AdminUtilities.debugNotice("finalParameters="+str(finalParameters))
           AdminUtilities.debugNotice("jdbcProvId="+jdbcProvId)
           AdminUtilities.debugNotice("About to call AdminTask command ...")
           result = AdminTask.createDatasource(jdbcProvId,finalParameters )
	else:
           AdminUtilities.debugNotice("stringFinalParameters="+stringFinalParams)
           AdminUtilities.debugNotice("jdbcProvId="+jdbcProvId)
           AdminUtilities.debugNotice("About to call AdminTask command ...")
           result = AdminTask.createDatasource(jdbcProvId,stringFinalParams )

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


## Example 13 create DataSource Using Template At Scope ##
def createDataSourceUsingTemplateAtScope( scope, JDBCName, templateID, datasourceName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createDataSourceUsingTemplateAtScope("+`scope`+", "+`JDBCName`+", "+`templateID`+", "+`datasourceName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create DataSource Using Template At Scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJDBC:                  createDataSourceUsingTemplateAtScope"
        print " Scope:"
        print "    scope                    "+scope
        print " JDBC provider:"       
        print "    name                     "+JDBCName
        print " DataSource:"
        print "    templateID               "+templateID
        print "    name                     "+datasourceName
        print " Optional attributes:"
        print "   otherAttributesList:     %s" % otherAttrsList  
        print "     authDataAlias"
        print "     authMechanismPreference"
        print "     category"
        print "     connectionPool"
        print "     datasourceHelperClassname"
        print "     description"
        print "     diagnoseConnectionUsage"
        print "     jndiName"
        print "     logMissingTransactionContext"
        print "     manageCachedHandles"
        print "     mapping"
        print "     preTestConfig"
        print "     properties"
        print "     provider (config ID)"
        print "     providerType"
        print "     relationalResourceAdapter"
        print "     statementCacheSize"
        print "     xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJDBC.createDataSourceUsingTemplateAtScope(\""+scope+"\", \""+JDBCName+"\", \""+templateID+"\", \""+datasourceName+"\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJDBC.createDataSourceUsingTemplateAtScope(\""+scope+"\", \""+JDBCName+"\", \""+templateID+"\", \""+datasourceName+"\", %s )"  %(otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJDBC.createDataSourceUsingTemplateAtScope(\""+scope+"\", \""+JDBCName+"\", \""+templateID+"\", \""+datasourceName+"\", \""+str(otherAttrsList)+"\")" 
        print " Return: The configuration ID of the created data source in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JDBCName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JDBCName", JDBCName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(datasourceName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["datasourceName", datasourceName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
            
        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope) 
        
        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExists = AdminConfig.getid(scopeFormatted)
        if (len(scopeExists) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jdbcExist = AdminConfig.getid(scopeFormatted+"JDBCProvider:"+JDBCName+"/")
        if (len(jdbcExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JDBCName", JDBCName]))

        # construct required attributes
        requiredAttrs = [["name", datasourceName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList) 
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JDBCProvider:"+JDBCName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JDBCProvider="+JDBCName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            dsExist = AdminConfig.getid(scopeFormatted+"JDBCProvider:"+JDBCName+"/DataSource:"+datasourceName+"/")
            if (len(dsExist) == 0):
                result = AdminConfig.createUsingTemplate("DataSource", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [datasourceName]))
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

