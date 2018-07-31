# This file is used to migrate Compute Grid 6.1, Compute Grid 8 or Modern Batch (Feature Pack or WebSphere 8) to the Compute Grid support within WebSphere 8.5
#
# Instructions to use:
# Migration is performed in the following order
# 1. Dmgr 2. Schedulers 3. Endpoints
#
# NOTE: Prior to running this script, there are some additional WebSphere environment variables that need to be created to support the
# migration. To create them, change your directory to the Deployment manager’s bin directory (WAS_HOME/bin), and execute the following script
#
# wsadmin.bat -lang jython -f <Websphere V8.5 WAS_HOME>/bin/addCGSystemAppVariables.py
#
# On the Deployment Manager (with Deployment Manager still running) 
# 1. Run: wsadmin.bat -lang jython -f migrateConfigTo85.py --backup [-configBackupDir /tmp] [-nameOfProfile dmgrprofilename]
# 
# 2. Stop the Deployment Manager
#
# 3. Migrate the Deployment Manager to WebSphere 8.5
#
# 4. Stop scheduler and endpoint servers and nodeagents.
#
# 5. Change to the "bin" directory of your WebSphere 8.5 Deployment Manager (<Websphere V8.5 WAS_HOME>/bin) and execute the
#   following script to migrate the configuration 
#
#   wsadmin.bat -conntype NONE -lang jython -f <Websphere V8.5 WAS_HOME>/bin/migrateConfigTo85.py --wasmigrate -oldWASHome <oldWASHome>
#   -newWASHome <newWASHome> -cellName <cell> -nameOfProfile <profile> -configBackupDir <PathToBackupLocation>
#
# 6. Start the WebSphere 8.5 Deployment Manager
#
# 7.  Change to the "bin" directory of your WebSphere 8.5. Deployment Manager (<Websphere V8.5 WAS_HOME>/bin) and execute the following script to restore
#   the migrated configuration:
#   
#  (The arguments in brackets are optional, depending on your configuration)
#
# wsadmin.bat -lang jython -f <Websphere V8.5 WAS_HOME>/bin/migrateConfigTo85.py --restore -nameOfProfile <profile> -configBackupDir <PathToBackupLocation>
# [-lreeJNDIName <lreeJNDIName>] [-lrsJNDIName <lrsJNDIName>] [-lreeSchema <lreeSchema>]
#
# 8. Migrate the LRSCHED and LREE databases using the appropriate DDLs
#  (This step not needed if migrating from Compute Grid 8.0)
#
# On App Servers (Migrate your schedulers, followed by endpoints)
#
# 1. Migrate your server to WebSphere 8.5
#
# 2. Start nodeagent, wait for node to sync.  At the node profile's bin directory, run the following command:
# wsadmin.bat -lang jython -f migrateConfig.py --restore -node mynode
# 
# 3. Start the application server
#

# # Change History
# --------------
# 3-10-11 initial version created
#=======================================================================================================================================================

import sys
import os
import re
import string
import javax.management as mgmt
from shutil import copy
from shutil import copytree
from shutil import copyfile
from shutil import rmtree
from java.io import File
from java.io import FileInputStream
from java.util import Properties


lineSeparator  = java.lang.System.getProperty("line.separator")
fileSeparator  = java.lang.System.getProperty("file.separator")
wasInstallRoot = java.lang.System.getProperty("was.install.root")
userInstallRoot = java.lang.System.getProperty("user.install.root")
osname         = java.lang.System.getProperty("os.name");
# ***********************
# delete cg6.1 cleanupNode files
# ***********************
def deleteFiles(profileName):
   configPath = wasInstallRoot + fileSeparator +  "profiles"  + fileSeparator + profileName + fileSeparator + "bin"
   
   cellName = getCellName()
   varName = "USER_INSTALL_ROOT"
   filesList = []
   found = "false"
   
   nodeList = AdminConfig.list("Node").split(lineSeparator)
   for node in nodeList:
        isDmgr = "false"
        nodeName = AdminConfig.showAttribute(node,"name")
        varMap = AdminConfig.getid("/Cell:" + cellName + "/Node:" + nodeName + "/VariableMap:/")
        serverEntries = AdminConfig.list("ServerEntry", node).split(lineSeparator)
        for serverEntry in serverEntries:
            serverType = AdminConfig.showAttribute(serverEntry, "serverType" )
            if serverType == "DEPLOYMENT_MANAGER":
                isDmgr = "true"

        if isDmgr == "false":
            entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
            eList = entries.splitlines()
            for entry in eList:
                name = AdminConfig.showAttribute(entry, "symbolicName")
                if name == varName:
                    value = AdminConfig.showAttribute(entry, "value")
            filePathUnix = value + fileSeparator + "bin" + fileSeparator + "cleanupNode.sh"
            filePathWin = value + fileSeparator + "bin" + fileSeparator + "cleanupNode.bat"
            if os.path.exists(filePathUnix):
                found = "true"
                print "Deleting file: " + filePathUnix + "..."
                os.unlink(filePathUnix)
                filesList.append(filePathUnix)
            
            if os.path.exists(filePathWin):
                print "Deleting file: " + filePathWin + "..."
                os.unlink(filePathWin)
                filesList.append(filePathWin)

   return

# ***********************
# rename cg6.1 cleanupNode files
# ***********************
def renameFiles():
   
   cellName = getCellName()
   varName = "USER_INSTALL_ROOT"
   filesList = []
   found = "false"
   
   nodeList = AdminConfig.list("Node").split(lineSeparator)
   for node in nodeList:
        isDmgr = "false"
        nodeName = AdminConfig.showAttribute(node,"name")
        varMap = AdminConfig.getid("/Cell:" + cellName + "/Node:" + nodeName + "/VariableMap:/")
        serverEntries = AdminConfig.list("ServerEntry", node).split(lineSeparator)
        for serverEntry in serverEntries:
            serverType = AdminConfig.showAttribute(serverEntry, "serverType" )
            if serverType == "DEPLOYMENT_MANAGER":
                isDmgr = "true"

        if isDmgr == "false":
            entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
            eList = entries.splitlines()
            for entry in eList:
                name = AdminConfig.showAttribute(entry, "symbolicName")
                if name == varName:
                    value = AdminConfig.showAttribute(entry, "value")
            filePathUnix = value + fileSeparator + "bin" + fileSeparator + "cleanupNode.sh"
            filePathWin = value + fileSeparator + "bin" + fileSeparator + "cleanupNode.bat"
            if os.path.exists(filePathUnix):
                found = "true"
                newFileName = filePathUnix + "_backup"
                print "Renaming file: " + filePathUnix + " to " + newFileName
                os.rename(filePathUnix, newFileName)
                filesList.append(filePathUnix)
            
            if os.path.exists(filePathWin):
                newFileName = filePathWin + "_backup"
                print "Renaming file: " + filePathWin + " to " + newFileName
                os.rename(filePathWin, newFileName)
                filesList.append(filePathWin)

   return

# ***********************
# check for cg6.1 cleanupNode
# ***********************
def scriptCheck(profileName):

   setOldProfilePath(profileName,wasInstallRoot)
   configPath = oldProfilePath + fileSeparator + "bin"
   
   cellName = getCellName()
   varName = "USER_INSTALL_ROOT"
   filesList = []
   found = "false"
   
   nodeList = AdminConfig.list("Node").split(lineSeparator)
   for node in nodeList:
        isDmgr = "false"
        nodeName = AdminConfig.showAttribute(node,"name")
        varMap = AdminConfig.getid("/Cell:" + cellName + "/Node:" + nodeName + "/VariableMap:/")
        serverEntries = AdminConfig.list("ServerEntry", node).split(lineSeparator)
        for serverEntry in serverEntries:
            if len(serverEntry) > 0:
               serverType = AdminConfig.showAttribute(serverEntry, "serverType" )
               if serverType == "DEPLOYMENT_MANAGER":
                   isDmgr = "true"

        if isDmgr == "false":
            if len(varMap) > 0:
               entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
               eList = entries.splitlines()
               for entry in eList:
                   name = AdminConfig.showAttribute(entry, "symbolicName")
                   if name == varName:
                       value = AdminConfig.showAttribute(entry, "value")

               filePathUnix = value + fileSeparator + "bin" + fileSeparator + "cleanupNode.sh"
               filePathWin = value + fileSeparator + "bin" + fileSeparator + "cleanupNode.bat"
               if os.path.exists(filePathUnix):
                   found = "true"
                   filesList.append(filePathUnix)
            
               if os.path.exists(filePathWin):
                   found = "true"
                   filesList.append(filePathWin)

   if found == "true":
        print
        print "ERROR: The following file(s) must be deleted or renamed before continuing"
        for file in filesList:
            print file
        print
        print "Run the migrateConfigTo85.py script with the --cleanupFiles option to remove these files.  Ensure the user running the script has write access to the old configuration"
        print
        print "Example:"
        print "wsadmin.sh/.bat -f migrateConfigTo85.py --cleanupFiles"
        sys.exit()
   return

def setNewProfilePath(profileName, installRoot):
    # In WebSphere 6.1 on z/OS, the profileRegistry.xml file is at WAS_HOME/profileRegistry.xml, instead of under the properties dir
    if osname == "z/OS":
         if os.path.exists(installRoot + fileSeparator + "profileRegistry.xml"):
              profileRegistryXML = installRoot + fileSeparator + "profileRegistry.xml"
         else:
              profileRegistryXML = getProfileRegLocation()
    else:
         profileRegistryXML = getProfileRegLocation()
    stringToFind = "name=\""+profileName+"\""
    profileRegistryXMLFile = open(profileRegistryXML, "r")
    found = "false"
    line=profileRegistryXMLFile.readline()
    global newProfilePath
    while line:
       line=profileRegistryXMLFile.readline()
       pos = string.find(line,stringToFind)
       if (pos > 0):
          found = "true"
          m = re.search('path="(.*?)"', line)
          newProfilePath = m.group(1)
          break

    profileRegistryXMLFile.close()
    if (found == "false"):
        print "Profile " + profileName + " not found"
        sys.exit()

def setOldProfilePath(profileName, installRoot):
    # In WebSphere 6.1 on z/OS, the profileRegistry.xml file is at WAS_HOME/profileRegistry.xml, instead of under the properties dir
    if osname == "z/OS":
         if os.path.exists(installRoot + fileSeparator + "profileRegistry.xml"):
              profileRegistryXML = installRoot + fileSeparator + "profileRegistry.xml"
         else:
              profileRegistryXML = getProfileRegLocation()
    else:
         profileRegistryXML = getProfileRegLocation()

    stringToFind = "name=\""+profileName+"\""
    profileRegistryXMLFile = open(profileRegistryXML, "r")
    found = "false"
    line=profileRegistryXMLFile.readline()
    global oldProfilePath
    while line:
       line=profileRegistryXMLFile.readline()
       pos = string.find(line,stringToFind)
       if (pos > 0):
          found = "true"
          m = re.search('path="(.*?)"', line)
          oldProfilePath = m.group(1)
          break

    profileRegistryXMLFile.close()
    if (found == "false"):
        print "Profile " + profileName + " not found"
        sys.exit()

# ***********************
# load profiles config
# ***********************
#Load properties file in java.util.Properties
def loadPropsFil(propsFil):

 inStream = FileInputStream(propsFil)
 propFil = Properties()
 propFil.load(inStream)

 return propFil

def getProfileRegLocation():

 myPropFil = loadPropsFil(wasInstallRoot+ fileSeparator + 'properties' + fileSeparator + 'wasprofile.properties')
 keys = myPropFil.keySet()
 for key in keys:
  if key == "WS_PROFILE_REGISTRY":
     profileRegLoc = myPropFil.getProperty(key)
 
 if os.path.isfile(profileRegLoc): # test to see if the file name is a valid file
	return profileRegLoc           # if so return it
 else:
	if profileRegLoc != "${was.install.root}/properties/profileRegistry.xml":
		print "Profile Registry File: " + profileRegLoc + " not found. Will attempt to use default Profile Registry File"
	defaultProfileRegLoc = wasInstallRoot + fileSeparator + "properties" + fileSeparator + "profileRegistry.xml"
	if os.path.isfile(defaultProfileRegLoc): # make sure the file exits at the default location
		return defaultProfileRegLoc
	else:  # no file found at the default location?
		print "Default Profile Registry File: " + defaultProfileRegLoc + " does not exist"
		sys.exit()
		
# ***********************
# backup config
# ***********************


def backupConfig(configBackupDir,profileName):

    print "INFO: Saving configuration"
    setOldProfilePath(profileName,wasInstallRoot)

    configPath = oldProfilePath + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName


    #configPath = wasInstallRoot + fileSeparator +  "profiles"  + fileSeparator + profileName + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName
    
    
    # Get list of GEE targets
    geetargets = getGEETargets()
    lrstargets = getLRSTargets()
    pjmtargets = getPJMTargets()
    
    if(os.path.exists(configBackupDir)):
        print configBackupDir + " exists, skipping create"
    else:
        print configBackupDir + " does not exist, creating it"
        os.mkdir(configBackupDir)
    # Open backup file
    f = open(configBackupDir + fileSeparator + configFile, "w")
    
    
    if len(geetargets) == 0:
        print "INFO: No Grid Execution Environment was installed"
    else:
        print "INFO: Grid Execution Environment was installed on following target: "

        #for geetarget in geetargets:
        #   print geetarget
        #print "      " + geetargets[0]
        # save the GEE targets
        for name, target in zip(geeAppNames, geetargets):
            print " " + target
            f.write(name + ":" + target + "\n")
        
    if len(lrstargets) == 0:
        print "INFO: No Long Running Schedulers installed"
    else:
        print "INFO: Long Running Schedulers were installed on following target: "
        for target in lrstargets:
            print " " + target
            f.write("LRS:" + target + "\n")

    if len(pjmtargets) == 0:
        print "INFO: No Parallel Job Manager installed"
    else:
        print "INFO: Parallel Job Manager installed on following target: "
        for target in pjmtargets:
            print " " + target
            f.write("PJM:" + target + "\n")


    f.close()   
        
      

    backupGridSchedulerConfig(configPath)

    print "INFO: Saved LRS Configuration"  
     
    # backup gridclassification dir 
    backupGridClassificationConfig(configPath)
    
    # backup gridjobclass dir
    backupJobClassConfig(configPath)   

    backupServerIndexes(configPath)

   
    return

def backupServerIndexes (configPath):
    print "INFO: Backing up ServerIndexes"

    isManaged = ""

    if os.path.exists(configBackupDir + fileSeparator + "nodes"):
        print "nodes dir exists removing"
        rmtree(configBackupDir + fileSeparator + "nodes")

    os.mkdir(configBackupDir + fileSeparator + "nodes")
    nodeList = AdminConfig.list("Node").split(lineSeparator)
    for nodename in nodeList:
        name = nodename.split("(")[0]
        serverIndexFile = configPath + fileSeparator + "nodes" + fileSeparator + name + fileSeparator + "serverindex.xml"
        if os.path.exists(configPath + fileSeparator + "nodes" + fileSeparator + name + fileSeparator + "servers" + fileSeparator + "dmgr"):
            print "INFO: Skipping dmgr"
        else:
            serverEntries = AdminConfig.list("ServerEntry", nodename).split(lineSeparator)
            for serverEntry in serverEntries:
                if len(serverEntry) > 0:
                    serverType = AdminConfig.showAttribute(serverEntry, "serverType" )
                    if serverType == "NODE_AGENT":
                       isManaged = "true"

                if isManaged == "true":
                   os.mkdir(configBackupDir + fileSeparator + "nodes" + fileSeparator + name)
                   copyfile(serverIndexFile, configBackupDir + fileSeparator + "nodes" + fileSeparator + name + fileSeparator + "serverindex.xml")

                isManaged = ""
    print "INFO: Backed up Serverindexes"

def backupGridSchedulerConfig(configPath):
    print "INFO: Saving gridscheduler.xml" 
    gridschedulerxmlFile =  configPath + fileSeparator + "gridscheduler.xml";
    applicationbindingFile = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear" + fileSeparator + "deployments" + fileSeparator + "LongRunningScheduler" + fileSeparator + "META-INF" + fileSeparator + "ibm-application-bnd.xmi";
    applicationxmlFile = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear" + fileSeparator + "deployments" + fileSeparator + "LongRunningScheduler" + fileSeparator + "META-INF" + fileSeparator + "application.xml";
    copyfile(gridschedulerxmlFile, configBackupDir + fileSeparator + "gridscheduler.xml")
    print "INFO: Saved gridscheduler.xml" 

    #application.xml will always exist, but only need to copy it if there are bindings
    if(os.path.exists(applicationbindingFile)):
        copyfile(applicationbindingFile, configBackupDir + fileSeparator + "ibm-application-bnd.xmi")
        copyfile(applicationxmlFile, configBackupDir + fileSeparator + "application.xml") 

    print "INFO: Saved LRS application bindings"
    return
    
def backupGridClassificationConfig(configPath):
    print "INFO: Saving gridclassification configuration" 
    gridclassificationConfigDirPath =  configPath + fileSeparator + "gridclassification"
    gridclassificationBackupPath = configBackupDir + fileSeparator + "gridclassification"
    if os.path.exists(gridclassificationBackupPath):
        # delete old backup data
        rmtree(gridclassificationBackupPath)

    if os.path.exists(gridclassificationConfigDirPath):
        copytree(gridclassificationConfigDirPath, gridclassificationBackupPath)
        print "INFO: Saved gridclassification configuration" 
    return
    
def backupJobClassConfig(configPath):
    print "INFO: Saving gridjobclass configuration" 
    jobClassConfigDirPath =  configPath + fileSeparator + "gridjobclasses";
    jobClassBackupPath =  configBackupDir + fileSeparator + "gridjobclasses"
    if os.path.exists(jobClassBackupPath):
        # delete old backup data
        rmtree(jobClassBackupPath)

    if os.path.exists(jobClassConfigDirPath):
        copytree(jobClassConfigDirPath, configBackupDir + fileSeparator + "gridjobclasses")
        print "INFO: Saved gridjobclass configuration" 
    return    
        
# get the GEE targets

def getGEETargets():

    targetList = []
    print "INFO: Getting GEE targets"
    try:
        list = AdminConfig.list('Deployment')
  
        results = list.split(lineSeparator)
  
        for result in results: 
  
            appls = result.split("(")  
  
            name = appls[0].split("_")
            if name[0] == "GEE" or name[0] == "PGCController":
                output = AdminApp.view(appls[0], ["-MapModulesToServers"])
                lines = output.split(lineSeparator)
                for line in lines:
                    server = line.split(":  ")
                    if server[0] == "Server":
                        targets = server[1].split("+")
                        for target in targets:
                            targetList.append(target[10:len(target)])
                            geeAppNames.append(appls[0])
                        break
    except:
        print "ERROR: Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
        pass
        
    return targetList


# get the PJM targets
def getPJMTargets():

    targetList = []
    print "INFO: Getting PJM targets"
    try:
        list = AdminConfig.list('Deployment')
  
        results = list.split(lineSeparator)
  
        for result in results: 
  
            appls = result.split("(")  
  
            name = appls[0].split("_")
            if name[0] == "ParallelJobManager":
                output = AdminApp.view(appls[0], ["-MapModulesToServers"])
                lines = output.split(lineSeparator)
                for line in lines:
                    server = line.split(":  ")
                    if server[0] == "Server":
                        targets = server[1].split("+")
                        for target in targets:
                            targetList.append(target[10:len(target)])
                            geeAppNames.append(appls[0])
                        break
    except:
        print "ERROR: Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
        pass
    return targetList

def getLRSTargets():

    targetList = []
    print "INFO: Getting LRS targets"
    try:
        list = AdminConfig.list('Deployment')
  
        results = list.split(lineSeparator)
  
        for result in results: 
  
            appls = result.split("(")  
  
            name = appls[0].split("_")
            if name[0] == "LongRunningScheduler":
                output = AdminApp.view(appls[0], ["-MapModulesToServers"])
                lines = output.split(lineSeparator)
                for line in lines:
                    server = line.split(":  ")
                    if server[0] == "Server":
                        targets = server[1].split("+")
                        for target in targets:
                            targetList.append(target[10:len(target)])
                            
                        break
    except:
        print "ERROR: Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
        pass
        
    return targetList

def getLRSAttributes():
    lrsAttrs = ""
    try:
        lrsAttrs = AdminTask.showLongRunningSchedulerAttributes()
        print "INFO: Long Running Scheduler was installed with following attributes :" + lrsAttrs
    except:
        print "INFO: NO LRS configuration detected"
        pass
     
    return lrsAttrs  
#-----------------------------------------------------
# Restore Config methods
#-----------------------------------------------------

def restoreConfig(configBackupDir,GEEDataSourceJNDIName, LRSDataSourceJNDIName, GEEDBSchema, profileName, nodeToRestore, restoreScheduler):

    configPath = wasInstallRoot + fileSeparator +  "profiles"  + fileSeparator + profileName + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName
    if nodeToRestore != "":
        updateSystemAppWebSphereVariableForNode(cellName, nodeToRestore,"CG_SYSTEM_APP_LOCATION", "${WAS_INSTALL_ROOT}/systemApps")
        if restoreScheduler == "yes":
            redeployLRS2()
            # update binaries_url for JobSchedulerMDI on dmgr
            updateMDIBinariesURL(configPath)
            # update binaries_url for JobSchedulerMDILP on dmgr
            updateMDILPBinariesURL(configPath)
       
    else:    

        setNewProfilePath(profileName,wasInstallRoot)
        configPath = newProfilePath + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName

        createCellVariable("GRID_ENDPOINT_DATABASE_SCHEMA",GEEDBSchema,"PGC DB Schema")
        print "Created cell variable GRID_ENDPOINT_DATABASE_SCHEMA with value: " + GEEDBSchema

        if GEEDataSourceJNDIName != "jdbc/lree":
            updateWebSphereVariableCellScope("GRID_ENDPOINT_DATASOURCE",GEEDataSourceJNDIName)
            
        print "INFO: reading saved configuration"
        geeNameToTargetMap, lrstargets, pjmtargets = readSavedConfig()    
   
        # restore gridscheduler.xml
        restoreGridSchedulerConfig(configPath)
        
        # restore grid classification config
        restoreGridClassificationConfig(configPath)
    
        # restore job class config
        restoreJobClassConfig(configPath)

        # restore server indexes
        restoreServerIndexes(configPath)
    
        # update binaries_url for LRS on dmgr
        updateLRSBinariesURL(configPath)
        # update binaries_url for JobSchedulerMDI on dmgr
        updateMDIBinariesURL(configPath)
        # update binaries_url for JobSchedulerMDILP on dmgr
        updateMDILPBinariesURL(configPath)
        # restore application bindings for LRS app (mapped roles for security)
        restoreAppBindings(configPath)
       
        save()
             
        # install PGCProxyController
        appInstalled = isAppInstalled(PGCProxyAppName, configPath)
        if appInstalled == "false":
            for lrstarget in lrstargets:
                print "INFO: installing PGCProxy on " + lrstarget
                lrscell, lrsnode, lrsserver, lrscluster = parseDeploymentTarget(lrstarget.rstrip())
                install(lrscell, lrscluster, lrsnode, lrsserver, PGCProxyAppName,"PGCProxyControllerEAR", PGCProxyAppName + ".ear", '')
        else:
            updatePGCProxyBinariesURL(configPath)
        
        # need to do an app update to get JMC to work
        if level != "wcg":
            redeployLRS()    
    
        metadatapath = configPath + fileSeparator + "applications" + fileSeparator + "isclite.ear" + fileSeparator + "ibm-edition-metadata.props"

        if level == "wcg8":
            mdimetadatatarget = configPath + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDI.ear"
            mdilpmetadatatarget = configPath + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDILP.ear"
            #jobschedulermetadatatarget = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear"
            print "Copying " + metadatapath + " to " + mdimetadatatarget
            copy(metadatapath,mdimetadatatarget)
            print "Copying " + metadatapath + " to " + mdilpmetadatatarget
            copy(metadatapath,mdimetadatatarget)
            #print "Copying " + metadatapath + " to " + jobschedulermetadatatarget
            #copy(metadatapath,jobschedulermetadatatarget) 

        if level != "wcg":
            pgcproxymetadatatarget = configPath + fileSeparator + "applications" + fileSeparator + "PGCProxyController.ear"
            print "Copying " + metadatapath + " to " + pgcproxymetadatatarget
            copy(metadatapath,pgcproxymetadatatarget)

        print len(geeNameToTargetMap)
        pgcNames = [] 
        for(geeName, geeTarget) in geeNameToTargetMap.items():
            print "INFO: Deploying PGC"
            dcell, dnode, dserver, dcluster = parseDeploymentTarget(geeTarget.rstrip())

            appName = generatePGCAppName(dnode, dserver, dcluster)
            #if dcluster != "":
            #   appName = geeName

            appInstalled = isAppInstalled(appName, configPath)
            pgcNames.append(appName)
            if (appInstalled == "false"):
                
                print "deploying PGC with name " + appName
                install(dcell, dcluster, dnode, dserver, appName, PGCAppName, PGCAppName + ".ear", '')
                save()
           
                #PGC is already installed just need to update the binaries url
            if level != "wcg":
                pgcappname = appName + ".ear"
                pgcmetadatatarget = configPath + fileSeparator + "applications" + fileSeparator + pgcappname
                print "Copying " + metadatapath + " to " + pgcmetadatatarget
                copy(metadatapath,pgcmetadatatarget)
        # WAS incorrectly generates the binaries url to container appName.ear when the ear file name is always PGCController
        # need to go in and manually update the binaries urls

        for pgcName in pgcNames:
            updatePGCBinariesURL(configPath, pgcName)
    save()    
    print "INFO: Migration Complete!"

def generateGEEAppName (dnode, dserver, dcluster):
    if dserver != "" and dnode != "":
        appName = "GEE_" + dnode + "_" + dserver
    else:
        appName = "GEE_" + dcluster

    print "GEE app name is " + appName
    return appName

def generatePGCAppName (dnode, dserver, dcluster):
    if dserver != "" and dnode != "":
        appName = "PGCController_" + dnode + "_" + dserver
    else:
        appName = "PGCController_" + dcluster

    return appName

def parseDeploymentTarget(deploymentTarget):
    print "parsing deployment Target"
    dcluster = ""
    dnode = ""
    dserver = ""
    dcell = ""
    tokens = deploymentTarget.split(",")
    for token in tokens:
        tks = token.split("=") 
        for tk in tks:
            if tk == "cluster":
                dcluster = tks[1]
                
            elif tk == "node":
                dnode = tks[1]
            elif tk == "server":
                dserver = tks[1]
            elif tk == "cell" or tk == "WebSphere:cell":
                dcell = tks[1]
    print "parsed deployment target" + dcell + dnode + dserver + dcluster        
    return dcell, dnode, dserver, dcluster  
# while restoring endpoints set the CG_SYSTEM_APP_LOCATION to the proper location
def updateCGSystemAppLocationWebSphereVariableForNode(cellName, nodeToRestore):
    print "updating websphere variable CG_SYSTEM_APP_LOCATION on cell: " + cellName + " and node: " + nodeToRestore
    scope = 'cell='+cellName+',node='+nodeToRestore
    varName = "CG_SYSTEM_APP_LOCATION"
    varValue = "${WAS_INSTALL_ROOT}/systemApps"
    
    print "JOUT: Set variable " + varName + " with value " + varValue + " on node " + nodeToRestore
    AdminTask.setVariable(['-variableName', varName , '-variableValue', varValue, '-scope', scope])
    print "Update completed"

def updateSystemAppWebSphereVariableForNode(cell, node, var, value):
    print "updating websphere variable " +  var + " on " + node
    scope = 'cell='+cell+',node='+node
    varName = var
    varValue = value
    
    print "JOUT: Set variable " + varName + " with value " + varValue + " on node " + node
    AdminTask.setVariable(['-variableName', varName , '-variableValue', varValue, '-scope', scope])
    print "Update completed"
def updateWebSphereVariable(varName, varValue):
    print "Updating websphere variable " + varName + " with value:" + varValue
    scope = 'cell='+cellName
   
    
    print "JOUT: Set variable " + varName + " with value " + varValue
    AdminTask.setVariable(['-variableName', varName , '-variableValue', varValue, '-scope', scope])
    print "Update completed"
def updateWebSphereVariableCellScope(varName, varValue):
    print "updating websphere variable " + varName + " with value:" + varValue
    scope = 'cell='+cellName
   
    
    print "JOUT: Set variable " + varName + " with value " + varValue
    AdminTask.setVariable(['-variableName', varName , '-variableValue', varValue, '-scope', scope])
    print "Update completed"
def updateLRSBinariesURL(configPath):
    print "Updating binaries URL"
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear" + fileSeparator + "deployments" + fileSeparator + "LongRunningScheduler" + fileSeparator + "deployment.xml"
    file = open(deploymentXML, "r") #Opens the file in read-mode
    depXMLTxt = file.read() #Reads the file and assigns the value to a variable
    file.close() #Closes the file (read session)
    file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
    if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
        file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
    elif depXMLTxt.find("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps") != -1 :
        file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
    else:
        file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/feature_packs/BATCH/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
    # and writes the whole output when done, wiping over the old contents of the file
    file.close() #Closes the file (write session)

    
    print "Succesfully updated " + deploymentXML

def updatePGCProxyBinariesURL (configPath):
    # update pgc proxy controller
    print "Updating PGC Proxy binaries URL"
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + "PGCProxyController.ear" + fileSeparator + "deployments" + fileSeparator + "PGCProxyController" + fileSeparator + "deployment.xml"
    file = open(deploymentXML, "r") #Opens the file in read-mode
    depXMLTxt = file.read() #Reads the file and assigns the value to a variable
    file.close() #Closes the file (read session)
    file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
    if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
        file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
    elif depXMLTxt.find("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps") != -1 :
        file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
    else:
        file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/feature_packs/BATCH/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
    # and writes the whole output when done, wiping over the old contents of the file
    file.close() #Closes the file (write session)
    print "Succesfully updated " + deploymentXML

def updateMDILPBinariesURL (configPath):
    # update MDILP
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDILP.ear" + fileSeparator + "deployments" + fileSeparator + "JobSchedulerMDILP" + fileSeparator + "deployment.xml"
    if os.path.exists(deploymentXML):
        file = open(deploymentXML, "r") #Opens the file in read-mode
        depXMLTxt = file.read() #Reads the file and assigns the value to a variable
        file.close() #Closes the file (read session)
        file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
        if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
            file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
	elif depXMLTxt.find("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps") != -1 :
	    file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
        else:
            file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/feature_packs/BATCH/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
        # and writes the whole output when done, wiping over the old contents of the file
        file.close() #Closes the file (write session)
        print "Succesfully updated " + deploymentXML
def updateMDIBinariesURL (configPath):
    # update MDILP
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDI.ear" + fileSeparator + "deployments" + fileSeparator + "JobSchedulerMDI" + fileSeparator + "deployment.xml"
    if os.path.exists(deploymentXML):
        file = open(deploymentXML, "r") #Opens the file in read-mode
        depXMLTxt = file.read() #Reads the file and assigns the value to a variable
        file.close() #Closes the file (read session)
        file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
        if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
            file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
	elif depXMLTxt.find("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps") != -1 :
		file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
        else:
            file.write(depXMLTxt.replace("$(WAS_INSTALL_ROOT)/feature_packs/BATCH/systemApps", "$(CG_SYSTEM_APP_LOCATION)")) #replaces all instances of our keyword
        # and writes the whole output when done, wiping over the old contents of the file
        file.close() #Closes the file (write session)
        print "Succesfully updated " + deploymentXML
def updatePJMBinariesURL(configPath):
    print "Updating PJM binaries URL"
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + "ParallelJobManager.ear" + fileSeparator + "deployments" + fileSeparator + "ParallelJobManager" + fileSeparator + "deployment.xml"
    file = open(deploymentXML, "r") #Opens the file in read-mode
    depXMLTxt = file.read() #Reads the file and assigns the value to a variable
    file.close() #Closes the file (read session)
    file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
    newDepXMLTxt = ""
    if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
    else:
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)/feature_packs/BATCH/systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
    # and writes the whole output when done, wiping over the old contents of the file
    file.close() #Closes the file (write session)
    print "Succesfully updated " + deploymentXML
def updatePGCBinariesURL(configPath, appName):
    print "Updating PGC binaries URL for: " + appName
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + appName + ".ear" + fileSeparator + "deployments" + fileSeparator + appName + fileSeparator + "deployment.xml"
    file = open(deploymentXML, "r") #Opens the file in read-mode
    depXMLTxt = file.read() #Reads the file and assigns the value to a variable
    file.close() #Closes the file (read session)
    file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
    newDepXMLTxt = ""
    if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
        
    elif depXMLTxt.find("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps") != -1 :
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)/stack_products/WCG/systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
        
    elif depXMLTxt.find("$(WAS_INSTALL_ROOT)\stack_products\WCG\systemApps") != -1 :
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)\stack_products\WCG\systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
        
    elif depXMLTxt.find("$(WAS_INSTALL_ROOT)\\feature_packs\\BATCH\\systemApps") != -1 :
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)\\feature_packs\\BATCH\\systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
        
    else:
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)/feature_packs/BATCH/systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
        
    # and writes the whole output when done, wiping over the old contents of the file
    file.write(newDepXMLTxt.replace(appName + ".ear", "PGCController.ear")) #replaces all instances of our keyword
    file.close()
    print "Succesfully updated " + deploymentXML

def updateGEEBinariesURL(configPath, appName):
    print "Updating GEE binaries URL"
    deploymentXML = configPath + fileSeparator + "applications" + fileSeparator + appName + ".ear" + fileSeparator + "deployments" + fileSeparator + appName + fileSeparator + "deployment.xml"
    file = open(deploymentXML, "r") #Opens the file in read-mode
    depXMLTxt = file.read() #Reads the file and assigns the value to a variable
    file.close() #Closes the file (read session)
    file = open(deploymentXML, "w") #Opens the file again, this time in write-mode
    newDepXMLTxt = ""
    if depXMLTxt.find("$(WAS_INSTALL_ROOT)/systemApps") != -1 :
        newDepXMLTxt = depXMLTxt.replace("$(WAS_INSTALL_ROOT)/systemApps", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
    else:
        newDepXMLTxt = depXMLTxt.replace("$(CG_SYSTEM_APP_LOCATION)", "$(CG_SYSTEM_APP_LOCATION)") #replaces all instances of our keyword
    # and writes the whole output when done, wiping over the old contents of the file
    file.write(newDepXMLTxt.replace(appName + ".ear", "GEE.ear")) #replaces all instances of our keyword
    # and writes the whole output when done, wiping over the old contents of the file
    file.close() #Closes the file (write session)
    print "Succesfully updated " + deploymentXML

def readSavedConfig():
    print "Reading saved configuration from " + configBackupDir + fileSeparator + configFile
    GeeNameToTargetMap = {}
    lrstargets = []
    pjmtargets = []
    f = open(configBackupDir + fileSeparator + configFile, "r")        
    lines = f.readlines()
    for line in lines:
        print "Line: " + line
                
        if line.startswith("GEE"):
            tokens = line.split(":")
            
            GeeNameToTargetMap[tokens[0]] = tokens[1]
            
            print "GEE:" + tokens[0] + ":" + tokens[1]
        if line.startswith("LRS"):
            tokens = line.split(":")
            lrstargets.append(tokens[1])
        if line.startswith("PGCController"):
             tokens = line.split(":")
             
             GeeNameToTargetMap[tokens[0]] = tokens[1]
             print "PGCController:" + tokens[0] + ":" + tokens[1]
        if line.startswith("PJM"):
            tokens = line.split(":")
            pjmtargets.append(tokens[1])

        
    f.close()
    print "Finished reading configuration"
    return GeeNameToTargetMap, lrstargets, pjmtargets
    
def restoreAppBindings(configPath):
    print "Migrating LRS application bindings"
    applicationbindingFile = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear" + fileSeparator + "deployments" + fileSeparator + "LongRunningScheduler" + fileSeparator + "META-INF" + fileSeparator + "ibm-application-bnd.xmi";
    applicationxmlFile = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear" + fileSeparator + "deployments" + fileSeparator + "LongRunningScheduler" + fileSeparator + "META-INF" + fileSeparator + "application.xml";

    # application.xml always exists, but only need to copy it if there were bindings backed up
    if os.path.exists(configBackupDir + fileSeparator + "ibm-application-bnd.xmi"):
        copyfile(configBackupDir + fileSeparator + "ibm-application-bnd.xmi", applicationbindingFile)
        copyfile(configBackupDir + fileSeparator + "application.xml", applicationxmlFile)

    print "Restored LRS application bindings"
    return
    
def restoreGridSchedulerConfig(configPath):
    print "Restoring gridscheduler.xml" 
    gridschedulerxmlFile =  configPath + fileSeparator + "gridscheduler.xml";
    copyfile(configBackupDir + fileSeparator + "gridscheduler.xml", gridschedulerxmlFile)
    print "Restored gridscheduler.xml" 
    return
    
def restoreGridClassificationConfig(configPath):
    print "Restoring gridclassification configuration" 
    backupPath = configBackupDir + fileSeparator + "gridclassification"
    gridclassificationConfigDirPath =  configPath + fileSeparator + "gridclassification";
    if os.path.exists(backupPath):
        if os.path.exists(gridclassificationConfigDirPath):
            rmtree(gridclassificationConfigDirPath)
        copytree(backupPath,gridclassificationConfigDirPath)
    print "Restored gridclassification configuration" 
    return
    
def restoreJobClassConfig(configPath):
    print "Restoring gridjobclass configuration" 
    jobClassConfigDirPath =  configPath + fileSeparator + "gridjobclasses";
    backupPath = configBackupDir + fileSeparator + "gridjobclasses"
    if os.path.exists(backupPath):
        if os.path.exists(jobClassConfigDirPath):
            rmtree(jobClassConfigDirPath)
        copytree(backupPath, jobClassConfigDirPath)
    print "Restored gridclassification configuration" 
    return    

def restoreServerIndexes (configPath):
    print "INFO: Restoring up ServerIndexes"
    nodeList = AdminConfig.list("Node").split(lineSeparator)
    for nodename in nodeList:
        print "Restoring ServerIndex for node " + nodename
        name = nodename.split("(")[0]
        serverIndexFile = configPath + fileSeparator + "nodes" + fileSeparator + name + fileSeparator + "serverindex.xml"
        backupServerIndex = configBackupDir + fileSeparator + "nodes" + fileSeparator + name + fileSeparator + "serverindex.xml"
        if os.path.exists(backupServerIndex):
            copyfile(configBackupDir + fileSeparator + "nodes" + fileSeparator + name + fileSeparator + "serverindex.xml", serverIndexFile )

    print "INFO: Restored up Serverindexes"
        
#--------------------------------------------------------
# Helper methods
#--------------------------------------------------------

# Get cell name

def getCellName():
	cell = AdminConfig.getid('/Cell:/')
	name = AdminConfig.showAttribute(cell,"name")
	return name
	
	
# get server type	

def getServerInfo():
    serverType = ""
    server = ""
    cell = ""
    node = ""
    servers = AdminConfig.list("Server").splitlines()
    for serverId in servers:
        serverName = serverId.split("(")[0]
        server = serverId.split("(")[1]  #remove name( from id
        server = server.split("/")
        cell = server[1]
        node = server[3]
        cellId = AdminConfig.getid("/Cell:" + cell + "/")
        cellType = AdminConfig.showAttribute(cellId, "cellType")
        
        #print "cellId: " + cellId
        #print "cellType: " + cellType
        if cellType == "DISTRIBUTED":
            if AdminConfig.showAttribute(serverId, "serverType") == "DEPLOYMENT_MANAGER":
                serverType = "DEPLOYMENT_MANAGER" 
        elif cellType == "STANDALONE":
            if AdminConfig.showAttribute(serverId, "serverType") == "APPLICATION_SERVER":
                serverType = "APPLICATION_SERVER" 
    
        
    return serverType, server, cell, node
def printHelp():
    print """

    Show help:
    >> wsadmin -lang jython -f migrateConfigTo85.py --help

    Backs up the GEE and LRSCHED configs:
    >> wsadmin -lang jython -f migrateConfigTo85.py --backup [-configBackupDir <config backup dir> -nameOfProfile <dmgr profilename>]
      
    Restores the GEE and LRSCHED configs:
    >> wsadmin -lang jython -f migrateConfigTo85.py --restore [-configBackupDir <config backup dir> -lreeJNDIName <jndi name for LREE>
        -lreeSchema <GEE schema name> -nameOfProfile <dmgr profile name> -node <node to be migrated (only for non-dmgr nodes)]
    
    Execute this command before starting up DMGR
    >> wsadmin -lang jython -f migrateConfigTo85.py --wasmigrate -oldWASHome <WAS install root of the old installation>
        -nameOfProfile <dmgr profileName> [-configBackupDir <config backupDir> -level <wcg or fep>]
        -newWASHome <new WAS install root> -cellName <cellName> -nameOfProfile <dmgr profileName> 
        -oldBackendID <like DB2UDBOS390_V9_1> -lreeJNDIName <like jdbc/lree_db2> 
        [-configBackupDir <config backupDir> -level <wcg or fep> -pjmJNDIName <PJM datasource jndi name>
         -pjmSchema [PJM database schema name] -pjmBackendID <PJM backend ID> 
         -cg611ProductFS <CG611ProductFS> -dmgrNodeName <dmgrNodeName>]

    If migrating from WCG 611, after all nodes in the cell have been completed migrated, run the script with this option
    >> wsadmin -lang jython -f migrateConfigTo85.py --afterMigrationCleanUp -cellName <cellName> -dmgrNodeName <dmgrNodeName>
    You may have to modify wsadmin to wsadmin.sh or wsadmin.bat, depending upon your operating environment.
  
    """
    
#------------------------------------------------------------------------------
# add WebSphere Variable
#------------------------------------------------------------------------------
def createCellVariable(varName, varValue, varDesc):
  # check if something of the same name already exists
  varEntries_str = AdminConfig.showAttribute(getCellVariables(),"entries")
  if (len(varEntries_str) > 2):
       varEntries_str =  varEntries_str[1:len(varEntries_str)-1] 
       varEntries = varEntries_str.split(" ")
       for var in varEntries:
          name = AdminConfig.showAttribute(var,"symbolicName")
          if(name == varName):
              print "Variable "+varName+" already exists, skipping creation."
              return
       AdminConfig.create("VariableSubstitutionEntry",getCellVariables(),[["symbolicName",varName],["value",varValue],["description",varDesc]])
  print "Variable "+varName+" created."
  
  return 

def getCellVariables():
  cellName = getCellName()
  varMap = AdminConfig.getid('/Cell:'+cellName+'/VariableMap:/')
  return varMap


#------------------------------------------------------------------------------
# add WebSphere Variable at Node
#------------------------------------------------------------------------------
def createNodeVariable(varName, varValue, varDesc, nodeName):
  print "createNodeVar" + nodeName
  cellName = getCellName()
  
  varMap = AdminConfig.getid("/Cell:" + cellName + "/Node:" + nodeName + "/VariableMap:/")
  
  entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
  
  eList = entries.splitlines()
  
  for entry in eList:
     name = AdminConfig.showAttribute(entry, "symbolicName")
     
     if name == varName:
        print "Variable "+varName+" already exists, skipping creation."
        return
    
  AdminConfig.create("VariableSubstitutionEntry",varMap,[["symbolicName",varName],["value",varValue],["description",varDesc]])
  print "Variable "+varName+" created."
  
  return        


def isTarget(target):
    targets = getTargets(target)
    for t in targets:
        if t == target:
            return "true"
    return "false"


# save configuration
    
def save():
    AdminConfig.save()
    if serverType == "DEPLOYMENT_MANAGER":
        dmgrbean = AdminControl.queryNames("type=DeploymentManager,*")
        AdminControl.invoke(dmgrbean, "syncActiveNodes", "true")
        msg = "Configuration was saved and synchronized to the active nodes"
    else:
        msg = "Configuration was saved"

    print "INFO: Configuration was saved and synchronized to the active nodes"

def redeployLRS2():
     print "Performing App update on LRS..."
     print "Redeploying LongRunningScheduler.ear..."
     earPath  = wasInstallRoot + fileSeparator + "systemApps" + fileSeparator + "LongRunningScheduler.ear"
     AdminApp.update("LongRunningScheduler",'app','[-operation update -contents ' + earPath + ']')
     AdminConfig.save()
     dmgrbean = AdminControl.queryNames("type=DeploymentManager,*")
     AdminControl.invoke(dmgrbean, "syncActiveNodes", "true")
     print "INFO: Configuration was saved and synchronized to the active nodes"

def redeployLRS():

    print "Performing App update on LRS..."
    systemApps  = wasInstallRoot + fileSeparator + "systemApps"
    earPath     = systemApps + fileSeparator + LRSAppName + ".ear"

    print "Redeploying " + LRSAppName + "..."
    AdminApp.update(LRSAppName,'app','[-operation update -contents ' + earPath + ']')

    print "LRS update completed"
    
def isAppInstalled (appName, configPath):
    foundApp = "false"
    depXML = configPath + fileSeparator + "applications" + fileSeparator + appName + ".ear" + fileSeparator + "deployments" + fileSeparator + appName + fileSeparator + "deployment.xml"
    if os.path.exists(depXML) :
        foundApp = "true"
    #for app1 in AdminApp.list().split():
    #    print "checking app:" + app1
   	#    if ( app1 == appName ) :
    #        print "Application " + appName + " is already installed"
   	#	    foundApp = "true"

    return foundApp
#------------------------------------------------------------------------------
# Install the application
#------------------------------------------------------------------------------

def install(cell, cluster, node, server, appname, webModuleName, earName, apps611Location):

    print "installing :" + appname + " on cell:" + cell + " cluster: " + cluster + " earName: " + earName + " webmodule" + webModuleName
    warName     = webModuleName + ".war"
    xmlName     = warName + ",WEB-INF/web.xml"
    
    cellName    = "WebSphere:cell=" + cell
    systemApps  = "$(CG_SYSTEM_APP_LOCATION)"
    if option == "--wasmigrate":
        if level == "wcg":
            earPath =  apps611Location + fileSeparator + earName
        else:
            earPath     = wasInstallRoot + fileSeparator + "systemApps" + fileSeparator + earName
    else:
        earPath     = wasInstallRoot + fileSeparator + "systemApps" + fileSeparator + earName
    

    if cluster != "":
        msg = "cluster " + cluster
        installTarget         = [ "-cluster", cluster ]
        MapModulesToServers   = [ [".*", ".*", cellName + ",cluster=" + cluster ] ]

    else:
        msg = "node/server " + node + "/" + server
        installTarget         = [ "-node", node, "-server", server ]
        MapModulesToServers   = [ [".*", ".*", cellName + ",node=" + node + ",server=" + server ] ]


    
    #uninstall(cluster,appname)
    

    options = [ 
                "-nopreCompileJSPs",
                "-noreloadEnabled",
                "-noprocessEmbeddedConfig",
                "-usedefaultbindings",
                "-zeroEarCopy",

                installTarget,

    
                "-MapModulesToServers",             MapModulesToServers,
    

                "-appname",                         appname, 
                "-installed.ear.destination",       systemApps
              ]
    
    AdminApp.install(earPath, options)
    
    
    
    print "INFO: installed " + appname + " to " + msg 

#------------------------------------------------------------------------------
# Install the GEE application
#------------------------------------------------------------------------------

def installGEE(wasHome, cell, cluster, node, server, schema, backend, appname, jdbcName, apps611Location):

    earPath     =  apps611Location + fileSeparator + "GEE.ear"
    systemApps  = "$(CG_SYSTEM_APP_LOCATION)"

    if cluster != "":
        msg = "-cluster " + cluster
        installTarget         = [ "-cluster", cluster ]
        print "GEE target is cluster " + cluster
    else:
        msg = "-node " + node + ", -server " + server
        installTarget         = [ "-node", node, "-server", server ]

    if cluster != "":
          options = [
                "-appname", appname,
                "-usedefaultbindings",
               "-zeroEarCopy",
              "-installed.ear.destination", systemApps,
                "-cluster", cluster, 
                 "-BackendIdSelection", [['.*', 'BatchJobExecutionEnvironmentEJBs.jar,.*', backend]],
                 "-DataSourceFor20CMPBeans", [['.*', '.*', 'BatchJobExecutionEnvironmentEJBs.jar,.*', jdbcName, 'container', ' ', ' ']]
              ]
    else:
         options = [
                "-appname", appname,
                "-usedefaultbindings",
               "-zeroEarCopy",
              "-installed.ear.destination", systemApps,
                 "-node", node,
                 "-server", server,
                 "-BackendIdSelection", [['.*', 'BatchJobExecutionEnvironmentEJBs.jar,.*', backend]],
                 "-DataSourceFor20CMPBeans", [['.*', '.*', 'BatchJobExecutionEnvironmentEJBs.jar,.*', jdbcName, 'container', ' ', ' ']]
              ]


    #AdminApp.install(earPath, ['-appname', appname, '-usedefaultbindings', '-zeroEarCopy', '-installed.ear.destination', '$(WAS_INSTALL_ROOT)/systemApps', installTarget, '-BackendIdSelection', [['.*', 'BatchJobExecutionEnvironmentEJBs.jar,.*', backend]], '-DataSourceFor20CMPBeans', [['.*', '.*', 'BatchJobExecutionEnvironmentEJBs.jar,.*', jdbcName, 'container', ' ', ' ']] ])
    AdminApp.install(earPath, options)

    print "INFO: installed " + appname + " to " + msg 


def installPJM(wasHome, cell, cluster, node, server, schema, backend, jdbcName, apps611Location):

    ejbName     = "ParallelJobManagerEJBs"
    jarName     = ejbName + ".jar"
    xmlName     = jarName + ",META-INF/ejb-jar.xml"
    cellName    = "WebSphere:cell=" + cell
    systemApps  = "$(CG_SYSTEM_APP_LOCATION)"
    earPath     =  apps611Location + fileSeparator + "ParallelJobManager.ear"
    pjmJob      = "ParallelJobManagerJob"
    appname     = "ParallelJobManager"

    if cluster != "":
        msg = "cluster " + cluster
        installTarget         = [ "-cluster", cluster ]
        MapModulesToServers   = [ [ ejbName, xmlName, cellName + ",cluster=" + cluster ] ]

    else:
        msg = "node/server " + node + "/" + server
        installTarget         = [ "-node", node, "-server", server ]
        MapModulesToServers   = [ [ ejbName, xmlName, cellName + ",node=" + node + ",server=" + server ] ]


    DataSourceFor20EJBModules = [ [ ejbName, xmlName, jdbcName ] ]

    DataSourceFor20CMPBeans   = [ 
                                  [ ejbName, "SubmittedJobs"     , xmlName, jdbcName, "cmpBinding.perConnectionFactory" ], 
                                  [ ejbName, "LogicalTX"         , xmlName, jdbcName, "cmpBinding.perConnectionFactory" ], 
                                  [ ejbName, "ParallelJobManager", xmlName, jdbcName, "cmpBinding.perConnectionFactory" ] 
                                ]

    BackendIdSelection        = [ [ ejbName, xmlName, backend ] ]

                                                                                                                                                                                                            
    MapEJBRefToEJB            = [                                                                                                                                                                           
                                  [ ejbName, "ParallelJobManagerJob", xmlName, "ejb/ParallelJobManager" , "com.ibm.websphere.batch.BatchJobStepLocalInterface", "ejb/com/ibm/ws/batch/ParallelJobManager"           ],
                                  [ ejbName, "ParallelJobManagerJob", xmlName, "ejb/SubmittedJobsAccess", "com.ibm.ws.batch.SubmittedJobsAccessLocal"         , "ejb/com/ibm/ws/batch/SubmittedJobsAccessLocalHome" ],
                                  [ ejbName, "ParallelJobManagerJob", xmlName, "ejb/SubmittedJobs"      , "com.ibm.ws.batch.SubmittedJobsLocal"               , "ejb/com/ibm/ws/batch/SubmittedJobsHome"            ],
                                  [ ejbName, "ParallelJobManagerJob", xmlName, "ejb/LogicalTXAccess"    , "com.ibm.ws.batch.LogicalTXAccessLocal"             , "ejb/com/ibm/ws/batch/LogicalTXAccessLocalHome"     ],
                                  [ ejbName, "ParallelJobManagerJob", xmlName, "ejb/LogicalTX"          , "com.ibm.ws.batch.LogicalTXLocal"                   , "ejb/com/ibm/ws/batch/LogicalTXHome"                ],
                                  [ ejbName, "SubmittedJobsAccess"  , xmlName, "ejb/SubmittedJobs"      , "com.ibm.ws.batch.SubmittedJobsLocal"               , "ejb/com/ibm/ws/batch/SubmittedJobsHome"            ],
                                  [ ejbName, "LogicalTXAccess"      , xmlName, "ejb/LogicalTX"          , "com.ibm.ws.batch.LogicalTXLocal"                   , "ejb/com/ibm/ws/batch/LogicalTXHome"                ],
                                  [ ejbName, "ParallelJobManager"   , xmlName, "ejb/SubmittedJobsAccess", "com.ibm.ws.batch.SubmittedJobsAccessLocal"         , "ejb/com/ibm/ws/batch/SubmittedJobsAccessLocalHome" ],
                                  [ ejbName, "ParallelJobManager"   , xmlName, "ejb/LogicalTXAccess"    , "com.ibm.ws.batch.LogicalTXAccessLocal"             , "ejb/com/ibm/ws/batch/LogicalTXAccessLocalHome"     ],
                                  [ ejbName, "ParallelJobManager"   , xmlName, "ejb/BatchGridDiscriminator"    , "com.ibm.ws.batch.BatchGridDiscriminatorRemote"             , "ejb/com/ibm/ws/batch/BatchGridDiscriminatorHome"     ]
                                ]


    options = [ 
                "-nodeployejb",
                "-nopreCompileJSPs",
                "-createMBeansForResources",
                "-noreloadEnabled",
                "-noprocessEmbeddedConfig",
                "-usedefaultbindings",
                "-zeroEarCopy",

                installTarget,

                "-defaultbinding.datasource.jndi",  jdbcName,
                "-deployejb.dbschema",              schema,
                "-deployejb.dbtype",                backend,

                "-MapEJBRefToEJB",                  MapEJBRefToEJB,
                "-BackendIdSelection",              BackendIdSelection,
                "-MapModulesToServers",             MapModulesToServers,
                "-DataSourceFor20EJBModules",       DataSourceFor20EJBModules,
                "-DataSourceFor20CMPBeans",         DataSourceFor20CMPBeans,

                "-appname",                         appname, 
                "-installed.ear.destination",       systemApps
              ]

    AdminApp.install(earPath, options)
#------------------------------------------------------------------------------
# Install MDI / MDILP application
#------------------------------------------------------------------------------

def installMDIorLP(wasHome, cell, cluster, node, server, appName, apps611Location):

    systemApps  = "$(CG_SYSTEM_APP_LOCATION)"
    earPath     =  apps611Location + fileSeparator + appName + ".ear"

    options = [ 
                 "-usedefaultbindings",
                 "-nocreateMBeansForResources",
                 "-zeroEarCopy",
                 "-skipPreparation",
                 "-appname",                         appName, 
                 "-installed.ear.destination",       systemApps,
                 "-cell",                            cell, 
              ]

    if cluster != "":

        options.append( "-cluster" )
        options.append( cluster )

        msg = "cluster " + cluster

    else:

        options.append( "-node" )
        options.append( node )
        options.append( "-server" )
        options.append( server )

        msg = "node/server " + node + "/" + server

    AdminApp.install(earPath, options)

    print ""
    print "installMDIorLP INFO: installed " + appName + " to " + msg 


#------------------------------------------------------------------------------
# Uninstall the PGCProxyController
#------------------------------------------------------------------------------

def uninstall(cluster,appname):
    print "Uninstalling " + appname
    try: 
        AdminApp.uninstall(appname)
        result = "removed"
    except:
        result = ""

    print "Uninstalling " + appname + " result = " + result
def wasmigrate2(configBackupDir,level,oldWASHome,wasInstallRoot,profileName,cellName,dmgrNodeName):
    print "Copying over WCG system application configuration from old DMGR " + oldWASHome + " to new " + wasInstallRoot

    setOldProfilePath(profileName,oldWASHome)
    setNewProfilePath(profileName,wasInstallRoot)

    configPath = newProfilePath + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName
        
    oldConfigDir = oldProfilePath + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName

    wasCopyLRSConfig(configPath, oldConfigDir)

    wasCopyGEEConfig(configPath, oldConfigDir, level)

    if level == "wcg8":
        oldMDILoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDI.ear"
        if os.path.exists(oldMDILoc):
            wasCopyMDIConfig(configPath, oldConfigDir)

        oldMDILPLoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDILP.ear"
        if os.path.exists(oldMDILPLoc):
            wasCopyMDILPConfig(configPath, oldConfigDir)
    
    if level != "wcg":
        wasCopyPGCProxyConfig(configPath, oldConfigDir)
        
    if level == "wcg8":  
        if dmgrNodeName != "":    
            updateCGSystemAppLocationWebSphereVariableForNode(cellName, dmgrNodeName)
            save()

    print "Finished Copying over WCG system application configuration from old DMGR " + oldWASHome + " to new Dmgr!"

#----------------------------------------------------------------------------------
# During a WAS upgrade need to manually copy over the WCG system app config files
#----------------------------------------------------------------------------------
def wasmigrate(configBackupDir,level,oldWASHome,oldBackendID,GEEDataSourceJNDIName,wasInstallRoot,profileName,cellName,PJMDataSourceJNDIName,pjmBackendID,pjmSchema,CG611ProductFS, dmgrNodeName):
    print "Copying over WCG system application configuration from old DMGR " + oldWASHome + " to new " + wasInstallRoot


    setOldProfilePath(profileName,oldWASHome)
    setNewProfilePath(profileName,wasInstallRoot)
   
    configPath =  newProfilePath + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName
        
    oldConfigDir = oldProfilePath + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName

    geeNameToTargetMap, lrstargets, pjmtargets = readSavedConfig()

    if level == "wcg":
        apps611Location = CG611ProductFS + fileSeparator + "systemApps"
        updateWebSphereVariableCellScope("CG_SYSTEM_APP_LOCATION", apps611Location)
        updateSystemAppWebSphereVariableForNode(cellName, dmgrNodeName, "CG_SYSTEM_APP_LOCATION", apps611Location)
    if level == "wcg8":
        updateWebSphereVariable("CG_SYSTEM_APP_LOCATION", "${WAS_INSTALL_ROOT}/systemApps")

    #wasCopyLRSConfig(configPath, oldConfigDir)
    for lrstarget in lrstargets:
        print "INFO: installing LRS on " + lrstarget
        lrscell, lrsnode, lrsserver, lrscluster = parseDeploymentTarget(lrstarget.rstrip())
        install(lrscell, lrscluster, lrsnode, lrsserver, LRSAppName, LRSAppName, LRSAppName + ".ear", apps611Location)

        oldMDILoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDI.ear"
        if os.path.exists(oldMDILoc):
            #wasCopyMDIConfig(configPath, oldConfigDir)
            installMDIorLP(wasInstallRoot, lrscell, lrscluster, lrsnode, lrsserver, "JobSchedulerMDI", apps611Location)
        else:
            print "No JobSchedulerMDI app to migrate. skipping..."

        oldMDILPLoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDILP.ear"
        if os.path.exists(oldMDILPLoc):
            #wasCopyMDILPConfig(configPath, oldConfigDir)
            installMDIorLP(wasInstallRoot, lrscell, lrscluster, lrsnode, lrsserver, "JobSchedulerMDILP", apps611Location)
        else:
            print "No JobSchedulerMDILP app to migrate. skipping..."

    print "Finished installing LRS/MDI/MDILP application"

    print len(geeNameToTargetMap)
    
    geeNames = []
    for(geeName, geeTarget) in geeNameToTargetMap.items():
        
        dcell, dnode, dserver, dcluster = parseDeploymentTarget(geeTarget.rstrip())

        appName = generateGEEAppName(dnode, dserver, dcluster)
        geeNames.append(appName)
        print "INFO: installing GEE on " + geeTarget
        installGEE(wasInstallRoot, dcell, dcluster, dnode, dserver, "${GRID_ENDPOINT_DATABASE_SCHEMA}", oldBackendID, appName, GEEDataSourceJNDIName, apps611Location)
        print "Finished installing " + appName
    print "Finished installing GEE"

    for pjmtarget in pjmtargets:
        print "INFO: Looking for Parallel Job Manager on " + pjmtarget
        dcell, dnode, dserver, dcluster = parseDeploymentTarget(pjmtarget.rstrip())
        oldPJMLoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "ParallelJobManager.ear"
        if os.path.exists(oldPJMLoc):
            installPJM(wasInstallRoot, dcell, dcluster, dnode, dserver, pjmSchema, pjmBackendID, PJMDataSourceJNDIName, apps611Location);
            print "Finished installing Parallel Job Manager"
        else:
            print "No ParallelJobManager app to migrate. skipping..."


    save()

    for geeName in geeNames:
            updateGEEBinariesURL(configPath, geeName) 
    
    #if level == "fep":
        #wasCopyPGCProxyConfig(configPath, oldConfigDir)

    print "Finished Copying over WCG system application configuration from old DMGR " + oldWASHome + " to new Dmgr!"
    save()

#----------------------------------------
# Copy over PGCProxy configuration files 
#-----------------------------------------       

def wasCopyPGCProxyConfig(configPath, oldConfigDir):
    print "Copying over PGCProxy Configuration. Old config Path: " + oldConfigDir + " -> new config Dir: " + configPath 
    
    # Copy PGCProxy application config
    oldPGCProxyLoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "PGCProxyController.ear"
        
    newPGCProxyLoc = configPath + fileSeparator + "applications" + fileSeparator + "PGCProxyController.ear"

    if os.path.exists(newPGCProxyLoc):
        print "PGC Proxy config exists. skipping..."
    else:
        copytree(oldPGCProxyLoc, newPGCProxyLoc)
 
    # Copy PGCProxy blas

    oldPGCProxyBLA = oldConfigDir + fileSeparator + "blas" + fileSeparator + "PGCProxyController"
        
    newPGCProxyBLA = configPath + fileSeparator + "blas" + fileSeparator + "PGCProxyController"

    if os.path.exists(newPGCProxyBLA):
        print "PGC Proxy BLA exists.. skipping..."
    else:
        copytree(oldPGCProxyBLA, newPGCProxyBLA)

    # Copy PGCProxy cus

    oldPGCProxyCus = oldConfigDir + fileSeparator + "cus" + fileSeparator + "PGCProxyController"

    newPGCProxyCus = configPath + fileSeparator + "cus" + fileSeparator + "PGCProxyController"

    if os.path.exists(newPGCProxyCus):
        print "PGC Proxy Cus exists. skipping..."
    else:  
        copytree(oldPGCProxyCus, newPGCProxyCus)  

    print "Finished copying PGCProxy configuration!" 

#----------------------------------------
# Copy over LRS configuration files 
#-----------------------------------------       
          
def wasCopyLRSConfig(configPath, oldConfigDir):
    print "Copying over LRS Configuration. Old config Path: " + oldConfigDir + " -> new config Dir: " + configPath 
    
    # Copy LRS application config
    oldLRSLoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear"
        
    newLRSLoc = configPath + fileSeparator + "applications" + fileSeparator + "LongRunningScheduler.ear"
    
    if os.path.exists(newLRSLoc):
        print "LRS config path exists. skipping..."
    else:
        copytree(oldLRSLoc, newLRSLoc)
 
    # Copy LRS blas

    oldLRSBLA = oldConfigDir + fileSeparator + "blas" + fileSeparator + "LongRunningScheduler"
    newLRSBLA = configPath + fileSeparator + "blas" + fileSeparator + "LongRunningScheduler"
    if os.path.exists(newLRSBLA):
        print "LRS BLA already exists skipping.."
    else:
        copytree(oldLRSBLA, newLRSBLA)

    # Copy LRS cus

    oldLRSCus = oldConfigDir + fileSeparator + "cus" + fileSeparator + "LongRunningScheduler"

    newLRSCus = configPath + fileSeparator + "cus" + fileSeparator + "LongRunningScheduler"
    if os.path.exists(newLRSCus):
        print "LRS Cus already exists skipping..."
    else:
        copytree(oldLRSCus, newLRSCus)

    print "Finished copying LRS configuration!"     
     

#----------------------------------------
# Copy over MDI configuration files 
#-----------------------------------------       
          
def wasCopyMDIConfig(configPath, oldConfigDir):
    print "Copying over MDI Configuration. Old config Path: " + oldConfigDir + " -> new config Dir: " + configPath 
    
    # Copy MDI application config
    oldMDILoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDI.ear"
        
    newMDILoc = configPath + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDI.ear"
    
    if os.path.exists(newMDILoc):
        print "MDI config path exists. skipping..."
    else:
        copytree(oldMDILoc, newMDILoc)
 
    # Copy MDI blas

    oldMDIBLA = oldConfigDir + fileSeparator + "blas" + fileSeparator + "JobSchedulerMDI"
    newMDIBLA = configPath + fileSeparator + "blas" + fileSeparator + "JobSchedulerMDI"
    if os.path.exists(newMDIBLA):
        print "MDI BLA exists, removing possible corrupted version..."
        rmtree(newMDIBLA)
    
    copytree(oldMDIBLA, newMDIBLA)

    # Copy MDI cus

    oldMDICus = oldConfigDir + fileSeparator + "cus" + fileSeparator + "JobSchedulerMDI"

    newMDICus = configPath + fileSeparator + "cus" + fileSeparator + "JobSchedulerMDI"
    if os.path.exists(newMDICus):
        print "MDI Cus already exists skipping..."
    else:
        copytree(oldMDICus, newMDICus)

    print "Finished copying MDI configuration!"


#----------------------------------------
# Copy over MDILP configuration files 
#-----------------------------------------       
          
def wasCopyMDILPConfig(configPath, oldConfigDir):
    print "Copying over MDILP Configuration. Old config Path: " + oldConfigDir + " -> new config Dir: " + configPath 
    
    # Copy MDILP application config
    oldMDILPLoc =  oldConfigDir + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDILP.ear"
        
    newMDILPLoc = configPath + fileSeparator + "applications" + fileSeparator + "JobSchedulerMDILP.ear"
    
    if os.path.exists(newMDILPLoc):
        print "MDILP config path exists. skipping..."
    else:
        copytree(oldMDILPLoc, newMDILPLoc)
 
    # Copy MDILP blas

    oldMDILPBLA = oldConfigDir + fileSeparator + "blas" + fileSeparator + "JobSchedulerMDILP"
    newMDILPBLA = configPath + fileSeparator + "blas" + fileSeparator + "JobSchedulerMDILP"
    if os.path.exists(newMDILPBLA):
        print "MDILP BLA already exists skipping.."
    else:
        copytree(oldMDILPBLA, newMDILPBLA)

    # Copy MDILP cus

    oldMDILPCus = oldConfigDir + fileSeparator + "cus" + fileSeparator + "JobSchedulerMDILP"

    newMDILPCus = configPath + fileSeparator + "cus" + fileSeparator + "JobSchedulerMDILP"
    if os.path.exists(newMDILPCus):
        print "MDILP Cus already exists skipping..."
    else:
        copytree(oldMDILPCus, newMDILPCus)

    print "Finished copying MDILP configuration!"



#----------------------------------------
# Copy over GEE configuration files 
#-----------------------------------------       
def wasCopyGEEConfig(configPath, oldConfigDir, level):
    print "INFO:Copying PGC config"
    # Copy GEE

    geeNameToTargetMap, lrstargets, pjmtargets = readSavedConfig()
    print len(geeNameToTargetMap)
    
    for(geeName, geeTarget) in geeNameToTargetMap.items():
        
        dcell, dnode, dserver, dcluster = parseDeploymentTarget(geeTarget.rstrip())

        pgcAppName = generatePGCAppName(dnode, dserver, dcluster) 
        #if dcluster != "":
        #    pgcAppName = geeName 

        
        newAppName =  ""   
        if level == "wcg":
            oldAppName = generateGEEAppName(dnode, dserver, dcluster)
            newAppName = oldAppName
        else:
            oldAppName = pgcAppName
            newAppName = oldAppName

        
        print "INFO:Copying over configuration for " + oldAppName

        # Copy GEE config

        oldGEELoc = oldConfigDir + fileSeparator + "applications" + fileSeparator + oldAppName + ".ear"
  
        newGEELoc = configPath + fileSeparator + "applications" + fileSeparator + newAppName + ".ear"

      
        if os.path.exists(newGEELoc):
            print "GEE config exists. skipping..."
        else:
            copytree(oldGEELoc, newGEELoc)

        # Copy GEE blas

        oldGEEBLA = oldConfigDir + fileSeparator + "blas" + fileSeparator + oldAppName
        
        newGEEBLA = configPath + fileSeparator + "blas" + fileSeparator + newAppName

       
        if os.path.exists(newGEEBLA):
            print "GEE BLA exists. skipping..."
        else:
            copytree(oldGEEBLA, newGEEBLA)

        # Copy GEE cus

        oldGEECus = oldConfigDir + fileSeparator + "cus" + fileSeparator + oldAppName

        newGEECus = configPath + fileSeparator + "cus" + fileSeparator + newAppName

        if os.path.exists(newGEECus):
            print "GEE Cus exists. skipping..."
        else:
            copytree(oldGEECus, newGEECus)

    print "Finished copying PGC configuration!"   
def afterMigrationCleanUp (cellName, dmgrNodeName):
    print "Performing final clean up after all nodes from WCG 611 level in the cell has been migrated..."

    #uninstall GEE
    #get GEE app name because it could be in GEE_<servername> or GEE_<clustername> format
    targetList = []
    try:
        list = AdminConfig.list('Deployment')
        results = list.split(lineSeparator)
        for result in results:
            appls = result.split("(")
            name = appls[0].split("_")
            if name[0] == "GEE":
                targetList.append(appls[0])
    except:
        pass
                

    print "INFO: Grid Execution Environment was found on following targets: "
    for target in targetList:
         print "      " + target

    #uninstall GEE_<name>
    for targetToRemove in targetList:
        uninstall("",targetToRemove)

    #uninstall PJM
    uninstall("",PJMAppName)

    varValue = "${WAS_INSTALL_ROOT}/systemApps"    

    print "updating websphere variable CG_SYSTEM_APP_LOCATION for cell " + cellName + " to value " + varValue
    updateWebSphereVariableCellScope("CG_SYSTEM_APP_LOCATION", varValue)

    print "updating websphere variable CG_SYSTEM_APP_LOCATION on " + dmgrNodeName + " to value " + varValue
    updateSystemAppWebSphereVariableForNode(cellName, dmgrNodeName, "CG_SYSTEM_APP_LOCATION", varValue)

    save()
    print "Finished cleaning up after migration!"   
#=======================================================================================================================================================
#
# Main execution logic:
#
#=======================================================================================================================================================

configFile   = "cgConfigBackup.txt"
configBackupDir = wasInstallRoot + fileSeparator + "temp"
configPath = ""
cellName = ""
server = ""
node = ""
geeNameToTargetMap = {}
geeAppNames = []
serverType = ""
LRSAppName = "LongRunningScheduler"
PGCAppName = "PGCController"
PGCProxyAppName = "PGCProxyController"
GEEAppName = "GEE"
PJMAppName = "ParallelJobManager"
PJMDataSourceJNDIName = "jdbc/parallelJobManager"
GEEDataSourceJNDIName = "jdbc/lree"
oldBackendID = "DERBY_V100_2"
pjmBackendID = "DERBY_V100_1"
pjmSchema = "PJSCHEMA"
LRSDataSourceJNDIName = "jdbc/lrsched"
GEEDBSchema = "LREESCHEMA"
profileName = "Dmgr01"
nodeToRestore = ""
level = "wcg"
keep = "true"
CG611ProductFS = ""
dmgrNodeName = ""



if len(sys.argv) > 0:
    option = sys.argv[0]
    if option == "--help":
        printHelp()
    elif option == "--wasmigrate":
        i = 1
        while i < len(sys.argv):
            if sys.argv[i] == '-level':
                level = sys.argv[i+1]
            if sys.argv[i] == '-oldWASHome':
                oldWASHome = sys.argv[i+1]
            if sys.argv[i] == '-nameOfProfile':
                profileName = sys.argv[i+1]
            if sys.argv[i] == '-configBackupDir':
                configBackupDir = sys.argv[i+1]
            if sys.argv[i] == '-newWASHome':
                wasInstallRoot = sys.argv[i+1]
            if sys.argv[i] == '-cellName':
                cellName = sys.argv[i+1]
            if sys.argv[i] == '-oldBackendID':
                oldBackendID = sys.argv[i+1]
            if sys.argv[i] == '-lreeJNDIName':
                GEEDataSourceJNDIName = sys.argv[i+1]
            if sys.argv[i] == '-keepOld':
                keep = sys.argv[i+1]
            if sys.argv[i] == '-pjmJNDIName':
                PJMDataSourceJNDIName = sys.argv[i+1]
            if sys.argv[i] == '-pjmBackendID':
                pjmBackendID = sys.argv[i+1]
            if sys.argv[i] == '-pjmSchema':
                pjmSchema = sys.argv[i+1]
            if sys.argv[i] == '-cg611ProductFS':
                CG611ProductFS = sys.argv[i+1]
            if sys.argv[i] == '-dmgrNodeName':
                dmgrNodeName = sys.argv[i+1]

            i = i + 2

        if keep != "true":
            if keep != "false":
                print "Invalid value specified for -keepOld.  Specify either true or false"
                sys.exit()

        if level == "wcg":
            sys.exit(wasmigrate(configBackupDir,level,oldWASHome,oldBackendID,GEEDataSourceJNDIName,wasInstallRoot,profileName,cellName,PJMDataSourceJNDIName,pjmBackendID,pjmSchema, CG611ProductFS, dmgrNodeName))
        if level == "wcg8":
            sys.exit(wasmigrate2(configBackupDir,level,oldWASHome,wasInstallRoot,profileName,cellName,dmgrNodeName))
        if level == "fep":
            sys.exit(wasmigrate2(configBackupDir,level,oldWASHome,wasInstallRoot,profileName,cellName,dmgrNodeName))
        if level == "was8":
            sys.exit(wasmigrate2(configBackupDir,level,oldWASHome,wasInstallRoot,profileName,cellName,dmgrNodeName))
    elif option == "--cleanupFiles":
        sys.exit(renameFiles())
    else:
        serverType, server, cellName, node = getServerInfo()
        configPath = wasInstallRoot + fileSeparator +  "profiles"  + fileSeparator + profileName + fileSeparator + "config" + fileSeparator + "cells" + fileSeparator + cellName

        if option == "--backup":
            i = 1
            while i < len(sys.argv):
                if sys.argv[i] == '-configBackupDir':
                    configBackupDir = sys.argv[i+1]
                if sys.argv[i] == '-nameOfProfile':
                    profileName = sys.argv[i+1]
                if sys.argv[i] == '-level':
                     level = sys.argv[i+1]					
                i = i + 2    
            
            if level == "wcg":
                if osname == "z/OS":
                     scriptCheck(profileName)
            sys.exit(backupConfig(configBackupDir,profileName))
        elif option == "--restore":
            i = 1
            while i < len(sys.argv):
            
                if sys.argv[i] == '-configBackupDir':                
                    configBackupDir = sys.argv[i+1]
                if sys.argv[i] == '-lreeJNDIName':
                    GEEDataSourceJNDIName = sys.argv[i+1]
                if sys.argv[i] == '-lrsJNDIName':
                    LRSDataSourceJNDIName = sys.argv[i+1]
                if sys.argv[i] == '-lreeSchema':
                    GEEDBSchema = sys.argv[i+1]  
                if sys.argv[i] == '-nameOfProfile':
                    profileName = sys.argv[i+1]
                if sys.argv[i] == '-node':
                    nodeToRestore = sys.argv[i+1]
                if sys.argv[i] == '-level':
                     level = sys.argv[i+1]
                i = i + 2    
                       
            sys.exit(restoreConfig(configBackupDir,GEEDataSourceJNDIName, LRSDataSourceJNDIName, GEEDBSchema, profileName, nodeToRestore, "no"))
        elif option == "--restoreScheduler":
            i = 1
            while i < len(sys.argv):
            
                if sys.argv[i] == '-configBackupDir':
                
                    configBackupDir = sys.argv[i+1]
                if sys.argv[i] == '-lreeJNDIName':
                    GEEDataSourceJNDIName = sys.argv[i+1]
                if sys.argv[i] == '-lrsJNDIName':
                    LRSDataSourceJNDIName = sys.argv[i+1]
                if sys.argv[i] == '-lreeSchema':
                    GEEDBSchema = sys.argv[i+1]  
                if sys.argv[i] == '-nameOfProfile':
                    profileName = sys.argv[i+1]
                if sys.argv[i] == '-node':
                    nodeToRestore = sys.argv[i+1]
                i = i + 2    
                       
            sys.exit(restoreConfig(configBackupDir,GEEDataSourceJNDIName, LRSDataSourceJNDIName, GEEDBSchema, profileName, nodeToRestore, "yes"))
    
        # run this option when the cell is completed migrated to WAS 8.5
        elif option == "--afterMigrationCleanUp":
            i = 1
            while i < len(sys.argv):
            
                if sys.argv[i] == '-dmgrNodeName':
                    dmgrNodeName = sys.argv[i+1]
                if sys.argv[i] == '-cellName':
                    cellName = sys.argv[i+1]
                i = i + 2    
                       
            sys.exit(afterMigrationCleanUp(cellName, dmgrNodeName))         
else:
    printHelp()
