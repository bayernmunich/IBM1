
###############################################################################
# Licensed Material - Property of IBM 
# 5724-I63, 5724-H88, 5733-W70 (C) Copyright IBM Corp. 2005, 2006, 2007 2008 - All Rights Reserved. 
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
# AdminApplication.py - Jython procedures for performing application management tasks.
#------------------------------------------------------------------------------
#
#   This script includes the following application script procedures:
#
#   Group 1: Install/uninstall applications
#      Ex1:  installAppWithDefaultBindingOption
#      Ex2:  installAppWithNodeAndServerOptions
#      Ex3:  installAppWithClusterOption
#      Ex4:  installAppModulesToSameServerWithMapModulesToServersOption
#      Ex5:  installAppModulesToDiffServersWithMapModulesToServersOption
#      Ex6:  installAppModulesToSameServerWithPatternMatching
#      Ex7:  installAppModulesToDiffServersWithPatternMatching
#      Ex8:  installAppModulesToMultiServersWithPatternMatching
#      Ex9:  installAppWithTargetOption
#      Ex10: installAppWithDeployEjbOptions
#      Ex11: installAppWithVariousTasksAndNonTasksOptions
#      Ex12: installWarFile
#      Ex13: uninstallApplication
#
#   Group 2: List applications/modules/get task information/general help
#      Ex14: listApplications
#      Ex15: listApplicationsWithTarget
#      Ex16: listModulesInAnApp
#      Ex17: getTaskInfoForAnApp
#      Ex48: checkIfAppExists
#      Ex49: getAppDeploymentTargets
#      Ex50: getAppDeployedNodes
#      Ex53: help
#
#   Group 3: Update applications
#      Ex18: updateApplicationUsingDefaultMerge
#      Ex19: updateApplicationWithUpdateIgnoreNewOption
#      Ex20: updateApplicationWithUpdateIgnoreOldOption
#      Ex21: addSingleFileToAnAppWithUpdateCommand
#      Ex22: updateSingleFileToAnAppWithUpdateCommand
#      Ex23: deleteSingleFileToAnAppWithUpdateCommand
#      Ex24: addSingleModuleFileToAnAppWithUpdateCommand
#      Ex25: updateSingleModuleFileToAnAppWithUpdateCommand
#      Ex26: addUpdateSingleModuleFileToAnAppWithUpdateCommand
#      Ex27: deleteSingleModuleFileToAnAppWithUpdateCommand
#      Ex28: addPartialAppToAnAppWithUpdateCommand
#      Ex29: updatePartialAppToAnAppWithUpdateCommand
#      Ex30: deletePartialAppToAnAppWithUpdateCommand
#      Ex31: updateEntireAppToAnAppWithUpdateCommand
#
#   Group 4: Export applications
#      Ex32: exportAnAppToFile
#      Ex33: exportAllApplicationsToDir
#      Ex34: exportAnAppDDLToDir
#
#   Group 5: Configure application deployment
#      Ex35: configureStartingWeightForAnApplication
#      Ex36: configureClassLoaderPolicyForAnApplication
#      Ex37: configureClassLoaderLoadingModeForAnApplication
#      Ex38: configureSessionManagementForAnApplication
#      Ex39: configureApplicationLoading
#      Ex40: configureLibraryReferenceForAnApplication
#      Ex41: configureEJBModulesOfAnApplication
#      Ex42: configureWebModulesOfAnApplication
#      Ex43: configureConnectorModulesOfAnApplication
#
#   Group 6: Start/stop applications
#      Ex44: startApplicationOnSingleServer
#      Ex45: startApplicationOnAllDeployedTargets
#      Ex46: stopApplicationOnSingleServer
#      Ex47: stopApplicationOnAllDeployedTargets
#      Ex51: startApplicationOnCluster
#      Ex52: stopApplicationOnCluster
#
#---------------------------------------------------------------------

import sys
import java
import AdminUtilities 

# Setting up Global Variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)

## Example 1: Install application with default binding options ##
def installAppWithDefaultBindingOption( appName, earFile, nodeName, serverName, dsJNDIName, dsUserName, dsPassword, connFactory, EJBprefix, virtualHostName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppWithDefaultBindingOption("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName`+", "+`dsJNDIName`+", "+`dsUserName`+", "+`dsPassword`+", "+`connFactory`+", "+`EJBprefix`+", "+`virtualHostName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application with default binding options
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------------------------------------"
                print " AdminApplication:       Install an application with the -usedefaultbindings option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " DataSource JNDI name:   "+dsJNDIName
                print " DataSource user name:   "+dsUserName
                print " DataSource password:    "+dsPassword
                print " Connection factory:     "+connFactory
                print " EJB prefix:             "+EJBprefix
                print " Virtual host name:      "+virtualHostName
                print " Usage: AdminApplication.installAppWithDefaultBindingOption(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName+"\", \""+dsJNDIName+"\", \""+dsUserName+"\", \""+dsPassword+"\", \""+connFactory+"\", \""+EJBprefix+"\", \""+virtualHostName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "----------------------------------------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                              
                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))
                               
                if (dsJNDIName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["dsJNDIName", dsJNDIName]))
                
                if (dsUserName == ""):
                  raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["dsUserName", dsUserName]))
                
                if (dsPassword == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["dsPassword", dsPassword]))
                
                if (connFactory == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["connFactory", connFactory]))
                
                if (EJBprefix == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["EJBprefix", EJBprefix]))
                
                if (virtualHostName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["virtualHostName", virtualHostName]))

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
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                # Install application with default binding options
                bindOpt = ["-usedefaultbindings", "-defaultbinding.datasource.jndi", dsJNDIName, "-defaultbinding.datasource.username", dsUserName,"-defaultbinding.datasource.password", dsPassword, "-defaultbinding.cf.jndi", connFactory, "-defaultbinding.ejbjndi.prefix", EJBprefix, "-defaultbinding.virtual.host", virtualHostName ]
                opts = bindOpt
                opts += ["-appname", appName, "-node", nodeName, "-server", serverName]
                AdminApp.install(earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 2: Install application with node and server options ##
def installAppWithNodeAndServerOptions( appName, earFile, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppWithNodeAndServerOptions("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application to an application server
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Install application with -node and -server options"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.installAppWithNodeAndServerOptions(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
               
                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))
                                
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

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf

                AdminApp.install( earFile, ["-appname", appName, "-node", nodeName, "-server", serverName] )
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
                
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
  
  
## Example 3: Install application with cluster option ##
def installAppWithClusterOption( appName, earFile, clusterName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppWithClusterOption("+`appName`+", "+`earFile`+", "+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install an application to a cluser
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy an application with -cluster option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Cluster name:           "+clusterName
                print " Usage: AdminApplication.installAppWithClusterOption(\""+appName+"\", \""+earFile+"\", \""+clusterName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))
                else:
                   cluster = AdminConfig.getid("/ServerCluster:"+clusterName+"/")
                   if (len(cluster) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                   #endIf
                #endIf

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                AdminApp.install( earFile, ["-appname", appName, "-cluster", clusterName] )
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 4: Install application to same server with MapModulesToServers option ##
def installAppModulesToSameServerWithMapModulesToServersOption( appName, earFile, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppModulesToSameServerWithMapModulesToServersOption("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application modules to same application server
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application modules to same server with -MapModulesToServers option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.installAppModulesToSameServerWithMapModulesToServersOption(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

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
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Identify server object
                aServer = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                
                # Use DefaultApplication.ear as example to map ejb and web modules to same application server 
                # mapping1 = ["Increment Enterprise Java Bean", "Increment.jar,META-INF/ejb-jar.xml", aServer]
                # mapping2 = ["Default Web Application", "DefaultWebApplication.war,WEB-INF/web.xml", aServer] 
                mapping1 = [".*", ".*.jar,.*", aServer]
                mapping2 = [".*", ".*.war,.*", aServer]  
                
                mapServerOpt = ["-MapModulesToServers", [mapping1, mapping2]]
                opts = mapServerOpt
                opts += ["-appname", appName]
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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


## Example 5: Install application to different servers with MapModulesToServers option ##
def installAppModulesToDiffServersWithMapModulesToServersOption( appName, earFile, nodeName, serverName1, serverName2, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppModulesToDiffServersWithMapModulesToServersOption("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName1`+", "+`serverName2`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application modules to different application servers
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application modules to different servers with -MapModulesToServers option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server1 name:           "+serverName1
                print " Server2 name:           "+serverName2
                print " Usage: AdminApplication.installAppModulesToDiffServersWithMapModulesToServersOption(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName1+"\", \""+serverName2+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                               
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName1 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName1]))

                if (serverName2 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName2]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # Check if server1 exists
                server1 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName1)
                if (len(server1) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName1]))
                #endIf
                                
                # Check if server2 exists
                server2 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName2)
                if (len(server2) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName2]))
                #endIf
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                aServer1 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName1
                aServer2 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName2
                
                # Use DefaultApplication.ear as example to map ejb module to serverName1 
                # mapping1 = ["Increment Enterprise Java Bean", "Increment.jar,META-INF/ejb-jar.xml", aServer1]
                mapping1 = [".*", ".*.jar,.*", aServer1]

                # Use DefaultApplication.ear as example to map web module to serverName2
                # mapping2 = ["Default Web Application", "DefaultWebApplication.war,WEB-INF/web.xml", aServer2] 
                mapping2 = [".*", ".*.war,.*", aServer2] 

                mapServerOpt = ["-MapModulesToServers", [mapping1, mapping2]]
                opts = mapServerOpt
                opts += ["-appname", appName]
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
    
## Example 6: Install application to same server with java pattern matching option##
def installAppModulesToSameServerWithPatternMatching( appName, earFile, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppModulesToSameServerWithPatternMatching("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application modules to same applicaton server using pattern matching
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application modules with -MapModulesToServers pattern matching option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.installAppModulesToSameServerWithPatternMatching(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

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

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")

                aServer = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                
                # Map ejb and web modules to same server with pattern matching
                mapping1 = [".*", ".*.jar,.*", aServer]
                mapping2 = [".*", ".*.war,.*", aServer]
                
                mapServerOpt = ["-MapModulesToServers", [mapping1, mapping2]]
                opts = mapServerOpt
                opts += ["-appname", appName]
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 7: Install application to different servers with java pattern matching option##
def installAppModulesToDiffServersWithPatternMatching( appName, earFile, nodeName, serverName1, serverName2, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppModulesToDiffServersWithPatternMatching("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName1`+", "+`serverName2`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application modules to different application servers using pattern matching
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application modules to different servers with -MapModulesToServers pattern matching option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server1 name:           "+serverName1
                print " Server2 name:           "+serverName2
                print " Usage: AdminApplication.installAppModulesToDiffServersWithPatternMatching(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName1+"\", \""+serverName2+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                               
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName1 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName1]))

                if (serverName2 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName2]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # Check if server1 exists
                server1 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName1)
                if (len(server1) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName1]))
                #endIf
                                
                # Check if server2 exists
                server2 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName2)
                if (len(server2) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName2]))
                #endIf

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf

                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")

                aServer1 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName1
                aServer2 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName2
                
                # Map ejb module to serverName1 with pattern matching
                mapping1 = [".*", ".*.jar,.*", aServer1 ]
                
                # Map web module to serverName2 with pattern matching
                mapping2 = [".*", ".*.war,.*", aServer2 ]
                
                mapServerOpt = ["-MapModulesToServers", [mapping1, mapping2]]
                opts = mapServerOpt
                opts += ["-appname", appName]
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 8: Install application to multiple targets with java pattern matching option##
def installAppModulesToMultiServersWithPatternMatching( appName, earFile, nodeName, serverName1, serverName2, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppModulesToMultiServersWithPatternMatching("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName1`+", "+`serverName2`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application modules to multiple application servers
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application modules to multiple servers with -MapModulesToServers pattern matching option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server1 name:           "+serverName1
                print " Server2 name:           "+serverName2
                print " Usage: AdminApplication.installAppModulesToMultiServersWithPatternMatching(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName1+"\", \""+serverName2+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                               
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName1 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName1]))

                if (serverName2 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName2]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # Check if server1 exists
                server1 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName1)
                if (len(server1) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName1]))
                #endIf
                                
                # Check if server2 exists
                server2 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName2)
                if (len(server2) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName2]))
                #endIf
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                aServer1 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName1
                aServer2 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName2
                
                # Map ejb and web module to multiple servers 
                mapping1 = [".*", ".*.jar,.*", aServer1 + "+" + aServer1]
                mapping2 = [".*", ".*.war,.*", aServer2 + "+" + aServer2]
                
                mapServerOpt = ["-MapModulesToServers", [mapping1, mapping2]]
                opts = mapServerOpt
                opts += ["-appname", appName]
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 9: Install application with target option ##
def installAppWithTargetOption( appName, earFile, nodeName, serverName1, serverName2,  failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppWithTargetOption("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName1`+", "+`serverName2`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application to application servers with -target option
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application to multiple servers with -target option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server1 name:           "+serverName1
                print " Server2 name:           "+serverName2
                print " Usage: AdminApplication.installAppWithTargetOption(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName1+"\", \""+serverName2+"\") "
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
               
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                               
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName1 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName1]))

                if (serverName2 == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName2]))

                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                # Check if server1 exists
                server1 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName1)
                if (len(server1) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName1]))
                #endIf
                                
                # Check if server2 exists
                server2 = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName2)
                if (len(server2) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName2]))
                #endIf
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                aServer1 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName1
                aServer2 = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName2
                
                # map application to multiple servers
                mapping = aServer1 + "+" + aServer2
                
                # install app with -target option
                mapServerOpt = ["-target", mapping]
                opts = mapServerOpt
                opts += ["-appname", appName]
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 10: Install application with deployejb options ##
def installAppWithDeployEjbOptions( appName, earFile, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppWithDeployEjbOptions("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application to application server with -deployejb option
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application with -deployejb option"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.installAppWithDeployEjbOptions(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

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

                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                               
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                #endIf
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                else:
                   node = AdminConfig.getid("/Node:"+nodeName+"/")
                   if (len(node) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                   #endIf
                #endIf
                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))
                else:
                   server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName)
                   if (len(server) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
                   #endIf
                #endIf
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                AdminApp.install(earFile, ["-appname", appName, "-node", nodeName, "-server", serverName, "-deployejb"] )
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 11 Install application with various task and non task options ##
def installAppWithVariousTasksAndNonTasksOptions( appName, earFile, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installAppWithVariousTasksAndNonTasksOptions("+`appName`+", "+`earFile`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install application to application server with different deployed tasks
                # Note: Use the DefaultApplication.ear as example application ear
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Deploy application with various tasks and non-tasks options"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.installAppWithVariousTasksAndNonTasksOptions(\""+appName+"\", \""+earFile+"\", \""+nodeName+"\", \""+serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                opts = ""
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

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

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                # -appname option
                nameOpt = ["-appname", appName, "-node", nodeName, "-server", serverName]
                opts = nameOpt
                
                # -BindJndiForEJBNonMessageBinding option
                mapping = ["Increment Enterprise Java Bean", "Increment", "Increment.jar,META-INF/ejb-jar.xml", "Increment"]
                mapjndibindOpt = ["-BindJndiForEJBNonMessageBinding", [mapping]]
                opts += mapjndibindOpt
                
                # -MapEJBRefToEJB option
                mapping = ["Default Web Application", "", "DefaultWebApplication.war,WEB-INF/web.xml", "Increment", "com.ibm.defaultapplication.Increment", "Increment"]
                mapejbrefOpt = ["-MapEJBRefToEJB", [mapping]]
                opts += mapejbrefOpt
                
                # -DataSourceFor20EJBModules option
                mapping = ["Increment Enterprise Java Bean", "Increment.jar,META-INF/ejb-jar.xml", "DefaultDatasource", "cmpBinding.perConnectionFactory"]
                mapdsejbOpt = ["-DataSourceFor20EJBModules", [mapping]]
                opts += mapdsejbOpt
                
                # -DataSourceFor20CMPBeans option
                mapping = ["Increment Enterprise Java Bean", "Increment", "Increment.jar,META-INF/ejb-jar.xml", "DefaultDatasource", "cmpBinding.perConnectionFactory"]
                mapdscmpOpt = ["-DataSourceFor20CMPBeans", [mapping]]
                opts += mapdscmpOpt
                
                # -MapWebModToVH option
                mapping = ["Default Web Application", "DefaultWebApplication.war,WEB-INF/web.xml", "default_host"]
                mapvirtualHostNameOpt = ["-MapWebModToVH", [mapping]]
                opts += mapvirtualHostNameOpt
                
                # other install options
                miscOpts = ["-nopreCompileJSPs", "-distributeApp", "-nouseMetaDataFromBinary", "-createMBeansForResources", "-noreloadEnabled", "-nodeployws", "-validateinstall", "warn", "-filepermission", ".*\\.jsp=777#.*\\.xml=755"]
                opts += miscOpts
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 12 install a war file ##
def installWarFile( appName, warFile, nodeName, serverName, contextRoot, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "installWarFile("+`appName`+", "+`warFile`+", "+`nodeName`+", "+`serverName`+", "+`contextRoot`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Install a war file
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Install a war file "
                print " Application name:       "+appName
                print " War file:               "+warFile
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Context root:           "+contextRoot
                print " Usage: AdminApplication.installWarFile(\""+appName+"\", \""+warFile+"\", \""+nodeName+"\", \""+serverName+"\", \""+contextRoot+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (warFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["warFile", warFile]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))
                   
                if (contextRoot == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contextRoot", contextRoot]))

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
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) > 0):
                   # application exists
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [appName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                warAttr = ["-contextroot", contextRoot, "-nodeployejb", "-nopreCompileJSPs", "-nouseMetaDataFromBinary"]
                opts = warAttr
                opts += ["-appname", appName, "-cell", cellName, "-node", nodeName, "-server", serverName]
                AdminApp.install( warFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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

  
## Example 13 Uninstall application ##
def uninstallApplication( appName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "uninstallApplication("+`appName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Uninstall an application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Uninstall application "
                print " Application name:       "+appName
                print " Usage: AdminApplication.uninstallApplication(\""+appName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                #endIf
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                
                AdminApp.uninstall(appName)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 14 list applications ##
def listApplications(failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listApplications("+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # List deployed applications 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print "---------------------------------------------------------------"
                print " AdminApplication:       List all deployed applications "
                print " Usage: AdminApplication.listApplications() "
                print " Return: List of the available application names in the respective cell."
                print "---------------------------------------------------------------"
                print " "
                print " "
                apps = AdminApp.list()
                AdminUtilities.infoNotice(apps)
                apps = AdminUtilities.convertToList(apps)
                return apps
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
  

## Example 15 list applications by a specified target ##
def listApplicationsWithTarget( nodeName, serverName, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listApplicationsWithTarget("+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # List deployed application by a specified target
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       List applications that have deployed on the specified target "
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.listApplicationsWithTarget(\""+nodeName+"\", \""+serverName+"\")"
                print " Return: List of the available application names for the given deployment target. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))

                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))

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
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                server = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                
                # list applications that are deployed on serverName
                apps = AdminApp.list(server)
                AdminUtilities.infoNotice(apps)
                apps = AdminUtilities.convertToList(apps)
                return apps
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
 

## Example 16 list Modules in an application ##
def listModulesInAnApp( appName, serverName, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listModulesInAnApp("+`appName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                        #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # List application modules in a deployed application 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       List modules in a deployed application "
                print " Application name:       "+appName
                print " Optional parameter: "
                print "         Server name:    "+serverName
                print " Usage: AdminApplication.listModulesInAnApp(\""+appName+"\", \""+serverName+"\")"
                print " Return: List of the modules for the given application name, or modules for the given application name and server name."
                print "---------------------------------------------------------------"
                print " "
                print " "
                opt = []
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                #endIf
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))

                if (len(serverName) != 0):
                   server = AdminConfig.getid("/Server:"+serverName)
                   if (len(server) == 0):
                      # server does not exist
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["serverName", serverName]))
                   #endIf
                   opt = "-server " + serverName 
                #endIf   
                
                modules = AdminApp.listModules( appName, opt)
                modules = AdminUtilities.convertToList(modules)
                return modules
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


## Example 17 Get information about a particular install task option  ##
def getTaskInfoForAnApp( earFile, taskName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "getTaskInfoForAnApp("+`earFile`+", "+`taskName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Get the information about a particular install task option for an application file 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Get task information for an application ear file "
                print " Ear file:               "+earFile
                print " Install Task name:      "+taskName  
                print " Usage: AdminApplication.getTaskInfoForAnApp(\""+earFile+"\", \""+taskName+"\")"
                print " Return: Provide information about a particular installation task for the given application enterprise archive (EAR) file."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                
                if (taskName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["taskName", taskName]))
   
                taskInfo = AdminApp.taskInfo(earFile, taskName)
                print taskInfo
                return taskInfo
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


## Example 18 Update application using default merge ##
def updateApplicationUsingDefaultMerge( appName, earFile, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updateApplicationUsingDefaultMerge("+`appName`+", "+`earFile`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update application using default merging
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update application using default merging"
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Usage: AdminApplication.updateApplicationUsingDefaultMerge(\""+appName+"\", \""+earFile+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))
                 
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))

                opts = " -update"
                opts += " -appname "+appName
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 19 Updating an application with update.ignore.new option ##
def updateApplicationWithUpdateIgnoreNewOption( appName, earFile, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updateApplicationWithUpdateIgnoreNewOption("+`appName`+", "+`earFile`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update application with update.ignore.new option
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update application using -update.ignore.new option. The bindings from the new version of the application are ignored.  "
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Usage: AdminApplication.updateApplicationWithUpdateIgnoreNewOption(\""+appName+"\", \""+earFile+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))

                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        
   
                opts = " -update"
                opts += " -update.ignore.new"
                #opts += " -appname "+appName
                opts += " -appname "+appName+ " -target "+newtarget

                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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


## Example 20 Updating an application with update.ignore.old option ##
def updateApplicationWithUpdateIgnoreOldOption( appName, earFile, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updateApplicationWithUpdateIgnoreOldOption("+`appName`+", "+`earFile`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update application with update.ignore.old option
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update application using -update.ignore.old option. The bindings from the installed version of the application are ignored. "
                print " Application name:       "+appName
                print " Ear file to deploy:     "+earFile
                print " Usage: AdminApplication.updateApplicationWithUpdateIgnoreOldOption(\""+appName+"\", \""+earFile+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (earFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["earFile", earFile]))

                # Identify deployment configuration object 
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        
                    
                opts = " -update"
                opts += " -update.ignore.old"
                opts += " -appname "+appName+ " -target "+newtarget
                
                AdminApp.install( earFile, opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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


## Example 21 Adding a single file with update command ##
def addSingleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addSingleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Add a single file to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Add a single file to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.addSingleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))
                
                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation add"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                opts += " -target "+newtarget

                AdminApp.update( appName, 'file', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 22 Updating a single file with update command ##
def updateSingleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updateSingleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update a single file to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update a single file to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.updateSingleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))
                
                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation update"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                opts += " -target "+newtarget

                AdminApp.update( appName, 'file', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 23 Deleting a single file with update command ##
def deleteSingleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteSingleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Delete a single file in a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Delete a single file in an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.deleteSingleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))
                
                # Identify deployment configuration object and assume application is deployed on same target
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        
                
                opts = " -operation delete"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                opts += " -target "+newtarget
                
                AdminApp.update( appName, 'file', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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


## Example 24 Adding a single module file to a deployed application with update command ##
def addSingleModuleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addSingleModuleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Add a single module file to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Add a single module file to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.addSingleModuleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))

                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        
               
                opts = " -operation add"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                
                # Use DefaultApplication.ear as example to update JNDI for EJB non message binding
                # opts += " -BindJndiForEJBNonMessageBinding [['Increment Enterprise Java Bean' Increment Increment.jar,META-INF/ejb-jar.xml Inc]] "
                
                opts += " -target "+newtarget

                AdminApp.update( appName, 'modulefile', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 25 Updating a single module file with update command ##
def updateSingleModuleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updateSingleModuleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update a single module file to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update a single module file to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.updateSingleModuleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))

                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation update"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                
                # Use DefaultApplication.ear as example to specify data source to EJB modules
                # opts += " -DataSourceFor20EJBModules [['Increment Enterprise Java Bean' Increment.jar,META-INF/ejb-jar.xml DefaultDatasource cmpBinding.perConnectionFactory]] "
                
                opts += " -target "+newtarget

                AdminApp.update( appName, 'modulefile', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 26 Adding and updating a single module file to a deployed application with update command ##
def addUpdateSingleModuleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, contextRoot, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addUpdateSingleModuleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`contextRoot`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Add and update a single module file to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Add and update a single module file to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Optional parameter (only for Web Module): "
                print "     Context root:       "+contextRoot
                print " Usage: AdminApplication.addUpdateSingleModuleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\", \""+contextRoot+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))
                
                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation addupdate"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                if (len(contextRoot) > 0):
                   opts += " -contextroot "+contextRoot
                #endIf   
                opts += " -target "+newtarget

                AdminApp.update( appName, 'modulefile', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 27 Deleting a single module file with update command ##
def deleteSingleModuleFileToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteSingleModuleFileToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Delete a single module file from a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Delete a single module file to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.deleteSingleModuleFileToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))

                # Identify deployment configuration object and assume application is deployed on same target
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        
                
                opts = " -operation delete"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                opts += " -target "+newtarget
                
                AdminApp.update( appName, 'modulefile', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 28 Adding a partial application to a deployed application with update command ##
def addPartialAppToAnAppWithUpdateCommand( appName, fileContent, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addPartialAppToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Add a partial application to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Add a parital application to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Usage: AdminApplication.addPartialAppToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation add"
                opts += " -contents "+fileContent
                opts += " -target "+newtarget

                AdminApp.update( appName, 'partialapp', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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

  
## Example 29 Updating a partial application with update command ##
def updatePartialAppToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updatePartialAppToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update a partial application to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update a parital application to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.updatePartialAppToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))

                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation update"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                opts += " -target "+newtarget

                AdminApp.update( appName, 'partialapp', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 30 Deleting a partial application from a deployed application with update command ##
def deletePartialAppToAnAppWithUpdateCommand( appName, fileContent, contentURI, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deletePartialAppToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`contentURI`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Delete a partial application from a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Delete a parital application to an existing deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Content URI:            "+contentURI
                print " Usage: AdminApplication.deletePartialAppToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\", \""+contentURI+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                if (contentURI == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["contentURI", contentURI]))

                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation delete"
                opts += " -contents "+fileContent
                opts += " -contenturi "+contentURI
                opts += " -target "+newtarget

                AdminApp.update( appName, 'partialapp', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 31 Updating entire application to a deployed application with update command ##
def updateEntireAppToAnAppWithUpdateCommand( appName, fileContent, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "updateEntireAppToAnAppWithUpdateCommand("+`appName`+", "+`fileContent`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Update an entire application to a deployed application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Update the entire deployed application using update command"
                print " Application name:       "+appName
                print " File content:           "+fileContent
                print " Usage: AdminApplication.updateEntireAppToAnAppWithUpdateCommand(\""+appName+"\", \""+fileContent+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (fileContent == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileContent", fileContent]))
                
                # Identify deployment configuration object
                targetList = []
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   cell = AdminConfig.list("Cell")
                   cellName = AdminConfig.showAttribute(cell, "name")

                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                          target = "WebSphere:cell="+cellName+",cluster="+clusterName
                          targetList.append(target)
                          
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          target = "WebSphere:cell="+cellName+",node="+nodeName+",server="+serverName
                          targetList.append(target)
                       #endIf 
                   #endFor
                #endIf  
                
                newtarget = ""
                for t in targetList:
                    newtarget = t
                    if (len(targetList) > 1):
                       newtarget += "+" + t
                    else:
                       newtarget = t
                #endFor        

                opts = " -operation update"
                opts += " -contents "+fileContent
                opts += " -usedefaultbindings "
                opts += " -nodeployejb "
                
                # Use DefaultApplication.ear as example to map web modules to virtual host
                # opts += " -MapWebModToVH [['Default Application' 'default_app.war,WEB-INF/web.xml' vh1]] "
                
                opts += " -target "+newtarget

                AdminApp.update( appName, 'app', opts)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 32 export application ##
def exportAnAppToFile( appName, exportFile, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "exportAnAppToFile("+`appName`+", "+`exportFile`+", "+`failonerror`+"): "

        try:
                        #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # export an application to a file 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Export an application to a file "
                print " Application name:       "+appName
                print " Export file name:       "+exportFile
                print " Usage: AdminApplication.exportAnAppToFile(\""+appName+"\", \""+exportFile+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (exportFile == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["exportFile", exportFile]))
                   
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                
                AdminApp.export(appName, exportFile)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 33 Exporting all applications to the directory specified ##
def exportAllApplicationsToDir( exportDir, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "exportAllApplicationsToDir("+`exportDir`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Export all applications to a directory  
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Export all deployed applications to a directory"
                print " Export directory:       "+exportDir  
                print " Usage: AdminApplication.exportAllApplicationsToDir(\""+exportDir+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required argument 
                if (exportDir == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["exportDir", exportDir]))

                apps = AdminApp.list()
                # convert jython string to list
                applist = AdminUtilities.convertToList(apps)
                
                # loop through all applications
                for app in applist:
                    AdminUtilities.infoNotice("Export application " + app + " to " + exportDir) 
                    AdminApp.export(app, exportDir + "/" + app + ".ear")
                #endFor
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 34 Extract the data definition language (DDL) from the application to the directory  ##
def exportAnAppDDLToDir( appName, exportDir, options, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "exportAnAppDDLToDir("+`appName`+", "+`exportDir`+", "+`options`+", "+`failonerror`+"): "

        try:
                        #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Export application DDLs to a directory 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Export application DDLs to a directory"
                print " Application name:       "+appName
                print " Dictory to export DDL:  "+exportDir  
                print " Options:                "+options
                print " Usage: AdminApplication.exportAnAppDDLToDir(\""+appName+"\", \""+exportDir+"\", \""+options+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required argument 
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (exportDir == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["exportDir", exportDir]))
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                
                AdminApp.exportDDL(appName, exportDir, options)
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 35 Configure starting weight attribute for an application ##
def configureStartingWeightForAnApplication( appName, startingWeight, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureStartingWeightForAnApplication("+`appName`+", "+`startingWeight`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to modify the starting Weight attribute in the application deployment
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure the starting weight attribute for an application "
                print " Application name:       "+appName
                print " Starting weight:        "+startingWeight
                print " Usage: AdminApplication.configureStartingWeightForAnApplication(\""+appName+"\", \""+startingWeight+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (startingWeight == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["startingWeight", startingWeight]))
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Modify application deployment attribute
                   AdminConfig.modify(appdeploy, [["startingWeight", startingWeight]] )
                #endIf 
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 36 Configure class loader policy for an application ##
def configureClassLoaderPolicyForAnApplication( appName, classloaderPolicy, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureClassLoaderPolicyForAnApplication("+`appName`+", "+`classloaderPolicy`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to modify a class loader policy in the application deployment
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure the class loader policy attribute for an application "
                print " Application name:       "+appName
                print " Classloader policy:     "+classloaderPolicy
                print " Usage: AdminApplication.configureClassLoaderPolicyForAnApplication(\""+appName+"\", \""+classloaderPolicy+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (classloaderPolicy == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classloaderPolicy", classloaderPolicy]))

                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                
                # Retrieve application deployment object 
                appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                # Modify application deployment attribute
                AdminConfig.modify(appdeploy, [["warClassLoaderPolicy", classloaderPolicy]] )
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 37 Configure class loader loading mode for an application ##
def configureClassLoaderLoadingModeForAnApplication( appName, classloaderMode, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureClassLoaderLoadingModeForAnApplication("+`appName`+", "+`classloaderMode`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to modify a classloader loading mode attribute in the application deployment 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure the classloader loading mode attribute for an application "
                print " Application name:       "+appName
                print " Classloader mode:       "+classloaderMode
                print " Usage: AdminApplication.configureClassLoaderLoadingModeForAnApplication(\""+appName+"\", \""+classloaderMode+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (classloaderMode == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classloaderMode", classloaderMode]))

                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Identify classloader object and modify classloader attribute
                   classloader = AdminConfig.showAttribute(appdeploy, "classloader")
                   AdminConfig.modify(classloader, [["mode", classloaderMode]] )
                #endIf 
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 38 Configure session management for an application ##
def configureSessionManagementForAnApplication(appName, enableCookie, enableProtSwitching, enableURLRewriting, enableSSLTracking, allowSessionAccess, sessionTimeout, maxWaitTime, persistMode, overflow, sessionCount, invalidTimeout, sessionEnable, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureSessionManagementForAnApplication("+`appName`+", , "+`enableCookie`+", "+`enableProtSwitching`+", "+`enableURLRewriting`+", "+`enableSSLTracking`+", "+`allowSessionAccess`+", "+`sessionTimeout`+", "+`maxWaitTime`+", "+`persistMode`+", "+`overflow`+", "+`sessionCount`+", "+`invalidTimeout`+", "+`sessionEnable`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # An example to configure session management attribute in the application deployment 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:               Configure the session management attributes for an application "
                print " Application name:               "+appName
                print " Enable cookie:                  "+enableCookie
                print " Enable protocol switching:      "+enableProtSwitching
                print " Enable URL rewriting:           "+enableURLRewriting
                print " Enable SSL tracking:            "+enableSSLTracking
                print " Allow serialized session access:"+allowSessionAccess
                print " Access session on timeout:      "+sessionTimeout
                print " Maximum wait time:              "+maxWaitTime
                print " Session persistence mode:       "+persistMode
                print " Allow overflow:                 "+overflow
                print " Maximum in memory session count:"+sessionCount
                print " Invalid timeout:                "+invalidTimeout
                print " Session enable:                 "+sessionEnable
                print " Usage: AdminApplication.configureSessionManagementForAnApplication(\""+appName+"\", \""+enableCookie+"\", \""+enableProtSwitching+"\", \""+enableSSLTracking+"\", \""+allowSessionAccess+"\", \""+sessionTimeout+"\", \""+maxWaitTime+"\", \""+persistMode+"\", \""+overflow+"\", \""+sessionCount+"\", \""+invalidTimeout+"\", \""+sessionEnable+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (enableCookie == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classloaderPolicy", classloaderPolicy]))
                
                if (enableProtSwitching == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enableProtSwitching", enableProtSwitching]))
                
                if (enableURLRewriting == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enableURLRewriting", enableURLRewriting]))
                
                if (enableSSLTracking == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enableSSLTracking", enableSSLTracking]))
                
                if (allowSessionAccess == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["allowSessionAccess", allowSessionAccess]))
                
                if (sessionTimeout == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sessionTimeout", sessionTimeout]))
                
                if (maxWaitTime == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["maxWaitTime", maxWaitTime]))
                
                if (persistMode == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["persistMode", persistMode]))
                
                if (overflow == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["overflow", overflow]))
                
                if (sessionCount == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sessionCount", sessionCount]))
                
                if (invalidTimeout == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["invalidTimeout", invalidTimeout]))
                
                if (sessionEnable == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sessionEnable", sessionEnable]))
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Set up session management attributes. Attribute values can be changed
                   cookieAttr = ["enableCookies", enableCookie]
                   protocolAttr = ["enableProtocolSwitchRewriting", enableProtSwitching]
                   urlAttr = ["enableUrlRewriting", enableURLRewriting]
                   sslAttr = ["enableSSLTracking", enableSSLTracking]
                   accessAttr = ["allowSerializedSessionAccess", allowSessionAccess]
                   timeoutAttr = ["accessSessionOnTimeout", sessionTimeout]
                   waitTimeAttr = ["maxWaitTime", maxWaitTime]
                   modeAttr = ["sessionPersistenceMode", persistMode]
                   overflowAttr = ["allowOverflow", overflow]
                   sessionCountAttr = ["maxInMemorySessionCount", sessionCount]
                   invalidateTimeoutAttr = ["invalidationTimeout", invalidTimeout]
                   enableAttr = ["enable", sessionEnable]
                   tuningParamsAttr = ["tuningParams", [overflowAttr, invalidateTimeoutAttr, sessionCountAttr]]
                   attrs = [cookieAttr, urlAttr, sslAttr, protocolAttr, accessAttr, timeoutAttr, waitTimeAttr, modeAttr, enableAttr, tuningParamsAttr]
                   sessionMgrAttr = [["sessionManagement", attrs]]
                
                   # Create sesson manager for the application 
                   appConfig = AdminConfig.create("ApplicationConfig", appdeploy, sessionMgrAttr)
                #endIf  
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return appConfig
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
  
  
## Example 39 Configure application loading ##
def configureApplicationLoading( appName, enableTargetMapping, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureApplicationLoading("+`appName`+", "+`enableTargetMapping`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to configure application loading attribute in the deployed targets 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure application loading attribute for an application "
                print " Application name:       "+appName
                print " Enable target mapping:  "+enableTargetMapping
                print " Usage: AdminApplication.configureApplicationLoading(\""+appName+"\", \""+enableTargetMapping+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (enableTargetMapping == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enableTargetMapping", enableTargetMapping]))

                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Identify target mapping in the application 
                   targetMappings = AdminConfig.showAttribute(appdeploy, "targetMappings")
                
                   # Convert Jython string to list
                   targetMap = AdminUtilities.convertToList(targetMappings)
                
                   # loop on each target map and disable the application loading 
                   for target in targetMap:
                       print "Modify deploy target mapping: " + target
                       AdminConfig.modify(target, [["enable", enableTargetMapping]] )
                   #endFor
                #endIf  
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 40 Configure library reference for an application ##
def configureLibraryReferenceForAnApplication( appName, sharedLibrary, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureLibraryReferenceForAnApplication("+`appName`+", "+`sharedLibrary`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to create a shared library reference for an application 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure shared library reference for an application "
                print " Application name:       "+appName
                print " Shared library name:    "+sharedLibrary
                print " Usage: AdminApplication.configureLibraryReferenceForAnApplication(\""+appName+"\", \""+sharedLibrary+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (sharedLibrary == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sharedLibrary", sharedLibrary]))

                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Identify classloader object  
                   classloader = AdminConfig.showAttribute(appdeploy, "classloader")
                
                   # Create shared library through cloassloader
                   libRef = AdminConfig.create("LibraryRef", classloader, [["libraryName", sharedLibrary], ["sharedClassloader", "true"]] )
                #endIf  
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return libRef
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
  
    
## Example 41 Configure EJB modules of an application ##
def configureEJBModulesOfAnApplication( appName, startingWeight, enableTargetMapping, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureEJBModulesOfAnApplication("+`appName`+", "+`startingWeight`+", "+`enableTargetMapping`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to configure an EJB module attribute in the application deployment  
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure EJB module attributes of an application "
                print " Application name:       "+appName
                print " Starting weight:        "+startingWeight
                print " Enable target mapping:  "+enableTargetMapping
                print " Usage: AdminApplication.configureEJBModulesOfAnApplication(\""+appName+"\", \""+startingWeight+"\", \""+enableTargetMapping+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required arguemtns
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (startingWeight == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["startingWeight", startingWeight]))
                
                if (enableTargetMapping == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["enableTargetingMapping", enableTargetMapping]))
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Obtain modules object in the application 
                   modules = AdminConfig.showAttribute(appdeploy, "modules")
                
                   # Convert jython string to list
                   modules = AdminUtilities.convertToList(modules)
                
                   # Loop on each module and find ejbmodule deployment
                   for aModule in modules:
                       if (aModule.find("EJBModuleDeployment") >= 0):
                          # Modify ejbmodule attribute
                          AdminConfig.modify(aModule, [["startingWeight", startingWeight]] )
                        
                          # Identify target mappings object
                          targetMappings = AdminConfig.showAttribute(aModule, "targetMappings")
                        
                          # Convert jython string to list
                          targetMappings = AdminUtilities.convertToList(targetMappings)
                       
                          # loop on each deployed target mapping
                          for aTargetMapping in targetMappings:
                              AdminUtilities.infoNotice("Modify deployed target Mapping: " + aTargetMapping)
                              
                              # Modify target mapping attribute
                              AdminConfig.modify(aTargetMapping, [["enable", enableTargetMapping]] )
                          #endFor
                       #endIf       
                    #endFor
                #endIf
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  
  
## Example 42 Configure web modules of an application ##
def configureWebModulesOfAnApplication(appName, webModule, startingWeight, classloaderMode, failonerror=AdminUtilities._BLANK_,
                                       createSessionManager=AdminUtilities._TRUE_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureWebModulesOfAnApplication(" + `appName` + ", " + `webModule` + ", " + `startingWeight` + ", " + `classloaderMode` + ", " + `failonerror` + ", " + `createSessionManager` + "): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to configure web modules attribute in the application deployment 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Configure web module attributes of an application "
                print " Application name:       "+appName
                print " Web module name:        "+webModule
                print " Starting weight:        "+startingWeight
                print " Classloader mode:       "+classloaderMode
                print " Usage: AdminApplication.configureWebModulesOfAnApplication(\""+appName+"\", \""+webModule+"\", \""+startingWeight+"\", \""+classloaderMode+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (webModule == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["webModule", webModule]))
                
                if (startingWeight == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["startingWeight", startingWeight]))
                
                if (classloaderMode == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["classloaderMode", classloaderMode]))
                
                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Obtain modules object in the application deployment
                   modules = AdminConfig.showAttribute(appdeploy, "modules")
                
                   # Convert jython string to list
                   modules = AdminUtilities.convertToList(modules)
                
                   # Set web module attributes and attribute values can be changed
                   weightAttr = ["startingWeight", startingWeight]
                   loaderModeAttr = ["classloaderMode", classloaderMode]
                   nameAttr = ["name", webModule]
                   descAttr = ["description", "Web Module config post create"]
                   enableAttr = ["enable", "true"]
                   sessionAttr = [enableAttr]
                   sessionMgrAttr = ["sessionManagement", sessionAttr]
                   webAttrs = [nameAttr, descAttr, sessionMgrAttr]                
                   # Loop on each modules and find web module deployment objects
                   for aModule in modules:
                       if (aModule.find("WebModuleDeployment") >= 0):
                           cfgCount = len(AdminUtilities.convertToList(
                               AdminConfig.showAttribute(aModule, "configs")))
                           if ( (cfgCount==0) & (createSessionManager==AdminUtilities._TRUE_)):
                               # Create a new web module config
                               webconfig = AdminConfig.create("WebModuleConfig", aModule, webAttrs)
                               AdminUtilities.infoNotice("Create a new web module config: " + webconfig)
                           #endIf
                              
                           # Modify web module attributes
                           AdminConfig.modify(aModule, [weightAttr, loaderModeAttr])
                           AdminUtilities.infoNotice("Modify web module attributes: " + aModule)
                       #endIf
                   #endFor
                #endIf  
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
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
  

## Example 43 Configure connector modules of an application ##
def configureConnectorModulesOfAnApplication( appName, j2cconnFactory, jndiName, authDataAlias, connTimeout, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "configureConnectorModulesOfAnApplication("+`appName`+", "+`j2cconnFactory`+", "+`jndiName`+", "+`authDataAlias`+", "+`connTimeout`+", "+`failonerror`+"): "

        try:
                        #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # An example to configure connector module attributes in the application deployment
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:               Configure connector module attributes of an application "
                print " Application name:               "+appName
                print " J2C connector factory:          "+j2cconnFactory
                print " JNDI name:                      "+jndiName
                print " Authentication data alias:      "+authDataAlias
                print " Connection timout:              "+connTimeout
                print " Usage: AdminApplication.configureConnectorModulesOfAnApplication(\""+appName+"\", \""+j2cconnFactory+"\", \""+jndiName+"\", \""+authDataAlias+"\", \""+connTimeout+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (j2cconnFactory == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["j2cconnFactory", j2cconnFactory]))
                
                if (jndiName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["jndiName", jndiName]))
                
                if (authDataAlias == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["authDataAlias", authDataAlias]))
                
                if (connTimeout == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["connTimeout", connTimeout]))

                # Identify deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   # Retrieve application deployment object 
                   appdeploy = AdminConfig.showAttribute(deployment, "deployedObject")
                
                   # Obtain modules object in the application deployment
                   modules = AdminConfig.showAttribute(appdeploy, "modules")
                
                   # Convert Jython string to list
                   modules = AdminUtilities.convertToList(modules)
                
                   # Set connection module attributes and attribute values can be changed 
                   nameAttr = ["name", j2cconnFactory]
                   descAttr = ["description", "Connection Factory created in application post configuration"]
                   jndiAttr = ["jndiName", jndiName]
                   authDataAttr = ["authDataAlias", authDataAlias]
                   timeoutAttr = ["connectionTimeout", connTimeout] 
                   connectionPoolAttr = ["connectionPool", [timeoutAttr]]
                   attrs = [nameAttr, descAttr, jndiAttr, authDataAttr, connectionPoolAttr]
                
                   # Loop on each module object and find connector module deployment
                   for aModule in modules:
                       if (aModule.find("ConnectorModuleDeployment") >= 0):
                          AdminUtilities.infoNotice("Find Connector module: " + aModule)
                        
                          # Identify resource adapter configuration object
                          aResAdapter = AdminConfig.showAttribute(aModule, "resourceAdapter")
                          AdminUtilities.infoNotice("Find J2CResourceAdapter: " + aResAdapter) 
                        
                          # Create a new J2CConnectionFactory object
                          J2CconnFactory = AdminConfig.create("J2CConnectionFactory", aResAdapter, attrs)
                          AdminUtilities.infoNotice("Create a new J2CConnectionFactory " + J2CconnFactory)
                       #endIf
                   #endFor
                #endIf 
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
                #return J2CconnFactory
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


## Example 44 Start application on single server ##
def startApplicationOnSingleServer( appName, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "startApplicationOnSingleServer("+`appName`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                        #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Start application on a single server
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Start an application on a single server "
                print " Application name:       "+appName
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.startApplicationOnSingleServer(\""+appName+"\", \""+nodeName+"\", \""+ serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
               
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                              
                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))
                 
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
                
                # Check if server is a webserver
                if (AdminConfig.showAttribute(server, 'serverType') == "WEB_SERVER"): 
                   AdminUtilities.infoNotice("Applications may not be started on a WebServer. Ignoring request to start " + appName + " on server named " + serverName + ".")
                   AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
                   return 1 #succeed
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Check if application is deployed on server target
                app = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(app) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", [appName, serverName]))
                else:
                   found = 0
                   targets = AdminConfig.showAttribute(app, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   for dt in targets:
                       # Application deployed on server
                       if (dt.find("ServerTarget") > 0):
                          sName = AdminConfig.showAttribute(dt, "name")
                          nName = AdminConfig.showAttribute(dt, "nodeName")
                          if (sName ==  serverName and nName == nodeName):
                             found = 1
                             break
                          #endIf
                       #endIf   
                   #endFor
                   if (found == 0):
                      # Application is not deployed on server
                      AdminUtilities.infoNotice("Application "+appName+ " is not deployed on the server "+serverName)
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6048E", [appName, serverName]))
                   #endIf
                #endIf

                # Query application MBean, PM35734 query Application mbean on specific process
                runningApp = AdminControl.queryNames("type=Application,name="+appName+",cell="+cellName+",node="+nodeName+",process="+serverName+",*")
                
                if (len(runningApp) > 0):
                   # Application is running
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6043E", ["Application", appName]))
                else:
                   # Query application manager mbean
                   appManager = AdminControl.queryNames("cell="+cellName+",node="+nodeName+",type=ApplicationManager,process="+serverName+",*")
                   
                   if (len(appManager) == 0):
                      # application manager mbean is not running on server
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                   else:
                      # Start application
                      AdminControl.invoke(appManager, "startApplication", appName)
                   #endIf
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
  
  
## Example 45 Start application on all deployed targeted nodes ##
def startApplicationOnAllDeployedTargets( appName, nodeName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "startApplicationOnAllDeployedTargets("+`appName`+", "+`nodeName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Start application on all deployed targets 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Start an application on all deployed nodes "
                print " Application name:       "+appName
                print " Node name:              "+nodeName
                print " Usage: AdminApplication.startApplicationOnAllDeployedTargets(\""+appName+"\", \""+nodeName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                              
                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(app) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                #endIf
                
                # find deployment targets
                deployment = AdminConfig.getid("/Deployment:"+appName+"/" )
                targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                targets = AdminUtilities.convertToList(targets)
                
                for dt in targets:
                   # Application deployed on cluster
                   if (dt.find("ClusteredTarget") > 0):
                      clusterName = AdminConfig.showAttribute(dt, "name")
                      # Get all cluster members
                      members = AdminConfig.getid("/ServerCluster:"+clusterName+"/ClusterMember:/")
                      members = AdminUtilities.convertToList(members)
                      if (len(members) == 0):
                         # No cluster members are found
                         raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ClusterMember"]))
                      else:   
                         # Find cluster member node
                         for member in members:
                            serverName = AdminConfig.showAttribute(member, "memberName")
                            #AdminUtilities.infoNotice("Cluster has server member: " + serverName)
                            nName = AdminConfig.showAttribute(member, "nodeName")
                            if (nName == nodeName):
                               # Query application manager MBeans  
                               appManager = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=ApplicationManager,*")
                               if (len(appManager) == 0):
                                  raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                               else:
                                  AdminControl.invoke(appManager, "startApplication", appName)
                            #endIf      
                         #endFor
                      #endIf
                   # application deploy on server target       
                   else:
                      serverName = AdminConfig.showAttribute(dt, "name")
                      nName = AdminConfig.showAttribute(dt, "nodeName")
                      server = AdminConfig.getid("/Node:"+nName+"/Server:"+serverName+"/")
                      if (AdminConfig.showAttribute(server, 'serverType') == "WEB_SERVER"):
                         AdminUtilities.infoNotice("Applications may not be started on a WebServer. Ignoring request to start " + appName + " on server named " + serverName + ".")
                      else:    
                         if (nName == nodeName):
                            # Query application manager MBeans  
                            appManager = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=ApplicationManager,*")
                            
                            if (len(appManager) == 0):
                               raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                            else:
                               AdminControl.invoke(appManager, "startApplication", appName)
                            #endIf
                      #endIf
                   #endIf
                #endFor
                
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
  
  
## Example 46 Stop application on single server ##
def stopApplicationOnSingleServer( appName, nodeName, serverName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "stopApplicationOnSingleServer("+`appName`+", "+`nodeName`+", "+`serverName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Stop application on single server 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Stop an application on single server "
                print " Application name:       "+appName
                print " Node name:              "+nodeName
                print " Server name:            "+serverName
                print " Usage: AdminApplication.stopApplicationOnSingleServer(\""+appName+"\", \""+nodeName+"\", \""+serverName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                              
                if (serverName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["serverName", serverName]))
                               
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
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(app) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(app, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   found = 0
                   for dt in targets:
                       # Application deployed on server
                       if (dt.find("ServerTarget") > 0):
                          sName = AdminConfig.showAttribute(dt, "name")
                          nName = AdminConfig.showAttribute(dt, "nodeName")
                          if (sName ==  serverName and nName == nodeName):
                             found = 1
                             break
                          #endIf
                       #endIf   
                   #endFor
                   if (found == 0):
                      # Application is not deployed on server
                      AdminUtilities.infoNotice("Application "+appName+ " is not deployed on the server "+serverName)
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6048E", [appName, serverName]))
                   #endIf
                #endIf

                # Check whether the application is running
                runningApp = AdminControl.queryNames("type=Application,name="+appName+",*")
                if (len(runningApp) == 0):
                   # Application is not running
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Application", appName]))
                else:
                   # Query application manager MBean and stop application      
                   appManager = AdminControl.queryNames("cell="+cellName+",node="+nodeName+",type=ApplicationManager,process="+serverName+",*")
                   
                   if (len(appManager) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                   else:
                      AdminControl.invoke(appManager, "stopApplication", appName)
                   #endIf
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
  
  
## Example 47 Stop application on all targeted nodes ##
def stopApplicationOnAllDeployedTargets( appName, nodeName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "stopApplicationOnAllDeployedTargets("+`appName`+", "+`nodeName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Stop application on all deployed targets 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Stop application on all deployed nodes "
                print " Application name:       "+appName
                print " Node name:              "+nodeName
                print " Usage: AdminApplication.stopApplicationOnAllDeployedTargets(\""+appName+"\", \""+nodeName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (nodeName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["nodeName", nodeName]))
                              
                # Check if node exists
                node = AdminConfig.getid("/Node:"+nodeName+"/")
                if (len(node) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["nodeName", nodeName]))
                #endIf
                
                cell = AdminConfig.list("Cell")
                cellName = AdminConfig.showAttribute(cell, "name")
                
                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/")
                if (len(app) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                #endIf
                
                # check whether application is running
                runningApp = AdminControl.queryNames("type=Application,name="+appName+",*")
                if (len(runningApp) == 0):
                   # Application is not running
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Application", appName]))
                else:
                   # find deployment targets
                   deployment = AdminConfig.getid("/Deployment:"+appName+"/" )
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                
                   for dt in targets:
                      # Application deployed on cluster
                      if (dt.find("ClusteredTarget") > 0):
                         clusterName = AdminConfig.showAttribute(dt, "name")
                         # Get all cluster members
                         members = AdminConfig.getid("/ServerCluster:"+clusterName+"/ClusterMember:/")
                         members = AdminUtilities.convertToList(members)
                         if (len(members) == 0):
                            # No cluster members are found
                            raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ClusterMember"]))
                         else:   
                            # Find cluster member node
                            for member in members:
                               serverName = AdminConfig.showAttribute(member, "memberName")
                               #AdminUtilities.infoNotice("Cluster has server member: " + serverName)
                               nName = AdminConfig.showAttribute(member, "nodeName")
                               if (nName == nodeName):
                                  # Query application manager MBeans  
                                  appManager = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=ApplicationManager,*")
                                  if (len(appManager) == 0):
                                     raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                                  else:
                                     AdminControl.invoke(appManager, "stopApplication", appName)
                               #endIf      
                            #endFor
                         #endIf
                      # application deployed on server target       
                      else:
                         serverName = AdminConfig.showAttribute(dt, "name")
                         nName = AdminConfig.showAttribute(dt, "nodeName")
                         if (nName == nodeName):
                            # Query application manager MBeans  
                            appManager = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=ApplicationManager,*")
                            
                            if (len(appManager) == 0):
                               raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                            else:
                               AdminControl.invoke(appManager, "stopApplication", appName)
                         #endIf
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


## Example 48 Check if application exists ##
def checkIfAppExists ( appName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "checkIfAppExists("+`appName`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Check if application exists
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Check if application exists"
                print " Application Name:       "+appName
                print " Usage: AdminApplication.checkIfAppExists(\""+appName+"\")"
                print " Return: Checks whether the application exists. If the application exists, a true value is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                appExists = "true"
                
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))

                # Retrieve application deployment configuration object
                app = AdminConfig.getid("/Deployment:"+appName+"/" )

                # Check if application exists, return true if app exists
                if (len(app) == 0):
                   appExists = "false"
                return appExists 
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

  
## Example 49 Get application deployment target ##
def getAppDeploymentTarget (appName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "getAppDeploymentTarget("+`appName`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminConfig
                
                #--------------------------------------------------------------------
                # Get application deployment target
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Get application deployment target"
                print " Application Name:       "+appName
                print " Usage: AdminApplication.getAppDeploymentTarget(\""+appName+"\")"
                print " Return: List the application deployment target for a specified application."
                print "---------------------------------------------------------------"
                print " "
                print " "
                targets = ""
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                # Retrieve application deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/" )

                # Check if deployment target exists
                if (len(deployment) == 0):
                    raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                #endIf
                return targets
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


## Example 50 Determine which nodes the application are deployed on ##
def getAppDeployedNodes (appName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "getDeploymentTarget("+`appName`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminApp
                
                #--------------------------------------------------------------------
                # Get the application deployed node list
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Get application deployed nodes"
                print " Application Name:       "+appName
                print " Usage: AdminApplication.getAppDeployedNodes(\""+appName+"\")"
                print " Return: List the node names on which the specified application is deployed."
                print "---------------------------------------------------------------"
                print " "
                print " "
                nodelist = []  
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))

                # Retrieve application deployment configuration object
                deployment = AdminConfig.getid("/Deployment:"+appName+"/" )

                # Check if deployment target exists
                if (len(deployment) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                else:
                   targets = AdminConfig.showAttribute(deployment, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                
                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          clusterName = AdminConfig.showAttribute(dt, "name")
                       
                          # Get all cluster members
                          members = AdminConfig.getid("/ServerCluster:"+clusterName+"/ClusterMember:/")
                          members = AdminUtilities.convertToList(members)
                       
                          # Find each cluster member node
                          for member in members:
                              nodeName = AdminConfig.showAttribute(member, "nodeName")
                              if (nodelist.count(nodeName) <= 0):
                                 AdminUtilities.infoNotice("Application deployed on node: " + nodeName)
                                 nodelist.append(nodeName)
                              #endIf   
                          #endFor
                       # Application deployed on server      
                       elif (dt.find("ServerTarget") > 0):
                          serverName = AdminConfig.showAttribute(dt, "name")
                          nodeName = AdminConfig.showAttribute(dt, "nodeName")
                          if (nodelist.count(nodeName) <= 0):
                             AdminUtilities.infoNotice("Application deployed on node: " + nodeName)
                             nodelist.append(nodeName)
                          #endIf
                       #endIf   
                   #endFor 
                #endIf
                return nodelist   
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


## Example 51 Start application on cluster ##
def startApplicationOnCluster( appName, clusterName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "startApplicationOnCluster("+`appName`+", "+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Start application on a cluster 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Start an application on a cluster "
                print " Application name:       "+appName
                print " Cluster name:           "+clusterName
                print " Usage: AdminApplication.startApplicationOnCluster(\""+appName+"\", \""+clusterName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                #endIf
                   
                # Check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:"+clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf

                if (len(app) > 0):
                   # Check if application is deployed on cluster
                   targets = AdminConfig.showAttribute(app, "deploymentTargets")
                   targets = AdminUtilities.convertToList(targets)
                   found = 0
                   for dt in targets:
                       # Application deployed on cluster
                       if (dt.find("ClusteredTarget") > 0):
                          cName = AdminConfig.showAttribute(dt, "name")
                          if (cName ==  clusterName):
                             found = 1
                          #endIf
                       #endIf
                   #endFor
                   if (found == 0):
                      # Application is not deployed on cluster
                      AdminUtilities.infoNotice("Application "+appName+ " is not deployed on the cluster "+clusterName)
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6048E", [appName, clusterName]))
                   #endIf
                #endIf
                                
                # check whether application is running
                runningApp = AdminControl.queryNames("type=Application,name="+appName+",*")
                if (len(runningApp) > 0):
                   # Application is running
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6043E", ["Application", appName]))
                else:
                   # Check if the cluster is running
                    clusterMbean = AdminControl.completeObjectName("type=Cluster,name="+clusterName+",*")
                    if (len(clusterMbean) == 0 or AdminControl.getAttribute(clusterMbean, "state") != "websphere.cluster.running"):
                       # Cluster is not running
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", clusterName]))
                    else:
                       # Get all cluster members
                       members = AdminConfig.getid("/ServerCluster:"+clusterName+"/ClusterMember:/")
                       members = AdminUtilities.convertToList(members)
                       if (len(members) == 0):
                          # No cluster members are found
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ClusterMember"]))
                       else:   
                          # Find each cluster member node
                          for member in members:
                              serverName = AdminConfig.showAttribute(member, "memberName")
                              AdminUtilities.infoNotice("Cluster has server member: " + serverName)
                              nodeName = AdminConfig.showAttribute(member, "nodeName")
                              AdminUtilities.infoNotice("application deployed on server membered node: " + nodeName)
                       
                              # Query application manager MBeans  
                              appManager = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=ApplicationManager,*")
                   
                              # Convert Jython string to list
                              if (len(appManager) == 0):
                                 # Application MBean is not running on server
                                 raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                              else:
                                 appManager = AdminUtilities.convertToList(appManager)
                   
                                 # Loop on each application manager and start the application
                                 for mgr in appManager:
                                     AdminUtilities.infoNotice("Start application ...")
                                     AdminControl.invoke(mgr, "startApplication", appName)
                                 #endFor
                              #endIf
                          #endFor      
                       #endIf
                    #endIf
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


## Example 52 Stop application on cluster ##
def stopApplicationOnCluster( appName, clusterName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "stopApplicationOnCluster("+`appName`+", "+`clusterName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminControl
                
                #--------------------------------------------------------------------
                # Stop application on cluster 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminApplication:       Stop application on a cluster "
                print " Application name:       "+appName
                print " Cluster name:           "+clusterName
                print " Usage: AdminApplication.stopApplicationOnCluster(\""+appName+"\", \""+clusterName+"\")"
                print " Return: If the command is successful, a value of 1 is returned. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # Check the required parameters
                if (appName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["appName", appName]))
                
                if (clusterName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["clusterName", clusterName]))

                # Check if application exists
                app = AdminConfig.getid("/Deployment:"+appName+"/" )
                if (len(app) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["appName", appName]))
                #endIf
                   
                # Check if cluster exists
                cluster = AdminConfig.getid("/ServerCluster:"+clusterName+"/")
                if (len(cluster) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["clusterName", clusterName]))
                #endIf

                targets = AdminConfig.showAttribute(app, "deploymentTargets")
                targets = AdminUtilities.convertToList(targets)
                found = 0
                for dt in targets:
                    # Application deployed on cluster
                    if (dt.find("ClusteredTarget") > 0):
                       cName = AdminConfig.showAttribute(dt, "name")
                       if (cName ==  clusterName):
                          found = 1
                       #endIf
                    #endIf
                #endFor
                if (found == 0):
                   # Application is not deployed on cluster
                   AdminUtilities.infoNotice("Application "+appName+ " is not deployed on the cluster "+clusterName)
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6048E", [appName, clusterName]))
                #endIf
                
                # Check whether the application is running
                runningApp = AdminControl.queryNames("type=Application,name="+appName+",*")
                if (len(runningApp) == 0):
                   # application is not running
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Application", appName]))
                else:
                   # Check if the cluster is running
                    clusterMbean = AdminControl.completeObjectName("type=Cluster,name="+clusterName+",*")
                    if (len(clusterMbean) == 0 or AdminControl.getAttribute(clusterMbean, "state") != "websphere.cluster.running"):
                       # Cluster is not running
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["Cluster", clusterName]))
                    else:
                       # Get all cluster members
                       members = AdminConfig.getid("/ServerCluster:"+clusterName+"/ClusterMember:/")
                       members = AdminUtilities.convertToList(members)
                       if (len(members) == 0):
                          # No cluster members are found
                          raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6042E", ["ClusterMember"]))
                       else:      
                          # Find each cluster member node
                          for member in members:
                             serverName = AdminConfig.showAttribute(member, "memberName")
                             AdminUtilities.infoNotice("Cluster has server member: " + serverName)
                             nodeName = AdminConfig.showAttribute(member, "nodeName")
                             AdminUtilities.infoNotice("application deployed on server membered node: " + nodeName)
                       
                             # Query application manager MBeans
                             appManager = AdminControl.queryNames("node="+nodeName+",process="+serverName+",type=ApplicationManager,*")
                             if (len(appManager) == 0):
                                raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6044E", ["ApplicationManager", "ApplicationManager"]))
                             else:
                                # Convert Jython string to list
                                appManager = AdminUtilities.convertToList(appManager)
                   
                                # Loop on each application manager and stop application 
                                for mgr in appManager:
                                    AdminUtilities.infoNotice("Stop application ...")
                                    AdminControl.invoke(mgr, "stopApplication", appName)
                                #endFor                                                                                             
                             #endIf   
                          #endFor
                       #endIf
                    #endIf             
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


## Example 53 Online help  ##
def help(procedure="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf

        try:
                #--------------------------------------------------------------------
                # Provide the online help
                #--------------------------------------------------------------------
                #print "---------------------------------------------------------------"
                #print " AdminApplication:       Help "
                #print " Script procedure:       "+procedure
                #print " Usage: AdminApplication.help(\""+procedure+"\")"
                #print " Return: List the help information for the specified AdminApplication script library function or list the help information for all of the AdminApplication script library functions if parameters are not passed. "
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)
               
                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINAPPLICATION_GENERAL_HELP")
                else:
                   procedure = "ADMINAPPLICATION_HELP_"+procedure.upper()
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
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef

