
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
# @(#) 1.18 SERV1/ws/code/admin.scripting/src/scriptLibraries/resources/JMS/V61/AdminJMS.py, WAS.admin.scripting, WAS855.SERV1, cf131750.07 12/15/11 14:22:13 [12/17/17 20:37:10]

#---------------------------------------------------------------------------------------
# AdminJMS.py - Jython procedures for performing JMSProvider, JMS resources tasks.
#---------------------------------------------------------------------------------------
#
#   This script includes the following procedures:
#       Ex1:    createJMSProvider
#       Ex2:    createJMSProviderUsingTemplate
#       Ex3:    createGenericJMSConnectionFactory
#       Ex4:    createGenericJMSConnectionFactoryUsingTemplate
#       Ex5:    createGenericJMSDestination
#       Ex6:    createGenericJMSDestinationUsingTemplate
#       Ex7:    createWASQueue
#       Ex8:    createWASQueueUsingTemplate
#       Ex9:    createWASQueueConnectionFactory
#       Ex10:   createWASQueueConnectionFactoryUsingTemplate
#       Ex11:   createWASTopic
#       Ex12:   createWASTopicUsingTemplate
#       Ex13:   createWASTopicConnectionFactory
#       Ex14:   createWASTopicConnectionFactoryUsingTemplate
#       Ex15:   listJMSProviderTemplates
#       Ex16:   listGenericJMSConnectionFactoryTemplates
#       Ex17:   listGenericJMSDestinationTemplates
#       Ex18:   listWASQueueTemplates
#       Ex19:   listWASQueueConnectionFactoryTemplates
#       Ex20:   listWASTopicTemplates
#       Ex21:   listWASTopicConnectionFactoryTemplates
#       Ex22:   listJMSProviders
#       Ex23:   listJMSConnectionFactories
#       Ex24:   listJMSDestinations
#       Ex25:   listWASQueues
#       Ex26:   listWASQueueConnectionFactories
#       Ex27:   listWASTopics
#       Ex28:   listWASTopicConnectionFactories
#       Ex29:   listGenericJMSConnectionFactories
#       Ex30:   listGenericJMSDestinations
#       Ex31:   startListenerPorts
#       Ex32:   help
#       Ex33:   createJMSProviderAtScope
#       Ex34:   createJMSProviderUsingTemplateAtScope
#       Ex35:   createGenericJMSConnectionFactoryAtScope
#       Ex36:   createGenericJMSConnectionFactoryUsingTemplateAtScope
#       Ex37:   createGenericJMSDestinationAtScope
#       Ex38:   createGenericJMSDestinationUsingTemplateAtScope
#       Ex39:   createWASQueueAtScope
#       Ex40:   createWASQueueUsingTemplateAtScope
#       Ex41:   createWASQueueConnectionFactoryAtScope
#       Ex42:   createWASQueueConnectionFactoryUsingTemplateAtScope
#       Ex43:   createWASTopicAtScope
#       Ex44:   createWASTopicUsingTemplateAtScope
#       Ex45:   createWASTopicConnectionFactoryAtScope
#       Ex46:   createWASTopicConnectionFactoryUsingTemplateAtScope
#       Ex47:   createSIBJMSConnectionFactory
#       Ex48:   createWMQConnectionFactory
#       Ex49:   createSIBJMSQueueConnectionFactory
#       Ex50:   createWMQQueueConnectionFactory
#       Ex51:   createSIBJMSTopicConnectionFactory
#       Ex52:   createWMQTopicConnectionFactory
#       Ex53:   createSIBJMSQueue
#       Ex54:   createWMQQueue
#       Ex55:   createSIBJMSTopic
#       Ex56:   createWMQTopic
#       Ex57:   createSIBJMSActivationSpec
#       Ex58:   createWMQActivationSpec
#
#---------------------------------------------------------------------

import sys
import AdminUtilities

#AdminUtilities.debugNotice("Loading AdminJMS.py name="+__name__)

# Global variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)


## Example 1 create JMSProvider ##
def createJMSProvider( nodeName, serverName, JMSProviderName, extInitContextFactory, extProviderURL, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJMSProvider("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`extInitContextFactory`+", "+`extProviderURL`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JMSProvider
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                               Creating JMSProvider"
        print " Scope:"
        print "     node                                "+nodeName
        print "     server                              "+serverName
        print "     JMSProviderName                     "+JMSProviderName
        print "     externalInitialContextFactory       "+extInitContextFactory
        print "     externalProviderURL                 "+extProviderURL
        print " Optional attributes:" 
        print "    otherAttributesList:               %s" % otherAttrsList
        print "     classpath "
        print "     description "
        print "     isolatedClassLoader "
        print "     nativepath "
        print "     propertySet "
        print "     providerType "
        print "     supportsASF "
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createJMSProvider(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createJMSProvider(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createJMSProvider(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) provider in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(extInitContextFactory) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extInitContextFactory", extInitContextFactory]))

        if (len(extProviderURL) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extProviderURL", extProviderURL]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # construct required attributes
        requiredAttrs = [["name", JMSProviderName], ["externalInitialContextFactory", extInitContextFactory], ["externalProviderURL", extProviderURL]]
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
           jms = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
           if (len(jms) == 0):
                result = AdminConfig.create("JMSProvider", parentID, finalAttrs)
           else:
                # WASL6046E=WASL6046E: [0] already exist
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSProviderName]))

        #Save the config depending on the AutoSave variable
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


## Example 2 create JMSProvider using template ##
def createJMSProviderUsingTemplate( nodeName, serverName, templateID, JMSProviderName, extInitContextFactory, extProviderURL, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJMSProviderUsingTemplate("+`nodeName`+", "+`serverName`+", "+`templateID`+", "+`JMSProviderName`+", "+`extInitContextFactory`+", "+`extProviderURL`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JMSProvider using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                           Creating JMSProvider"
        print " Scope:"
        print "    node                             "+nodeName
        print "    server                           "+serverName
        print " JMS provider:"
        print "    templateConfigID                 "+templateID
        print "    name                             "+JMSProviderName
        print "    externalInitialContextFactory    "+extInitContextFactory
        print "    externalProviderURL              "+extProviderURL
        print " Optional attributes:"
        print "    otherAttributesList:           %s" % otherAttrsList
        print "       classpath "
        print "       description "
        print "       isolatedClassLoader "
        print "       nativepath "
        print "       propertySet "
        print "       providerType "
        print "       supportsASF "
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createJMSProviderUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+templateID+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\")"
        else:        
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createJMSProviderUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+templateID+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createJMSProviderUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+templateID+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) provider using a template in the respective cell"
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

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(extInitContextFactory) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extInitContextFactory", extInitContextFactory]))

        if (len(extProviderURL) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extProviderURL", extProviderURL]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # construct required attributes
        requiredAttrs = [["name", JMSProviderName], ["externalInitialContextFactory", extInitContextFactory], ["externalProviderURL", extProviderURL]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jms = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
            if (len(jms) == 0):
                result = AdminConfig.createUsingTemplate("JMSProvider", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSProviderName]))

        #Save the config depending on the AutoSave variable
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


## Example 3 create GenericJMSConnectionFactory ##
def createGenericJMSConnectionFactory( nodeName, serverName, JMSProviderName, JMSCFName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSConnectionFactory("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`JMSCFName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create GenericJMSConnectionFactory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating GenericJMSConnectionFactory"
        print " Scope:"
        print "    node                         "+nodeName
        print "    server                       "+serverName
        print "    JMSProviderName              "+JMSProviderName
        print " GenericJMSConnectionFactory:"
        print "    name                         "+JMSCFName
        print "    jndiName                     "+jndiName
        print "    externalJNDIName             "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      sessionPool"
        print "      type"
        print "      xaRecoveryAuthAlias" 
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(JMSCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSCFName", JMSCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSCFName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmscf = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/GenericJMSConnectionFactory:"+JMSCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.create("GenericJMSConnectionFactory", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 4 create GenericJMSConnectionFactoryUsingTemplate ##
def createGenericJMSConnectionFactoryUsingTemplate( nodeName, serverName, JMSProviderName, templateID, JMSCFName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSConnectionFactoryUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`templateID`+", "+`JMSCFName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create GenericJMSConnectionFactory using template
        #--------------------------------------------------------------------
        print "----------------------------------------------------------------------------------"
        print " AdminJMS:                       Creating JMSConnectionFactory using template"
        print " Scope:"
        print "    node                         "+nodeName
        print "    server                       "+serverName
        print "    JMSProviderName              "+JMSProviderName
        print " GenericJMSConnectionFactory:"
        print "    templateConfigID             "+templateID
        print "    name                         "+JMSCFName
        print "    jndiName                     "+jndiName
        print "    externalJNDIName             "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      sessionPool"
        print "      type"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) connection factory using a template in the respective cell"
        print "----------------------------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JMSCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSCFName", JMSCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSCFName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmscf = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/GenericJMSConnectionFactory:"+JMSCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.createUsingTemplate("GenericJMSConnectionFactory", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 5 create GenericJMSDestination ##
def createGenericJMSDestination( nodeName, serverName, JMSProviderName, JMSDestName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSDestination("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`JMSDestName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create GenericJMSDestination
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating GenericJMSDestination"
        print " Scope:"
        print "    node                         "+nodeName
        print "    server                       "+serverName 
        print "    JMSProviderName              "+JMSProviderName
        print " GenericJMSDestination:"
        print "    name                         "+JMSDestName
        print "    jndiName                     "+jndiName
        print "    externalJNDIName             "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      propertySet"
        print "      providerType"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSDestination(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSDestination(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSDestination(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\")"                       
        print " Return: The configuration ID of the created Java Message Service (JMS) destination in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(JMSDestName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSDestName", JMSDestName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSDestName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmsd = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/GenericJMSDestination:"+JMSDestName+"/")
            if (len(jmsd) == 0):
                result = AdminConfig.create("GenericJMSDestination", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSDestName]))

        #Save the config depending on the AutoSave variable
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


## Example 6 create JMSDestinationUsingTemplate ##
def createGenericJMSDestinationUsingTemplate( nodeName, serverName, JMSProviderName, templateID, JMSDestName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSDestinationUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`templateID`+", "+`JMSDestName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create GenericJMSDestination using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating GenericJMSDestination using template"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProviderName          "+JMSProviderName
        print " GenericJMSDestination:"
        print "    templateConfigID         "+templateID
        print "    name                     "+JMSDestName
        print "    jndiName                 "+jndiName
        print "    externalJNDIName         "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      propertySet"
        print "      providerType"
        print "      type"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSDestinationUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSDestinationUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSDestinationUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) destination in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JMSDestName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSDestName", JMSDestName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSDestName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList) 
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)
       
        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmsd = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/GenericJMSDestination:"+JMSDestName+"/")
            if (len(jmsd) == 0):
                result = AdminConfig.createUsingTemplate("GenericJMSDestination", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSDestName]))

        #Save the config depending on the AutoSave variable
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


## Example 7 create WASQueue ##
def createWASQueue( nodeName, serverName, JMSProviderName, WASQueueName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueue("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`WASQueueName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueue
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASQueue"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProviderName          "+JMSProviderName
        print " WASQueue:"
        print "    name                     "+WASQueueName
        print "    jndiName                 "+jndiName
        print " Optional attributes:"        
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      node"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueue(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASQueueName+"\", \""+jndiName+"\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueue(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASQueueName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueue(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASQueueName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere queue in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "
       
        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASQueueName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueName", WASQueueName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            jmsq = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASQueue:"+WASQueueName+"/")
            if (len(jmsq) == 0):
                result = AdminConfig.create("WASQueue", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueName]))

        #Save the config depending on the AutoSave variable
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


## Example 8 create WASQueueUsingTemplate ##
def createWASQueueUsingTemplate( nodeName, serverName, JMSProviderName, templateID, WASQueueName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASQueueName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueue using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASQueue using template"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProviderName          "+JMSProviderName
        print " WASQueue:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASQueueName
        print "    jndiName                 "+jndiName
        print " "
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      node"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority" 
        print "  "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueName+"\", \""+jndiName+"\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere queue using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASQueueName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueName", WASQueueName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList) 
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmsq = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASQueue:"+WASQueueName+"/")
            if (len(jmsq) == 0):
                result = AdminConfig.createUsingTemplate("WASQueue", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueName]))

        #Save the config depending on the AutoSave variable
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


## Example 9 create WASQueueConnectionFactory ##
def createWASQueueConnectionFactory( nodeName, serverName, JMSProviderName, WASQueueCFName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueConnectionFactory("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`WASQueueCFName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueueConnectionFactory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating WASQueueConnectionFactory"
        print " Scope:"
        print "    node                         "+nodeName
        print "    server                       "+serverName
        print "    JMSProviderName              "+JMSProviderName
        print " WASQueueConnectionFactory:"
        print "    name                         "+WASQueueCFName
        print "    jndiName                     "+jndiName
        print " "
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCacheHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASQueueCFName+"\", \""+jndiName+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere queue connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASQueueCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueCFName", WASQueueCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueCFName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmscf = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASQueueConnectionFactory:"+WASQueueCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.create("WASQueueConnectionFactory", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 10 create WASQueueConnectionFactoryUsingTemplate ##
def createWASQueueConnectionFactoryUsingTemplate( nodeName, serverName, JMSProviderName, templateID, WASQueueCFName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueConnectionFactoryUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASQueueCFName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueueConnectionFactory using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASQueueConnectionFactory using template"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProvider              "+JMSProviderName
        print " WASQueueConnectionFactory:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASQueueCFName
        print "    jndiName                 "+jndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCacheHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueCFName+"\", \""+jndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere queue connection factory using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASQueueCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueCFName", WASQueueCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueCFName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmscf = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASQueueConnectionFactory:"+WASQueueCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.createUsingTemplate("WASQueueConnectionFactory", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 11 create WASTopic ##
def createWASTopic( nodeName, serverName, JMSProviderName, WASTopicName, jndiName, topic, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopic("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`WASTopicName`+", "+`jndiName`+", "+`topic`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopic
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASTopic"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProvider              "+JMSProviderName
        print " WASTopic:"
        print "    name                     "+WASTopicName
        print "    jndiName                 "+jndiName
        print "    topic                    "+topic
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopic(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopic(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopic(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASTopicName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicName", WASTopicName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(topic) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["topic", topic]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicName], ["jndiName", jndiName], ["topic", topic]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)    
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmst = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASTopic:"+WASTopicName+"/")
            if (len(jmst) == 0):
                result = AdminConfig.create("WASTopic", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicName]))

        #Save the config depending on the AutoSave variable
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


## Example 12 create WASTopicUsingTemplate ##
def createWASTopicUsingTemplate( nodeName, serverName, JMSProviderName, templateID, WASTopicName, jndiName, topic, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASTopicName`+", "+`jndiName`+", "+`topic`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopic using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASTopic using template"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProvider              "+JMSProviderName
        print " WASTopic:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASTopicName
        print "    jndiName                 "+jndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASTopicName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicName", WASTopicName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicName], ["jndiName", jndiName], ["topic", topic]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)  
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmst = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASTopic:"+WASTopicName+"/")
            if (len(jmst) == 0):
                result = AdminConfig.createUsingTemplate("WASTopic", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicName]))

        #Save the config depending on the AutoSave variable
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


## Example 13 create WASTopicConnectionFactory ##
def createWASTopicConnectionFactory( nodeName, serverName, JMSProviderName, WASTopicCFName, jndiName, port, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicConnectionFactory("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`WASTopicCFName`+", "+`jndiName`+", "+`port`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopicConnectionFactory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating WASTopicConnectionFactory"
        print " Scope:"
        print "    node                         "+nodeName
        print "    server                       "+serverName
        print "    JMSProvider                  "+JMSProviderName
        print " WASTopicConnectionFactory:"
        print "    name                         "+WASTopicCFName
        print "    jndiName                     "+jndiName
        print "    port (DIRECT, QUEUED)        "+port
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      clientID"
        print "      cloneSupport"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicConnectionFactory(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
            
        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASTopicCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicCFName", WASTopicCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicCFName], ["jndiName", jndiName], ["port", port]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmstcf = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASTopicConnectionFactory:"+WASTopicCFName+"/")
            if (len(jmstcf) == 0):
                result = AdminConfig.create("WASTopicConnectionFactory", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicCFName]))

        #Save the config depending on the AutoSave variable
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
  

## Example 14 create WASTopicConnectionFactoryUsingTemplate ##
def createWASTopicConnectionFactoryUsingTemplate( nodeName, serverName, JMSProviderName, templateID, WASTopicCFName, jndiName, port, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicConnectionFactoryUsingTemplate("+`nodeName`+", "+`serverName`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASTopicCFName`+", "+`jndiName`+", "+`port`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopicConnectionFactory using template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASTopicConnectionFactory using template"
        print " Scope:"
        print "    node                     "+nodeName
        print "    server                   "+serverName
        print "    JMSProvider              "+JMSProviderName
        print " WASTopicConnectionFactory:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASTopicCFName
        print "    jndiName                 "+jndiName
        print "    port (DIRECT, QUEUED)    "+port
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      clientID"
        print "      cloneSupport"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicConnectionFactoryUsingTemplate(\""+nodeName+"\", \""+serverName+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASTopicCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicCFName", WASTopicCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        jmsExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicCFName], ["jndiName", jndiName], ["port", port]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["Node="+nodeName+":Server="+serverName+":JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmstcf = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/JMSProvider:"+JMSProviderName+"/WASTopicConnectionFactory:"+WASTopicCFName+"/")
            if (len(jmstcf) == 0):
                result = AdminConfig.createUsingTemplate("WASTopicConnectionFactory", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 15 list JMSProvider templates##
def listJMSProviderTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJDBCProviderTemplates("+`templateName`+", "+`failonerror`+"): "


    try:
        #--------------------------------------------------------------------
        # list JMSProvider templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list JMSProvider templates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listJMSProviderTemplates()"
        else:
            print " Usage: AdminJMS.listJMSProviderTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the Java Message Service (JMS) provider template for the specified template name parameter or list all of the available configuration IDs for the JMS provider template if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("JMSProvider")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("JMSProvider", templateName)
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


## Example 16 list GenericJMSConnectionFactory templates ##
def listGenericJMSConnectionFactoryTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listGenericJMSConnectionFactoryTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list GenericJMSConnectionFactory templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list GenericJMSConnectionFactory templates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listGenericJMSConnectionFactoryTemplates()"
        else:
            print " Usage: AdminJMS.listGenericJMSConnectionFactoryTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the generic Java Message Service (JMS) connection factory template for the specified template name parameter or list all of the available configuration IDs for the generic Java Message Servicce (JMS) connection factory template if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("GenericJMSConnectionFactory")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("GenericJMSConnectionFactory", templateName)
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


## Example 17 list GenericJMSDestination templates ##
def listGenericJMSDestinationTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listGenericJMSDestinationTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list JMSDestination templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list GenericJMSDestination templates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listGenericJMSDestinationTemplates()"
        else:
            print " Usage: AdminJMS.listGenericJMSDestinationTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the generic Java Message Service (JMS) destination template for the specified template name parameter or list all of the available configuration IDs for the generic JMS destination template if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("GenericJMSDestination")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("GenericJMSDestination", templateName)
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


## Example 18 list WASQueue templates ##
def listWASQueueTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASQueueTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list WASQueue templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list WASQueue templates"
        print " Optinal parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listWASQueueTemplates()"
        else:
            print " Usage: AdminJMS.listWASQueueTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the generic WebSphere queue template for the specified template name parameter or list all of the available generic IDs for the WebSphere queue template if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("WASQueue")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("WASQueue", templateName)
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


## Example 19 list WASQueueConnectionFactory templates ##
def listWASQueueConnectionFactoryTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASQueueConnectionFactoryTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list WASQueueConnectionFactory templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list WASQueueConnectionFactory templates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listWASQueueConnectionFactoryTemplates()"
        else:
            print " Usage: AdminJMS.listWASQueueConnectionFactoryTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the WebSphere queue connection factory template for a specified template name parameter or list all of the available configuration IDs for the WebSphere queue connection factory template if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("WASQueueConnectionFactory")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("WASQueueConnectionFactory", templateName)
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


## Example 20 list WASTopic templates ##
def listWASTopicTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASTopicTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list WASTopic templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list WASTopic templates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listWASTopicTemplates()"
        else:
            print " Usage: AdminJMS.listWASTopicTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the WebSphere topic template for a specified template name parameter or list all of the available configuration IDs for the WebSphere topic template if a template name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("WASTopic")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("WASTopic", templateName)
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


## Example 21 list WASTopicConnectionFactory templates ##
def listWASTopicConnectionFactoryTemplates( templateName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASTopicConnectionFactoryTemplates("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # list WASTopicConnectionFactory templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           list WASTopicConnectionFactory templates"
        print " Optional parameter:"
        print " Template name:      "+templateName
        if (len(templateName) == 0):
            print " Usage: AdminJMS.listWASTopicConnectionFactoryTemplates()"
        else:    
            print " Usage: AdminJMS.listWASTopicConnectionFactoryTemplates(\""+templateName+"\")"
        print " Return: List the configuration IDs for the WebSphere topic connection factory for a specified template name parameter or list all of the available configuration IDs for the WebSphere topic connection factory if a template name parameter is not specified in a given cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        newList = []
        templates = AdminUtilities._BLANK_
        if (templateName == AdminUtilities._BLANK_):
            templates = AdminConfig.listTemplates("WASTopicConnectionFactory")
            newList = AdminUtilities.convertToList(templates)
        else:
            templates = AdminConfig.listTemplates("WASTopicConnectionFactory", templateName)
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


## Example 22 list JMSProviders ##
def listJMSProviders( JMSProviderName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJMSProviders("+`JMSProviderName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List JMSProviders
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                listJMSProviders"
        print " Optional parameter:"
        print " JMS provider name:       "+JMSProviderName
        if (len(JMSProviderName) == 0):
            print " Usage: AdminJMS.listJMSProviders()"
        else:    
            print " Usage: AdminJMS.listJMSProviders(\""+JMSProviderName+"\")"
        print " Return: List the configuration IDs for the Java Message Service (JMS) provider for a specified JMS provider name parameter or list all of the available configuration IDs for the JMS provider if a template name paramter is not specified in the respective cell" 
        print "---------------------------------------------------------------"
        print " "

        jmss = AdminUtilities._BLANK_
        if (JMSProviderName == AdminUtilities._BLANK_):
            jmss = AdminConfig.list("JMSProvider")
        else:
            jmss = AdminConfig.getid("/JMSProvider:"+JMSProviderName+"/")
        #print jmss
        jmsList = AdminUtilities.convertToList(jmss)
        return jmsList
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


## Example 23 list GenericJMSConnectionFactories ##
def listGenericJMSConnectionFactories( JMSCFName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listGenericJMSConnectionFactories("+`JMSCFName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List GenericJMSConnectionFactories
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                               listGenericJMSConnectionFactories"
        print " Optional parameter:"
        print " GenericJMSConnectionFactory name:       "+JMSCFName
        if (len(JMSCFName) == 0):
            print " Usage: AdminJMS.listGenericJMSConnectionFactories()"
        else:    
            print " Usage: AdminJMS.listGenericJMSConnectionFactories(\""+JMSCFName+"\")"
        print " Return: List the configuration IDs for the generic Java Message Service (JMS) connection factory for a specified JMSConnection Factory parameter name or list all of the available configuration IDs for the generic JMS connection factory if a JMSConnection Factory parameter name is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        jmscfs = AdminUtilities._BLANK_
        if (JMSCFName == AdminUtilities._BLANK_):
            jmscfs = AdminConfig.list("GenericJMSConnectionFactory")
        else:
            jmscfs = AdminConfig.getid("/GenericJMSConnectionFactory:"+JMSCFName+"/")
        #print jmscfs
        jmscfList = AdminUtilities.convertToList(jmscfs)
        return jmscfList
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


## Example 24 list GenericJMSDestinations ##
def listGenericJMSDestinations( JMSDestName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listGenericJMSDestinations("+`JMSDestName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List GenericJMSDestinations
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       listGenericJMSDestinations"
        print " Optional parameter:"
        print " GenericJMSDestination name:     "+JMSDestName
        if (len(JMSDestName) == 0):
            print " Usage: AdminJMS.listGenericJMSDestinations()"
        else:    
            print " Usage: AdminJMS.listGenericJMSDestinations(\""+JMSDestName+"\")"
        print " Return: List the configuration IDS for the generic Java Message Service (JMS) destination for a specified JMSDestination name parameter or list all of the available configuration IDs for a generic JMS destination if a Generic JMSDestination name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        jmsds = AdminUtilities._BLANK_
        if (JMSDestName == AdminUtilities._BLANK_):
            jmsds = AdminConfig.list("GenericJMSDestination")
        else:
            jmsds = AdminConfig.getid("/GenericJMSDestination:"+JMSDestName+"/")
        #print jmsds
        jmsdList = AdminUtilities.convertToList(jmsds)
        return jmsdList
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
  

## Example 25 list WASQueues ##
def listWASQueues( WASQueueName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASQueues("+`WASQueueName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List WASQueues
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                 listWASQueues"
        print " Optional parameter:"
        print " WASQueue name:            "+WASQueueName
        if (len(WASQueueName) == 0):
            print " Usage: AdminJMS.listWASQueues()"
        else:
            print " Usage: AdminJMS.listWASQueues(\""+WASQueueName+"\")"
        print " Return: List the WebSphere queue configuration IDs for a specified WebSphere Queue name parameter or list all of the available WebSphere queue configuration IDs if a WebSpphere Queue name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        wasqueues = AdminUtilities._BLANK_
        if (WASQueueName == AdminUtilities._BLANK_):
            wasqueues = AdminConfig.list("WASQueue")
        else:
            wasqueues = AdminConfig.getid("/WASQueue:"+WASQueueName+"/")
        #print wasqueues
        wasqueueList = AdminUtilities.convertToList(wasqueues)
        return wasqueueList
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
  
 
## Example 26 list WASQueueConnectionFactories ##
def listWASQueueConnectionFactories( WASQueueCFName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASQueueConnectionFactories("+`WASQueueCFName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List WASQueueConnectionFactories
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                               listWASQueueConnectionFactories"
        print " Optional parameter:"
        print " WASQueueConnectionFactory name:         "+WASQueueCFName
        if (len(WASQueueCFName) == 0):
            print " Usage: AdminJMS.listWASQueueConnectionFactories()"
        else:    
            print " Usage: AdminJMS.listWASQueueConnectionFactories(\""+WASQueueCFName+"\")"
        print " Return: List the configuration IDs for the WebSphere queue connection factory for a specified Connection Factory parameter name or list all of the available configuration IDs for the WebSphere queue connection factory if a connection factory parameter name is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        wasqueuecfs = AdminUtilities._BLANK_
        if (WASQueueCFName == AdminUtilities._BLANK_):
            wasqueuecfs = AdminConfig.list("WASQueueConnectionFactory")
        else:
            wasqueuecfs = AdminConfig.getid("/WASQueueConnectionFactory:"+WASQueueCFName+"/")
        #print wasqueuecfs
        wasqueuecfList = AdminUtilities.convertToList(wasqueuecfs)
        return wasqueuecfList
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
  
  
## Example 27 list WASTopics ##
def listWASTopics( WASTopicName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASTopics("+`WASTopicName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List WASTopics
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                 listWASTopics"
        print " Optional parameter:"
        print " WASTopic name:            "+WASTopicName
        if (len(WASTopicName) == 0):
            print " Usage: AdminJMS.listWASTopics()"
        else:
            print " Usage: AdminJMS.listWASTopics(\""+WASTopicName+"\")"
        print " Return: List the configuration IDs for the WebSphere topic for a specified Topic parameter name, or all available WAS Topic Config IDs if no Topic parameter name is given in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        wastopics = AdminUtilities._BLANK_
        if (WASTopicName == AdminUtilities._BLANK_):
            wastopics = AdminConfig.list("WASTopic")
        else:
            wastopics = AdminConfig.getid("/WASTopic:"+WASTopicName+"/")
        #print wastopics
        wastopicList = AdminUtilities.convertToList(wastopics)
        return wastopicList
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


## Example 28 list WASTopicConnectionFactories ##
def listWASTopicConnectionFactories( WASTopicCFName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listWASTopicConnectionFactories("+`WASTopicCFName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List JMSProviders
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                               listWASTopicConnectionFactories"
        print " Optional parameter:"
        print " WASTopicConnectionFactory name:         "+WASTopicCFName
        if (len(WASTopicCFName) == 0):
            print " Usage: AdminJMS.listWASTopicConnectionFactories()"
        else:
            print " Usage: AdminJMS.listWASTopicConnectionFactories(\""+WASTopicCFName+"\")"
        print " Return: List the configuration IDs for the WebSphere topic connection factory for a specified Topic Connection Factory parameter name or list all of the available configuration IDs for the WebSphere topic connection factory if a Topic Connection Factory parameter name is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        wastopiccfs = AdminUtilities._BLANK_
        if (WASTopicCFName == AdminUtilities._BLANK_):
            wastopiccfs = AdminConfig.list("WASTopicConnectionFactory")
        else:
            wastopiccfs = AdminConfig.getid("/WASTopicConnectionFactory:"+WASTopicCFName+"/")
        #print wastopiccfs
        wastopiccfList = AdminUtilities.convertToList(wastopiccfs)
        return wastopiccfList
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


## Example 29 list JMSConnectionFactories ##
def listJMSConnectionFactories( jmscfName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJMSConnectionFactories("+`jmscfName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List JMSConnectionFactories
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       listJMSConnectionFactories"
        print " Optional parameter:"
        print " JMSConnectionFactory name:      "+jmscfName
        if (len(jmscfName) == 0):
            print " Usage: AdminJMS.listJMSConnectionFactories()"
        else:
            print " Usage: AdminJMS.listJMSConnectionFactories(\""+jmscfName+"\")"
        print " Return: List the configuration IDs for the Java Database Connectivity (JDBC) provider for a specified JDBCProvider name parameter or list all of the available configuration IDs for the JDBC provider if a JDBCProvider name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        jmscfs = AdminUtilities._BLANK_
        if (jmscfName == ""):
            jmscfs = AdminConfig.list("JMSConnectionFactory")
        else:
            jmscfs = AdminConfig.getid("/JMSConnectionFactory:"+jmscfName+"/")
        #print jmscfs
        jmscfList = AdminUtilities.convertToList(jmscfs)
        return jmscfList
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


## Example 30 list JMSDestinations ##
def listJMSDestinations( jmsdestName=AdminUtilities._BLANK_, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJMSDestinations("+`jmsdestName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List JMSDestinations
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                listJMSDestinations"
        print " Optional parameter:"
        print " JMSDestination name:     "+jmsdestName
        if (len(jmsdestName) == 0):
            print " Usage: AdminJMS.listJMSDestinations()"
        else:
            print " Usage: AdminJMS.listJMSDestinations(\""+jmsdestName+"\")"
        print " Return: List the configuration IDs for the Java Message Service (JMS) destination for a specified JMSDestination name parameter or list all of the available configuration IDs for the JMS destination if a JMSDestination name parameter is not specified in the respective cell"
        print "---------------------------------------------------------------"
        print " "

        jmsds = AdminUtilities._BLANK_
        if (jmsdestName == AdminUtilities._BLANK_):
            jmsds = AdminConfig.list("JMSDestination")
        else:
            jmsds = AdminConfig.getid("/JMSDestination:"+jmsdestName+"/")
        #print jmsds
        jmsdList = AdminUtilities.convertToList(jmsds)
        return jmsdList
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


## Example 31 startListenerPorts ##
def startListenerPort( nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "startListenerPort("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # start ListenerPort
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:           startListenerPort"
        print " Scope:"
        print "    nodeName         "+nodeName
        print "    serverName       "+serverName
        print " Usage: AdminJMS.startListenerPort(\""+nodeName+"\", \""+serverName+"\")"
        print " Return: If the command is successful, a value of 1 is returned"
        print "---------------------------------------------------------------"
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        lpMBean = AdminControl.queryNames("type=ListenerPort,process="+serverName+",node="+nodeName+",*")
        if (len(lpMBean) != 0):
            isRunning = AdminControl.getAttribute(lpMBean, "started") 
        if (isRunning == "false"):
            AdminControl.invoke(lpMBean, "start")
        return 1
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


## Example 32 Online help ##
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
        #print " AdminJMS:          Help "
        #print " Script procedure:  "+procedure
        #print " Usage: AdminJMS.help(\""+procedure+"\")"
        #print " Return: Receive help information for the specified AdminJMS library function or provide help information on all of the AdminJMS script library functions if parameters are not passed" 
        #print "---------------------------------------------------------------"        
        #print " "
        #print " "
        bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
        resourceBundle = AdminUtilities.getResourceBundle(bundleName)

        if (len(procedure) == 0):
            message = resourceBundle.getString("ADMINJMS_GENERAL_HELP")
        else:
            procedure = "ADMINJMS_HELP_"+procedure.upper()
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
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef



## New JMS functions to support different scope
##############################################################################################################################################################
##############################################################################################################################################################

## Example 33 create JMSProvider at scope##
def createJMSProviderAtScope( scope, JMSProviderName, extInitContextFactory, extProviderURL, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJMSProviderAtScope("+`scope`+", "+`JMSProviderName`+", "+`extInitContextFactory`+", "+`extProviderURL`+", "+`otherAttrsList`+", "+`failonerror`+"): "
    
    try:
        #--------------------------------------------------------------------
        # create JMSProvider at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                               Creating JMSProvider at scope"
        print " Scope:"
        print "     scope                                "+scope
        print "     JMSProviderName                      "+JMSProviderName
        print "     externalInitialContextFactory        "+extInitContextFactory
        print "     externalProviderURL                  "+extProviderURL
        print " Optional attributes:" 
        print "    otherAttributesList:                %s" % otherAttrsList
        print "      classpath "
        print "      description "
        print "      isolatedClassLoader "
        print "      nativepath "
        print "      propertySet "
        print "      providerType "
        print "      supportsASF "
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createJMSProviderAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createJMSProviderAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createJMSProviderAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) provider in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(extInitContextFactory) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extInitContextFactory", extInitContextFactory]))

        if (len(extProviderURL) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extProviderURL", extProviderURL]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        # construct required attributes
        requiredAttrs = [["name", JMSProviderName], ["externalInitialContextFactory", extInitContextFactory], ["externalProviderURL", extProviderURL]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        parentIDs = AdminConfig.getid(scopeFormatted)
        parentIDList = AdminUtilities.convertToList(parentIDs)
        
        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["scope="+scope]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jms = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
            if (len(jms) == 0):
                result = AdminConfig.create("JMSProvider", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSProviderName]))

        #Save the config depending on the AutoSave variable
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


## Example 34 create JMSProvider using template at scope##
def createJMSProviderUsingTemplateAtScope( scope, templateID, JMSProviderName, extInitContextFactory, extProviderURL, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createJMSProviderUsingTemplateAtScope("+`scope`+", "+`templateID`+", "+`JMSProviderName`+", "+`extInitContextFactory`+", "+`extProviderURL`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JMSProvider using template at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                           Creating JMSProvider using template at scope"
        print " Scope:"
        print "    scope                            "+scope
        print " JMS provider:"
        print "    templateConfigID                 "+templateID
        print "    name                             "+JMSProviderName
        print "    externalInitialContextFactory    "+extInitContextFactory
        print "    externalProviderURL              "+extProviderURL
        print " Optional attributes:"
        print "    otherAttributesList:           %s" % otherAttrsList
        print "      classpath "
        print "      description "
        print "      isolatedClassLoader "
        print "      nativepath "
        print "      propertySet "
        print "      providerType "
        print "      supportsASF "
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createJMSProviderUsingTemplateAtScope(\""+scope+"\", \""+templateID+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createJMSProviderUsingTemplateAtScope(\""+scope+"\", \""+templateID+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createJMSProviderUsingTemplateAtScope(\""+scope+"\", \""+templateID+"\", \""+JMSProviderName+"\", \""+extInitContextFactory+"\", \""+extProviderURL+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) provider using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(extInitContextFactory) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extInitContextFactory", extInitContextFactory]))

        if (len(extProviderURL) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extProviderURL", extProviderURL]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        # construct required attributes
        requiredAttrs = [["name", JMSProviderName], ["externalInitialContextFactory", extInitContextFactory], ["externalProviderURL", extProviderURL]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted)
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["scope="+scope]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jms = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
            if (len(jms) == 0):
                result = AdminConfig.createUsingTemplate("JMSProvider", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSProviderName]))

        #Save the config depending on the AutoSave variable
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


## Example 35 create GenericJMSConnectionFactory at scope ##
def createGenericJMSConnectionFactoryAtScope( scope, JMSProviderName, JMSCFName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSConnectionFactoryAtScope("+`scope`+", "+`JMSProviderName`+", "+`JMSCFName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create GenericJMSConnectionFactory at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating GenericJMSConnectionFactory at scope"
        print " Scope:"
        print "    scope                        "+scope   
        print "    JMSProviderName              "+JMSProviderName
        print " GenericJMSConnectionFactory:"
        print "    name                         "+JMSCFName
        print "    jndiName                     "+jndiName
        print "    externalJNDIName             "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      sessionPool"
        print "      type"
        print "      xaRecoveryAuthAlias" 
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(JMSCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSCFName", JMSCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                
        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)
        
        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSCFName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmscf = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/GenericJMSConnectionFactory:"+JMSCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.create("GenericJMSConnectionFactory", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 36 create GenericJMSConnectionFactoryUsingTemplateAtScope ##
def createGenericJMSConnectionFactoryUsingTemplateAtScope( scope, JMSProviderName, templateID, JMSCFName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSConnectionFactoryUsingTemplateAtScope("+`scope`+", "+`JMSProviderName`+", "+`templateID`+", "+`JMSCFName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JMSConnectionFactory using template at scope
        #--------------------------------------------------------------------
        print "----------------------------------------------------------------------------------"
        print " AdminJMS:                       Creating JMSConnectionFactory using template at scope"
        print " Scope:"
        print "    scope                        "+scope
        print "    JMSProviderName              "+JMSProviderName
        print " GenericJMSConnectionFactory:"
        print "    templateConfigID             "+templateID
        print "    name                         "+JMSCFName
        print "    jndiName                     "+jndiName
        print "    externalJNDIName             "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSCFName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) connection factory using a template in the respective cell"
        print "----------------------------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JMSCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSCFName", JMSCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                
        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)
        
        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSCFName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)    
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmscf = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/GenericJMSConnectionFactory:"+JMSCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.createUsingTemplate("GenericJMSConnectionFactory", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 37 create GenericJMSDestination at scope ##
def createGenericJMSDestinationAtScope( scope, JMSProviderName, JMSDestName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSDestinationAtScope("+`scope`+", "+`JMSProviderName`+", "+`JMSDestName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create JMSDestination at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating GenericJMSDestination at scope"
        print " Scope:"
        print "    scope                        "+scope
        print "    JMSProviderName              "+JMSProviderName
        print " GenericJMSDestination:"
        print "    name                         "+JMSDestName
        print "    jndiName                     "+jndiName
        print "    externalJNDIName             "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      propertySet"
        print "      providerType"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSDestinationAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSDestinationAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSDestinationAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\" )"
        print " Return: The configuration ID of the created Java Message Service (JMS) destination in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(JMSDestName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSDestName", JMSDestName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSDestName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)  
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmsd = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/GenericJMSDestination:"+JMSDestName+"/")
            if (len(jmsd) == 0):
                result = AdminConfig.create("GenericJMSDestination", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSDestName]))

        #Save the config depending on the AutoSave variable
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


## Example 38 create GenericJMSDestinationUsingTemplateAtScope ##
def createGenericJMSDestinationUsingTemplateAtScope( scope, JMSProviderName, templateID, JMSDestName, jndiName, extJndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericJMSDestinationUsingTemplateAtScope("+`scope`+", "+`JMSProviderName`+", "+`templateID`+", "+`JMSDestName`+", "+`jndiName`+", "+`extJndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create GenericJMSDestination using template at scope 
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating GenericJMSDestination using template at scope"
        print " Scope:"
        print "    scope                    "+scope
        print "    JMSProviderName          "+JMSProviderName
        print " GenericJMSDestination:"
        print "    templateConfigID         "+templateID
        print "    name                     "+JMSDestName
        print "    jndiName                 "+jndiName
        print "    externalJNDIName         "+extJndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      propertySet"
        print "      providerType"
        print "      type"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createGenericJMSDestinationUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createGenericJMSDestinationUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createGenericJMSDestinationUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+JMSDestName+"\", \""+jndiName+"\", \""+extJndiName+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created Java Message Service (JMS) destination in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(JMSDestName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSDestName", JMSDestName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(extJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["extJndiName", extJndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", JMSDestName], ["jndiName", jndiName], ["externalJNDIName", extJndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            jmsd = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/GenericJMSDestination:"+JMSDestName+"/")
            if (len(jmsd) == 0):
                result = AdminConfig.createUsingTemplate("GenericJMSDestination", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [JMSDestName]))

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


## Example 39 create WASQueue at scope ##
def createWASQueueAtScope( scope, JMSProviderName, WASQueueName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueAtScope("+`scope`+", "+`JMSProviderName`+", "+`WASQueueName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueue at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASQueue at scope"
        print " Scope:"
        print "    scope                    "+scope
        print "    JMSProviderName          "+JMSProviderName
        print " WASQueue:"
        print "    name                     "+WASQueueName
        print "    jndiName                 "+jndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      node"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASQueueName+"\", \""+jndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASQueueName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASQueueName+"\", \""+jndiName+"\",  \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere queue in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASQueueName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueName", WASQueueName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList) 
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if object already exist
            jmsq = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASQueue:"+WASQueueName+"/")
            if (len(jmsq) == 0):
                result = AdminConfig.create("WASQueue", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueName]))

        #Save the config depending on the AutoSave variable
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


## Example 40 create WASQueueUsingTemplateAtScope ##
def createWASQueueUsingTemplateAtScope( scope, JMSProviderName, templateID, WASQueueName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueUsingTemplateAtScope("+`scope`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASQueueName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueue using template at scope
        #--------------------------------------------------------------------

        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASQueue using template at scope"
        print " Scope:"
        print "    scope                    "+scope
        print "    JMSProviderName          "+JMSProviderName
        print " WASQueue:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASQueueName
        print "    jndiName                 "+jndiName
        print " "        
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      node"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority" 
        print "  "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueName+"\", \""+jndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created WebSphere queue using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASQueueName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueName", WASQueueName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmsq = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASQueue:"+WASQueueName+"/")
            if (len(jmsq) == 0):
                result = AdminConfig.createUsingTemplate("WASQueue", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueName]))

        #Save the config depending on the AutoSave variable
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


## Example 41 create WASQueueConnectionFactoryAtScope ##
def createWASQueueConnectionFactoryAtScope( scope, JMSProviderName, WASQueueCFName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueConnectionFactoryAtScope("+`scope`+", "+`JMSProviderName`+", "+`WASQueueCFName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueueConnectionFactory at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating createWASQueueConnectionFactoryAtScope"
        print " Scope:"
        print "    scope                         "+scope
        print " JMS provider:"
        print "    name                         "+JMSProviderName
        print " WASQueueConnectionFactory:"
        print "    name                         "+WASQueueCFName
        print "    jndiName                     "+jndiName
        print " "
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCacheHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASQueueCFName+"\", \""+jndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created WebSphere queue connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASQueueCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueCFName", WASQueueCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueCFName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)  
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmscf = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASQueueConnectionFactory:"+WASQueueCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.create("WASQueueConnectionFactory", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 42 create WASQueueConnectionFactoryUsingTemplateAtScope ##
def createWASQueueConnectionFactoryUsingTemplateAtScope( scope, JMSProviderName, templateID, WASQueueCFName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASQueueConnectionFactoryUsingTemplateAtScope("+`scope`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASQueueCFName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASQueueConnectionFactory using template at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASQueueConnectionFactory using template at scope"
        print " Scope:"
        print "    scope                    "+scope
        print "    JMSProvider              "+JMSProviderName
        print " WASQueueConnectionFactory:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASQueueCFName
        print "    jndiName                 "+jndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCacheHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASQueueConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueCFName+"\", \""+jndiName+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASQueueConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASQueueConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASQueueCFName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created WebSphere queue connection factory using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASQueueCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASQueueCFName", WASQueueCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)
        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASQueueCFName], ["jndiName", jndiName]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmscf = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASQueueConnectionFactory:"+WASQueueCFName+"/")
            if (len(jmscf) == 0):
                result = AdminConfig.createUsingTemplate("WASQueueConnectionFactory", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASQueueCFName]))

        #Save the config depending on the AutoSave variable
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


## Example 43 create WASTopic at scope ##
def createWASTopicAtScope( scope, JMSProviderName, WASTopicName, jndiName, topic, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicAtScope("+`scope`+", "+`JMSProviderName`+", "+`WASTopicName`+", "+`jndiName`+", "+`topic`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopic
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               Creating WASTopic"
        print " Scope:"
        print "    scope                   "+scope
        print "    JMSProvider             "+JMSProviderName
        print " WASTopic:"
        print "    name                    "+WASTopicName
        print "    jndiName                "+jndiName
        print "    topic                   "+topic
        print " Optional attributes:"
        print "    otherAttributesList:  %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASTopicName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicName", WASTopicName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (len(topic) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["topic", topic]))

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicName], ["jndiName", jndiName], ["topic", topic]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmst = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASTopic:"+WASTopicName+"/")
            if (len(jmst) == 0):
                result = AdminConfig.create("WASTopic", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicName]))

        #Save the config depending on the AutoSave variable
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


## Example 44 create WASTopicUsingTemplate at scope##
def createWASTopicUsingTemplateAtScope( scope, JMSProviderName, templateID, WASTopicName, jndiName, topic, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicUsingTemplateAtScope("+`scope`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASTopicName`+", "+`jndiName`+", "+`topic`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopic using template at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASTopic using template"
        print " Scope:"
        print "    scope                     "+scope
        print "    JMSProvider              "+JMSProviderName
        print " WASTopic:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASTopicName
        print "    jndiName                 "+jndiName
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      category"
        print "      description"
        print "      expiry"
        print "      persistence"
        print "      priority"
        print "      propertySet"
        print "      providerType"
        print "      specifiedExpiry"
        print "      specifiedPriority"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicName+"\", \""+jndiName+"\", \""+topic+"\",  \""+str(otherAttrsList)+"\")"
        print " Return: The configuration ID of the created WebSphere topic using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASTopicName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicName", WASTopicName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicName], ["jndiName", jndiName], ["topic", topic]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmst = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASTopic:"+WASTopicName+"/")
            if (len(jmst) == 0):
                result = AdminConfig.createUsingTemplate("WASTopic", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicName]))

        #Save the config depending on the AutoSave variable
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


## Example 45 create WASTopicConnectionFactory at scope ##
def createWASTopicConnectionFactoryAtScope( scope, JMSProviderName, WASTopicCFName, jndiName, port, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicConnectionFactoryAtScope("+`scope`+", "+`JMSProviderName`+", "+`WASTopicCFName`+", "+`jndiName`+", "+`port`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopicConnectionFactory at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                       Creating WASTopicConnectionFactory at scope"
        print " Scope:"
        print "    scope                        "+scope
        print "    JMSProvider                  "+JMSProviderName
        print " WASTopicConnectionFactory:"
        print "    name                         "+WASTopicCFName
        print "    jndiName                     "+jndiName
        print "    port ((DIRECT, QUEUED)       "+port
        print " Optional attributes:"
        print "    otherAttributesList:       %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      clientID"
        print "      cloneSupport"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\")"
        else:        
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\",  %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicConnectionFactoryAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic connection factory in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(WASTopicCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicCFName", WASTopicCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicCFName], ["jndiName", jndiName], ["port", port]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmstcf = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASTopicConnectionFactory:"+WASTopicCFName+"/")
            if (len(jmstcf) == 0):
                result = AdminConfig.create("WASTopicConnectionFactory", parentID, finalAttrs)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicCFName]))

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val= "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef  


## Example 46 create WASTopicConnectionFactoryUsingTemplateAtScope ##
def createWASTopicConnectionFactoryUsingTemplateAtScope( scope, JMSProviderName, templateID, WASTopicCFName, jndiName, port, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWASTopicConnectionFactoryUsingTemplateAtScope("+`scope`+", "+`JMSProviderName`+", "+`templateID`+", "+`WASTopicCFName`+", "+`jndiName`+", "+`port`+", "+`otherAttrsList`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # create WASTopicConnectionFactory using template at scope
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:                   Creating WASTopicConnectionFactory using template at scope"
        print " Scope:"
        print "    scope                    "+scope
        print "    JMSProvider              "+JMSProviderName
        print " WASTopicConnectionFactory:"
        print "    templateConfigID         "+templateID
        print "    name                     "+WASTopicCFName
        print "    jndiName                 "+jndiName
        print "    port (DIRECT, QUEUED)    "+port
        print " Optional attributes:"
        print "    otherAttributesList:   %s" % otherAttrsList
        print "      XAEnabled"
        print "      authDataAlias"
        print "      authMechanismPreference"
        print "      category"
        print "      clientID"
        print "      cloneSupport"
        print "      connectionPool"
        print "      description"
        print "      diagnoseConnectionUsage"
        print "      logMissingTransactionContext"
        print "      manageCachedHandles"
        print "      mapping"
        print "      node"
        print "      preTestConfig"
        print "      properties"
        print "      propertySet"
        print "      providerType"
        print "      serverName"
        print "      sessionPool"
        print "      xaRecoveryAuthAlias"
        print " "
        if (otherAttrsList==[]):
            print " Usage: AdminJMS.createWASTopicConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\")"
        else:
            if(str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWASTopicConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", %s)"  %(otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWASTopicConnectionFactoryUsingTemplateAtScope(\""+scope+"\", \""+JMSProviderName+"\", \""+templateID+"\", \""+WASTopicCFName+"\", \""+jndiName+"\", \""+port+"\", \""+str(otherAttrsList)+ "\")"
        print " Return: The configuration ID of the created WebSphere topic using a template in the respective cell"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

        if (len(JMSProviderName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JMSProviderName", JMSProviderName]))

        if (len(templateID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateID", templateID]))

        if (len(WASTopicCFName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["WASTopicCFName", WASTopicCFName]))

        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        if (scope.find(".xml") >0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        scopeFormatted=AdminUtilities.getScopeContainmentPath(scope)

        # checking if the parameter value exist
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        scopeExist = AdminConfig.getid(scopeFormatted)
        if (len(scopeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        jmsExist = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        if (len(jmsExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["JMSProviderName", JMSProviderName]))

        # construct required attributes
        requiredAttrs = [["name", WASTopicCFName], ["jndiName", jndiName], ["port", port]]
        otherAttrsList=AdminUtilities.convertParamStringToList(otherAttrsList)   
        finalAttrs = requiredAttrs+otherAttrsList

        # get parent configID
        parentIDs = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/")
        parentIDList = AdminUtilities.convertToList(parentIDs)

        # check if there is more then one exist
        # WASL6045E=WASL6045E: Multiple [0] found on your configuration.
        result = AdminUtilities._BLANK_
        if (len(parentIDList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["JMSProvider="+JMSProviderName]))
        if (len(parentIDList) == 1):
            parentID = parentIDList[0]
            # check if the object already exist
            jmstcf = AdminConfig.getid(scopeFormatted+"JMSProvider:"+JMSProviderName+"/WASTopicConnectionFactory:"+WASTopicCFName+"/")
            if (len(jmstcf) == 0):
                result = AdminConfig.createUsingTemplate("WASTopicConnectionFactory", parentID, finalAttrs, templateID)
            else:
                # WASL6046E=WASL6046E: [0] already exist. 
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [WASTopicCFName]))

        #Save the config depending on the AutoSave variable
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


## New JMS functions
###############################################################################################################################################################
###############################################################################################################################################################
# Example 47 Create a generic SIBJMSConnection factory
def createSIBJMSConnectionFactory(scope, name, jndiName , busName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createSIBJMSConnectionFactory(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `busName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a SIB JMS Connection factory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createSIBJMSConnectionFactory "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " JMSConnectionFactory:       "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Bus:   "
        print "     busName:                "+busName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     authDataAlias                        "
        print "     containerAuthAlias                   "
        print "     mappingAlias                         "
        print "     xaRecoveryAuthAlias                  "
        print "     category                             "
        print "     description                          "
        print "     logMissingTransactionContext         "
        print "     manageCachedHandles                  "
        print "     clientID                             "
        print "     userName                             "
        print "     password                             "
        print "     nonPersistentMapping                 "
        print "     persistentMapping                    "
        print "     durableSubscriptionHome              "
        print "     readAhead                            "
        print "     target                               "
        print "     targetType                           "
        print "     targetSignificance                   "
        print "     targetTransportChain                 "
        print "     providerEndPoints                    "
        print "     connectionProximity                  "
        print "     tempQueueNamePrefix                  "
        print "     tempTopicNamePrefix                  "
        print "     shareDataSourceWithCMP               "
        print "     shareDurableSubscriptions            "
        print "     consumerDoesNotModifyPayloadAfterGet "
        print "     producerDoesNotModifyPayloadAfterSet "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createSIBJMSConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\")"
        else:  
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createSIBJMSConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\", %s)" % (otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createSIBJMSConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new SIB JMS Connection Factory"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(busName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["busName", busName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #no need to set the type parameter here - the AdminTask command asks to leave the parameter unset to
        #create a generic connection factory

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["busName", busName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createSIBJMSConnectionFactory(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 48 Create a WMQ factory - type is 'CF'
def createWMQConnectionFactory(scope,name ,jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWMQConnectionFactory(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `otherAttrsList` + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a WMQ Connection Factory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createWMQConnectionFactory "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " MQConnectionFactory:        "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList 
        print "     maxBatchSize            "
        print "     brokerCCSubQueue        "
        print "     brokerCtrlQueue         "
        print "     brokerQmgr              "
        print "     brokerSubQueue          "
        print "     brokerVersion           "
        print "     brokerPubQueue          "
        print "     ccdtQmgrName            "
        print "     ccdtUrl                 "
        print "     ccsid                   "
        print "     cleanupInterval         "
        print "     cleanupLevel            "
        print "     clientId                "
        print "     clonedSubs              "
        print "     compressHeaders         "
        print "     compressPayload         "
        print "     containerAuthAlias      "
        print "     description             "
        print "     failIfQuiescing         "
        print "     localAddress            "
        print "     mappingAlias            "
        print "     modelQueue              "
        print "     msgRetention            "
        print "     msgSelection            "
        print "     pollingInterval         "
        print "     providerVersion         "
        print "     pubAckInterval          "
        print "     qmgrHostname            "
        print "     qmgrName                "
        print "     qmgrPortNumber          "
        print "     qmgrSvrconnChannel      "
        print "     rcvExitInitData         "
        print "     rcvExit                 "
        print "     replyWithRFH2           "
        print "     rescanInterval          "
        print "     secExitInitData         "
        print "     secExit                 "
        print "     sendExitInitData        "
        print "     sendExit                "
        print "     sparseSubs              "
        print "     sslConfiguration        "
        print "     sslCrl                  "
        print "     sslPeerName             "
        print "     sslResetCount           "
        print "     sslType                 "
        print "     stateRefreshInt         "
        print "     subStore                "
        print "     support2PCProtocol      "
        print "     tempQueuePrefix         "
        print "     tempTopicPrefix         "
        print "     wildcardFormat          "
        print "     wmqTransportType        "
        print "     xaRecoveryAuthAlias     "
        print " "  
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createWMQConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\")"
        else:       
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWMQConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", %s)" % (otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWMQConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new WMQ Connection Factory"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        #prepare the parameters for the AdminTask command - set the implied type of CF in this case
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)
        requiredParameters = [["name", name], ["jndiName", jndiName], ["type", "CF"]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr

        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createWMQConnectionFactory(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 49 Create a SIBJMS Queue Connection factory
def createSIBJMSQueueConnectionFactory(scope, name, jndiName , busName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createSIBJMSQueueConnectionFactory(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `busName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a SIB JMS Queue Connection factory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createSIBJMSQueueConnectionFactory "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " JMSQueueConnectionFactory:   "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Bus:   "
        print "     busName:                "+busName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     authDataAlias                        "
        print "     containerAuthAlias                   "
        print "     mappingAlias                         "
        print "     xaRecoveryAuthAlias                  "
        print "     category                             "
        print "     description                          "
        print "     logMissingTransactionContext         "
        print "     manageCachedHandles                  "
        print "     clientID                             "
        print "     userName                             "
        print "     password                             "
        print "     nonPersistentMapping                 "
        print "     persistentMapping                    "
        print "     durableSubscriptionHome              "
        print "     readAhead                            "
        print "     target                               "
        print "     targetType                           "
        print "     targetSignificance                   "
        print "     targetTransportChain                 "
        print "     providerEndPoints                    "
        print "     connectionProximity                  "
        print "     tempQueueNamePrefix                  "
        print "     tempTopicNamePrefix                  "
        print "     shareDataSourceWithCMP               "
        print "     shareDurableSubscriptions            "
        print "     consumerDoesNotModifyPayloadAfterGet "
        print "     producerDoesNotModifyPayloadAfterSet "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createSIBJMSQueueConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createSIBJMSQueueConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\", %s)" % (otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createSIBJMSQueueConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new SIB JMS Queue Connection Factory"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(busName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["busName", busName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #set the type parameter to 'Queue' to create a queue connection factory
        typeParameter = [["type", "Queue"]]
        otherAttrsList = otherAttrsList + typeParameter

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["busName", busName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createSIBJMSConnectionFactory(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 50 Create a WMQ Queue Connection factory - type is 'QCF'
def createWMQQueueConnectionFactory(scope,name ,jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWMQQueueConnectionFactory(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `otherAttrsList` + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a WMQ Queue Connection Factory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createWMQQueueConnectionFactory "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " MQQueueConnectionFactory:   "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     maxBatchSize            "
        print "     brokerCCSubQueue        "
        print "     brokerCtrlQueue         "
        print "     brokerQmgr              "
        print "     brokerSubQueue          "
        print "     brokerVersion           "
        print "     brokerPubQueue          "
        print "     ccdtQmgrName            "
        print "     ccdtUrl                 "
        print "     ccsid                   "
        print "     cleanupInterval         "
        print "     cleanupLevel            "
        print "     clientId                "
        print "     clonedSubs              "
        print "     compressHeaders         "
        print "     compressPayload         "
        print "     containerAuthAlias      "
        print "     description             "
        print "     failIfQuiescing         "
        print "     localAddress            "
        print "     mappingAlias            "
        print "     modelQueue              "
        print "     msgRetention            "
        print "     msgSelection            "
        print "     pollingInterval         "
        print "     providerVersion         "
        print "     pubAckInterval          "
        print "     qmgrHostname            "
        print "     qmgrName                "
        print "     qmgrPortNumber          "
        print "     qmgrSvrconnChannel      "
        print "     rcvExitInitData         "
        print "     rcvExit                 "
        print "     replyWithRFH2           "
        print "     rescanInterval          "
        print "     secExitInitData         "
        print "     secExit                 "
        print "     sendExitInitData        "
        print "     sendExit                "
        print "     sparseSubs              "
        print "     sslConfiguration        "
        print "     sslCrl                  "
        print "     sslPeerName             "
        print "     sslResetCount           "
        print "     sslType                 "
        print "     stateRefreshInt         "
        print "     subStore                "
        print "     support2PCProtocol      "
        print "     tempQueuePrefix         "
        print "     tempTopicPrefix         "
        print "     wildcardFormat          "
        print "     wmqTransportType        "
        print "     xaRecoveryAuthAlias     "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createWMQQueueConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWMQQueueConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", %s)" % (otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWMQQueueConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new WMQ Queue Connection Factory"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #prepare the parameters for the AdminTask command - set the implied type of QCF in this case
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)
        requiredParameters = [["name", name], ["jndiName", jndiName], ["type", "QCF"]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr

        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createWMQConnectionFactory(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef

 
# Example 51 Create a SIBJMS Topic Connection factory
def createSIBJMSTopicConnectionFactory(scope, name, jndiName , busName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createSIBJMSTopicConnectionFactory(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `busName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a SIB JMS Topic Connection factory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createSIBJMSTopicConnectionFactory "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " JMSTopicConnectionFactory:  "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Bus:   "
        print "     busName:                "+busName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     authDataAlias                        "
        print "     containerAuthAlias                   "
        print "     mappingAlias                         "
        print "     xaRecoveryAuthAlias                  "
        print "     category                             "
        print "     description                          "
        print "     logMissingTransactionContext         "
        print "     manageCachedHandles                  "
        print "     clientID                             "
        print "     userName                             "
        print "     password                             "
        print "     nonPersistentMapping                 "
        print "     persistentMapping                    "
        print "     durableSubscriptionHome              "
        print "     readAhead                            "
        print "     target                               "
        print "     targetType                           "
        print "     targetSignificance                   "
        print "     targetTransportChain                 "
        print "     providerEndPoints                    "
        print "     connectionProximity                  "
        print "     tempQueueNamePrefix                  "
        print "     tempTopicNamePrefix                  "
        print "     shareDataSourceWithCMP               "
        print "     shareDurableSubscriptions            "
        print "     consumerDoesNotModifyPayloadAfterGet "
        print "     producerDoesNotModifyPayloadAfterSet "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createSIBJMSTopicConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\")"
        else:  
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createSIBJMSTopicConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\", %s)" % (otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createSIBJMSTopicConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + busName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new SIB JMS Topic Connection Factory"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(busName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["busName", busName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #set the type parameter to 'Topic' to create a topic connection factory
        typeParameter = [["type", "Topic"]]
        otherAttrsList = otherAttrsList + typeParameter

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["busName", busName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createSIBJMSConnectionFactory(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 52 Create a WMQ Topic Connection factory - type is 'TCF'
def createWMQTopicConnectionFactory(scope,name ,jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWMQTopicConnectionFactory(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `otherAttrsList` + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a WMQ Topic Connection Factory
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createWMQTopicConnectionFactory "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " MQTopicConnectionFactory:   "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList 
        print "     maxBatchSize            "
        print "     brokerCCSubQueue        "
        print "     brokerCtrlQueue         "
        print "     brokerQmgr              "
        print "     brokerSubQueue          "
        print "     brokerVersion           "
        print "     brokerPubQueue          "
        print "     ccdtQmgrName            "
        print "     ccdtUrl                 "
        print "     ccsid                   "
        print "     cleanupInterval         "
        print "     cleanupLevel            "
        print "     clientId                "
        print "     clonedSubs              "
        print "     compressHeaders         "
        print "     compressPayload         "
        print "     containerAuthAlias      "
        print "     description             "
        print "     failIfQuiescing         "
        print "     localAddress            "
        print "     mappingAlias            "
        print "     modelQueue              "
        print "     msgRetention            "
        print "     msgSelection            "
        print "     pollingInterval         "
        print "     providerVersion         "
        print "     pubAckInterval          "
        print "     qmgrHostname            "
        print "     qmgrName                "
        print "     qmgrPortNumber          "
        print "     qmgrSvrconnChannel      "
        print "     rcvExitInitData         "
        print "     rcvExit                 "
        print "     replyWithRFH2           "
        print "     rescanInterval          "
        print "     secExitInitData         "
        print "     secExit                 "
        print "     sendExitInitData        "
        print "     sendExit                "
        print "     sparseSubs              "
        print "     sslConfiguration        "
        print "     sslCrl                  "
        print "     sslPeerName             "
        print "     sslResetCount           "
        print "     sslType                 "
        print "     stateRefreshInt         "
        print "     subStore                "
        print "     support2PCProtocol      "
        print "     tempQueuePrefix         "
        print "     tempTopicPrefix         "
        print "     wildcardFormat          "
        print "     wmqTransportType        "
        print "     xaRecoveryAuthAlias     "
        print " "  
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createWMQTopicConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWMQTopicConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", %s)" % (otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWMQTopicConnectionFactory(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new WMQ Topic Connection Factory"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #prepare the parameters for the AdminTask command - set the implied type of TCF in this case
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)
        requiredParameters = [["name", name], ["jndiName", jndiName], ["type", "TCF"]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr

        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createWMQConnectionFactory(configIdScope, finalParameters)
        
        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 53 Create a SIBJMS Queue
def createSIBJMSQueue(scope, name, jndiName , queueName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createSIBJMSQueue(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `queueName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a SIB JMS Queue
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createSIBJMSQueue "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " JMSQueue:                   "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Queue:   "
        print "     queueName:                "+queueName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     description                     "
        print "     deliveryMode                    "
        print "     timeToLive                      "
        print "     priority                        "
        print "     readAhead                       "
        print "     busName                         "
        print "     scopeToLocalQP                  "
        print "     producerBind                    "
        print "     producerPreferLocal             "
        print "     gatherMessages                  "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createSIBJMSQueue(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + queueName + "\")"
        else:  
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createSIBJMSQueue(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + queueName + "\", %s)" % (otherAttrsList)
            else:  
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createSIBJMSQueue(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + queueName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new SIB JMS Queue"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(queueName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["queueName", queueName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)
               
        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["queueName", queueName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createSIBJMSQueue(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif
        
        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 54 Create a WMQ Queue
def createWMQQueue(scope, name, jndiName , queueName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWMQQueue(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `queueName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a WMQ Queue
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createWMQQueue "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " MQQueue:                    "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Queue:   "
        print "     queueName:                "+queueName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     ccsid                           "
        print "     decimalEncoding                 "
        print "     description                     "
        print "     expiry                          "
        print "     floatingPointEncoding           "
        print "     integerEncoding                 "
        print "     persistence                     "
        print "     priority                        "
        print "     qmgr                            "
        print "     readAheadClose                  "
        print "     readAhead                       "
        print "     sendAsync                       "
        print "     useRFH2                         "
        print "     useNativeEncoding               "
        print " "
        
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createWMQQueue(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + queueName + "\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWMQQueue(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + queueName + "\", %s)" % (otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWMQQueue(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + queueName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new WMQ Queue"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(queueName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["queueName", queueName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["queueName", queueName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createWMQQueue(configIdScope, finalParameters)
        
        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 55 Create a SIBJMS Topic
def createSIBJMSTopic(scope, name, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createSIBJMSTopic(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a SIB JMS Topic
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createSIBJMSTopic "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " JMSTopic:                   "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     description              "
        print "     topicSpace               "
        print "     topicName                "
        print "     deliveryMode             "
        print "     timeToLive               "
        print "     priority                 "
        print "     readAhead                "
        print "     busName                  "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createSIBJMSTopic(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createSIBJMSTopic(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", %s)" % otherAttrsList
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createSIBJMSTopic(\"" + scope + "\", \"" + name + "\" , \"" + jndiName +  "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new SIB JMS Topic"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createSIBJMSTopic(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 56 Create a WMQ Topic
def createWMQTopic(scope, name, jndiName , topicName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWMQTopic(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `topicName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a WMQ Topic
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createWMQTopic "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " MQTopic:                    "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print " Topic:   "
        print "     topicName:                "+topicName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "    brokerCCDurSubQueue         "
        print "    brokerDurSubQueue           "
        print "    brokerPubQmgr               "
        print "    brokerPubQueue              "
        print "    brokerVersion               "
        print "    ccsid                       "
        print "    decimalEncoding             "
        print "    description                 "
        print "    expiry                      "
        print "    floatingPointEncoding       "
        print "    integerEncoding             "
        print "    persistence                 "
        print "    priority                    "
        print "    readAheadClose              "
        print "    readAhead                   "
        print "    sendAsync                   "
        print "    useRFH2                     "
        print "    useNativeEncoding           "
        print "    wildcardFormat              "
        print " "

        if (otherAttrsList == []):
            print " Usage: AdminJMS.createWMQTopic(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + topicName + "\")"
        else:
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWMQTopic(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + topicName + "\", %s)" % (otherAttrsList)
            else:
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWMQTopic(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + topicName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new WMQ Topic"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(topicName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["topicName", topicName]))

        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["topicName", topicName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr

        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createWMQTopic(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 57 Create a SIBJMS ActivationSpec
def createSIBJMSActivationSpec(scope, name, jndiName , destinationJndiName , otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createSIBJMSActivationSpec(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `destinationJndiName` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a SIB JMS ActivationSpec
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createSIBJMSActivationSpec "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " JMSActivationSpec:          "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print "     destinationJndiName:    "+destinationJndiName
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     description                                      "
        print "     acknowledgeMode                                  "
        print "     authenticationAlias                              "
        print "     busName                                          "
        print "     clientId                                         "
        print "     destinationType                                  "
        print "     durableSubscriptionHome                          "
        print "     maxBatchSize                                     "
        print "     maxConcurrency                                   "
        print "     messageSelector                                  "
        print "     password                                         "
        print "     subscriptionDurability                           "
        print "     subscriptionName                                 "
        print "     shareDurableSubscriptions                        "
        print "     userName                                         "
        print "     readAhead                                        "
        print "     target                                           "
        print "     targetType                                       "
        print "     targetSignificance                               "
        print "     targetTransportChain                             "
        print "     providerEndPoints                                "
        print "     shareDataSourceWithCMP                           "
        print "     consumerDoesNotModifyPayloadAfterGet             "
        print "     forwarderDoesNotModifyPayloadAfterSet            "
        print "     alwaysActivateAllMDBs                            "
        print "     retryInterval                                    "
        print "     autoStopSequentialMessageFailure                 "
        print "     failingMessageDelay                              "
        print " "
        if (otherAttrsList == []):
            print " Usage: AdminJMS.createSIBJMSActivationSpec(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + destinationJndiName + "\")"
        else:  
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createSIBJMSActivationSpec(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + destinationJndiName + "\", %s)" % (otherAttrsList)
            else:  
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createSIBJMSActivationSpec(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + destinationJndiName + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new SIB JMS ActivationSpec"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(destinationJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["destinationJndiName", destinationJndiName]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))


        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)
               
        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["destinationJndiName", destinationJndiName]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createSIBJMSActivationSpec(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


# Example 58 Create a WMQ ActivationSpec
def createWMQActivationSpec(scope, name, jndiName , destinationJndiName , destinationType, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWMQActivationSpec(" + `scope` + ", " + `name`+ ", " + `jndiName` + ", " + `destinationJndiName` + ", " + `destinationType` + ", " + `otherAttrsList` + ", " + `failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a WMQ ActivationSpec
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminJMS:               createWMQActivationSpec "
        print " Scope:                      "
        print "     scope:                  "+scope
        print " MQActivationSpec:           "
        print "     name:                   "+name
        print "     jndiName:               "+jndiName
        print "     destinationJndiName:    "+destinationJndiName
        print "     destinationType ('javax.jms.Queue' or 'javax.jms.Topic'):  "+destinationType
        print " Optional Parameters :                   "
        print "   otherAttributesList:        %s" % otherAttrsList
        print "     authAlias                            "
        print "     brokerCCDurSubQueue                  "
        print "     brokerCCSubQueue                     "
        print "     brokerCtrlQueue                      "
        print "     brokerQmgr                           "
        print "     brokerSubQueue                       "
        print "     brokerVersion                        "
        print "     ccdtQmgrName                         "
        print "     ccdtUrl                              "
        print "     ccsid                                "
        print "     cleanupInterval                      "
        print "     cleanupLevel                         "
        print "     clientId                             "
        print "     clonedSubs                           "
        print "     compressHeaders                      "
        print "     compressPayload                      "
        print "     description                          "
        print "     failIfQuiescing                      "
        print "     failureDeliveryCount                 "
        print "     maxPoolSize                          "
        print "     messageSelector                      "
        print "     msgRetention                         "
        print "     msgSelection                         "
        print "     poolTimeout                          "
        print "     providerVersion                      "
        print "     qmgrHostname                         "
        print "     qmgrName                             "
        print "     qmgrPortNumber                       "
        print "     qmgrSvrconnChannel                   "
        print "     rcvExitInitData                      "
        print "     rcvExit                              "
        print "     rescanInterval                       "
        print "     secExitInitData                      "
        print "     secExit                              "
        print "     sendExitInitData                     "
        print "     sendExit                             "
        print "     sparseSubs                           "
        print "     sslConfiguration                     "
        print "     sslCrl                               "
        print "     sslPeerName                          "
        print "     sslResetCount                        "
        print "     sslType                              "
        print "     startTimeout                         "
        print "     stateRefreshInt                      "
        print "     stopEndpointIfDeliveryFails          "
        print "     subscriptionDurability               "
        print "     subscriptionName                     "
        print "     subStore                             "
        print "     wildcardFormat                       "
        print "     wmqTransportType                     "
        print "     localAddress                         "
        print ""
        print " "

        if (otherAttrsList == []):
            print " Usage: AdminJMS.createWMQActivationSpec(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + destinationJndiName + "\", \"" + destinationType + "\")"
        else:  
            if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                print " Usage: AdminJMS.createWMQActivationSpec(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + destinationJndiName + "\", \"" + destinationType + "\", %s)" % (otherAttrsList)
            else: 
                # d714926 check if script syntax error  
                if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                else:
                   if (otherAttrsList.find("\"") > 0):
                      otherAttrsList = otherAttrsList.replace("\"", "\'")
                   print " Usage: AdminJMS.createWMQActivationSpec(\"" + scope + "\", \"" + name + "\" , \"" + jndiName + "\", \"" + destinationJndiName + "\", \"" + destinationType + "\", \"" + str(otherAttrsList) + "\")"
        print " Return: The Configuration Id of the new WMQ ActivationSpec"
        print "---------------------------------------------------------------"
        print " "
        print " "

        #Make sure required parameters are non-empty
        if (len(scope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))
        if (len(name) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["name", name]))
        if (len(jndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
        if (len(destinationJndiName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["destinationJndiName", destinationJndiName]))
        if (len(destinationType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["destinationType", destinationType]))


        #validate the scope
        #we will end up with a containment path for the scope - convert that to the config id which is needed.
        if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
        scopeContainmentPath = AdminUtilities.getScopeContainmentPath(scope)
        configIdScope = AdminConfig.getid(scopeContainmentPath)
        # if at this point, we don't have a proper config id, then the scope specified was incorrect
        if (len(configIdScope) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

        #validate the destinationType - must be javax.jms.Queue or javax.jms.Topic
        if ( (destinationType != "javax.jms.Queue") and (destinationType != "javax.jms.Topic") ) :
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["destinationType", destinationType]))

        #convert to list format
        otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

        #prepare for AdminTask command call
        requiredParameters = [["name", name], ["jndiName", jndiName], ["destinationJndiName", destinationJndiName], ["destinationType", destinationType]]
        finalAttrsList = requiredParameters + otherAttrsList
        finalParameters = []
        for attrs in finalAttrsList:
            attr = ["-"+attrs[0], attrs[1]]
            finalParameters = finalParameters+attr


        #call the corresponding AdminTask command
        AdminUtilities.debugNotice("About to call AdminTask command with target : " + str(configIdScope))
        AdminUtilities.debugNotice("About to call AdminTask command with parameters : " + str(finalParameters))
        newObjectId = AdminTask.createWMQActivationSpec(configIdScope, finalParameters)

        #Save the config depending on the AutoSave variable
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        #endif

        #return the config ID of the newly created object
        AdminUtilities.debugNotice("Returning config id of new object : " + str(newObjectId))
        return newObjectId

    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != AdminUtilities._TRUE_):
            print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
            val = "%s %s" % (sys.exc_type, sys.exc_value)
            raise "ScriptLibraryException: ", `val`
        else:   
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef
