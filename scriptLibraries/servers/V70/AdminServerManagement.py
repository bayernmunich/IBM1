
###############################################################################
# Licensed Material - Property of IBM 
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) Copyright IBM Corp. 2007, 2008 - All Rights Reserved
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
# @(#) 1.31.1.1 SERV1/ws/code/admin.scripting/src/scriptLibraries/servers/V61/AdminServerManagement.py, WAS.admin.scripting, WAS855.SERV1, cf131750.07 3/6/17 10:28:30 [12/17/17 20:37:44]
#
#-------------------------------------------------------------------------------------
# AdminServerManagementr.py - Jython procedures for performing server management tasks.
#-------------------------------------------------------------------------------------
#
#   This script includes the following server management procedures:
#
#   Group 1: ServerConfiguration
#       Ex1:  listServers
#       Ex2:  listServerTypes
#       Ex3:  listServerTemplates
#       EX4:  createApplicationServer
#       Ex5:  createAppServerTemplate
#       Ex6:  createGenericServer
#       Ex7:  createWebServer
#       Ex8:  deleteServer
#       Ex9:  deleteServerTemplate
#       Ex10: startAllServers
#       Ex11: startSingleServer
#       Ex12: stopAllServers
#       Ex13: stopSingleServer
#       Ex14: listJVMProperties
#       Ex15: showServerInfo
#       Ex16: getJavaHome
#       Ex17: setJVMProperties
#       Ex19: checkIfServerExists
#       Ex20: checkIfServerTemplateExists
#       Ex21: configureProcessDefinition
#       Ex22: configureEndPointsHost
#       Ex23: configureClassLoader
#       Ex24: queryMBeans
#       Ex25: viewProductInformation
#       Ex26: getServerPID
#       Ex27: getServerProcessType
#       Ex43: configureCustomProperty
#       Ex48: configureSessionManagerForServer
#       Ex49: configureCookieForServer
# 
#   Group 2: ServerTracingAndLoggingConfiguration
#       Ex18: setTraceSpecification
#       Ex28: configureTraceService
#       Ex29: configureJavaVirtualMachine
#       Ex30: configureServerLogs
#   Ex31: configureJavaProcessLogs
#       Ex32: configureRASLoggingService
#       Ex33: configurePerformanceMonitoringService
#       Ex34: configurePMIRequestMetrics
#
#   Group 3: OtherServicesConfiguration
#       Ex35: configureRuntimeTransactionService
#       Ex36: configureEJBContainer
#       Ex37: configureDynamicCache
#       Ex38: configureMessageListenerService
#       Ex39: configureListenerPortForMessageListenerService
#       Ex40: configureThreadPool
#       Ex41: configureStateManageable
#       Ex42: configureORBService
#       Ex44; configureTransactionService
#       Ex45: configureWebContainer
#       Ex46: configureHTTPTransportForWebContainer
#       Ex47: configureHTTPTransportEndPointForWebContainer
#       Ex50: configureFileTransferService
#       Ex51: configureAdminService
#       Ex52: configureCustomService
#       Ex53: help
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

## Example 1 List available servers with given server type and node ##
def listServers(serverType="", nodeName="", failonerror=AdminUtilities._BLANK_):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listServers("+`serverType`+", "+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List servers
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  List servers"
        print " Optional parameters: "
        print "         Server type:    "+serverType
        print "         Node name:      "+nodeName
        print " Usage: AdminServerManagement.listServers(\""+serverType+"\", \""+nodeName+"\") "
        print " Return: List of the servers in the cell. The list is filtered based on the server type and node name parameters if they are provided."
        print "---------------------------------------------------------------"
        print " "
        print " "
        # Construct optional parameters
        optionalParamList = []

        if (len(serverType) > 0):
            optionalParamList = ['-serverType', serverType] 

        if (len(nodeName) > 0):
            # check if node exists
            node = AdminConfig.getid("/Node:" +nodeName+"/")
            if (len(node) == 0):
               raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
            #endIf
            optionalParamList = optionalParamList + ['-nodeName', nodeName]
        #endIf

        # List servers with specified server type
        servers = AdminTask.listServers(optionalParamList)

        # Convert Jython string to list
        servers = AdminUtilities.convertToList(servers)

        # Loop through each server in server list
        newservers = []
        for aServer in servers:
            # Obtain server and node names
            sname = aServer[0:aServer.find("(")]
            nname = aServer[aServer.find("nodes/")+6:aServer.find("servers/")-1]
            # Retrieve the server config id
            sid = AdminConfig.getid("/Node:"+nname+"/Server:"+sname)
            if (newservers.count(sid) <= 0):
                  newservers.append(sid)
            #AdminUtilities.infoNotice("Server: " + sid)
        #endFor
        return newservers
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


## Example 2 List available server types for a given node ##
def listServerTypes( nodeName="", failonerror=AdminUtilities._BLANK_):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listServerTypes("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List server types
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  List server types for a given node"
        print " Optional parameter: "
        print "         Node name:      "+nodeName
        print " Usage: AdminServerManagement.listServerTypes(\""+nodeName+"\")"
        print " Return: List of the server types in the cell. The list is filtered based on the node name parameter if it is provided."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # List available server types
        if (len(nodeName) > 0):
            # check if node exists
            node = AdminConfig.getid("/Node:" +nodeName+"/")
            if (len(node) == 0):
               # Node does not exist
               raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
            #endIf
            serverTypes = AdminTask.listServerTypes(nodeName)
        else:
            serverTypes = AdminTask.listServerTypes()
        #endIf

        # Convert Jython string to list
        types = AdminUtilities.convertToList(serverTypes)
        #AdminUtilities.infoNotice("Server types: " +serverTypes)
        return types 
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


## Example 3 List available server templates for a given template version, server type and template name ##
def listServerTemplates( version="", serverType="", templateName="", failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listServerTemplates("+`version`+", "+`serverType`+", "+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List server templates
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          List available server templates given template version, server type and template name"
        print " Optional parameter list: "
        print "         Template version:       "+version
        print "         Server type:            "+serverType
        print "         Template name:          "+templateName
        print " Usage: AdminServerManagement.listServerTemplates(\""+version+"\", \""+serverType+"\", \""+templateName+"\") "
        print " Return: List of server templates in the cell. The list is filtered based on the template version, server type, and template name parameters if they are provided."
        print "----------------------------------------------------------------"
        print " "
        print " "
        # Construct optional parameters
        optionalParamList = []
        if (len(version) != 0):
           optionalParamList = ['-version', version]
        if (len(serverType) != 0):
           optionalParamList = optionalParamList + ['-serverType', serverType]
        if (len(templateName) != 0):
           optionalParamList = optionalParamList + ['-name', templateName]

        # List server templates
        templates = AdminTask.listServerTemplates(optionalParamList)

        # Convert Jython string to list
        templates = AdminUtilities.convertToList(templates)
        # Loop through each server template in templates list
        newTemplates = []
        for aTemplate in templates:
            # Retrieve the template config id
            aTemplate =  aTemplate[aTemplate.find("(")+1:len(aTemplate)-1]
            tid = AdminConfig.listTemplates("Server", aTemplate[aTemplate.find("(")+1:len(aTemplate)-1])
            if (newTemplates.count(tid) <= 0):
                newTemplates.append(tid)
        #endFor
        if (len(newTemplates) > 0):
           #AdminUtilities.infoNotice(newTemplates)
           return newTemplates
        else:
           #AdminUtilities.infoNotice(templates)
           return templates
        #endIf
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


## Example 4 Create a new application server ##
def createApplicationServer( nodeName, serverName, templateName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createApplicationServer("+`nodeName`+", "+`serverName`+", "+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a new application server 
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Create an application server on a given node"
        print " Node name:              "+nodeName
        print " New Server name:        "+serverName
        print " Optional parameter: "
        print "         Template name:  "+templateName
        print " Usage: AdminServerManagement.createApplicationServer(\""+nodeName+"\", \""+serverName+"\", \""+templateName+"\") "
        print " Return: The configuration ID of the new application server."
        print "----------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters 
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # Node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
        if (len(server) > 0):
           # Server already exists
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [serverName]))
        #endIf

        # Construct required parameters
        requiredParamList = ['-name', serverName]
                
        # Construct optional parameters
        optionalParamList = []
        if (len(templateName) != 0):
            optionalParamList = ['-templateName', templateName]

        paramList = requiredParamList + optionalParamList

        # Create application server 
        server = AdminTask.createApplicationServer(nodeName, paramList)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return server
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


## Example 5 Create a new application server template ##
def createAppServerTemplate( nodeName, serverName, newTemplate, failonerror=AdminUtilities._BLANK_ ):  
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createAppServerTemplate("+`nodeName`+", "+`serverName`+", "+`newTemplate`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a new application server template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:   Create an application server template on a given node"
        print " Node name:               "+nodeName
        print " Server name:             "+serverName
        print " New Template name:       "+newTemplate
        print " Usage: AdminServerManagement.createAppServerTemplate(\""+nodeName+"\", \""+serverName+"\", \""+newTemplate+"\") "
        print " Return: The configuration ID of the new application server template."
        print "----------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (newTemplate == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["newTemplate", newTemplate]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # check if server exists
        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # check if template exists
        template = AdminConfig.listTemplates("Server", newTemplate)
        if (len(template) > 0):
           # template already exists
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [newTemplate]))
        #endIf

        # Construct required parameters 
        requiredParamList = ['-templateName', newTemplate, '-serverName', serverName, '-nodeName', nodeName]

        # Create application server template
        template = AdminTask.createApplicationServerTemplate(requiredParamList)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return template
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


## Example 6 Create a new generic server ##
def createGenericServer( nodeName, serverName, templateName, startCmd, startCmdArgs, workingDir, stopCmd, stopCmdArgs, failonerror=AdminUtilities._BLANK_):  
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createGenericServer("+`nodeName`+", "+`serverName`+", "+`templateName`+", "+`startCmd`+", "+`startCmdArgs`+", "+`workingDir`+", "+`stopCmd`+", "+`stopCmdArgs`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a new generic server
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Create a new generic server on a given node"
        print " Node name:                      "+nodeName
        print " New generic server name:        "+serverName
        print " Optional parameters: "
        print "         Template name:          "+templateName
        print "         Start command path:     "+startCmd
        print "         Start command parameters:"+startCmdArgs
        print "         Working directory:      "+workingDir
        print "         Stop command path:      "+stopCmd
        print "         Stop command parameters: "+stopCmdArgs
        print " Usage: AdminServerManagement.createGenericServer(\""+nodeName+"\", \""+serverName+"\", \""+templateName+"\", \""+startCmd+"\", \""+startCmdArgs+"\", \""+workingDir+"\", \""+stopCmd+"\", \""+stopCmdArgs+"\" ) "
        print " Return: The configuration ID of the new generic server."
        print "-----------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) > 0):
           # server already exists
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [serverName]))
        #endIf

        # Construct required parameters
        requiredParamList = ['-name', serverName]

        # Construct optional parameters
        optionalParamList = []
        configProcParamList = []
        if (len(templateName) != 0):
            optionalParamList = ['-templateName', templateName]
        if (len(startCmd) != 0):
            configProcParamList = ['-startCommand', startCmd]
        if (len(startCmdArgs) != 0):
            configProcParamList = configProcParamList + ['-startCommandArgs', startCmdArgs]
        if (len(workingDir) != 0):
            configProcParamList = configProcParamList + ['-workingDirectory', workingDir]
        if (len(stopCmd) != 0):
            configProcParamList = configProcParamList + ['-stopCommand', stopCmd]
        if (len(stopCmdArgs) != 0):
            configProcParamList = configProcParamList + ['-stopCommandArgs', stopCmdArgs]
        if (len(configProcParamList) > 0):
            optionalParamList = optionalParamList + ['-ConfigProcDef', configProcParamList]
        paramList = requiredParamList + optionalParamList       

        # Create generic server
        server = AdminTask.createGenericServer(nodeName, paramList)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return server
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



## Example 7 Create a new web server ##
def createWebServer( nodeName, serverName, webPort, webInstallPath, pluginInstallPath, configfile, serviceName, errorLog, accessLog, protocol, failonerror=AdminUtilities._BLANK_):  
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "createWebServer("+`nodeName`+", "+`serverName`+", "+`webPort`+", "+`webInstallPath`+", "+`pluginInstallPath`+", "+`configfile`+", "+`serviceName`+", "+`errorLog`+", "+`accessLog`+", "+`protocol`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Create a new web server
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:   Create a new web server on a given node"
        print " Node name:                              "+nodeName
        print " New web server name:                    "+serverName
        print " Optional parameters: "
        print "         WebServer port number:          "+webPort
        print "         WebServer install root:         "+webInstallPath
        print "         Plugin install path:            "+pluginInstallPath
        print "         Configuration file path:        "+configfile
        print "         Windows service name:           "+serviceName
        print "         Error log path:                 "+errorLog
        print "         Access log path:                "+accessLog
        print "         Web protocol (HTTP or HTTPs):   "+protocol  
        print " Usage: AdminServerManagement.createWebServer(\""+nodeName+"\", \""+serverName+"\", \""+webPort+"\", \""+webInstallPath+"\", \""+pluginInstallPath+"\", \""+configfile+"\", \""+serviceName+"\", \""+errorLog+"\", \""+accessLog+"\", \""+protocol+"\" ) "
        print " Return: The configuration ID of the new web server."
        print "-----------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) > 0):
           # server already exists
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [serverName]))
        #endIf


        # Construct required parameters
        requiredParamList = ['-name', serverName]

        # Construct optional parameters
        optionalParamList = []
        serverConfigParamList = []
        if (len(webPort) != 0):
            serverConfigParamList = ['-webPort', webPort]
        if (len(webInstallPath) != 0):
            serverConfigParamList = serverConfigParamList + ['-webInstallRoot', webInstallPath]
        if (len(pluginInstallPath) != 0):
            serverConfigParamList = serverConfigParamList + ['-pluginInstallRoot', pluginInstallPath]
        if (len(configfile) != 0):
            serverConfigParamList = serverConfigParamList + ['-configurationFile', configfile]
        if (len(serviceName) != 0):
            serverConfigParamList = serverConfigParamList + ['-serviceName', serviceName]
        if (len(errorLog) != 0):
            serverConfigParamList = serverConfigParamList + ['-errorLogFile', errorLog]
        if (len(accessLog) != 0):
            serverConfigParamList = serverConfigParamList + ['-accessLogFile', accessLog]
        if (len(protocol) != 0):
            serverConfigParamList = serverConfigParamList + ['-webProtocol', protocol]
        if (len(serverConfigParamList) > 0):
            optionalParamList = optionalParamList + ['-serverConfig', serverConfigParamList]

        paramList = requiredParamList + optionalParamList

        # Create web server
        server = AdminTask.createWebServer(nodeName, paramList)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return server

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


## Example 8 Delete a server ##
def deleteServer( nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):  
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "deleteServer("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Delete a server
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:   Delete a server on a given node"
        print " Node name:               "+nodeName
        print " Server name:             "+serverName
        print " Usage: AdminServerManagement.deleteServer(\""+nodeName+"\", \""+serverName+"\") "
        print "---------------------------------------------------------------"
        print " Return: None"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Delete server
        result = AdminTask.deleteServer(['-serverName', serverName, '-nodeName', nodeName])

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return result

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


## Example 9 Delete a server template ##
def deleteServerTemplate( templateName, failonerror=AdminUtilities._BLANK_ ):  
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "deleteServerTemplate("+`templateName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Delete server template
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:   Delete a server template"
        print " Template name:           "+templateName
        print " Usage: AdminServerManagement.deleteServerTemplate(\""+templateName+"\") "
        print " Return: None"
        print "---------------------------------------------------------------"
        print " "
        print " "

        if (templateName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateName", templateName]))
        else:
            template = listServerTemplates("", "", templateName)
            # template does not exist
            if (len(template) == 0):
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["templateName", templateName]))
            else:
               for t in template:
                   AdminUtilities.infoNotice("Delete a server template")
                   AdminTask.deleteServerTemplate(t)
               #endFor
            #endIf
        #endIf
        if (AdminUtilities._AUTOSAVE_ == "true"):
           AdminConfig.save()
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
    return 1
#endDef


## Example 10 Start all servers on a given node ##
def startAllServers( nodeName, failonerror=AdminUtilities._BLANK_):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "startAllServers("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Start all servers 
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:   Start all servers"
        print " Node name:               "+nodeName
        print " Usage: AdminServerManagement.startAllServers(\""+nodeName+"\") "
        print " Return: None"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
        else:
            node = AdminConfig.getid("/Node:" +nodeName+"/")
            if (len(node) == 0):
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
            #endIf
        #endIf

        # Retrieve server configuration objects
        servers = AdminConfig.getid("/Node:"+nodeName+"/Server:/")

        if (len(servers) == 0):
           # No servers exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["Server"]))
        else:
           # Convert Jython string to list
           servers = AdminUtilities.convertToList(servers)

           # Start each server in the server lists
           for aServer in servers:
              # Identify server name
              serverName = AdminConfig.showAttribute(aServer,"name")
              nodeagent = AdminControl.queryNames("type=NodeAgent,node="+nodeName+",*")
              if (serverName != "nodeagent"):
                 if (len(nodeagent) == 0):
                    # node agent is not started.  Unable to start server
                    raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["NodegAgent", nodeName]))
                 else:
                    runningServer = AdminControl.queryNames("type=Server,node="+nodeName+",name="+serverName+",*")
                    if (len(runningServer) > 0 and AdminControl.getAttribute(runningServer, "state") == "STARTED"):
                       AdminUtilities.infoNotice("Server " + serverName + " started already")
                    else:
                       AdminUtilities.infoNotice("Start server: " + serverName)
                       AdminControl.startServer(serverName, nodeName)
                    #endIf
                 #endIf
              #endIf
           #endFor
        #endIf
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
    return 1  # succeed
#endDef


## Example 11 Start single server on a given node ##
def startSingleServer( nodeName, serverName, failonerror=AdminUtilities._BLANK_):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "startSingleServer("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Start single server 
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Start single server"
        print " Node name:              "+nodeName
        print " Server name:            "+serverName
        print " Usage: AdminServerManagement.startSingleServer(\""+nodeName+"\", \""+serverName+"\") "
        print " Return: None"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Identify server name
        serverName = AdminConfig.showAttribute(server,"name")

        # Start server
        nodeagent = AdminControl.queryNames("type=NodeAgent,node="+nodeName+",*")
        if (len(nodeagent) == 0):      
           # Node agent is not started.  Unable to start server 
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["NodegAgent", nodeName]))
        else:
           runningServer = AdminControl.queryNames("type=Server,node="+nodeName+",name="+serverName+",*")
           if (len(runningServer) > 0 and AdminControl.getAttribute(runningServer, "state") == "STARTED"):
                # server is running
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6043E", ["Server", serverName]))
           else:
                AdminUtilities.infoNotice("Start server: " + serverName)
                AdminControl.startServer(serverName, nodeName)
           #endIf
        #endIf 
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
    return 1  # succeed
#endDef


## Example 12 Stop all running servers on a given node ##
def stopAllServers( nodeName, failonerror=AdminUtilities._BLANK_):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "stopAllServers("+`nodeName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Stop all running servers 
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:   Stop all servers"
        print " Node name:               "+nodeName
        print " Usage: AdminServerManagement.stopAllServers(\""+nodeName+"\") " 
        print " Return: None"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
        else:
            node = AdminConfig.getid("/Node:" +nodeName+"/")
            if (len(node) == 0):
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
            #endIf
        #endIf

        # Retrieve server configuration objects
        servers = AdminConfig.getid("/Node:"+nodeName+"/Server:/")

        if (len(servers) == 0):
           # No servers exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["Server"]))
        else:
           # Identify the running server MBeans
           runningServers = AdminControl.queryNames("type=Server,node="+nodeName+",processType=ManagedProcess,*")

           if (len(runningServers) == 0):
              # no any server mbeans are running, PI74657 should not raise exception when all servers are stopped
              #raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Server", "Server"]))
              AdminUtilities.infoNotice("Servers were stopped already.")
           else:
              # Convert Jython string to list
              runningServers = AdminUtilities.convertToList(runningServers)

              # Stop each running server in the server list
              for aRunningServer in runningServers:
                 if (len(aRunningServer) > 0):
                    serverName = AdminControl.getAttribute(aRunningServer, "name")
                    AdminUtilities.infoNotice("Stop server: " + serverName)
                    AdminControl.stopServer(serverName, nodeName)
                 #endIf
              #endFor
           #endIf
        #endIf
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
    return 1  # succeed
#endDef


## Example 13 Stop single server on a given node ##
def stopSingleServer( nodeName, serverName, failonerror=AdminUtilities._BLANK_):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "stopSingleServer("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Stop single running server 
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Stop single server"
        print " Node name:              "+nodeName
        print " Server name:            "+serverName
        print " Usage: AdminServerManagement.stopSingleServer(\""+nodeName+"\", \""+serverName+"\") " 
        print " Return: None"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Identify server MBean
        runningServer = AdminControl.queryNames("WebSphere:name="+serverName+",type=Server,node="+nodeName+",processType=ManagedProcess,*")

        # Stop server
        if (len(runningServer) == 0):
           # Server is not running, should not throw exception as server was stopped already
           #raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Server", serverName]))
           AdminUtilities.infoNotice("Server was stopped already " + serverName) 
        else:
           serverName = AdminControl.getAttribute(runningServer, "name")
           AdminUtilities.infoNotice("Stop server: " + serverName)
           AdminControl.stopServer(serverName, nodeName)
        #endIf
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
    return 1  # succeed
#endDef


## Example 14 List JVM properties of a given server ##
def listJVMProperties( nodeName, serverName, JVMProperty, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "listJVMProperties("+`nodeName`+", "+`serverName`+", "+`JVMProperty`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # List Java Virtual Machine (JVM) configuration for a given server and node
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          List JVM properties"
        print " Node name:                      "+nodeName
        print " Server name:                    "+serverName
        print " Optional parameter: "
        print "         JVM Property Name:      "+JVMProperty
        print " Usage: AdminServerManagement.listJVMProperties(\""+nodeName+"\", \""+serverName+"\", \""+JVMProperty+"\") "
        print " Return: The Java virtual machine (JVM) properties of the specified server. If the optional property name parameter is provided, only the JVM property with that name is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Construct required parameters
        requiredParamList = ['-serverName', serverName, '-nodeName', nodeName]

        # Construct optional parameters
        optionalParamList = []
        if (len(JVMProperty) != 0):
           optionalParamList = ['-propertyName', JVMProperty]

        paramList = requiredParamList + optionalParamList

        # Show JVMProperties
        property = AdminTask.showJVMProperties(paramList)

        # Convert Jython String to list
        property = AdminUtilities.convertToList(property)

        return property
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


## Example 15 Show server information of a given server ##
def showServerInfo( nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "showServerInfo("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Show server information for a given server and node
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Show server infomation JVM properties"
        print " Node name:                  "+nodeName
        print " Server name:                "+serverName
        print " Usage: AdminServerManagement.showServerInfo(\""+nodeName+"\", \""+serverName+"\") "
        print " Return: The server information for the specified server including the product version, server type, and cell name."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Show server information
        serverInfo = AdminTask.showServerInfo(server)

        # Convert Jython string to list
        serverInfo = AdminUtilities.convertToList(serverInfo)

        return serverInfo
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


## Example 16 Get Java home value of a given server##
def getJavaHome( nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "getJavaHome("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Get Java Home value
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Get Java home value"
        print " Node name:              "+nodeName
        print " Server name:            "+serverName
        print " Usage: AdminServerManagement.getJavaHome(\""+nodeName+"\", \""+serverName+"\") "
        print " Return: The Java Home value for the specified server."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Get Java Home value
        javaHome = AdminTask.getJavaHome(['-serverName', serverName, '-nodeName', nodeName])

        return javaHome
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

 
## Example 17 Set JVM properties to a given server ##
def setJVMProperties( nodeName, serverName, classpath, bootClasspath, initHeapsize, maxHeapsize, debugMode, debugArgs, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "setJVMProperties("+`nodeName`+", "+`serverName`+", "+`classpath`+", "+`bootClasspath`+", "+`initHeapsize`+", "+`maxHeapsize`+", "+`debugMode`+", "+`debugArgs`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Set JVM properties
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Set Java virtual machine (JVM) properties"
        print " Node name:                      "+nodeName
        print " Server name:                    "+serverName
        print " Optional parameters: "
        print "         Classpath:              "+classpath
        print "         Boot class path:        "+bootClasspath
        print "         Initial heap size:      "+initHeapsize
        print "         Maximum heap size:      "+maxHeapsize
        print "         Debug mode:             "+debugMode
        print "         Debug parameters:        "+debugArgs
        print " Usage: AdminServerManagement.setJVMProperties(\""+nodeName+"\", \""+serverName+"\", \""+classpath+"\", \""+bootClasspath+"\", \""+initHeapsize+"\", \""+maxHeapsize+"\", \""+debugMode+"\", \""+debugArgs+"\") "
        print " Return: If the command is successful, a true value is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        # Construct required parameters
        requiredParamList = ['-serverName', serverName, '-nodeName', nodeName]
                
        # Construct optional parameters
        optionalParamList = []
        if (len(classpath) != 0):
           optionalParamList = ['-classpath', classpath]
        if (len(bootClasspath) != 0):
           optionalParamList = optionalParamList + ['-bootClasspath', bootClasspath]
        if (len(initHeapsize) != 0):
           optionalParamList = optionalParamList + ['-initialHeapSize', initHeapsize]
        if (len(maxHeapsize) != 0):
           optionalParamList = optionalParamList + ['-maximumHeapSize', maxHeapsize]
        if (len(debugMode) != 0):
           optionalParamList = optionalParamList + ['-debugMode', debugMode]
        if (len(debugArgs) != 0):
           optionalParamList = optionalParamList + ['-debugArgs', debugArgs]
        paramList = requiredParamList + optionalParamList       

        # Set JVM properties
        result = AdminTask.setJVMProperties(paramList)
        
        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return result
    
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


## Example 18 Set the trace specification for the given server ##
def setTraceSpecification( nodeName, serverName, traceSpec, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "setTraceSpecification("+`nodeName`+", "+`serverName`+", "+`traceSpec`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Set trace specification for the server
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Set trace specification"
        print " Node name:              "+nodeName
        print " Server name:            "+serverName
        print " Trace specification:    "+traceSpec
        print " Usage: AdminServerManagement.setTraceSpecification(\""+nodeName+"\", \""+serverName+"\", \""+traceSpec+"\") "
        print " Return: If the command is successful, a true value is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           # node does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) == 0):
           # server does not exist
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
        #endIf

        if (traceSpec == ""):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["traceSpec", traceSpec]))

        # Set trace specification
        result = AdminTask.setTraceSpecification(['-serverName', serverName, '-nodeName', nodeName, '-traceSpecification', traceSpec])

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return result

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


## Example 19 Check if server exists ##
def checkIfServerExists ( nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "checkIfServerExists("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "
        
    try:
        #--------------------------------------------------------------------
        # Check if server exists
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Check if server exists"
        print " Node name:              "+nodeName
        print " Server name:            "+serverName
        print " Usage: AdminServerManagement.checkIfServerExists(\""+nodeName+"\", \""+serverName+"\")"
        print " Return: If the server exists, a true value is returned. Otherwise, a false value is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "
        serverExists = "false"

        # Check the required parameters
        if (nodeName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (serverName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # Check if node exists
        node = AdminConfig.getid("/Node:" +nodeName+"/")
        if (len(node) == 0):
           raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
        #endIf

        # Check if server exists
        server = AdminConfig.getid("/Node:" +nodeName+"/Server:"+serverName+"/")
        if (len(server) > 0):
           serverExists = "true"
        #endIf

        return serverExists
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


## Example 20 Check if server template exists ##
def checkIfServerTemplateExists ( templateName, failonerror=AdminUtilities._BLANK_ ):
    if (failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "checkIfServerTemplateExists("+`templateName`+", "+`failonerror`+"): "
        
    try:
        #--------------------------------------------------------------------
        # Check if server template exists
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Check if server template exists"
        print " Template name:          "+templateName
        print " Usage: AdminServerManagement.checkIfServerTemplateExists(\""+templateName+"\")"
        print " Return: If the server template exists, a true value is returned. Otherwise, a false value is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "
        serverTemplateExists = "false"
        # Check the required parameters
        if (templateName == ""):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["templateName", templateName]))

        templates = listServerTemplates("", "", templateName)
        if (len(templates) > 0):
            for t in templates:
                tname = AdminConfig.showAttribute(t, "name")
                if (tname == templateName):
                   AdminUtilities.infoNotice("Found server template: " + templateName)
                   serverTemplateExists = "true"
            #endFor
        #endIf
        return serverTemplateExists
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


# LIDB4362-82.1 start
## Example 21 Configure java process definition ##
def configureProcessDefinition(nodeName, serverName, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureProcessDefinition("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configure Java process definition
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configure java process definition"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " Optional Attributes:"
        print "     otherAttributesList          %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureProcessDefintion(\""+nodeName+"\", \""+serverName+"\")"
        else:
            print " Usage: AdminServerManagement.configureProcessDefintion(\""+nodeName+"\", \""+serverName+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a true value is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredParams = ["-nodeName", nodeName, "-serverName", serverName]
        otherParamList = []
        for attrs in otherAttrList:
            attr = ["-"+attrs[0], attrs[1]]
            #print attr
            otherParamList = otherParamList+attr

        #print otherParamList
        finalParams = requiredParams+otherParamList
        #print finalParams

        result = AdminTask.setProcessDefinition(finalParams)

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
            return -1
        else:
            return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 22 Configure end points host ##
def configureEndPointsHost(nodeName, serverName, hostName, failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureEndPointsHost("+`nodeName`+", "+`serverName`+", "+`hostName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configure end points hostname
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configure server end points hostname"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " hostName:                       "+hostName
        print " Usage: AdminServerManagement.configureEndPointsHost(\""+nodeName+"\", \""+serverName+"\", \""+hostName+"\")"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(hostName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["hostName", hostName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        nodeID = AdminConfig.getid("/Node:"+nodeName+"/")
        serverIndex = AdminConfig.list("ServerIndex", nodeID)
        serverEntries = AdminConfig.list("ServerEntry", serverIndex)
        serverEntryList = AdminUtilities.convertToList(serverEntries)
        for serverEntry in serverEntryList:
            seName = AdminConfig.showAttribute(serverEntry, "serverName")
            if (seName == serverName):
                namedEndPoints = AdminConfig.list("NamedEndPoint", serverEntry)
                namedEndPointList = AdminUtilities.convertToList(namedEndPoints)
                for namedEndPoint in namedEndPointList:
                    endPoint = AdminConfig.showAttribute(namedEndPoint, "endPoint")
                    AdminConfig.modify(endPoint, [["host", hostName]])

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 23: Configure application server classloader #
def configureApplicationServerClassloader(nodeName, serverName, policy, mode, libraryName, failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureApplicationServerClassloader("+`nodeName`+", "+`serverName`+", "+`policy`+", "+`mode`+", "+`libraryName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configure ApplicationServer Classloader
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configure ApplicationServer classloader"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " policy:                         "+policy
        print " mode:                           "+mode
        print " libraryName:                    "+libraryName
        print " Usage: AdminServerManagement.configureApplicationServerClassloader(\""+nodeName+"\", \""+serverName+"\", \""+policy+"\", \""+mode+"\", \""+libraryName+"\")"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(policy) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["policy", policy]))

        if (len(mode) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mode", mode]))

        if (len(libraryName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["libraryName", libraryName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["applicationClassLoaderPolicy", policy], ["applicationClassLoadingMode", mode]]

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        apss = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ApplicationServer:"+"/")
        apsList = AdminUtilities.convertToList(apss)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        aps = AdminUtilities._BLANK_
        if (len(apsList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["ApplicationServer"]))
            return -1
        if (len(apsList) == 1):
            aps = apsList[0]
            AdminConfig.modify(aps, requiredAttrs)
        if (len(apsList) == 0):
            aps = AdminConfig.create("ApplicationServer", server, requiredAttrs)

        # get Classloader
        cls = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ApplicationServer:"+"/Classloader:/")
        clList = AdminUtilities.convertToList(cls)
        if (len(clList) == 0):
            cl = AdminConfig.create("Classloader", aps, [["mode", mode]])
            lib = AdminConfig.create("LibraryRef", cl, [["libraryName", libraryName]])
        else:
            # modify all the Classloader under this ApplicationServer
            for cl in clList:
                AdminConfig.modify(cl, [["mode", mode]])
                # get LibraryRef
                libs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ApplicationServer:"+"/Classloader:/LibraryRef:/")
                libList = AdminUtilities.convertToList(libs)
                if (len(libList) == 0):
                    lib = AdminConfig.create("LibraryRef", cl, [["libraryName", libraryName]])
                else:
                    libFound = "false"
                    for lib in libList:
                        libName = AdminConfig.showAttribute(lib, "libraryName")
                        if (libName == libraryName):
                            libFound = "true"
                    if (libFound == "false"):
                        lib = AdminConfig.create("LibraryRef", cl, [["libraryName", libraryName]])

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(aps)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 24: Query mbeans
def queryMBeans(nodeName, serverName, mbeanType, failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "queryMBeans("+`nodeName`+", "+`serverName`+", "+`mbeanType`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Querying MBeans
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Query MBeans"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " mbeanType:                      "+mbeanType
        print " Usage: AdminServerManagement.queryMBeans(\""+nodeName+"\", \""+serverName+"\", \""+mbeanType+"\")"
        print " Return: List of the ObjectName values of the specified type on the specified server."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(mbeanType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["mbeanType", mbeanType]))

        mbeans = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type="+mbeanType+",*")
        mbeanList = AdminUtilities.convertToList(mbeans)
        return mbeanList
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 25: View product information
def viewProductInformation(failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "viewProductInformation(): "

    try:
        #--------------------------------------------------------------------
        # Viewing product information
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Showing server version"
        print " Usage: AdminServerManagement.viewProductInformation()"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        serverMBeans = AdminControl.queryNames("type=Server,*")
        serverMBeanList = AdminUtilities.convertToList(serverMBeans)

        # check if the mbean will be used is running
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(serverMBeanList) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Server", "Server"]))

        result = AdminControl.getAttribute(serverMBeanList[0], "serverVersion") 
        print result
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 26: get server pid
def getServerPID(nodeName, serverName, failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "getServerPID("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Get Server PID
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Get server PID"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " Usage: AdminServerManagement.getServerPID(\""+nodeName+"\", \""+serverName+"\")"
        print " Return: The process ID of the specified server."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))


        serverMBean = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=Server,*")
        # check if the mbean will be used is running
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(serverMBean) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Server", serverName]))

        else:
            result = AdminControl.getAttribute(serverMBean, "pid") 
            return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 27: get server processType
def getServerProcessType(nodeName, serverName, failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "getServerProcessType("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Get Server process type
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Get server process type"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " Usage: AdminServerManagement.getServerProcessType(\""+nodeName+"\", \""+serverName+"\")"
        print " Return: The process type of the specified server."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        serverMBean = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=Server,*")

        # check if the mbean will be used is running
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(serverMBean) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Server", serverName]))
        else:
            result = AdminControl.getAttribute(serverMBean, "processType") 
            return result
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 28: Configure Trace Service
def configureTraceService(nodeName, serverName, traceString, outputType, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureTraceService("+`nodeName`+", "+`serverName`+", "+`traceString`+", "+`outputType`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring Trace Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Configuring TraceService"
        print " nodeName:                   "+nodeName
        print " serverName:                 "+serverName
        print " startupTraceSpecification:  "+traceString
        print " Optional Parameter:"
        print " traceOutputType:            "+outputType
        print " Optional Attributes:"
        print "     otherAttributeList      %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureTraceService(\""+nodeName+"\", \""+serverName+"\", \""+traceString+"\", \""+outputType+"\")"
        else:
            print " Usage: AdminServerManagement.configureTraceService(\""+nodeName+"\", \""+serverName+"\", \""+traceString+"\", \""+outputType+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(traceString) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["traceString", traceString]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["startupTraceSpecification", traceString]]

        # Construct optional parameters
        optionalParamList = []
        if (len(outputType) != 0):
            optionalParamList = optionalParamList + [["traceOutputType", outputType]]

        finalAttrs = requiredAttrs+optionalParamList+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        tss = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/TraceService:/")
        tsList = AdminUtilities.convertToList(tss)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ts = AdminUtilities._BLANK_
        if (len(tsList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["TraceService"]))
            return -1
        if (len(tsList) == 1):
            ts = tsList[0]
            AdminConfig.modify(ts, finalAttrs)
        if (len(tsList) == 0):
            ts = AdminConfig.create("TraceService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ts)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 29: Configure JavaVirtualMachine
def configureJavaVirtualMachine(jvmConfigID, debugMode, debugArgs, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureJavaVirtualMachine("+`jvmConfigID`+", "+`debugMode`+", "+`debugArgs`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring JavaVirtualMachine
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configuring JavaVirtualMachine"
        print " JavaVirtualMachine configID:    "+jvmConfigID
        print " debugMode:                      "+debugMode
        print " debugArgs:                      "+debugArgs
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureJavaVirtualMachine(\""+jvmConfigID+"\", \""+debugMode+"\", \""+debugArgs+"\")"
        else:
            print " Usage: AdminServerManagement.configureJavaVirtualMachine(\""+jvmConfigID+"\", \""+debugMode+"\", \""+debugArgs+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(jvmConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JavaVirtualMachine configID", jvmConfigID]))

        if (len(debugMode) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["debugMode", debugMode]))

        if (len(debugArgs) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["debugArgs", debugArgs]))

        # contruct required attributes
        requiredAttrs = [["debugMode", debugMode], ["debugArgs", debugArgs]]
        finalAttrs = requiredAttrs+otherAttrList

        AdminConfig.modify(jvmConfigID, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(jvmConfigID)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 30: Configure ServerLogs
def configureServerLogs(nodeName, serverName, logRoot, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureServerLogs("+`nodeName`+", "+`serverName`+", "+`logRoot`+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring ServerLogs
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring server logs"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " serverLogRoot:          "+logRoot
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureServerLogs(\""+nodeName+"\", \""+serverName+"\", \""+logRoot+"\")"
        else:
            print " Usage: AdminServerManagement.configureServerLogs(\""+nodeName+"\", \""+serverName+"\", \""+logRoot+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(logRoot) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["logRoot", logRoot]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        osRequiredAttrs = [["fileName", logRoot+"/SystemOut.log"]]
        osFinalAttrs = osRequiredAttrs+otherAttrList
        esRequiredAttrs = [["fileName", logRoot+"/SystemErr.log"]]
        esFinalAttrs = esRequiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")

        osd = AdminConfig.showAttribute(server, "outputStreamRedirect")
        if (osd != None):
            osdList = AdminUtilities.convertToList(osd)
        else:
            osdList = []
        outputStream = AdminUtilities._BLANK_
        errorStream = AdminUtilities._BLANK_

        if (len(osdList) == 0):
            outputStream = AdminConfig.create("StreamRedirect", server, osFinalAttrs, "outputStreamRedirect")
        if (len(osdList) == 1):
            outputStream = osdList[0]
            AdminConfig.modify(outputStream, osFinalAttrs)
        if (len(osdList) > 1):
            # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["OutputStreamRedirect"]))

        esd = AdminConfig.showAttribute(server, "errorStreamRedirect")
        if (esd != None):
            esdList = AdminUtilities.convertToList(esd)
        else:
            esdList = []
        if (len(esdList) == 0):
            errorStream = AdminConfig.create("StreamRedirect", server, esFinalAttrs, "errorStreamRedirect")
        if (len(esdList) == 1):
            errorStream = esdList[0]
            AdminConfig.modify(errorStream, esFinalAttrs)
        if (len(esdList) > 1):
            # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["ErrorStreamRedirect"]))

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(outputStream)
        print AdminConfig.showall(errorStream)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 31: Configure JavaProcessLogs
def configureJavaProcessLogs(jpdConfigID, logRoot, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureJavaProcessLogs("+`jpdConfigID`+", "+`logRoot`+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring JavaProcessLogs
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:            Configuring java process logs"
        print " JavaProcessDef configID:        "+jpdConfigID
        print " processLogRoot:                 "+logRoot
        print " Optional Attributes:"
        print "     otherAttributeList  %s"     % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureJavaProcessLogs(\""+jpdConfigID+"\", \""+logRoot+"\")"
        else:
            print " Usage: AdminServerManagement.configureJavaProcessLogs(\""+jpdConfigID+"\", \""+logRoot+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(jpdConfigID) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["JavaProcessDef configID", jpdConfigID]))

        if (len(logRoot) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["logRoot", logRoot]))

        # contruct required attributes
        requiredAttrs = [["stderrFilename", logRoot+"/native_stderr.log"], ["stdoutFilename", logRoot+"/native_stdout.log"]]
        finalAttrs = requiredAttrs+otherAttrList

        ors = AdminConfig.list("OutputRedirect", jpdConfigID)
        orList = AdminUtilities.convertToList(ors)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration
        ord = AdminUtilities._BLANK_
        if (len(orList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["OutputRedirect"]))
            return -1
        if (len(orList) == 1):
            ord = orList[0]
            AdminConfig.modify(ord, finalAttrs)
        if (len(orList) == 0):
            ord = AdminConfig.create("OutputRedirect", jpdConfigID, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ord)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 32: Configure RASLogging Service
def configureRASLoggingService(nodeName, serverName, logRoot, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureRASLoggingService("+`nodeName`+", "+`serverName`+", "+`logRoot`+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring RASLogging Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring RAS logging service"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " processLogRoot:         "+logRoot
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureRASLoggingService(\""+nodeName+"\", \""+serverName+"\", \""+logRoot+"\")"
        else:
            print " Usage: AdminServerManagement.configureRASLoggingService(\""+nodeName+"\", \""+serverName+"\", \""+logRoot+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(logRoot) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["logRoot", logRoot]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["name", logRoot+"/activity.log"]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")    
        rass = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/RASLoggingService:/")
        rasList = AdminUtilities.convertToList(rass)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ras = AdminUtilities._BLANK_
        if (len(rasList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["RASLoggingService"]))
        if (len(rasList) == 1):
            ras = rasList[0]
        if (len(rasList) == 0):
            ras = AdminConfig.create("RASLoggingService", server, [])

        sls = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/RASLoggingService:/ServiceLog:/")
        slList = AdminUtilities.convertToList(sls)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        sl = AdminUtilities._BLANK_
        if (len(slList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["ServiceLog"]))
            return -1
        if (len(slList) == 1):
            sl = slList[0]
            AdminConfig.modify(sl, finalAttrs)
        if (len(slList) == 0):
            sl = AdminConfig.create("ServiceLog", ras, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ras)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 33: Configure PerformanceMonitoring Service
def configurePerformanceMonitoringService(nodeName, serverName, enable, initialSpecLevel, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configurePerformanceMonitoringService("+`nodeName`+", "+`serverName`+", "+`enable`+", "+`initialSpecLevel`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring AdminService
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring PerformanceMonitoring service"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " enable:                 "+enable
        print " initialSpecLevel:       "+initialSpecLevel
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
           print " Usage: AdminServerManagement.configurePerformanceMonitoringService(\""+nodeName+"\", \""+serverName+"\", \""+enable+"\", \""+initialSpecLevel+"\")"
        else:
           print " Usage: AdminServerManagement.configurePerformanceMonitoringService(\""+nodeName+"\", \""+serverName+"\", \""+enable+"\", \""+initialSpecLevel+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(enable) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enable", enable]))

        if (len(initialSpecLevel) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["initialSpecLevel", initialSpecLevel]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["enable", enable], ["initialSpecLevel", initialSpecLevel]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        pmis = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/PMIService:/")
        pmiList = AdminUtilities.convertToList(pmis)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        pmi = AdminUtilities._BLANK_
        if (len(pmiList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["PMIService"]))
        if (len(pmiList) == 1):
            pmi = pmiList[0]
            AdminConfig.modify(pmi, finalAttrs)
        if (len(pmiList) == 0):
            pmi = AdminConfig.create("PMIService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(pmi)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 34: Configure PMIRequestMetrics
def configurePMIRequestMetrics(enable, traceLevel, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configurePMIRequestMetrics("+`enable`+", "+`traceLevel`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring AdminService
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring PMIRequestMetrics"
        print " enable:                 "+enable
        print " traceLevel:             "+traceLevel
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configurePMIRequestMetrics(\""+enable+"\", \""+traceLevel+"\")"
        else:
            print " Usage: AdminServerManagement.configurePMIRequestMetrics(\""+enable+"\", \""+traceLevel+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(enable) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enable", enable]))

        if (len(traceLevel) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["traceLevel", traceLevel]))

        # contruct required attributes
        requiredAttrs = [["enable", enable], ["traceLevel", traceLevel]]
        finalAttrs = requiredAttrs+otherAttrList

        cellID = AdminConfig.list("Cell")
        cellName = AdminConfig.showAttribute(cellID, "name")
        pmirms = AdminConfig.getid("/Cell:"+cellName+"/PMIRequestMetrics:/")
        pmirmList = AdminUtilities.convertToList(pmirms)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        pmirm = AdminUtilities._BLANK_
        if (len(pmirmList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["PMIRequestMetrics"]))
        if (len(pmirmList) == 1):
            pmirm = pmirmList[0]
            AdminConfig.modify(pmirm, finalAttrs)
        if (len(pmirmList) == 0):
            pmirm = AdminConfig.create("PMIRequestMetrics", cellID, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(pmirm)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 35: Configure runtime transaction service
def configureRuntimeTransactionService(nodeName, serverName, totalTranLifetimeTimeout, clientInactivityTimeout, failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureRuntimeTransactionService("+`nodeName`+", "+`serverName`+", "+`totalTranLifetimeTimeout`+", "+`clientInactivityTimeout`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring RuntimeTransaction Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:           Configuring RuntimeTransactionService"
        print " nodeName:                        "+nodeName
        print " serverName:                      "+serverName
        print " totalTranLifetimeTimeout:       %s" % (totalTranLifetimeTimeout)
        print " clientInactivityTimeout:        %s" % (clientInactivityTimeout)
        print " Usage: AdminServerManagement.configureRuntimeTransactionService(\""+nodeName+"\", \""+serverName+"\", \""+`totalTranLifetimeTimeout`+"\", \""+`clientInactivityTimeout`+"\")"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        tsMBean = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=TransactionService,*")

        # check if the mbean will be used is running
        # WASL6044E=WASL6044E: The {0}:{1} mbean is not running.
        if (len(tsMBean) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["TransactionService", serverName]))
        else:
            attrs = [["totalTranLifetimeTimeout", totalTranLifetimeTimeout], ["clientInactivityTimeout", clientInactivityTimeout]]
            AdminControl.setAttributes(tsMBean, attrs) 
            return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 36: Configure EJB container
def configureEJBContainer(nodeName, serverName, passivationDir, defaultDatasourceJNDIName, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureEJBContainer("+`nodeName`+", "+`serverName`+", "+`passivationDir`+", "+`defaultDatasourceJNDIName`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring EJBContainer
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Configuring EJBContainer"
        print " nodeName:                   "+nodeName
        print " serverName:                 "+serverName
        print " passivationDirectory:       "+passivationDir
        print " defaultDatasourceJNDIName:  "+defaultDatasourceJNDIName
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureEJBContainer(\""+nodeName+"\", \""+serverName+"\", \""+passivationDir+"\", \""+defaultDatasourceJNDIName+"\")"
        else:
            print " Usage: AdminServerManagement.configureEJBContainer(\""+nodeName+"\", \""+serverName+"\", \""+passivationDir+"\", \""+defaultDatasourceJNDIName+"\", %s)"% (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(passivationDir) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["passivationDir", passivationDir]))

        if (len(defaultDatasourceJNDIName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["defaultDatasourceJNDIName", defaultDatasourceJNDIName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["passivationDirectory", passivationDir], ["defaultDatasourceJNDIName", defaultDatasourceJNDIName]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        ejbs = AdminConfig.list("EJBContainer", server)
        ejbList = AdminUtilities.convertToList(ejbs)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ejb = AdminUtilities._BLANK_
        if (len(ejbList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["EJBContainer"]))
        if (len(ejbList) == 1):
            ejb = ejbList[0]
            AdminConfig.modify(ejb, finalAttrs)
        if (len(ejbList) == 0):
            ejb = AdminConfig.create("EJBContainer", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ejb)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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

# Example 37: Configure dynamic cache
def configureDynamicCache(nodeName, serverName, defaultPriority, cacheSize, externalCacheGroupName, externalCacheGroupType, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureDynamicCache("+`nodeName`+", "+`serverName`+", "+`defaultPriority`+", "+`cacheSize`+", "+externalCacheGroupName+", "+externalCacheGroupType+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring DynamicCache
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Configuring DynamicCache"
        print " nodeName:                   "+nodeName
        print " serverName:                 "+serverName
        print " defaultPriority:            %s" % (defaultPriority)
        print " cacheSize:                  %s" % (cacheSize)
        print " externalCacheGroupName      "+externalCacheGroupName
        print " externalCacheGroupType      "+externalCacheGroupType
        print " Optional Attributes:"
        print "     otherAttributeList      %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureDynamicCache(\""+nodeName+"\", \""+serverName+"\", \""+`defaultPriority`+"\", \""+`cacheSize`+"\", \""+externalCacheGroupName+"\", \""+externalCacheGroupType+"\")"
        else:
            print " Usage: AdminServerManagement.configureDynamicCache(\""+nodeName+"\", \""+serverName+"\", \""+`defaultPriority`+"\", \""+`cacheSize`+"\", \""+externalCacheGroupName+"\", \""+externalCacheGroupType+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(externalCacheGroupName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["externalCacheGroupName", externalCacheGroupName]))

        if (len(externalCacheGroupType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["externalCacheGroupType", externalCacheGroupType]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["defaultPriority", defaultPriority], ["cacheSize", cacheSize]]
        finalAttrs = requiredAttrs+otherAttrList
        ecgAttrs = [["name", externalCacheGroupName], ["type", externalCacheGroupType]]

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        dcs = AdminConfig.list("DynamicCache", server)
        dcList = AdminUtilities.convertToList(dcs)
        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        dc = AdminUtilities._BLANK_
        if (len(dcList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["DynamicCache"]))
        if (len(dcList) == 1):
            dc = dcList[0]
            AdminConfig.modify(dc, finalAttrs)
            ecgs = AdminConfig.list("ExternalCacheGroup", dc)
            ecgList = AdminUtilities.convertToList(ecgs)
            if (len(ecgList) == 0):
                AdminConfig.create("ExternalCacheGroup", dc, ecgAttrs)
            else:
                ecgFound = "false"
                for ecg in ecgList:
                    ecgName = AdminConfig.showAttribute(ecg, "name")
                    if (ecgName == externalCacheGroupName):
                        ecgFound = "true"
                        AdminConfig.modify(ecg, ecgAttrs)

                if (ecgFound == "false"):
                    AdminConfig.create("ExternalCacheGroup", dc, ecgAttrs)

        if (len(dcList) == 0):
            dc = AdminConfig.create("DynamicCache", server, finalAttrs)
            # and creating the new ExternalCacheGroup
            AdminConfig.create("ExternalCacheGroup", dc, ecgAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(dc)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 38: Configure message listener service
def configureMessageListenerService(nodeName, serverName, maxListenerRetry, listenerRecoveryInterval, poolingThreshold, poolingTimeout, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureMessageListenerService("+`nodeName`+", "+`serverName`+", "+`maxListenerRetry`+", "+`listenerRecoveryInterval`+", "+`poolingThreshold`+", "+`poolingTimeout`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring MessageListener Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Configuring MessageListenerService"
        print " nodeName:                   "+nodeName
        print " serverName:                 "+serverName
        print " maxListenerRetry:           %s" % (maxListenerRetry)
        print " listenerRecoveryInterval:   %s" % (listenerRecoveryInterval)
        print " poolingThreashold:          %s" % (poolingThreshold)
        print " poolingTimeout:             %s" % (poolingTimeout)
        print " Optional Attributes:"
        print "     otherAttributeList      %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureMessageListenerService(\""+nodeName+"\", \""+serverName+"\", \""+`maxListenerRetry`+"\", \""+`listenerRecoveryInterval`+"\", \""+`poolingThreshold`+"\", \""+`poolingTimeout`+"\")"
        else:
            print " Usage: AdminServerManagement.configureMessageListenerService(\""+nodeName+"\", \""+serverName+"\", \""+`maxListenerRetry`+"\", \""+`listenerRecoveryInterval`+"\", \""+`poolingThreshold`+"\", \""+`poolingTimeout`+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["maxMDBListenerRetries", maxListenerRetry], ["mdbListenerRecoveryInterval", listenerRecoveryInterval], ["mqJMSPoolingThreshold", poolingThreshold], ["mqJMSPoolingTimeout", poolingTimeout]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        mls = AdminConfig.list("MessageListenerService", server)
        mlList = AdminUtilities.convertToList(mls)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ml = AdminUtilities._BLANK_
        if (len(mlList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["MessageListenerService"]))
        if (len(mlList) == 1):
            ml = mlList[0]
            AdminConfig.modify(ml, finalAttrs)
        if (len(mlList) == 0):
            ml = AdminConfig.create("MessageListenerService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ml)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 39: Configure listener port for message listener service
def configureListenerPortForMessageListenerService(nodeName, serverName, lpName, connFactoryJNDIName, destJNDIName, maxMessages, maxRetries, maxSessions, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureListenerPortForMessageListenerService("+`nodeName`+", "+`serverName`+", "+`lpName`+", "+`connFactoryJNDIName`+", "+`destJNDIName`+", "+`maxMessages`+", "+`maxRetries`+", "+`maxSessions`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring ListenerPort for MessageListener Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Configuring ListenerPort for MessageListenerService"
        print " nodeName:                   "+nodeName
        print " serverName:                 "+serverName
        print " listenerPortName:           "+lpName
        print " connectionFactoryJNDIName:  "+connFactoryJNDIName
        print " destinationJNDIName:        "+destJNDIName
        print " maxMessages:                %s" % (maxMessages)
        print " maxRetries:                 %s" % (maxRetries)
        print " maxSession:                 %s" % (maxSessions)
        print " Usage: AdminServerManagement.configureListenerPortForMessageListenerService(\""+nodeName+"\", \""+serverName+"\", \""+lpName+"\", \""+connFactoryJNDIName+"\", \""+destJNDIName+"\", \""+`maxMessages`+"\", \""+`maxRetries`+"\", \""+`maxSessions`+"\")"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(lpName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["lpName", lpName]))

        if (len(connFactoryJNDIName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["connFactoryJNDIName", connFactoryJNDIName]))

        if (len(destJNDIName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["destJNDIName", destJNDIName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["name", lpName], ["connectionFactoryJNDIName", connFactoryJNDIName], ["destinationJNDIName", destJNDIName], ["maxMessages", maxMessages], ["maxRetries", maxRetries], ["maxSessions", maxSessions]]

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        mls = AdminConfig.list("MessageListenerService", server)
        mlList = AdminUtilities.convertToList(mls)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ml = AdminUtilities._BLANK_
        if (len(mlList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["MessageListenerService"]))
        if (len(mlList) == 1):
            ml = mlList[0]
            # get ListenerPort
            lps = AdminConfig.list("ListenerPort", ml)
            lpList = AdminUtilities.convertToList(lps)
            if (len(lpList) == 0):
                AdminConfig.create("ListenerPort", ml, requiredAttrs)
            else:
                lpFound = "false"
                for lp in lpList:
                    lpNm = AdminConfig.showAttribute(lp, "name")
                    if (lpNm == lpName):
                        lpFound = "true"
                        AdminConfig.modify(lp, requiredAttrs)

                if (lpFound == "false"):
                    AdminConfig.create("ListenerPort", ml, requiredAttrs)
        if (len(mlList) == 0):
            ml = AdminConfig.create("MessageListenerService", server, [])
            AdminConfig.create("ListenerPort", ml, requiredAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ml)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 40: Configure thread pool 
def configureThreadPool(nodeName, serverName, parentType, tpName, maxSize, minSize, inactivityTimeout, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureThreadPool("+`nodeName`+", "+`serverName`+", "+`parentType`+", "+`maxSize`+", "+`minSize`+", "+`inactivityTimeout`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring ThreadPool
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring ThreadPool"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " parentType:             "+parentType
        print " threadPoolName:         "+tpName
        print " maximumSize:            %s" % (maxSize)
        print " minimumSize:            %s" % (minSize)
        print " inactivityTimeout:      %s" % (inactivityTimeout)
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureThreadPool(\""+nodeName+"\", \""+serverName+"\", \""+parentType+"\", \""+tpName+"\", \""+`maxSize`+"\", \""+`minSize`+"\", \""+`inactivityTimeout`+"\")"
        else:
            print " Usage: AdminServerManagement.configureThreadPool(\""+nodeName+"\", \""+serverName+"\", \""+parentType+"\", \""+tpName+"\", \""+`maxSize`+"\", \""+`minSize`+"\", \""+`inactivityTimeout`+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(parentType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["parentType", parentType]))

        if (len(tpName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["tpName", tpName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["name", tpName], ["maximumSize", maxSize], ["minimumSize", minSize], ["inactivityTimeout", inactivityTimeout]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        parents = AdminConfig.list(parentType, server)
        parentList = AdminUtilities.convertToList(parents)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        # WASL6047E=WASL6047E: Object of type {0} does not exist. 
        parent = AdminUtilities._BLANK_
        tp = AdminUtilities._BLANK_
        if (len(parentList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", [parentType]))
        if (len(parentList) == 1):
            parent = parentList[0]
            # get the ThreadPool
            tps = AdminConfig.list("ThreadPool", parent)
            tpList = AdminUtilities.convertToList(tps)

            # check if there is more then one exists
            if (len(tpList) == 0):
                tp = AdminConfig.create("ThreadPool", parent, finalAttrs)
            else:
                tpFound = "false"
                for t in tpList:
                    tpNm = AdminConfig.showAttribute(t, "name")
                    if (tpNm == tpName):
                        tp = t
                        AdminConfig.modify(t, finalAttrs)
                        tpFound = "true"
                        break

                if (tpFound == "false"):
                    tp = AdminConfig.create("ThreadPool", parent, finalAttrs)

        if (len(parentList) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6047E", [parentType]))

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(tp)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 41: Configure state manageable
def configureStateManageable(nodeName, serverName, parentType, initialState, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureStateManageable("+`nodeName`+", "+`serverName`+", "+`parentType`+", "+`initialState`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring StateManageable
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring StateManageable"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " parentType:             "+parentType
        print " initialState:           "+initialState
        print " Usage: AdminServerManagement.configureStateManageable(\""+nodeName+"\", \""+serverName+"\", \""+parentType+"\", \""+initialState+"\")"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(parentType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["parentType", parentType]))

        if (len(initialState) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["initialState", initialState]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["initialState", initialState]]

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        parents = AdminConfig.list(parentType, server)
        parentList = AdminUtilities.convertToList(parents)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        # WASL6047E=WASL6047E: Object of type {0} does not exist. 
        parent = AdminUtilities._BLANK_
        sm = AdminUtilities._BLANK_
        if (len(parentList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", [parentType]))
        if (len(parentList) == 1):
            parent = parentList[0]
            sms = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/"+parentType+":/StateManageable:/")
            smList = AdminUtilities.convertToList(sms)

            # check if there is more then one exists
            if (len(smList) > 1):
                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["StateManageable"]))
            if (len(smList) == 1):
                sm = smList[0]
                AdminConfig.modify(sm, requiredAttrs)
            if (len(smList) == 0):
                sm = AdminConfig.create("StateManageable", parent, requiredAttrs)

        if (len(parentList) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6047E", [parentType]))

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(sm)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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
 

# Example 42: Configure object request broker service
def configureORBService(nodeName, serverName, requestTimeout, requestRetriesCount, requestRetriesDelay, connCacheMax, connCacheMin, locateRequestTimeout, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureORBService("+`nodeName`+", "+`serverName`+", "+`requestTimeout`+", "+`requestRetriesCount`+", "+`requestRetriesDelay`+", "+`connCacheMax`+", "+`connCacheMin`+", "+`locateRequestTimeout`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring Object Request Broker Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring ORBService"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " requestTimeout:         %s" % (requestTimeout)
        print " requestRetriesCount:    %s" % (requestRetriesCount)
        print " requestRetriesDelay:    %s" % (requestRetriesDelay)
        print " connectionCacheMax:     %s" % (connCacheMax)
        print " connectionCacheMin:     %s" % (connCacheMin)
        print " locateRequestTimeout:   %s" % (locateRequestTimeout)
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureORBService(\""+nodeName+"\", \""+serverName+"\", \""+`requestTimeout`+"\", \""+`requestRetriesCount`+"\", \""+`requestRetriesDelay`+"\", \""+`connCacheMax`+"\", \""+`connCacheMin`+"\", \""+`locateRequestTimeout`+"\")"
        else:
            print " Usage: AdminServerManagement.configureORBService(\""+nodeName+"\", \""+serverName+"\", \""+`requestTimeout`+"\", \""+`requestRetriesCount`+"\", \""+`requestRetriesDelay`+"\", \""+`connCacheMax`+"\", \""+`connCacheMin`+"\", \""+`locateRequestTimeout`+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["requestTimeout", requestTimeout], ["requestRetriesCount", requestRetriesCount], ["requestRetriesDelay", requestRetriesDelay], ["connectionCacheMaximum", connCacheMax], ["connectionCacheMinimum", connCacheMin], ["locateRequestTimeout", locateRequestTimeout]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        orbs = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/ObjectRequestBroker:/")
        orbList = AdminUtilities.convertToList(orbs)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        orb = AdminUtilities._BLANK_
        if (len(orbList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["ObjectRequestBroker"]))
        if (len(orbList) == 1):
            orb = orbList[0]
            AdminConfig.modify(orb, finalAttrs)
        if (len(orbList) == 0):
            orb = AdminConfig.create("ObjectRequestBroker", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(orb)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 43: Configure custom property
def configureCustomProperty(nodeName, serverName, parentType, propName, propValue, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureCustomProperty("+`nodeName`+", "+`serverName`+", "+`parentType`+", "+`propName`+", "+`propValue`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring Custom Property
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring custom Property"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " parentType:             "+parentType
        print " propertyName:           "+propName
        print " propertyValue:          "+propValue
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureCustomProperty(\""+nodeName+"\", \""+serverName+"\", \""+parentType+"\", \""+propName+"\", \""+propValue+"\")"
        else:
            print " Usage: AdminServerManagement.configureCustomProperty(\""+nodeName+"\", \""+serverName+"\", \""+parentType+"\", \""+propName+"\", \""+propValue+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(parentType) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["parentType", parentType]))

        if (len(propName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propName", propName]))

        if (len(propValue) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["propValue", propValue]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["name", propName], ["value", propValue]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        parents = AdminConfig.list(parentType, server)
        parentList = AdminUtilities.convertToList(parents)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        prop = AdminUtilities._BLANK_
        parent = AdminUtilities._BLANK_
        if (len(parentList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", [parentType]))
        if (len(parentList) == 1):
            parent = parentList[0]
            # get the Property
            props = AdminConfig.list("Property", parent)
            propList = AdminUtilities.convertToList(props)
            if (len(propList) == 0):
                prop = AdminConfig.create("Property", parent, finalAttrs)
            else:
                pFound = "false"
                for p in propList:
                    pName = AdminConfig.showAttribute(p, "name")
                    if (pName == propName):
                        prop = p
                        pFound = "true"
                        AdminConfig.modify(p, finalAttrs)

                if (pFound == "false"):
                    prop = AdminConfig.create("Property", parent, finalAttrs)

        if (len(parentList) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6047E", [parentType]))

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(prop)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 44: Configure transaction service
def configureTransactionService(nodeName, serverName, totalTranLifetimeTimeout, clientInactivityTimeout, maxTransactionTimeout, heuristicRetryLimit, heuristicRetryWait, propogatedOrBMTTranLifetimeTimeout, asyncResponseTimeout, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureORBService("+`nodeName`+", "+`serverName`+", "+`totalTranLifetimeTimeout`+", "+`clientInactivityTimeout`+", "+`maxTransactionTimeout`+", "+`heuristicRetryLimit`+", "+`heuristicRetryWait`+", "+`propogatedOrBMTTranLifetimeTimeout`+", "+`asyncResponseTimeout`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring Transaction Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:              Configuring TransactionService"
        print " nodeName:                           "+nodeName
        print " serverName:                         "+serverName
        print " totalTranLifetimeTimeout:           %s" % (totalTranLifetimeTimeout)
        print " clientInactivityTimeout:            %s" % (clientInactivityTimeout)
        print " maximumTransactionTimeout:          %s" % (maxTransactionTimeout)
        print " heuristicRetryLimit:                %s" % (heuristicRetryLimit)
        print " heuristicRetryWait:                 %s" % (heuristicRetryWait)
        print " propogatedOrBMTranLifetimeTimeout:  %s" % (propogatedOrBMTTranLifetimeTimeout)
        print " asyncResponseTimeout:               %s" % (asyncResponseTimeout)
        print " Optional Attributes:"
        print "     otherAttributeList              %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureTransactionService(\""+nodeName+"\", \""+serverName+"\", \""+`totalTranLifetimeTimeout`+"\", \""+`clientInactivityTimeout`+"\", \""+`maxTransactionTimeout`+"\", \""+`heuristicRetryLimit`+"\", \""+`heuristicRetryWait`+"\", \""+`propogatedOrBMTTranLifetimeTimeout`+"\", \""+`asyncResponseTimeout`+"\")"
        else:
            print " Usage: AdminServerManagement.configureTransactionService(\""+nodeName+"\", \""+serverName+"\", \""+`totalTranLifetimeTimeout`+"\", \""+`clientInactivityTimeout`+"\", \""+`maxTransactionTimeout`+"\", \""+`heuristicRetryLimit`+"\", \""+`heuristicRetryWait`+"\", \""+`propogatedOrBMTTranLifetimeTimeout`+"\", \""+`asyncResponseTimeout`+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["totalTranLifetimeTimeout", totalTranLifetimeTimeout], ["clientInactivityTimeout", clientInactivityTimeout], ["maximumTransactionTimeout", maxTransactionTimeout], ["heuristicRetryLimit", heuristicRetryLimit], ["heuristicRetryWait", heuristicRetryWait], ["propogatedOrBMTTranLifetimeTimeout", propogatedOrBMTTranLifetimeTimeout], ["asyncResponseTimeout", asyncResponseTimeout]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        tss = AdminConfig.list("TransactionService", server)
        tsList = AdminUtilities.convertToList(tss)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ts = AdminUtilities._BLANK_
        if (len(tsList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["TransactionService"]))
        if (len(tsList) == 1):
            ts = tsList[0]
            AdminConfig.modify(ts, finalAttrs)
        if (len(tsList) == 0):
            ts = AdminConfig.create("TransactionService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ts)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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

# Example 45: Configure web container
def configureWebContainer(nodeName, serverName, defaultVirtualHostName, enableServletCaching, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureWebContainer("+`nodeName`+", "+`serverName`+", "+`defaultVirtualHostName`+", "+`enableServletCaching`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring WebContainer
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring WebContainer"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " defaultVirtualHostName: "+defaultVirtualHostName
        print " enableServletCaching:   "+enableServletCaching
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureWebContainer(\""+nodeName+"\", \""+serverName+"\", \""+defaultVirtualHostName+"\", \""+enableServletCaching+"\")"
        else:
            print " Usage: AdminServerManagement.configureWebContainer(\""+nodeName+"\", \""+serverName+"\", \""+defaultVirtualHostName+"\", \""+enableServletCaching+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(defaultVirtualHostName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["defaultVirtualHostName", defaultVirtualHostName]))

        if (len(enableServletCaching) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enableServletCaching", enableServletCaching]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["defaultVirtualHostName", defaultVirtualHostName], ["enableServletCaching", enableServletCaching]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        wcs = AdminConfig.list("WebContainer", server)
        wcList = AdminUtilities.convertToList(wcs)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        wc = AdminUtilities._BLANK_
        if (len(wcList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["WebContainer"]))
        if (len(wcList) == 1):
            wc = wcList[0]
            AdminConfig.modify(wc, finalAttrs)
        if (len(wcList) == 0):
            wc = AdminConfig.create("WebContainer", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(wc)
        return 1 
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 46: Configure HTTP transport for WebContainer
def configureHTTPTransportForWebContainer(nodeName, serverName, adjustPort, external, sslConfig, sslEnabled, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureHTTPTransportForWebContainer("+`nodeName`+", "+`serverName`+", "+`adjustPort`+", "+`external`+", "+`sslConfig`+", "+`sslEnabled`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring HTTP Transport for WebContainer
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring HTTPTransport for WebContainer"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " adjustPort:             "+adjustPort
        print " external:               "+external
        print " sslConfig:              "+sslConfig
        print " sslEnabled:             "+sslEnabled
        print " Usage: AdminServerManagement.configureHTTPTransportForWebContainer(\""+nodeName+"\", \""+serverName+"\", \""+adjustPort+"\", \""+external+"\", \""+sslConfig+"\", \""+sslEnabled+"\")"
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(adjustPort) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["adjustPort", adjustPort]))

        if (len(external) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["external", external]))

        if (len(sslConfig) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sslConfig", sslConfig]))

        if (len(sslEnabled) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sslEnabled", sslEnabled]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["adjustPort", adjustPort], ["external", external], ["sslConfig", sslConfig], ["sslEnabled", sslEnabled]]

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        wcs = AdminConfig.list("WebContainer", server)
        wcList = AdminUtilities.convertToList(wcs)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        wc = AdminUtilities._BLANK_
        if (len(wcList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["WebContainer"]))
        if (len(wcList) == 1):
            wc = wcList[0]

            # get the HTTPTransport
            https = AdminConfig.list("HTTPTransport", wc)
            httpList = AdminUtilities.convertToList(https)
            if (len(httpList) == 0):
                # create a new on
                # I could not create it with all the attributes, always give me None
                # so to work around this, I created with empty list and then modify it with all the specified user attributes
                http = AdminConfig.create("HTTPTransport", wc, [])
                AdminConfig.modify(http, requiredAttrs)
            else:
                for h in httpList:
                    AdminConfig.modify(h, requiredAttrs)

        if (len(wcList) == 0):
            wc = AdminConfig.create("WebContainer", server, [])
            # create a new on
            # I could not create it with all the attributes, always give me None
            # so to work around this, I created with empty list and then modify it with all the specified user attributes
            http = AdminConfig.create("HTTPTransport", wc, [])
            AdminConfig.modify(http, requiredAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(wc)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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

# Example 47: Configure HTTP transport end point for WebContainer
def configureHTTPTransportEndPointForWebContainer(nodeName, serverName, newHostName, newPort, oldHostName=AdminUtilities._BLANK_, oldPort=AdminUtilities._BLANK_, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureHTTPTransportEndPointForWebContainer("+`nodeName`+", "+`serverName`+", "+`newHostName`+", "+`newPort`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring HTTP Transport End Point for WebContainer
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configuring HTTPTransport endPoint for WebContainer"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " newHostName:                    "+newHostName
        print " newPort:                        %s" % (newPort)
        print " Usage: AdminServerManagement.configureHTTPTransportEndPointForWebContainer(\""+nodeName+"\", \""+serverName+"\", \""+newHostName+"\", \""+`newPort`+"\")"
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(newHostName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["newHostName", newHostName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["host", newHostName], ["port", newPort]]

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        wcs = AdminConfig.list("WebContainer", server)
        wcList = AdminUtilities.convertToList(wcs)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        wc = AdminUtilities._BLANK_
        ep = AdminUtilities._BLANK_
        if (len(wcList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["WebContainer"]))
        if (len(wcList) == 1):
            wc = wcList[0]

            # get the HTTPTransport
            https = AdminConfig.list("HTTPTransport", wc)
            httpList = AdminUtilities.convertToList(https)
            if (len(httpList) == 0):
                # create a new on
                # I could not create it with all the attributes, always give me None
                # so to work around this, I created with empty list and then modify it with all the specified user attributes
                http = AdminConfig.create("HTTPTransport", wc, [])
                ep = AdminConfig.create("EndPoint", http, [["host", newHostName], ["port", newPort]])
            else:
                for h in httpList:
                    # get EndPoint
                    eps = AdminConfig.list("EndPoint", h)
                    epList = AdminUtilities.convertToList(eps)
                    if (len(epList) == 0):
                        ep = AdminConfig.create("EndPoint", h, requiredAttrs)
                    if (len(epList) == 1):
                        ep = epList[0]
                        AdminConfig.modify(epList[0], requiredAttrs)
        if (len(wcList) == 0):
            wc = AdminConfig.create("WebContainer", server, [])
            # create a new on
            # I could not create it with all the attributes, always give me None
            # so to work around this, I created with empty list and then modify it with all the specified user attributes
            http = AdminConfig.create("HTTPTransport", wc, [])
            ep = AdminConfig.create("EndPoint", http, requiredAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(wc)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 48: Configure SessionManager for Server
def configureSessionManagerForServer(nodeName, serverName, sessionPersistenceMode,  otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureSessionManagerForServer("+`nodeName`+", "+`serverName`+", "+`sessionPersistenceMode`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring SessionManager for Server
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configuring SessionManager for Server"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " sessionPersistenceMode:         "+sessionPersistenceMode
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureSessionManagerForServer(\""+nodeName+"\", \""+serverName+"\", \""+sessionPersistenceMode+"\")"
        else:
            print " Usage: AdminServerManagement.configureSessionManagerForServer(\""+nodeName+"\", \""+serverName+"\", \""+sessionPersistenceMode+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(sessionPersistenceMode) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sessionPersistenceMode", sessionPersistenceMode]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["sessionPersistenceMode", sessionPersistenceMode]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        sms = AdminConfig.list("SessionManager", server)
        smList = AdminUtilities.convertToList(sms)
 
        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        sm = AdminUtilities._BLANK_
        if (len(smList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["SessionManager"]))
        if (len(smList) == 1):
            sm = smList[0]
            AdminConfig.modify(sm, finalAttrs)
        if (len(smList) == 0):
            sm = AdminConfig.create("SessionManager", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(sm)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 49: Configure Cookie for Server
def configureCookieForServer(nodeName, serverName, cookieName, domain, maxAge, secure,  otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureCookieForServer("+`nodeName`+", "+`serverName`+", "+`cookieName`+", "+`domain`+", "+`maxAge`+", "+`secure`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring Cookie for Server
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:          Configuring Cookie for Server"
        print " nodeName:                       "+nodeName
        print " serverName:                     "+serverName
        print " cookieName:                     "+cookieName
        print " domain:                         "+domain
        print " maximumAge:                     %s" % (maxAge)
        print "secure:                          "+secure
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureCookieForServer(\""+nodeName+"\", \""+serverName+"\", \""+cookieName+"\", \""+domain+"\", \""+`maxAge`+"\", \""+secure+"\")"
        else:
            print " Usage: AdminServerManagement.configureCookieForServer(\""+nodeName+"\", \""+serverName+"\", \""+cookieName+"\", \""+domain+"\", \""+`maxAge`+"\", \""+secure+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(cookieName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["cookieName", cookieName]))

        if (len(domain) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["domain", domain]))

        if (len(secure) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["secure", secure]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["name", cookieName], ["domain", domain], ["maximumAge", maxAge], ["secure", secure]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        sms = AdminConfig.list("SessionManager", server)
        smList = AdminUtilities.convertToList(sms)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        sm = AdminUtilities._BLANK_
        cookie = AdminUtilities._BLANK_
        if (len(smList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["SessionManager"]))
        if (len(smList) == 1):
            sm = smList[0]

            # get Cookie
            cookies = AdminConfig.list("Cookie", sm)
            cookieList = AdminUtilities.convertToList(cookies)
            if (len(cookieList) == 0):
                cookie = AdminConfig.create("Cookie", sm, finalAttrs)
            else:
                cookieFound = "false"
                for c in cookieList:
                    cName = AdminConfig.showAttribute(c, "name")
                    if (cName == cookieName): 
                        cookie = c
                        AdminConfig.modify(c, finalAttrs)
                        cookieFound = "true"
                        break

                if (cookieFound == "false"):
                    cookie = AdminConfig.create("Cookie", sm, finalAttrs)

        if (len(smList) == 0):
            sm = AdminConfig.create("SessionManager", server, [])
            cookie =AdminConfig.create("Cookie", sm, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(cookie)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 50: Configure FileTransfer Service
def configureFileTransferService(nodeName, serverName, retriesCount, retryWaitTime, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureFileTransferService("+`nodeName`+", "+`serverName`+", "+`retriesCount`+", "+`retryWaitTime`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring FileTransfer Service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring FileTransferService"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " retriesCount:           %s" % (retriesCount)
        print "retryWaitTime:           %s" % (retryWaitTime)
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureFileTransferService(\""+nodeName+"\", \""+serverName+"\", \""+`retriesCount`+"\", \""+`retryWaitTime`+"\")"
        else:
            print " Usage: AdminServerManagement.configureFileTransferService(\""+nodeName+"\", \""+serverName+"\", \""+`retriesCount`+"\", \""+`retryWaitTime`+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["retriesCount", retriesCount], ["retryWaitTime", retryWaitTime]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        ftss = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/FileTransferService:/")
        ftsList = AdminUtilities.convertToList(ftss)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        fts = AdminUtilities._BLANK_
        if (len(ftsList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["FileTransferService"]))
        if (len(ftsList) == 1):
            fts = ftsList[0]
            AdminConfig.modify(fts, finalAttrs)
        if (len(ftsList) == 0):
            fts = AdminConfig.create("FileTransferService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()
        
        print AdminConfig.showall(fts)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 51: Configure Admin Service
def configureAdminService(nodeName, serverName, localAdminProtocolType, remoteAdminProtocolType, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureAdminService("+`nodeName`+", "+`serverName`+", "+`localAdminProtocolType`+", "+`remoteAdminProtocolType`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring AdminService
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:      Configuring AdminService"
        print " nodeName:                   "+nodeName
        print " serverName:                 "+serverName
        print " localAdminProtocol:         "+localAdminProtocolType
        print " remoteAdminProtocol:        "+remoteAdminProtocolType
        print " Optional Attributes:"
        print "     otherAttributeList      %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureAdminService(\""+nodeName+"\", \""+serverName+"\", \""+localAdminProtocolType+"\", \""+remoteAdminProtocolType+"\")"
        else:
            print " Usage: AdminServerManagement.configureAdminService(\""+nodeName+"\", \""+serverName+"\", \""+localAdminProtocolType+"\", \""+remoteAdminProtocolType+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # get the connector configID
        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        adss = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/AdminService:/")
        adsList = AdminUtilities.convertToList(adss)

        # correct the connector type and find the config id for the connector type
        import java.lang.String as String
        lapConnType = String(localAdminProtocolType)
        rapConnType = String(remoteAdminProtocolType)

        if (not lapConnType.endsWith("Connector")):
            lapConnType = lapConnType.concat("Connector")

        if (not rapConnType.endsWith("Connector")):
            rapConnType = rapConnType.concat("Connector")

        lapID = AdminConfig.list(lapConnType, server)
        rapID = AdminConfig.list(rapConnType, server)

        # contruct required attributes
        requiredAttrs = [["localAdminProtocol", lapID], ["remoteAdminProtocol", rapID]]
        finalAttrs = requiredAttrs+otherAttrList

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        ads = AdminUtilities._BLANK_
        if (len(adsList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["AdminService"]))
        if (len(adsList) == 1):
            ads = adsList[0]
            AdminConfig.modify(ads, finalAttrs)
        if (len(adsList) == 0):
            ads = AdminConfig.create("AdminService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(ads)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


# Example 52: Configure Custom Service
def configureCustomService(nodeName, serverName, className, displayName, classpath, otherAttrList=[], failonerror=AdminUtilities._BLANK_):
    if(failonerror==AdminUtilities._BLANK_): 
        failonerror=AdminUtilities._FAIL_ON_ERROR_
    #endIf
    msgPrefix = "configureCustomService("+`nodeName`+", "+`serverName`+", "+`className`+", "+`displayName`+", "+`classpath`+", "+`failonerror`+"): "

    try:
        #--------------------------------------------------------------------
        # Configuring custom service
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminServerManagement:  Configuring CustomService"
        print " nodeName:               "+nodeName
        print " serverName:             "+serverName
        print " classname:              "+className
        print " displayname:            "+displayName
        print " classpath:              "+classpath
        print " Optional Attributes:"
        print "     otherAttributeList  %s" % (otherAttrList)
        if (len(otherAttrList) == 0):
            print " Usage: AdminServerManagement.configureCustomService(\""+nodeName+"\", \""+serverName+"\", \""+className+"\", \""+displayName+"\", \""+classpath+"\")"
        else:
            print " Usage: AdminServerManagement.configureCustomService(\""+nodeName+"\", \""+serverName+"\", \""+className+"\", \""+displayName+"\", \""+classpath+"\", %s)" % (otherAttrList)
        print " Return: If the command is successful, a value of 1 is returned."
        print "---------------------------------------------------------------"
        print " "
        print " "

        # checking required parameters
        # WASL6041E=WASL6041E: Invalid parameter value: {0}:{1}
        if (len(nodeName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

        if (len(serverName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

        if (len(className) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["className", className]))

        if (len(displayName) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["displayName", displayName]))

        if (len(classpath) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classpath", classpath]))

        # checking if the parameter value exists
        # WASL6040E=WASL6040E: The specified argument {0}:{1} does not exist.
        nodeExist = AdminConfig.getid("/Node:"+nodeName+"/")
        if (len(nodeExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))

        serverExist = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        if (len(serverExist) == 0):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))

        # contruct required attributes
        requiredAttrs = [["classname", className], ["displayName", displayName], ["classpath", classpath]]
        finalAttrs = requiredAttrs+otherAttrList

        server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
        css = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/CustomService:/")
        csList = AdminUtilities.convertToList(css)

        # check if there is more then one exists
        # WASL6045E=WASL6045E: Multiple {0} found in your configuration.  
        cs = AdminUtilities._BLANK_
        if (len(csList) > 1):
            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6045E", ["CustomService"]))
        if (len(csList) == 1):
            cs = csList[0]
            AdminConfig.modify(cs, finalAttrs)
        if (len(csList) == 0):
            cs = AdminConfig.create("CustomService", server, finalAttrs)

        if (AdminUtilities._AUTOSAVE_ == "true"):
            AdminConfig.save()

        print AdminConfig.showall(cs)
        return 1
    except:
        typ, val, tb = sys.exc_info()
        if(typ==SystemExit):  raise SystemExit,`val`
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


## Example 53 Online help ##
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
        #print " AdminServerManagement:          Help "
        #print " Script procedure:               "+procedure
        #print " Usage: AdminServerManagement.help(\""+procedure+"\")"
        #print " Return: Receive help information for the specified script library function."
        #print "---------------------------------------------------------------"
        #print " "
        #print " "

        if (len(procedure) == 0):
            message = resourceBundle.getString("ADMINSERVERMANAGEMENT_GENERAL_HELP")
        else:
            procedure = "ADMINSERVERMANAGEMENT_HELP_"+procedure.upper()
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
#endDef
# LIDB4362-82.1 end

