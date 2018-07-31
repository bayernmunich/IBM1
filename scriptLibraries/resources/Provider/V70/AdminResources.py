
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

# @(#) 1.2 SERV1/ws/code/admin.scripting/src/scriptLibraries/resources/JMS/V61/AdminJMS.py, WAS.admin.scripting, WASX.SERV1 7/6/07 11:15:07 [9/20/07 13:01:02]

#---------------------------------------------------------------------------------------
# AdminJMS.py - Jython procedures for performing resource tasks.
#---------------------------------------------------------------------------------------
#
#   This script includes the following procedures:
#       Ex1: createMailProvider
#       Ex2: createProtocolProvider
#       Ex3: createMailSession
#       Ex4: createCompleteMailProvider
#       Ex5: createResourceEnvProvider
#       Ex6: createResourceEnvProviderRef
#       Ex7: createResourceEnvEntries
#       Ex8: createCompleteResourceEnvProvider
#       Ex9: createURLProvider
#       Ex10: createURL
#       Ex11: createCompleteURLProvider
#       Ex12: createScheduler
#       Ex13: createJAASAuthenticationAlias
#       Ex14: createWorkManager
#       Ex15: createSharedLibrary
#       Ex16: createLibraryRef
#       Ex17: help
#       Ex18: createMailProviderAtScope
#       Ex19: createProtocolProviderAtScope
#       Ex20: createMailSessionAtScope
#       Ex21: createCompleteMailProviderAtScope
#       Ex22: createResourceEnvProviderAtScope
#       Ex23: createResourceEnvProviderRefAtScope
#       Ex24: createResourceEnvEntriesAtScope
#       Ex25: createCompleteResourceEnvProviderAtScope
#       Ex26: createURLProviderAtScope
#       Ex27: createURLAtScope
#       Ex28: createCompleteURLProviderAtScope
#       Ex29: createSchedulerAtScope
#       Ex30: createWorkManagerAtScope
#       Ex31: createSharedLibraryAtScope
#
#---------------------------------------------------------------------

import sys
import AdminUtilities

# Setting up Global Variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)


## Example 1 create a mail provider ##
def createMailProvider( nodeName, serverName, mailProviderName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createMailProvider("+`nodeName`+", "+`serverName`+", "+`mailProviderName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a new mail provider
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                         Create a new mail provider"
                print " Scope:"
                print "    node name                            "+nodeName
                print "    server name                          "+serverName
                print " Mail provider:"
                print "    mail provider name                   "+mailProviderName
                print " Usage: AdminResources.createMailProvider(\""+nodeName+"\",  \""+serverName+"\", \""+mailProviderName+"\")"
                print " Return: The configuration ID of the created Mail Provider in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf

                # Check if server exists
                server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
                if (len(server) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
                #endIf

                # check if mail provider already exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailProviderName]))
                #endIf

                # construct required attributes
                requiredAttrs = [["name", mailProviderName]]

                # create a mail provider in server
                mailProvider = AdminConfig.create("MailProvider", server, requiredAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return mailProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 2 create a protocol provider for the mail provider ##
def createProtocolProvider( nodeName, serverName, mailProviderName, protocolProviderName, className, type, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createProtocolProvider("+`nodeName`+", "+`serverName`+", "+`mailProviderName`+", "+`protocolProviderName`+", "+`className`+", "+`type`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # create a new protocol provider for mail provider
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a new protocol provider for mail provider"
                print " Scope:"
                print "    node name                    "+nodeName
                print "    server name                  "+serverName
                print " Mail provider:"
                print "    mail provider name           "+mailProviderName
                print " Protocol provider:"
                print "    protocol provider name       "+protocolProviderName
                print "    class name                   "+className
                print "    type                         "+type
                print " Usage: AdminResources.createProtocolProvider(\""+nodeName+"\", \""+serverName+"\", \""+mailProviderName+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\")"
                print " Return: The configuration ID of the created Protocol Provider in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                if (protocolProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocolProviderName", protocolProviderName]))

                if (className == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["className", className]))

                if (type == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["type", type]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf

                # Check if server exists
                server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
                if (len(server) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
                #endIf

                # check if mail provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["mailProviderName", mailProviderName]))
                #endIf

                # check if protocol provider already exists
                protocolProvider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName+"/ProtocolProvider:/")
                if (len(protocolProvider) > 0):
                   protocolProvider = AdminUtilities.convertToList(protocolProvider)
                   for p in protocolProvider:
                       name = AdminConfig.showAttribute(p, "protocol")
                       if (name == protocolProviderName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [protocolProviderName]))
                       #endIf
                   #endFor
                #endIf

                # Construct attributes
                attrs = [["protocol", protocolProviderName], ["classname", className], ["type", type]]

                # Create a new protocol provider in mail provider 
                protocolProvider = AdminConfig.create("ProtocolProvider", provider, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return protocolProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 3 Create mail session for mail provider ##
def createMailSession( nodeName, serverName, mailProviderName, mailSessionName, jndiName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createMailSession("+`nodeName`+", "+`serverName`+", "+`mailProviderName`+", "+`mailSessionName`+", "+`jndiName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create new mail session for the mail provider 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a new mail session for mail provider"
                print " Scope:"
                print "    node name                    "+nodeName
                print "    server name                  "+serverName
                print " Mail provider name:             "+mailProviderName
                print " Mail session:"
                print "    mail session name            "+mailSessionName
                print "    jndiName                     "+jndiName
                print " Usage: AdminResources.createMailSession(\""+nodeName+"\", \""+serverName+"\", \""+mailProviderName+"\", \""+mailSessionName+"\", \""+jndiName+"\")"
                print " Return: The configuration ID of the created mail session in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                if (mailSessionName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailSessionName", mailSessionName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf

                # Check if server exists
                server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
                if (len(server) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
                #endIf

                # Check if mail provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["mailProviderName", mailProviderName]))
                #endIf

                # Check if mail session already exists 
                session = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName+"/MailSession:"+mailSessionName)
                if (len(session) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailSessionName]))
                #endIf

                # Construct required attributes
                requiredAttrs = [["name", mailSessionName], ["jndiName", jndiName]] 

                # Create a new mail session in mail provider
                mailSession = AdminConfig.create("MailSession", provider, requiredAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return mailSession
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 4 A complete example to create mail provider with protocol provider, mail session and custom property ##
def createCompleteMailProvider( nodeName, serverName, mailProviderName, propertyName, propertyValue, protocolProviderName, className, mailSessionName, jndiName, mailStoreServer, mailStoreUser, mailStorePassword, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createCompleteMailProvider("+`nodeName`+", "+`serverName`+", "+`mailProviderName`+", "+`propertyName`+", "+`propertyValue`+", "+`protocolProviderName`+", "+`className`+", "+`mailSessionName`+", "+`jndiName`+", "+`mailStoreServer`+", "+`mailStoreUser`+", "+`mailStorePassword`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a mail provider with protocol provider, mail session and custom property
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------------------------"
                print " AdminResources:                 Create a complete mail provider"
                print " Scope:"
                print "    node name                    "+nodeName
                print "    server name                  "+serverName
                print " Mail provider:"
                print "    mail provider                "+mailProviderName
                print " Custom property:"
                print "    property name                "+propertyName
                print "    property value               "+propertyValue
                print " Protocol provider: "
                print "    protocol name                "+protocolProviderName
                print "    class name                   "+className
                print " Mail session: "
                print "    mail session name            "+mailSessionName
                print "    jndi name                    "+jndiName
                print "    mail store host              "+mailStoreServer
                print "    mail store user              "+mailStoreUser
                print "    mail store password          "+mailStorePassword
                print " Usage: AdminResources.configCompleteMailProvider(\""+nodeName+"\", \""+serverName+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+mailSessionName+"\", \""+jndiName+"\", \""+mailStoreServer+"\", \""+mailStoreUser+"\", \""+mailStorePassword+"\")"
                print " Return: The configuration ID of the created Mail Provider in the respective cell" 
                print "----------------------------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                if (propertyName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyName", propertyName]))

                if (propertyValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyValue", propertyValue]))

                if (protocolProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocolProviderName", protocolProviderName]))

                if (className == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["className", className]))

                if (mailSessionName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailSessionName", mailSessionName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                if (mailStoreServer == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailStoreServer", mailStoreServer]))

                if (mailStoreUser == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailStoreUser", mailStoreUser]))

                if (mailStorePassword == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailStorePassword", mailStorePassword]))


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

                # Check if mail provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailProviderName]))
                #endIf

                # Check if protocolProvider exists
                protocolProvider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName+"/ProtocolProvider:/")
                if (len(protocolProvider) > 0):
                   protocolProvider = AdminUtilities.convertToList(protocolProvider)
                   for p in protocolProvider:
                       name = AdminConfig.showAttribute(p, "protocol")
                       if (name == protocolProviderName):
                          # protocolProvider already exists
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [protocolProviderName]))
                       #endIf
                   #endFor
                #endIf

                # Check if mail session exists 
                session = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/MailProvider:"+mailProviderName+"/MailSession:"+mailSessionName)
                if (len(session) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailSessionName]))
                #endIf

                # Construct mail provider attributes
                attrs = [["name", mailProviderName ], ["description", "Mail Provider example"]]

                # Create mail provider in server
                mailProvider = AdminConfig.create("MailProvider", server, attrs)

                # Create a custom property if custom property does not exist
                propertySet = AdminConfig.showAttribute(mailProvider, "propertySet")
                if (propertySet != None):
                   resource = AdminConfig.showAttribute(propertySet, "resourceProperties")
                   resource = AdminUtilities.convertToList(resource)
                   for r in resource:
                       # Check if resource property name exists
                       if (AdminConfig.showAttribute(r, "name") == propertyName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propertyName]))
                   #endFor
                else:
                   propertySet = AdminConfig.create("J2EEResourcePropertySet", mailProvider, [] )

                   # construct custom property attributes and create new resource property 
                   attrs = [["name", propertyName], ["value", propertyValue], ["type", "java.lang.String"]]
                   AdminConfig.create("J2EEResourceProperty", propertySet, attrs)
                #endIf

                # Construct protocol provider attributes and create protocol provider
                attrs = [["protocol", protocolProviderName], ["classname", className], ["type", "STORE"]]
                protocolProvider = AdminConfig.create("ProtocolProvider", mailProvider, attrs)

                # Construct mail session attributes and create mail session
                attrs = [["name", mailSessionName], ["jndiName", jndiName], ["mailStoreProtocol", protocolProvider], ["mailStoreHost", mailStoreServer], ["mailStoreUser", mailStoreUser], ["mailStorePassword", mailStorePassword]]
                mailSession = AdminConfig.create("MailSession", mailProvider, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return mailProvider

        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != AdminUtilities._TRUE_):
                    print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                    val = "%s %s" % (sys.exc_type, sys.exc_value)
                    AdminConfig.reset()
                    raise "ScriptLibraryException: ", `val`
                else:
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #endDef


## Example 5 create resource environment provider ##
def createResourceEnvProvider( nodeName, serverName, resEnvProviderName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createResourceEnvProvider("+`nodeName`+", "+`serverName`+", "+`resEnvProviderName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment provider
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create resource environment provider"
                print " Scope:"
                print "    node name            "+nodeName
                print "    server               "+serverName
                print " Resource Environment provider:"
                print "    name                 "+resEnvProviderName
                print " Usage: AdminResources.createResourceEnvProvider(\""+nodeName+"\", \""+serverName+"\", \""+resEnvProviderName+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Provider in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

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

                # Check if resource environment provider already exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvProviderName]))
                #endIf

                # construct attributes
                attrs = [["name", resEnvProviderName], ["description", "Resource Environment Provider example"]]

                # Create a resource environment provider in server
                resEnvProvider = AdminConfig.create("ResourceEnvironmentProvider", server, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return resEnvProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 6 create resource environment provider referenceable ##
def createResourceEnvProviderRef( nodeName, serverName, resEnvProviderName, resEnvFactoryClass, resEnvClassName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createResourceEnvProviderRef("+`nodeName`+", "+`serverName`+", "+`resEnvProviderName`+", "+`resEnvFactoryClass`+", "+`resEnvClassName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment provider referenceable
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create resource environment referenceable"
                print " Scope:"
                print "    node name            "+nodeName
                print "    server name          "+serverName
                print " Ressource environment provider:"
                print "    name                 "+resEnvProviderName
                print " Referenceable:"
                print "    factory Class        "+resEnvFactoryClass
                print "    class name           "+resEnvClassName
                print " Usage: AdminResources.createResourceEnvProviderRef(\""+nodeName+"\", \""+serverName+"\", \""+resEnvProviderName+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Provider Reference ID in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                if (resEnvFactoryClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvFactoryClass", resEnvFactoryClass]))

                if (resEnvClassName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvClassName", resEnvClassName]))

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

                # Check if resource environment provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["resEnvProviderName", resEnvProviderName]))
                #endIf

                # Create a resource environment referenceable if it does not exist
                ref = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName+"/Referenceable:/")
                if (len(ref) > 0):
                   ref = AdminUtilities.convertToList(ref)
                   for r in ref:
                       if (AdminConfig.showAttribute(r, "factoryClassname") == resEnvFactoryClass and AdminConfig.showAttribute(r, "classname") == resEnvClassName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", ["Referenceable"]))
                   #endFor
                #endIf

                # Construct required attributes
                attrs = [["factoryClassname", resEnvFactoryClass], ["classname", resEnvClassName]]

                # Create a new referenceable in resource environment provider  
                reference = AdminConfig.create("Referenceable", provider, attrs)
                        
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return reference
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 7 create resource environment entry ##
def createResourceEnvEntries( nodeName, serverName, resEnvProviderName, resEnvEntryName, jndiName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createResourceEnvEntriesf("+`nodeName`+", "+`serverName`+", "+`resEnvProviderName`+", "+`resEnvEntryName`+", "+`jndiName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment entry 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create resource environment entry"
                print " Scope:"
                print "    node name            "+nodeName
                print "    server name          "+serverName
                print " Resource environment provider"
                print "    name                 "+resEnvProviderName
                print " Resource environment entry:"
                print "    name                 "+resEnvEntryName
                print "    jndi name            "+jndiName
                print " Usage: AdminResources.createResourceEnvEntries(\""+nodeName+"\", \""+serverName+"\", \""+resEnvProviderName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Entry in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                if (resEnvEntryName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvEntryName", resEnvEntryName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

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

                # Check if resource environment provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["resEnvProviderName", resEnvProviderName]))
                #endIf

                # check if resource environment entry exists
                resEnvEntry = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName+"/ResourceEnvEntry:"+resEnvEntryName+"/")
                if (len(resEnvEntry) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvEntryName]))

                # Construct required attributes
                requiredAttrs = [["name", resEnvEntryName], ["jndiName", jndiName]]

                # Create a resource environment entry in resource environment provider
                resEnvEntry = AdminConfig.create("ResourceEnvEntry", provider, requiredAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return resEnvEntry
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 8 A complete example to create a resource envioronment provider with resource env referenceable, resource env entry and custom property #
def createCompleteResourceEnvProvider( nodeName, serverName, resEnvProviderName, propertyName, propertyValue, resEnvFactoryClass, resEnvClassName, resEnvEntryName, jndiName, failonerror=AdminUtilities._BLANK_ ):

        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createCompleteResourceEnvProvider("+`nodeName`+", "+`serverName`+", "+`resEnvProviderName`+", "+`propertyName`+", "+`propertyValue`+", "+`resEnvFactoryClass`+", "+`resEnvClassName`+", "+`resEnvEntryName`+", "+`jndiName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment provider and custom property, referenceable and resource environment entry
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a complete resource environment provider"
                print " Scope:"
                print "    node name                    "+nodeName
                print "    server name                  "+serverName
                print " Ressource environment provider"
                print "    name                         "+resEnvProviderName
                print " Custom property:"
                print "    property name                "+propertyName
                print "    property value               "+propertyValue
                print " Referenceable:"
                print "    factory Class                "+resEnvFactoryClass
                print "    class name                   "+resEnvClassName
                print " Resource environment entry:"
                print "    name                         "+resEnvEntryName
                print "    jndi name                    "+jndiName
                print " Usage: AdminResources.createResourceEnvProviderRef(\""+nodeName+"\", \""+serverName+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Provider in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                if (propertyName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyName", propertyName]))

                if (propertyValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyValue", propertyValue]))

                if (resEnvFactoryClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvFactoryClass", resEnvFactoryClass]))

                if (resEnvClassName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvClassName", resEnvClassName]))

                if (resEnvEntryName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvEntryName", resEnvEntryName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

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

                # Check if resource environment provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvProviderName]))
                #endIf

                # Construct attributes
                attrs = [["name", resEnvProviderName], ["description", "Resource Environment Provider example"]]

                # Create a new resource environment provider 
                resEnvProvider = AdminConfig.create("ResourceEnvironmentProvider", server, attrs)

                # Create a custom property if custom property does not exist
                propertySet = AdminConfig.showAttribute(resEnvProvider, "propertySet")
                if (propertySet != None):
                   resource = AdminConfig.showAttribute(propertySet, "resourceProperties")
                   resource = AdminUtilities.convertToList(resource)
                   for r in resource:
                       # Check if resource property name exists
                       if (AdminConfig.showAttribute(r, "name") == propertyName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propertyName]))
                   #endFor
                else:
                   propertySet = AdminConfig.create("J2EEResourcePropertySet", resEnvProvider, [] )
                   # Construct attributes and create a new resource property
                   attrs = [["name", propertyName], ["value", propertyValue], ["type", "java.lang.String"]]
                   AdminConfig.create("J2EEResourceProperty", propertySet, attrs)
                #endIf

                # Create a resource environment referenceable if it does not exist
                ref = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName+"/Referenceable:/")
                if (len(ref) > 0):
                   ref = AdminUtilities.convertToList(ref)
                   for r in ref:
                       if (AdminConfig.showAttribute(ref, "factoryClassname") == resEnvFactoryClass and AdminConfig.showAttribute(ref, "classname") == resEnvClassName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", ["Referenceable"]))
                   #endFor
                else:
                   # Construct attributes
                   attrs = [["factoryClassname", resEnvFactoryClass], ["classname", resEnvClassName]]
                   ref = AdminConfig.create("Referenceable", resEnvProvider, attrs)
                #endIf

                # Create a resource envioronment entry if it does not exist
                resEnvEntry = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ResourceEnvironmentProvider:"+resEnvProviderName+"/ResourceEnvEntry:"+resEnvEntryName+"/")
                if (len(resEnvEntry) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvEntryName]))
                else:
                   # Construct attributes and create resource environment entry 
                   attrs = [["name", resEnvEntryName], ["jndiName", jndiName], ["referenceable", ref]]
                   resEnvEntry = AdminConfig.create("ResourceEnvEntry", resEnvProvider, attrs)
                #endIf

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return resEnvProvider
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != AdminUtilities._TRUE_):
                    print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                    val = "%s %s" % (sys.exc_type, sys.exc_value)
                    AdminConfig.reset()
                    raise "ScriptLibraryException: ", `val`
                else:
                    return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 9 create URL provider ##
def createURLProvider( nodeName, serverName, urlProviderName, streamHandlerClass, protocol, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createURLProvider("+`nodeName`+", "+`serverName`+", "+`urlProviderName`+", "+`streamHandlerClass`+", "+`protocol`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create URLProvider
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create URL provider"
                print " Scope:"
                print "    node name            "+nodeName
                print "    server name          "+serverName
                print " URL provider:"
                print "    name                 "+urlProviderName
                print "    stream handler class "+streamHandlerClass
                print "    protocol             "+protocol
                print " Usage: AdminResources.createURLProvider(\""+nodeName+"\", \""+serverName+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\")"
                print " Return: The configuration ID of the created URL Provider in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (urlProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlProviderName", urlProviderName]))

                if (streamHandlerClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["streamHandlerClass", streamHandlerClass]))

                if (protocol == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocol", protocol]))

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

                # Check if URL provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/URLProvider:"+urlProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlProviderName]))
                #endIf

                # Construct required attributes
                requiredAttrs = [["name", urlProviderName], ["streamHandlerClassName", streamHandlerClass], ["protocol", protocol]]

                # Create URL provider in server
                urlProvider = AdminConfig.create("URLProvider", server, requiredAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return urlProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 10 create new URL for url provider ##
def createURL( nodeName, serverName, urlProviderName, urlName, jndiName, urlSpec, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createURL("+`nodeName`+", "+`serverName`+", "+`urlProviderName`+", "+`urlName`+", "+`jndiName`+", "+`urlSpec`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a new URL for the URL provider
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create URL"
                print " Scope:"
                print "    node name            "+nodeName
                print "    server name          "+serverName
                print "    URLProvider          "+urlProviderName
                print " URL attributes:"
                print "    name                 "+urlName
                print "    jndi name            "+jndiName
                print "    URL specificiation   "+urlSpec
                print " Usage: AdminResources.createURL(\""+nodeName+"\", \""+serverName+"\", \""+urlProviderName+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\")"
                print " Return: The configuration ID of the created URL in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (urlProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlProviderName", urlProviderName]))

                if (urlName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlName", urlName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                if (urlSpec == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlSpec", urlSpec]))

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

                # Check if URL provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/URLProvider:"+urlProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["urlProviderName", urlProviderName]))
                #endIf

                # Create a URL if it does not exist
                url = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/URLProvider:"+urlProviderName+"/URL:"+urlName+"/")
                if (len(url) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlName]))

                # Construct required attributes
                requiredAttrs = [["name", urlName], ["jndiName", jndiName], ["spec", urlSpec]]

                # Create URL in URLProvider
                url = AdminConfig.create("URL", provider, requiredAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return url
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 11 A complete example to create an URL provider with URL and customer property ##
def createCompleteURLProvider( nodeName, serverName, urlProviderName, streamHandlerClass, protocol, propertyName, propertyValue, urlName, jndiName, urlSpec, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createCompleteURLProvider("+`nodeName`+", "+`serverName`+", "+`urlProviderName`+", "+`streamHandlerClass`+", "+`protocol`+", "+`propertyName`+", , "+`propertyValue`+", "+`urlName`+", "+`jndiName`+", "+`urlSpec`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a URL provider and custom property and URL
                #--------------------------------------------------------------------

                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a complete URL provider"
                print " Scope:"
                print "    node name                    "+nodeName
                print "    server name                  "+serverName
                print " URL Provider:"
                print "    name                         "+urlProviderName
                print "    stream handler class         "+streamHandlerClass
                print "    protocol                     "+protocol
                print " Custom property:"
                print "    property name                "+propertyName
                print "    property value               "+propertyValue
                print " URL:"
                print "    name                         "+urlName
                print "    jndi name                    "+jndiName
                print "    URL specification            "+urlSpec
                print " Usage: AdminResources.configURLProvider(\""+nodeName+"\", \""+serverName+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\", , \""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\")"
                print " Return: The configuration ID of the created URL Provider in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (urlProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlProviderName", urlProviderName]))

                if (streamHandlerClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["streamHandlerClass", streamHandlerClass]))

                if (protocol == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocol", protocol]))

                if (propertyName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyName", propertyName]))

                if (propertyValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyValue", propertyValue]))

                if (urlName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlName", urlName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                if (urlSpec == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlSpec", urlSpec]))

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

                # Check if URL provider exists
                provider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/URLProvider:"+urlProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlProviderName]))
                #endIf

                # Create new URL provider
                # Construct attributes
                attrs = [["name", urlProviderName], ["streamHandlerClassName", streamHandlerClass], ["protocol", protocol]]
                urlProvider = AdminConfig.create("URLProvider", server, attrs)

                # Create a custom property if custom property does not exist
                propertySet = AdminConfig.showAttribute(urlProvider, "propertySet")
                if (propertySet != None):
                   resource = AdminConfig.showAttribute(propertySet, "resourceProperties")
                   resource = AdminUtilities.convertToList(resource)
                   for r in resource:
                       # Check if resource property name exists
                       if (AdminConfig.showAttribute(r, "name") == propertyName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propertyName]))
                   #endFor
                else:
                   propertySet = AdminConfig.create("J2EEResourcePropertySet", urlProvider, [] )
                   # Construct attributes and create a new resource property
                   attrs = [["name", propertyName], ["value", propertyValue], ["type", "java.lang.String"]]
                   AdminConfig.create("J2EEResourceProperty", propertySet, attrs)
                #endIf

                # Create a URL if it does not exist
                url = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/URLProvider:"+urlProviderName+"/URL:"+urlName+"/")
                if (len(url) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlName]))

                # Construct attributes
                attrs = [["name", urlName], ["jndiName", jndiName], ["spec", urlSpec]]
                url = AdminConfig.create("URL", urlProvider, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return urlProvider
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != AdminUtilities._TRUE_):
                    print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                    val = "%s %s" % (sys.exc_type, sys.exc_value)
                    AdminConfig.reset()
                    raise "ScriptLibraryException: ", `val`
                else:
                    return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 12 create a scheduler resource ##
def createScheduler( nodeName, serverName, schedName, schedJNDI, schedCategory, schedDSJNDI, schedTablePrefix, schedPollInterval, wmName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createScheduler("+`nodeName`+", "+`serverName`+", "+`schedName`+", "+`schedJNDI`+", "+`schedCategory`+", "+`schedDSJNDI`+", "+`schedTablePrefix`+", "+`schedPollInterval`+", "+`wmName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create WASTopic using template
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a scheduler"
                print " Scope:"
                print "    node name                    "+nodeName
                print "    server name                  "+serverName
                print " Scheduler:"
                print "    name                         "+schedName
                print "    jndi name                    "+schedJNDI
                print "    category                     "+schedCategory
                print "    data source JNDI name        "+schedDSJNDI
                print "    table prefix                 "+schedTablePrefix
                print "    poll interval                "+schedPollInterval
                print "    work management JNDI name    "+wmName
                print " Usage: AdminResources.createScheduler(\""+nodeName+"\", \""+serverName+"\", \""+schedName+"\", \""+schedJNDI+"\", \""+schedCategory+"\", \""+schedDSJNDI+"\", \""+schedTablePrefix+"\", \""+schedPollInterval+"\", \""+wmName+"\")"
                print " Return: The configuration ID of the created Scheduler in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (schedName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedName", schedName]))

                if (schedJNDI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedJNDI", schedJNDI]))

                if (schedCategory == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedCategory", schedCategory]))

                if (schedDSJNDI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedDSJNDI", schedDSJNDI]))

                if (schedTablePrefix == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedTablePrefix", schedTablePrefix]))

                if (schedPollInterval == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedPollInterval", schedPollInterval]))

                if (wmName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmName", wmName]))


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

                # Check if the scheduler configuration name already exists
                schedulerConfigList = AdminConfig.list("SchedulerConfiguration", server)
                schedulerConfigList = AdminUtilities.convertToList(schedulerConfigList)
                for schedulerEntry in schedulerConfigList:
                    if (schedulerEntry.find(schedName) >= 0):
                       # Scheduler exists
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [schedName]))
                    #endIf
                #endFor

                # Get the scheduler provider
                schedulerProvider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/SchedulerProvider:/")
                if (len(schedulerProvider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["SchedulerProvider"]))
                else:
                   # Check if the work manager for the scheduler already exists
                   workMgrInfo = AdminConfig.list("WorkManagerInfo", server)
                   workMgrInfo = AdminUtilities.convertToList(workMgrInfo)
                   for workManagerInfoEntry in workMgrInfo:
                       workManagerJNDI = AdminConfig.showAttribute(workManagerInfoEntry, "jndiName")
                       if (workManagerJNDI == wmName):
                          workManager = workManagerInfoEntry
                          break
                       else:
                          workManager = wmName
                       #endIf
                   #endFor
                #endIf

                # Create the scheduler
                nameAttr = ["name", schedName]
                jndiNameAttr = ["jndiName", schedJNDI]
                categoryAttr = ["category", schedCategory]
                datasourceJNDINameAttr  = ["datasourceJNDIName", schedDSJNDI]
                tablePrefixAttr = ["tablePrefix", schedTablePrefix]
                pollIntervalAttr = ["pollInterval", schedPollInterval]
                workManagerInfoAttr = ["workManagerInfoJNDIName", workManager]
                attrs = [nameAttr, jndiNameAttr, categoryAttr, datasourceJNDINameAttr, tablePrefixAttr, pollIntervalAttr, workManagerInfoAttr]
                scheduler= AdminConfig.create("SchedulerConfiguration", schedulerProvider, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return scheduler
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 13 create JAAS authentication alias ##
def createJAASAuthenticationAlias( authAlias, uid, password, description="", failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createJAASAuthenticationAlias("+`authAlias`+", "+`uid`+", "+`password`+", "+`description`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create JAAS authentication alias
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create a JAAS authentication alias"
                print " Authentication alias:"
                print "    alias                "+authAlias
                print "    user ID              "+uid
                print "    password             "+password
                print "    description          "+description
                print " Usage: AdminResources.createJAASAuthenticationAlias(\""+authAlias+"\", \""+uid+"\", \""+password+"\", \""+description+"\")"
                print " Return: The configuration ID of the created Java Authentication and Authorization Service (JAAS) Authentication Alias in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (authAlias == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authAlias", authAlias]))

                if (uid == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["uid", uid]))

                if (password == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["password", password]))

                # Create the JAASAuthData object if it does not exist
                #authAliasTest = "[alias "+authAlias+"]"
                jaasAuthData = AdminConfig.list("JAASAuthData")
                jaasAuthDataList = AdminUtilities.convertToList(jaasAuthData)
                for authDataEntry in jaasAuthDataList:
                    authDataEntries = AdminConfig.showAttribute(authDataEntry, "alias")
                    authDataEntries = AdminUtilities.convertToList(authDataEntries)
                    for authAliasEntry in authDataEntries:
                        if ( authAliasEntry == authAlias):
                           # The authAlias already exists
                           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [authAlias]))
                        #endIf
                    #endFor
                #endFor

                # Get the config id for the cell's security object
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                sec = AdminConfig.getid("/Cell:"+cellName+"/Security:/")

                # Create a new JAASAuthData
                attrs = [["alias", authAlias], ["userId", uid], ["password", password]]
                if (len(description) > 0):
                   attrs = attrs + [["description", description]]

                if (len(sec) > 0):
                   jaasAuthData  = AdminConfig.create("JAASAuthData", sec, attrs)
                #endIf 

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return jaasAuthData
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 14 create work manager ##
def createWorkManager( nodeName, serverName, wmName, wmDesc, wmJNDI, wmCategory, wmNumAlarmThreads, wmMinThreads, wmMaxThreads, wmThreadPriority, wmIsGrowable, wmServiceNames, failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createWorkManager("+`nodeName`+", "+`serverName`+", "+`wmName`+", "+`wmDesc`+", "+`wmJNDI`+", "+`wmCategory`+", "+`wmNumAlarmThreads`+", "+`wmMinThreads`+", "+`wmMaxThreads`+", "+`wmThreadPriority`+", "+`wmIsGrowable`+", "+`wmServiceNames`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create work manager
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create a work manager"
                print " Scope:"
                print "    node name            "+nodeName
                print "    server name          "+serverName
                print " Work manager:"
                print "    name                 "+wmName
                print "    description          "+wmDesc
                print "    JNDI                 "+wmJNDI
                print "    category             "+wmCategory
                print "    number alarm threads "+wmNumAlarmThreads
                print "    min threads          "+wmMinThreads
                print "    max threads          "+wmMaxThreads
                print "    thread priority      "+wmThreadPriority
                print "    growable             "+wmIsGrowable
                print "    service names        "+wmServiceNames
                print " Usage: AdminResources.createWorkManager(\""+nodeName+"\", \""+serverName+"\", \""+wmName+"\", \""+wmDesc+"\", \""+wmJNDI+"\", \""+wmCategory+"\", \""+wmNumAlarmThreads+"\", \""+wmMinThreads+"\", \""+wmMaxThreads+"\", \""+wmThreadPriority+"\", \""+wmIsGrowable+"\", \""+wmServiceNames+"\")"
                print " Return: The configuration ID of the created Work Manager in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                workManager = ""

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (wmName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmName", wmName]))

                if (wmDesc == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmDesc", wmDesc]))

                if (wmJNDI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmJNDI", wmJNDI]))

                if (wmCategory == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmCategory", wmCategory]))

                if (wmNumAlarmThreads == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmNumAlarmThreads", wmNumAlarmThreads]))

                if (wmMinThreads == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmMinThreads", wmMinThreads]))

                if (wmMaxThreads == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmMaxThreads", wmMaxThreads]))

                if (wmThreadPriority == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmThreadPriority", wmThreadPriority]))

                if (wmIsGrowable == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmIsGrowable", wmIsGrowable]))

                if (wmServiceNames == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmServiceNames", wmServiceNames]))

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

                # Check if the work manager already exists
                workMgrInfo = AdminConfig.list("WorkManagerInfo", server)
                workMgrInfo = AdminUtilities.convertToList(workMgrInfo)
                for workManagerInfoEntry in workMgrInfo:
                    workManagerNameOfEntry = AdminConfig.showAttribute(workManagerInfoEntry, "name")
                    if (workManagerNameOfEntry == wmName ):
                       # Work manager already exists
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [wmName]))
                    #endIf
                #endFor

                # Get the work manager provider
                workManagerProvider = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/WorkManagerProvider:/")
                if (len(workManagerProvider) == 0):
                   # WorkManagerProvider could not be found."
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["WorkManagerProvider"]))

                else:
                   # Construct work manager attributes
                   nameAttr = ["name", wmName]
                   descriptionAttr = ["description", wmDesc]
                   jndiNameAttr = ["jndiName", wmJNDI]
                   categoryAttr = ["category", wmCategory]
                   numAlarmThreadsAttr = ["numAlarmThreads", wmNumAlarmThreads]
                   minThreadsAttr = ["minThreads", wmMinThreads]
                   maxThreadsAttr = ["maxThreads", wmMaxThreads]
                   threadPriorityAttr = ["threadPriority", wmThreadPriority]
                   isGrowableAttr = ["isGrowable", wmIsGrowable]
                   serviceNamesAttr = ["serviceNames", wmServiceNames]
                   attrs = [nameAttr, descriptionAttr, jndiNameAttr, categoryAttr, numAlarmThreadsAttr, minThreadsAttr, maxThreadsAttr, threadPriorityAttr, isGrowableAttr, serviceNamesAttr]

                   # Create a new work manager
                   workManager = AdminConfig.create("WorkManagerInfo", workManagerProvider, attrs)
                #endIf 
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return workManager
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


# Example 15 create shared library ##
def createSharedLibrary(nodeName, serverName, libName, classpath, failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createSharedLibrary("+`nodeName`+", "+`serverName`+", "+`libName`+", "+`classpath`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Create shared library 
                #--------------------------------------------------------------------
                print ""
                print "---------------------------------------------------------------"
                print " AdminResources:         Create shared library"
                print " Scope:"
                print "    node                "+nodeName
                print "    server              "+serverName
                print " Shared library:"
                print "    name                "+libName
                print "    classpath           "+classpath
                print " Usage: AdminResources.createSharedLibrary(\""+nodeName+"\", \""+serverName+"\", \""+libName+"\", \""+classpath+"\")"
                print " Return: The configuration ID of the created Library in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

                if (libName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["libName", libName]))
                if (classpath == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classpath", classpath]))

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

                # Check if the Shared library already exists
                library = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/Library:"+libName)
                if (len(library) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [libName]))
                #endIf

                # Construct attributes
                attrs = [["name", libName], ["classPath", classpath]] 
                library = AdminConfig.create("Library", server, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return library

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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # success
#endDef


# Example 16 Create library reference##
def createLibraryRef(libName, appName, failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createLibraryRef("+`libName`+", "+`appName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Create the library reference
                #--------------------------------------------------------------------
                print ""
                print "---------------------------------------------------------------"
                print " AdminResource:         Create library reference"
                print " Library reference:"
                print "    name                "+libName
                print "    application         "+appName
                print " Usage: AdminResources.createLibraryRef(\""+libName+"\", \""+appName+"\")"
                print " Return: The configuration ID of the created Library Ref in the respective cell"
                print "---------------------------------------------------------------"
                print " "
                print " "

                libRef = ""

                # check  the required arguments
                if (libName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["libName", libName]))

                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))

                # Check if the library reference already exists
                libRefList = AdminConfig.list("LibraryRef")
                libRefList = AdminUtilities.convertToList(libRefList)

                for sharedLibraryEntry in libRefList:
                    sharedLibraryName = AdminConfig.showAttribute(sharedLibraryEntry, "libraryName")
                    if (sharedLibraryName == libName ):
                       # Library reference already exists
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [libName]))
                    #endIf
                #endFor

                deployment  = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   # Application does not exist
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   appDeploy   = AdminConfig.showAttribute(deployment, "deployedObject")
                   classLoader = AdminConfig.showAttribute(appDeploy, "classloader")

                   # Construct library reference attributes
                   attrs = [["libraryName", libName], ["sharedClassloader", "true"]]
                   libRef = AdminConfig.create("LibraryRef", classLoader, attrs)
                #endIf

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return libRef

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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 17 Online help ##
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
                #print " AdminResources:                 Help "
                #print " Script procedure:               "+procedure
                #print " Usage: AdminResources.help(\""+procedure+"\")"
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)

                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINRESOURCES_GENERAL_HELP")
                else:
                   procedure = "ADMINRESOURCES_HELP_"+procedure.upper()
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
        #AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix
#endDef



## New resource functions to support different scope
########################################################################################################################################################
########################################################################################################################################################

## Example 18 create a mail provider in the specified scope##
def createMailProviderAtScope( scope, mailProviderName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createMailProviderAtScope("+`scope`+", "+`mailProviderName`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a new mail provider at scope 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                         Create a new mail provider at scope"
                print " Scope:                                  "+scope  
                print " Mail provider:"
                print "    Mail provider name                   "+mailProviderName
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "    classpath "
                print "    description "
                print "    nativepath "
                print "    providerType "
                print "    isolatedClassLoader "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Mail Provider in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                # check if scope exists
                if (len(scopeId) == 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                # check if mail provider already exists
                provider = AdminConfig.getid(scopepath + "MailProvider:"+mailProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailProviderName]))
                #endIf

                # construct required attributes
                requiredAttrs = [["name", mailProviderName]]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList

                # create a mail provider in server
                mailProvider = AdminConfig.create("MailProvider", scopeId, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return mailProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 19 create a protocol provider for the mail provider in the specified scope##
def createProtocolProviderAtScope( scope, mailProviderName, protocolProviderName, className, type, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createProtocolProviderAtScope("+`scope`+", "+`mailProviderName`+", "+`protocolProviderName`+", "+`className`+", "+`type`+", "+`otherAttrsList`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # create a new protocol provider for mail provider at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a new protocol provider for mail provider at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " Mail provider:"
                print "    mail provider name           "+mailProviderName
                print " Protocol provider:"                             
                print "    protocol provider name       "+protocolProviderName
                print "    class name                   "+className
                print "    type (STORE, TRANSPORT)      "+type
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     classpath "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createProtocolProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createProtocolProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", %s)" % (otherAttrsList)
                   else:
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createProtocolProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Protocol Provider in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check  the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                if (protocolProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocolProviderName", protocolProviderName]))

                if (className == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["className", className]))

                if (type == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["type", type]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # check if mail provider exists
                provider = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["mailProviderName", mailProviderName]))
                #endIf

                # check if protocol provider already exists
                protocolProvider = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName+"/ProtocolProvider:/")
                if (len(protocolProvider) > 0):
                   protocolProvider = AdminUtilities.convertToList(protocolProvider)
                   for p in protocolProvider:
                       name = AdminConfig.showAttribute(p, "protocol")
                       if (name == protocolProviderName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [protocolProviderName]))
                       #endIf
                   #endFor
                #endIf

                # construct required attributes
                requiredAttrs = [["protocol", protocolProviderName], ["classname", className], ["type", type]]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList

                # Create a new protocol provider in mail provider 
                protocolProvider = AdminConfig.create("ProtocolProvider", provider, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return protocolProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 20 Create mail session for mail provider in the specified scope##
def createMailSessionAtScope(scope, mailProviderName, mailSessionName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createMailSessionAtScope("+`scope`+", "+`mailProviderName`+", "+`mailSessionName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                #  create new mail session for the mail provider at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a new mail session for mail provider at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " Mail provider name:             "+mailProviderName
                print " Mail session:"
                print "    mail session name            "+mailSessionName
                print "    jndiName                     "+jndiName
                print " Optional attributes:"
                print "   otherAttributesList:           %s" % (otherAttrsList)
                print "     category "
                print "     debug "
                print "     description "
                print "     mailFrom "
                print "     mailStoreUser "
                print "     mailStorePassword "
                print "     mailStoreHost "
                print "     mailStorePort "
                print "     mailStoreProtocol (ProtocolProvider config ID) "
                print "     mailTransportUser "
                print "     mailTransportPassword "
                print "     mailTransportHost "
                print "     mailTransportPort "
                print "     mailTransportProtocol (ProtocolProvider config ID) "
                print "     providerType "
                print "     strict "
                print "  "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createMailSessionAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+mailSessionName+"\", \""+jndiName+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createMailSessionAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+mailSessionName+"\", \""+jndiName+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createMailSessionAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+mailSessionName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created mail session in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                if (mailSessionName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailSessionName", mailSessionName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 

                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if mail provider exists
                provider = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["mailProviderName", mailProviderName]))
                #endIf

                # Check if mail session already exists 
                session = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName+"/MailSession:"+mailSessionName)
                if (len(session) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailSessionName]))
                #endIf

                # Construct required attributes
                requiredAttrs = [["name", mailSessionName], ["jndiName", jndiName]] 

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList

                # Create a new mail session in mail provider
                mailSession = AdminConfig.create("MailSession", provider, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return mailSession
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 21 A complete example to create mail provider with protocol provider, mail session and custom property in the specified scope##
def createCompleteMailProviderAtScope(scope, mailProviderName, propertyName, propertyValue, protocolProviderName, className, type, mailSessionName, jndiName, mailProviderOtherAttributesList=[], mailSessionOtherAttributesList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createCompleteMailProviderAtScope("+`scope`+", "+`mailProviderName`+", "+`propertyName`+", "+`propertyValue`+", "+`protocolProviderName`+", "+`className`+", "+`type`+", "+`mailSessionName`+", "+`jndiName`+",  "+`mailProviderOtherAttributesList`+", "+`mailSessionOtherAttributesList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a mail provider with protocol provider, mail session and custom property at scope
                #--------------------------------------------------------------------
                print "----------------------------------------------------------------------------------"
                print " AdminResources:                 Create a complete mail provider at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " Mail provider:"
                print "    mail provider                "+mailProviderName
                print " Custom property:"
                print "    property name                "+propertyName
                print "    property value               "+propertyValue
                print " Protocol provider: "
                print "    protocol name                "+protocolProviderName
                print "    class name                   "+className
                print "    type (STORE, TRANSPORT)      "+type
                print " Mail session: "
                print "    mail session name            "+mailSessionName
                print "    jndi name                    "+jndiName
                print " Optional attributes:"
                print "   MailProvider optional attributes  %s" % (mailProviderOtherAttributesList)
                print "     classpath"
                print "     description"
                print "     nativepath"
                print "     providerType"
                print "     isolatedClassLoader"
                print "     "
                print "   MailSession optional attributes   %s" % (mailSessionOtherAttributesList)
                print "     category "
                print "     debug "
                print "     description "
                print "     mailFrom "
                print "     mailStoreUser "
                print "     mailStorePassword "
                print "     mailStoreHost "
                print "     mailStorePort "
                print "     mailTransportUser "
                print "     mailTransportPassword "
                print "     mailTransportHost "
                print "     mailTransportPort "
                print "     providerType "
                print "     strict "
                print " "
                if (len(mailProviderOtherAttributesList) == 0 and len(mailSessionOtherAttributesList) == 0):
                   print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\")" 
                else:
                   if (len(mailProviderOtherAttributesList) > 0 and len(mailSessionOtherAttributesList) == 0):
                      if (str(mailProviderOtherAttributesList).startswith("[[") > 0 and len(mailSessionOtherAttributesList) == 0):
                         print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\", %s)" % (mailProviderOtherAttributesList)
                      else:
                         # d714926 check if script syntax error  
                         if (str(mailProviderOtherAttributesList).startswith("[",0,1) > 0 or str(mailProviderOtherAttributesList).startswith("[[[",0,3) > 0):
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [mailProviderOtherAttributesList]))
                         else:
                            if (mailProviderOtherAttributesList.find("\"") > 0):
                               mailProviderOtherAttributesList = mailProviderOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\", \""+str(mailProviderOtherAttributesList)+"\")"
                   elif (len(mailProviderOtherAttributesList) == 0 and len(mailSessionOtherAttributesList) > 0):
                      if (str(mailSessionOtherAttributesList).startswith("[[") > 0 and str(mailSessionOtherAttributesList).startswith("[[[",0,3) == 0):
                         print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\", \""+"\", %s)" % (mailSessionOtherAttributesList)
                      else:
                         # d714926 check if script syntax error  
                         if (str(mailSessionOtherAttributesList).startswith("[",0,1) > 0 or str(mailSessionOtherAttributesList).startswith("[[[",0,3) > 0):
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [mailSessionOtherAttributesList]))
                         else:
                            if (mailSessionOtherAttributesList.find("\"") > 0):
                               mailSessionOtherAttributesList = mailSessionOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\", \""+"\", \""+str(mailSessionOtherAttributesList)+"\")"
                   else:
                      if (len(mailProviderOtherAttributesList) > 0 and len(mailSessionOtherAttributesList) > 0):
                         # d714926 
                         if ((str(mailProviderOtherAttributesList).startswith("[[") > 0 and str(mailProviderOtherAttributesList).startswith("[[[",0,3) == 0) and 
                             (str(mailSessionOtherAttributesList).startswith("[[") > 0 and str(mailSessionOtherAttributesList).startswith("[[[",0,3) == 0)):
                            print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\", %s %c %s)" % (mailProviderOtherAttributesList,",",mailSessionOtherAttributesList)
                         else:
                            # d714926 check if script syntax error 
                            if ((str(mailProviderOtherAttributesList).startswith("[",0,1) > 0 or str(mailProviderOtherAttributesList).startswith("[[[",0,3) > 0) or 
                                (str(mailSessionOtherAttributesList).startswith("[",0,1) > 0 or str(mailSessionOtherAttributesList).startswith("[[[",0,3) > 0)): 
                                if (str(mailProviderOtherAttributesList).startswith("[",0,1) > 0 or str(mailProviderOtherAttributesList).startswith("[[[",0,3) > 0):
                                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [mailProviderOtherAttributesList]))
                                if (str(mailSessionOtherAttributesList).startswith("[",0,1) > 0 or str(mailSessionOtherAttributesList).startswith("[[[",0,3) > 0):
                                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [mailSessionOtherAttributesList]))
                            else:
                                if (mailProviderOtherAttributesList.find("\"") > 0):
                                   mailProviderOtherAttributesList = mailProviderOtherAttributesList.replace("\"", "\'")
                                if (mailSessionOtherAttributesList.find("\"") > 0):
                                   mailSessionOtherAttributesList = mailSessionOtherAttributesList.replace("\"", "\'")
                                print " Usage: AdminResources.createCompleteMailProviderAtScope(\""+scope+"\", \""+mailProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+protocolProviderName+"\", \""+className+"\", \""+type+"\", \""+mailSessionName+"\", \""+jndiName+"\", \""+str(mailProviderOtherAttributesList)+"\", \""+str(mailSessionOtherAttributesList)+"\")"
                print " Return: The configuration ID of the created Mail Provider in the respective scope" 
                print "----------------------------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (mailProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailProviderName", mailProviderName]))

                if (propertyName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyName", propertyName]))

                if (propertyValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyValue", propertyValue]))

                if (protocolProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocolProviderName", protocolProviderName]))

                if (className == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["className", className]))

                if (type == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["type", type]))

                if (mailSessionName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mailSessionName", mailSessionName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 

                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if mail provider exists
                provider = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailProviderName]))
                #endIf

                # Check if protocolProvider exists
                protocolProvider = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName+"/ProtocolProvider:/")
                if (len(protocolProvider) > 0):
                   protocolProvider = AdminUtilities.convertToList(protocolProvider)
                   for p in protocolProvider:
                       name = AdminConfig.showAttribute(p, "protocol")
                       if (name == protocolProviderName):
                          # protocolProvider already exists
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [protocolProviderName]))
                       #endIf
                   #endFor   
                #endIf

                # Check if mail session exists 
                session = AdminConfig.getid(scopepath+"MailProvider:"+mailProviderName+"/MailSession:"+mailSessionName)
                if (len(session) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [mailSessionName]))
                #endIf

                # Construct mail provider attributes
                mailRequiredAttrs = [["name", mailProviderName ]]

                # convert string "parmName=value, paramName=value ..." to list
                mailOtherAttributesList = AdminUtilities.convertParamStringToList(mailProviderOtherAttributesList)

                finalAttrs = mailRequiredAttrs+mailOtherAttributesList

                # Create mail provider in server
                mailProvider = AdminConfig.create("MailProvider", scopeId, finalAttrs)

                # Create a custom property if custom property does not exist
                propertySet = AdminConfig.showAttribute(mailProvider, "propertySet")
                if (propertySet != None):
                   resource = AdminConfig.showAttribute(propertySet, "resourceProperties")
                   resource = AdminUtilities.convertToList(resource)
                   for r in resource:
                       # Check if resource property name exists
                       if (AdminConfig.showAttribute(r, "name") == propertyName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propertyName]))
                   #endFor
                else:
                   propertySet = AdminConfig.create("J2EEResourcePropertySet", mailProvider, [] )

                   # construct custom property attributes and create new resource property 
                   attrs = [["name", propertyName], ["value", propertyValue], ["type", "java.lang.String"]]
                   AdminConfig.create("J2EEResourceProperty", propertySet, attrs)
                #endIf

                # Construct protocol provider attributes and create protocol provider
                attrs = [["protocol", protocolProviderName], ["classname", className], ["type", type]]
                protocolProvider = AdminConfig.create("ProtocolProvider", mailProvider, attrs)

                # Construct mail session attributes and create mail session
                sessionRequiredAttrs = [["name", mailSessionName], ["jndiName", jndiName], ["mailStoreProtocol", protocolProvider]]

                # convert string "parmName=value, paramName=value ..." to list
                sessionOtherAttributesList = AdminUtilities.convertParamStringToList(mailSessionOtherAttributesList)

                sessionFinalAttrs = sessionRequiredAttrs+sessionOtherAttributesList

                mailSession = AdminConfig.create("MailSession", mailProvider, sessionFinalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return mailProvider

        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != AdminUtilities._TRUE_):
                    print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                    val = "%s %s" % (sys.exc_type, sys.exc_value)
                    AdminConfig.reset()
                    raise "ScriptLibraryException: ", `val`

                else:
                    return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 22 create resource environment provider in the specified scope##
def createResourceEnvProviderAtScope(scope, resEnvProviderName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createResourceEnvProviderAtScope("+`scope`+", "+`resEnvProviderName`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment provider at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create a new resource environment provider at scope"
                print " Scope:"
                print "    scope                "+scope
                print " Resource Environment provider:"
                print "    name                 "+resEnvProviderName
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     classpath "
                print "     description "
                print "     isolatedClassLoader "
                print "     nativepath "
                print "     providerType "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Provider in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 

                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if resource environment provider already exists
                provider = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvProviderName]))
                #endIf

                # construct attributes
                requiredAttrs = [["name", resEnvProviderName]]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList
                
                # Create a resource environment provider in server
                resEnvProvider = AdminConfig.create("ResourceEnvironmentProvider", scopeId, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return resEnvProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 23 create resource environment provider referenceable in the specified scope##
def createResourceEnvProviderRefAtScope( scope, resEnvProviderName, resEnvFactoryClass, resEnvClassName, failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
              failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createResourceEnvProviderRefAtScope("+`scope`+", "+`resEnvProviderName`+", "+`resEnvFactoryClass`+", "+`resEnvClassName`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment provider referenceable at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create a new resource environment referenceable at scope"
                print " Scope:"
                print "    scope                "+scope
                print " Resource environment provider:"
                print "    name                 "+resEnvProviderName
                print " Referenceable:"
                print "    factory Class        "+resEnvFactoryClass
                print "    class name           "+resEnvClassName
                print " Usage: AdminResources.createResourceEnvProviderRefAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Provider Reference ID in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                if (resEnvFactoryClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvFactoryClass", resEnvFactoryClass]))

                if (resEnvClassName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvClassName", resEnvClassName]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 

                #print "scope path: " + scopepath
                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if resource environment provider exists
                provider = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["resEnvProviderName", resEnvProviderName]))
                #endIf

                # Create a resource environment referenceable if it does not exist
                ref = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName+"/Referenceable:/")
                if (len(ref) > 0):
                   ref = AdminUtilities.convertToList(ref)
                   for r in ref:
                       if (AdminConfig.showAttribute(r, "factoryClassname") == resEnvFactoryClass and AdminConfig.showAttribute(r, "classname") == resEnvClassName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", ["Referenceable"]))
                   #endFor
                #endIf

                # Construct required attributes
                attrs = [["factoryClassname", resEnvFactoryClass], ["classname", resEnvClassName]]

                # Create a new referenceable in resource environment provider  
                reference = AdminConfig.create("Referenceable", provider, attrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return reference
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 24 create resource environment entry in the specified scope##
def createResourceEnvEntriesAtScope(scope, resEnvProviderName, resEnvEntryName, jndiName, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createResourceEnvEntriesAtScope("+`scope`+", "+`resEnvProviderName`+", "+`resEnvEntryName`+", "+`jndiName`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment entry at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create a new resource environment entry at scope"
                print " Scope:"
                print "    scope                "+scope
                print " Resource environment provider"
                print "    name                 "+resEnvProviderName
                print " Resource environment entry:"
                print "    name                 "+resEnvEntryName
                print "    jndi name            "+jndiName
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     category "
                print "     description "
                print "     providerType "
                print "     referenceable (Referenceable config id) "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createResourceEnvEntriesAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createResourceEnvEntriesAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", %s)" % (otherAttrsList)
                   else:
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createResourceEnvEntriesAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Entry in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                if (resEnvEntryName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvEntryName", resEnvEntryName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 

                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if resource environment provider exists
                provider = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["resEnvProviderName", resEnvProviderName]))
                #endIf

                # check if resource environment entry exists
                resEnvEntry = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName+"/ResourceEnvEntry:"+resEnvEntryName+"/")
                if (len(resEnvEntry) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvEntryName]))

                # Construct required attributes
                requiredAttrs = [["name", resEnvEntryName], ["jndiName", jndiName]]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList

                # Create a resource environment entry in resource environment provider
                resEnvEntry = AdminConfig.create("ResourceEnvEntry", provider, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return resEnvEntry
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 25 A complete example to create a resource envioronment provider with resource env referenceable, resource env entry and custom property in specified scope#
def createCompleteResourceEnvProviderAtScope(scope, resEnvProviderName, propertyName, propertyValue, resEnvFactoryClass, resEnvClassName, resEnvEntryName, jndiName, resEnvProviderOtherAttributesList=[], resEnvEntryOtherAttributesList=[], failonerror=AdminUtilities._BLANK_ ):

        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createCompleteResourceEnvProviderAtScope("+`scope`+", "+`resEnvProviderName`+", "+`propertyName`+", "+`propertyValue`+", "+`resEnvFactoryClass`+", "+`resEnvClassName`+", "+`resEnvEntryName`+", "+`jndiName`+", "+`resEnvProviderOtherAttributesList`+", "+`resEnvProviderOtherAttributesList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create resource environment provider and custom property, referenceable and resource environment entry at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a complete resource environment provider at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " Resource environment provider"
                print "    name                         "+resEnvProviderName
                print " Custom property:"
                print "    property name                "+propertyName
                print "    property value               "+propertyValue
                print " Referenceable:"
                print "    factory Class                "+resEnvFactoryClass
                print "    class name                   "+resEnvClassName
                print " Resource environment entry:"
                print "    name                         "+resEnvEntryName
                print "    jndi name                    "+jndiName
                print " Optional attributes:"
                print "   ResourceEnvProvider optional attributes %s" % (resEnvProviderOtherAttributesList)
                print "     classpath "
                print "     description "
                print "     isolatedClassLoader "
                print "     nativepath "
                print "     providerType "
                print "     "
                print "   ResourceEnvEntry optional attributes %s" % (resEnvEntryOtherAttributesList)
                print "     category "
                print "     description "
                print "     providerType "
                print " "
                if (len(resEnvProviderOtherAttributesList) == 0 and len(resEnvEntryOtherAttributesList) == 0):
                   print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\")" 
                else:
                   if (len(resEnvProviderOtherAttributesList) > 0 and len(resEnvEntryOtherAttributesList) == 0):
                      if (str(resEnvProviderOtherAttributesList).startswith("[[") > 0 and str(resEnvProviderOtherAttributesList).startswith("[[[",0,3) == 0):
                         print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", %s)" % (resEnvProviderOtherAttributesList)
                      else:
                         # d714926 check if script syntax error  
                         if (str(resEnvProviderOtherAttributesList).startswith("[",0,1) > 0 or str(resEnvProviderOtherAttributesList).startswith("[[[",0,3) > 0):
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [resEnvProviderOtherAttributesList]))
                         else:
                            if (resEnvProviderOtherAttributesList.find("\"") > 0):
                               resEnvProviderOtherAttributesList = resEnvProviderOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", \""+str(resEnvProviderOtherAttributesList)+"\")"
                   elif (len(resEnvProviderOtherAttributesList) == 0 and len(resEnvEntryOtherAttributesList) > 0):
                      if (str(resEnvEntryOtherAttributesList).startswith("[[") > 0 and str(resEnvEntryOtherAttributesList).startswith("[[[",0,3) == 0):
                         print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", \""+"\", \""+str(resEnvEntryOtherAttributesList)+"\")"
                      else:
                         # d714926 check if script syntax error  
                         if (str(resEnvEntryOtherAttributesList).startswith("[",0,1) > 0 or str(resEnvEntryOtherAttributesList).startswith("[[[",0,3) > 0):
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [resEnvEntryOtherAttributesList]))
                         else:
                            if (resEnvEntryOtherAttributesList.find("\"") > 0):
                               resEnvEntryOtherAttributesList = resEnvEntryOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", \""+"\", %s)" %(resEnvEntryOtherAttributesList)
                   else:
                      if (len(resEnvProviderOtherAttributesList) > 0 and len(resEnvEntryOtherAttributesList) > 0):
                         if ((str(resEnvProviderOtherAttributesList).startswith("[[") > 0  and str(resEnvProviderOtherAttributesList).startswith("[[[",0,3) == 0) and 
                             (str(resEnvEntryOtherAttributesList).startswith("[[") > 0 and str(resEnvEntryOtherAttributesList).startswith("[[[",0,3) == 0)):
                            print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", %s %c %s)" % (resEnvProviderOtherAttributesList,",",resEnvEntryOtherAttributesList)
                         else:
                            if ((str(resEnvProviderOtherAttributesList).startswith("[",0,1) > 0  and str(resEnvProviderOtherAttributesList).startswith("[[[",0,3) > 0) or
                                (str(resEnvEntryOtherAttributesList).startswith("[",0,1) >0  and str(resEnvEntryOtherAttributesList).startswith("[[[",0,3) > 0)):
                                if (str(resEnvProviderOtherAttributesList).startswith("[",0,1) > 0  and str(resEnvProviderOtherAttributesList).startswith("[[[",0,3) > 0):
                                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [resEnvProviderOtherAttributesList]))
                                if (str(resEnvEntryOtherAttributesList).startswith("[",0,1) > 0  and str(resEnvEntryOtherAttributesList).startswith("[[[",0,3) > 0):
                                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [resEnvEntryOtherAttributesList]))
                            else:
                                if (resEnvProviderOtherAttributesList.find("\"") > 0):
                                   resEnvProviderOtherAttributesList = resEnvProviderOtherAttributesList.replace("\"", "\'")
                                if (resEnvEntryOtherAttributesList.find("\"") > 0):
                                   resEnvEntryOtherAttributesList = resEnvEntryOtherAttributesList.replace("\"", "\'")
                                print " Usage: AdminResources.createCompleteResourceEnvProviderAtScope(\""+scope+"\", \""+resEnvProviderName+"\", \""+propertyName+"\", \""+propertyValue+"\", \""+resEnvFactoryClass+"\", \""+resEnvClassName+"\", \""+resEnvEntryName+"\", \""+jndiName+"\", \""+str(resEnvProviderOtherAttributesList)+"\", \""+str(resEnvEntryOtherAttributesList)+"\")"
                print " Return: The configuration ID of the created Resource Env Environment Provider in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (resEnvProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvProviderName", resEnvProviderName]))

                if (propertyName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyName", propertyName]))

                if (propertyValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyValue", propertyValue]))

                if (resEnvFactoryClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvFactoryClass", resEnvFactoryClass]))

                if (resEnvClassName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvClassName", resEnvClassName]))

                if (resEnvEntryName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["resEnvEntryName", resEnvEntryName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if resource environment provider exists
                provider = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvProviderName]))
                #endIf

                # Construct attributes
                providerRequiredAttrs = [["name", resEnvProviderName]]  

                # convert string "parmName=value, paramName=value ..." to list
                providerOtherAttributesList = AdminUtilities.convertParamStringToList(resEnvProviderOtherAttributesList)

                providerFinalAttrs = providerRequiredAttrs+providerOtherAttributesList

                # Create a new resource environment provider 
                resEnvProvider = AdminConfig.create("ResourceEnvironmentProvider", scopeId, providerFinalAttrs)

                # Create a custom property if custom property does not exist
                propertySet = AdminConfig.showAttribute(resEnvProvider, "propertySet")
                if (propertySet != None):
                   resource = AdminConfig.showAttribute(propertySet, "resourceProperties")
                   resource = AdminUtilities.convertToList(resource)
                   for r in resource:
                       # Check if resource property name exists
                       if (AdminConfig.showAttribute(r, "name") == propertyName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propertyName]))
                   #endFor
                else:
                   propertySet = AdminConfig.create("J2EEResourcePropertySet", resEnvProvider, [] )
                   # Construct attributes and create a new resource property
                   attrs = [["name", propertyName], ["value", propertyValue], ["type", "java.lang.String"]]
                   AdminConfig.create("J2EEResourceProperty", propertySet, attrs)
                #endIf
                
                # Create a resource environment referenceable if it does not exist
                ref = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName+"/Referenceable:/")
                if (len(ref) > 0):
                   ref = AdminUtilities.convertToList(ref)
                   for r in ref:
                       if (AdminConfig.showAttribute(ref, "factoryClassname") == resEnvFactoryClass and AdminConfig.showAttribute(ref, "classname") == resEnvClassName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", ["Referenceable"]))
                   #endFor
                else:
                   # Construct attributes
                   attrs = [["factoryClassname", resEnvFactoryClass], ["classname", resEnvClassName]]
                   ref = AdminConfig.create("Referenceable", resEnvProvider, attrs)
                #endIf

                # Create a resource envioronment entry if it does not exist
                resEnvEntry = AdminConfig.getid(scopepath+"ResourceEnvironmentProvider:"+resEnvProviderName+"/ResourceEnvEntry:"+resEnvEntryName+"/")

                if (len(resEnvEntry) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [resEnvEntryName]))
                else:
                   # Construct attributes and create resource environment entry 
                   entryRequiredAttrs = [["name", resEnvEntryName], ["jndiName", jndiName], ["referenceable", ref]]

                   # convert string "parmName=value, paramName=value ..." to list
                   entryOtherAttributesList = AdminUtilities.convertParamStringToList(resEnvEntryOtherAttributesList)

                   entryFinalAttrs = entryRequiredAttrs+entryOtherAttributesList
                   resEnvEntry = AdminConfig.create("ResourceEnvEntry", resEnvProvider, entryFinalAttrs)
                #endIf

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return resEnvProvider
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != AdminUtilities._TRUE_):
                    print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                    val = "%s %s" % (sys.exc_type, sys.exc_value)
                    AdminConfig.reset()
                    raise "ScriptLibraryException: ", `val`
                else:
                    return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 26 create URL provider in the specified scope##
def createURLProviderAtScope( scope, urlProviderName, streamHandlerClass, protocol, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createURLProviderAtScope("+`scope`+", "+`urlProviderName`+", "+`streamHandlerClass`+", "+`protocol`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create URLProvider at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create URL provider at scope"
                print " Scope:"
                print "    scope                "+scope
                print " URL provider:"
                print "    name                 "+urlProviderName
                print "    stream handler class "+streamHandlerClass
                print "    protocol             "+protocol
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     classpath "
                print "     description "
                print "     isolatedClassLoader "
                print "     nativepath "
                print "     providerType "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created URL Provider in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (urlProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlProviderName", urlProviderName]))

                if (streamHandlerClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["streamHandlerClass", streamHandlerClass]))

                if (protocol == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocol", protocol]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if URL provider exists
                provider = AdminConfig.getid(scopepath+"URLProvider:"+urlProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlProviderName]))
                #endIf

                # Construct required attributes
                requiredAttrs = [["name", urlProviderName], ["streamHandlerClassName", streamHandlerClass], ["protocol", protocol]]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList

                # Create URL provider in server
                urlProvider = AdminConfig.create("URLProvider", scopeId, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return urlProvider
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 27 create new URL for url provider in the specified scope##
def createURLAtScope(scope, urlProviderName, urlName, jndiName, urlSpec, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createURLAtScope("+`scope`+", "+`urlProviderName`+", "+`urlName`+", "+`jndiName`+", "+`urlSpec`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a new URL for the specified URL provider at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:         Create URL at scope"
                print " Scope:"
                print "    scope                "+scope
                print "    URLProvider          "+urlProviderName
                print " URL attributes:"
                print "    name                 "+urlName
                print "    jndi name            "+jndiName
                print "    URL specificiation   "+urlSpec
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     description "
                print "     category "
                print "     providerType "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createURLAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createURLAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createURLAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created URL in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (urlProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlProviderName", urlProviderName]))

                if (urlName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlName", urlName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                if (urlSpec == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlSpec", urlSpec]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if URL provider exists
                provider = AdminConfig.getid(scopepath+"URLProvider:"+urlProviderName)
                if (len(provider) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["urlProviderName", urlProviderName]))
                #endIf

                # Create a URL if it does not exist
                url = AdminConfig.getid(scopepath+"URLProvider:"+urlProviderName+"/URL:"+urlName+"/")
                if (len(url) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlName]))

                # Construct required attributes
                requiredAttrs = [["name", urlName], ["jndiName", jndiName], ["spec", urlSpec]]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList

                # Create URL in URLProvider
                url = AdminConfig.create("URL", provider, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return url
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 28 A complete example to create an URL provider with URL and customer property in the specified scope##
def createCompleteURLProviderAtScope( scope, urlProviderName, streamHandlerClass, protocol, propertyName, propertyValue, urlName, jndiName, urlSpec, urlProviderOtherAttributesList=[], urlOtherAttributesList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createCompleteURLProviderAtScope("+`scope`+", "+`urlProviderName`+", "+`streamHandlerClass`+", "+`protocol`+", "+`propertyName`+", "+`propertyValue`+", "+`urlName`+", "+`jndiName`+", "+`urlSpec`+", "+`urlProviderOtherAttributesList`+", "+`urlOtherAttributesList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a URL provider and custom property and URL at scope
                #--------------------------------------------------------------------

                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a complete URL provider at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " URL Provider:"
                print "    name                         "+urlProviderName
                print "    stream handler class         "+streamHandlerClass
                print "    protocol                     "+protocol
                print " Custom property:"
                print "    property name                "+propertyName
                print "    property value               "+propertyValue
                print " URL:"
                print "    name                         "+urlName
                print "    jndi name                    "+jndiName
                print "    URL specification            "+urlSpec
                print " Optional attributes:"
                print "   URLProvider optional attributes  %s" % (urlProviderOtherAttributesList)
                print "     classpath "
                print "     description "
                print "     isolatedClassLoader "
                print "     nativepath "
                print "     providerType "
                print "     "
                print "   URL optional attributes  %s" % (urlOtherAttributesList)
                print "     description "
                print "     category "
                print "     providerType "
                print " "

                if (len(urlProviderOtherAttributesList) == 0 and len(urlOtherAttributesList) == 0):
                   print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\")" 
                else:
                   if (len(urlProviderOtherAttributesList) > 0 and len(urlOtherAttributesList) == 0):
                      if (str(urlProviderOtherAttributesList).startswith("[[") > 0 and str(urlProviderOtherAttributesList).startswith("[[[",0,3) == 0):
                         print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", %s)" % (urlProviderOtherAttributesList)
                      else:
                         # d714926 check if script syntax error  
                         if (str(urlProviderOtherAttributesList).startswith("[",0,1) > 0 or str(urlProviderOtherAttributesList).startswith("[[[",0,3) > 0):
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [urlProviderOtherAttributesList]))
                         else:
                            if (urlProviderOtherAttributesList.find("\"") > 0):
                               urlProviderOtherAttributesList = urlProviderOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", \""+str(urlProviderOtherAttributesList)+"\")"
                   elif (len(urlProviderOtherAttributesList) == 0 and len(urlOtherAttributesList) > 0):
                      if (len(urlOtherAttributesList).startswith("[[") > 0 and str(urlOtherAttributesList).startswith("[[[",0,3) == 0):
                         print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", \""+"\", %s)" % (urlOtherAttributesList)
                      else:
                         # d714926 check if script syntax error  
                         if (str(urlOtherAttributesList).startswith("[",0,1) > 0 or str(urlOtherAttributesList).startswith("[[[",0,3) > 0):
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [urlOtherAttributesList]))
                         else:
                            if (urlOtherAttributesList.find("\"") > 0):
                               urlOtherAttributesList = urlOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", \""+"\", \""+str(urlOtherAttributesList)+"\")"
                   else:
                      if ((str(urlProviderOtherAttributesList).startswith("[[") >0 and str(urlProviderOtherAttributesList).startswith("[[[",0,3) == 0) and 
                          (str(urlOtherAttributesList).startswith("[[") > 0 and str(urlOtherAttributesList).startswith("[[[",0,3) == 0)):
                         print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", %s %c %s)" % (urlProviderOtherAttributesList,",",urlOtherAttributesList)
                      else:
                         if ((str(urlProviderOtherAttributesList).startswith("[",0,1) > 0 and str(urlProviderOtherAttributesList).startswith("[[[",0,3) > 0) or 
                             (str(urlOtherAttributesList).startswith("[",0,1) > 0 and str(urlOtherAttributesList).startswith("[[[",0,3) > 0)): 
                            if (str(urlProviderOtherAttributesList).startswith("[",0,1) > 0 and str(urlProviderOtherAttributesList).startswith("[[[",0,3) > 0):
                               raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [urlProviderOtherAttributesList]))
                            if (str(urlOtherAttributesList).startswith("[",0,1) > 0 and str(urlOtherAttributesList).startswith("[[[",0,3) > 0):
                               raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [urlOtherAttributesList]))
                         else:
                            if (urlProviderOtherAttributesList.find("\"") > 0):
                               urlProviderOtherAttributesList = urlProviderOtherAttributesList.replace("\"", "\'")
                            if (urlOtherAttributesList.find("\"") > 0):
                               urlOtherAttributesList = urlOtherAttributesList.replace("\"", "\'")
                            print " Usage: AdminResources.createCompleteURLProviderAtScope(\""+scope+"\", \""+urlProviderName+"\", \""+streamHandlerClass+"\", \""+protocol+"\",\""+propertyName+"\", \""+propertyValue+"\", \""+urlName+"\", \""+jndiName+"\", \""+urlSpec+"\", \""+str(urlProviderOtherAttributesList)+"\", \""+str(urlOtherAttributesList)+"\")"
                print " Return: The configuration ID of the created URL Provider in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (urlProviderName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlProviderName", urlProviderName]))

                if (streamHandlerClass == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["streamHandlerClass", streamHandlerClass]))

                if (protocol == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["protocol", protocol]))

                if (propertyName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyName", propertyName]))

                if (propertyValue == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propertyValue", propertyValue]))

                if (urlName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlName", urlName]))

                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))

                if (urlSpec == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["urlSpec", urlSpec]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if URL provider exists
                provider = AdminConfig.getid(scopepath+"URLProvider:"+urlProviderName)
                if (len(provider) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlProviderName]))
                #endIf

                # Create new URL provider
                providerRequiredAttrs = [["name", urlProviderName], ["streamHandlerClassName", streamHandlerClass], ["protocol", protocol]]

                # convert string "parmName=value, paramName=value ..." to list
                providerOtherAttributesList = AdminUtilities.convertParamStringToList(urlProviderOtherAttributesList)

                providerFinalAttrs = providerRequiredAttrs+providerOtherAttributesList
                urlProvider = AdminConfig.create("URLProvider", scopeId, providerFinalAttrs)

                # Create a custom property if custom property does not exist
                propertySet = AdminConfig.showAttribute(urlProvider, "propertySet")
                if (propertySet != None):
                   resource = AdminConfig.showAttribute(propertySet, "resourceProperties")
                   resource = AdminUtilities.convertToList(resource)
                   for r in resource:
                       # Check if resource property name exists
                       if (AdminConfig.showAttribute(r, "name") == propertyName):
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [propertyName]))
                   #endFor
                else:
                   propertySet = AdminConfig.create("J2EEResourcePropertySet", urlProvider, [] )
                   # Construct attributes and create a new resource property
                   attrs = [["name", propertyName], ["value", propertyValue], ["type", "java.lang.String"]]
                   AdminConfig.create("J2EEResourceProperty", propertySet, attrs)
                #endIf

                # Create a URL if it does not exist
                url = AdminConfig.getid(scopepath+"URLProvider:"+urlProviderName+"/URL:"+urlName+"/")
                if (len(url) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [urlName]))

                # Construct attributes
                urlRequiredAttrs = [["name", urlName], ["jndiName", jndiName], ["spec", urlSpec]]

                # convert string "parmName=value, paramName=value ..." to list
                urlOtherAttributesList = AdminUtilities.convertParamStringToList(urlOtherAttributesList)

                urlFinalAttrs = urlRequiredAttrs+urlOtherAttributesList
                url = AdminConfig.create("URL", urlProvider, urlFinalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return urlProvider
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != AdminUtilities._TRUE_):
                    print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                    val = "%s %s" % (sys.exc_type, sys.exc_value)
                    AdminConfig.reset()
                    raise "ScriptLibraryException: ", `val`
                else:
                    return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 29 create a scheduler resource in the specified scope##
def createSchedulerAtScope( scope, schedName, schedJNDI, schedDSJNDI, schedTablePrefix, schedPollInterval, wmName, schedProviderID, otherAttrsList=[], failonerror=AdminUtilities._BLANK_ ):
        if(failonerror==AdminUtilities._BLANK_): 
           failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createSchedulerAtScope("+`scope`+", "+`schedName`+", "+`schedJNDI`+", "+`schedDSJNDI`+", "+`schedTablePrefix`+", "+`schedPollInterval`+", "+`wmName`+", "+`schedProviderID`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create a scheduler resource at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a scheduler at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " Scheduler:"
                print "    name                         "+schedName
                print "    jndi name                    "+schedJNDI
                print "    data source JNDI name        "+schedDSJNDI
                print "    table prefix                 "+schedTablePrefix
                print "    poll interval                "+schedPollInterval
                print "    work management JNDI name    "+wmName
                print "    SchedulerProvider ID         "+schedProviderID
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     category "
                print "     datasourceAlias "
                print "     description "
                print "     loginConfigName "
                print "     providerType "
                print "     securityRole "
                print "     useAdminRoles "
                print "     referenceable (Referenceable config id) "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createSchedulerAtScope(\""+scope+"\", \""+schedName+"\", \""+schedJNDI+"\", \""+schedDSJNDI+"\", \""+schedTablePrefix+"\", \""+schedPollInterval+"\", \""+wmName+"\", \""+schedProviderID+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createSchedulerAtScope(\""+scope+"\", \""+schedName+"\", \""+schedJNDI+"\", \""+schedDSJNDI+"\", \""+schedTablePrefix+"\", \""+schedPollInterval+"\", \""+wmName+"\", \""+schedProviderID+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createSchedulerAtScope(\""+scope+"\", \""+schedName+"\", \""+schedJNDI+"\", \""+schedDSJNDI+"\", \""+schedTablePrefix+"\", \""+schedPollInterval+"\", \""+wmName+"\", \""+schedProviderID+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Scheduler in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (schedName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedName", schedName]))

                if (schedJNDI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedJNDI", schedJNDI]))

                if (schedDSJNDI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedDSJNDI", schedDSJNDI]))

                if (schedTablePrefix == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedTablePrefix", schedTablePrefix]))

                if (schedPollInterval == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedPollInterval", schedPollInterval]))

                if (wmName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmName", wmName]))

                if (schedProviderID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["schedProviderID", schedProviderID]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if the scheduler configuration name already exists
                schedulerConfigList = AdminConfig.list("SchedulerConfiguration", scopeId)
                schedulerConfigList = AdminUtilities.convertToList(schedulerConfigList)
                for schedulerEntry in schedulerConfigList:
                    if (schedulerEntry.find(schedName) >= 0):
                       # Scheduler exists
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [schedName]))
                    #endIf
                #endFor

                # Get the scheduler provider
                if (AdminConfig.getObjectType(schedProviderID) == None):
                   # SchedulerProvider ID could not be found
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["SchedulerProvider", schedProviderID]))
                else:
                   # Check if the work manager for the scheduler already exists
                   workMgrInfo = AdminConfig.list("WorkManagerInfo", scopeId)
                   workMgrInfo = AdminUtilities.convertToList(workMgrInfo)
                   for workManagerInfoEntry in workMgrInfo:
                       workManagerJNDI = AdminConfig.showAttribute(workManagerInfoEntry, "jndiName")
                       if (workManagerJNDI == wmName):
                          workManager = workManagerInfoEntry
                          break
                       else:
                          workManager = wmName
                       #endIf
                   #endFor
                #endIf

                # Create the scheduler
                nameAttr = ["name", schedName]
                jndiNameAttr = ["jndiName", schedJNDI]
                datasourceJNDINameAttr  = ["datasourceJNDIName", schedDSJNDI]
                tablePrefixAttr = ["tablePrefix", schedTablePrefix]
                pollIntervalAttr = ["pollInterval", schedPollInterval]
                workManagerInfoAttr = ["workManagerInfoJNDIName", workManager]
                requiredAttrs = [nameAttr, jndiNameAttr, datasourceJNDINameAttr, tablePrefixAttr, pollIntervalAttr, workManagerInfoAttr]

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList
                scheduler= AdminConfig.create("SchedulerConfiguration", schedProviderID, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return scheduler
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
 

## Example 30 create work manager in the specified scope##
def createWorkManagerAtScope( scope, wmName, wmJNDI, wmNumAlarmThreads, wmMinThreads, wmMaxThreads, wmThreadPriority, wmProviderID, otherAttrsList=[], failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createWorkManagerAtScope("+`scope`+", "+`wmName`+", "+`wmJNDI`+", "+`wmNumAlarmThreads`+", "+`wmMinThreads`+", "+`wmMaxThreads`+", "+`wmThreadPriority`+", "+`wmProviderID`+", "+`otherAttrsList`+", "+`failonerror`+"): "
        try:
                #--------------------------------------------------------------------
                # create work manager at scope
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminResources:                 Create a work manager at scope"
                print " Scope:"
                print "    scope                        "+scope
                print " Work manager:"
                print "    name                         "+wmName
                print "    JNDI name                    "+wmJNDI
                print "    number alarm threads         "+wmNumAlarmThreads
                print "    min threads                  "+wmMinThreads
                print "    max threads                  "+wmMaxThreads
                print "    thread priority              "+wmThreadPriority
                print "    WorkManagerProvider ID       "+wmProviderID
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     description "
                print "     category "
                print "     daemonTranClass "
                print "     defTranClass "
                print "     isDistributable "
                print "     isGrowable "
                print "     providerType "
                print "     serviceNames "
                print "     workReqQFullAction "
                print "     workReqQSize "
                print "     workTimeout "
                print "     referenceable (Referenceable config id) "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createWorkManagerAtScope(\""+scope+"\", \""+wmName+"\", \""+wmJNDI+"\", \""+wmNumAlarmThreads+"\", \""+wmMinThreads+"\", \""+wmMaxThreads+"\", \""+wmThreadPriority+"\", \""+wmProviderID+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createWorkManagerAtScope(\""+scope+"\", \""+wmName+"\", \""+wmJNDI+"\", \""+wmNumAlarmThreads+"\", \""+wmMinThreads+"\", \""+wmMaxThreads+"\", \""+wmThreadPriority+"\", \""+wmProviderID+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createWorkManagerAtScope(\""+scope+"\", \""+wmName+"\", \""+wmJNDI+"\", \""+wmNumAlarmThreads+"\", \""+wmMinThreads+"\", \""+wmMaxThreads+"\", \""+wmThreadPriority+"\", \""+wmProviderID+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Work Manager in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                workManager = ""

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (wmName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmName", wmName]))

                if (wmJNDI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmJNDI", wmJNDI]))

                if (wmNumAlarmThreads == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmNumAlarmThreads", wmNumAlarmThreads]))

                if (wmMinThreads == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmMinThreads", wmMinThreads]))

                if (wmMaxThreads == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmMaxThreads", wmMaxThreads]))

                if (wmThreadPriority == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmThreadPriority", wmThreadPriority]))

                if (wmProviderID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["wmProviderID", wmProviderID]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):  
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if the work manager already exists
                workMgrInfo = AdminConfig.list("WorkManagerInfo", scopeId)
                workMgrInfo = AdminUtilities.convertToList(workMgrInfo)
                for workManagerInfoEntry in workMgrInfo:
                    workManagerNameOfEntry = AdminConfig.showAttribute(workManagerInfoEntry, "name")
                    if (workManagerNameOfEntry == wmName ):
                       # Work manager already exists
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [wmName]))
                    #endIf
                #endFor

                # Get the work manager provider
                if (AdminConfig.getObjectType(wmProviderID) == None):
                   # WorkManagerProvider could not be found."
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["WorkManagerProvider", wmProviderID]))
                else:
                   # Construct work manager attributes
                   nameAttr = ["name", wmName]
                   jndiNameAttr = ["jndiName", wmJNDI]
                   numAlarmThreadsAttr = ["numAlarmThreads", wmNumAlarmThreads]
                   minThreadsAttr = ["minThreads", wmMinThreads]
                   maxThreadsAttr = ["maxThreads", wmMaxThreads]
                   threadPriorityAttr = ["threadPriority", wmThreadPriority]
                   requiredAttrs = [nameAttr, jndiNameAttr, numAlarmThreadsAttr, minThreadsAttr, maxThreadsAttr, threadPriorityAttr]

                   # convert string "parmName=value, paramName=value ..." to list
                   otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                   finalAttrs = requiredAttrs+otherAttrsList
                   # Create a new work manager
                   workManager = AdminConfig.create("WorkManagerInfo", wmProviderID, finalAttrs)
                #endIf

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return workManager
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


# Example 31 create shared library in the specified scope##
def createSharedLibraryAtScope( scope, libName, classpath, otherAttrsList=[], failonerror=AdminUtilities._BLANK_):
        if(failonerror==AdminUtilities._BLANK_): 
            failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createSharedLibraryAtScope("+`scope`+", "+`libName`+", "+`classpath`+", "+`otherAttrsList`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Create shared library at scope 
                #--------------------------------------------------------------------
                print ""
                print "---------------------------------------------------------------"
                print " AdminResources:         Create shared library at scope"
                print " Scope:"
                print "    scope                "+scope
                print " Shared library:"
                print "    name                 "+libName
                print "    classpath            "+classpath
                print " Optional attributes:"
                print "   otherAttributesList:  %s" % (otherAttrsList)
                print "     description "
                print "     isolatedClassLoader "
                print "     nativePath "
                print " "
                if (otherAttrsList == []):
                   print " Usage: AdminResources.createSharedLibraryAtScope(\""+scope+"\", \""+libName+"\", \""+classpath+"\")"
                else:
                   if (str(otherAttrsList).startswith("[[") > 0 and str(otherAttrsList).startswith("[[[",0,3) == 0):
                      print " Usage: AdminResources.createSharedLibraryAtScope(\""+scope+"\", \""+libName+"\", \""+classpath+"\", %s)" % (otherAttrsList)
                   else: 
                      # d714926 check if script syntax error  
                      if (str(otherAttrsList).startswith("[",0,1) > 0 or str(otherAttrsList).startswith("[[[",0,3) > 0):  
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6049E", [otherAttrsList]))
                      else:
                         if (otherAttrsList.find("\"") > 0):
                            otherAttrsList = otherAttrsList.replace("\"", "\'")
                         print " Usage: AdminResources.createSharedLibraryAtScope(\""+scope+"\", \""+libName+"\", \""+classpath+"\", \""+str(otherAttrsList)+"\")"
                print " Return: The configuration ID of the created Library Ref in the respective scope"
                print "---------------------------------------------------------------"
                print " "
                print " "

                # check the required arguments
                if (scope == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["scope", scope]))

                if (libName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["libName", libName]))

                if (classpath == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classpath", classpath]))

                # check if scope exists
                if (scope.find(".xml") > 0 and AdminConfig.getObjectType(scope) == None): 
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))

                scopepath = AdminUtilities.getScopeContainmentPath(scope) 
                AdminUtilities.debugNotice("scope="+scope)
                AdminUtilities.debugNotice("scope path="+scopepath)

                scopeId = AdminConfig.getid(scopepath)

                if (len(scopeId) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["scope", scope]))
                #endIf

                # Check if the Shared library already exists
                library = AdminConfig.getid(scopepath+"Library:"+libName)
                if (len(library) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [libName]))
                #endIf

                # Construct attributes
                requiredAttrs = [["name", libName], ["classPath", classpath]] 

                # convert string "parmName=value, paramName=value ..." to list
                otherAttrsList = AdminUtilities.convertParamStringToList(otherAttrsList)

                finalAttrs = requiredAttrs+otherAttrsList
                library = AdminConfig.create("Library", scopeId, finalAttrs)

                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return library
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # success
#endDef


