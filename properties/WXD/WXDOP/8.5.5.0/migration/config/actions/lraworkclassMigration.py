#-------------------------------------------------------------------
# Licensed Material - Property of IBM
#
# 5724-J34 Copyright IBM Corp. 2006,2007
# All Rights Reserved.
# U.S. Government users - RESTRICTED RIGHTS - Use, Duplication, or
# Disclosure restricted by GSA-ADP schedule contract with IBM Corp.
# Status = JEJO610
#
# -------------------------------------------------------------------------
# lraworkclassMigration - migrates Default work classes for long running applications from
# 6.0 cell to 6.1 cell.
# 
# @author - Michael Smith
#
# Change History
# --------------
# 04-21-2006 initial version created
#===================================================================================================

import sys
import com.ibm.ws.sm.workspace.WorkSpace as WorkSpace
import com.ibm.ws.xd.config.workclass.util.ApplicationUtil as ApplicationUtil
import com.ibm.ws.xd.operationalpolicymonitor.util.MonitorUtil as MonitorUtil

lineSeparator = java.lang.System.getProperty('line.separator')

    
def createAppSLAWorkClass(modules, protocol):
    slaWorkClass=""
    appLongName=findDeployment(appname)
    appShortName=appname
       
    if (appLongName != None):
        slaWorkClass=findAppSLAWorkClass(getWorkClassName(protocol))
        if (slaWorkClass == None):
            wclassAttributes = [["matchAction","Default_TC"],
                                ["name",getWorkClassName(protocol)],
                                ["type",getProtocolForWorkClass(protocol)],
                                ["description","This is a default workclass."]]
            slaWorkClass=AdminConfig.create("WorkClass",appLongName,wclassAttributes)
            print ("INFO: Created... default service workclass: "+getWorkClassName(protocol))

        if (slaWorkClass != None):
            createDefaultModules(slaWorkClass, modules, protocol)
    else:
        print "WARNING: The application specified does not exist in this WAS deployment."
        errorExit()


def createDefaultModules(wcid, modules, protocol):
    for modulename in modules:                        
        if (protocol == "HTTP" or protocol == "SOAP"):
            uriExpression="*"
        else:
            uriExpression="*:*"

        if  1 == 1: #(not ApplicationUtil.isLRAModule(cellName, appname, modulename, wksp)):
            wcModuleAttributes = [ ["moduleName",modulename],
                                 ["matchExpression",uriExpression],
                                 ["id",getWorkClassName(protocol)+":!:"+appname+":!:"+modulename]]
            workClassModule=AdminConfig.create("WorkClassModule",wcid,wcModuleAttributes)
            print ("INFO: Adding... workclass module: "+modulename)
        
def createDefaultLRAModules(wcid, iiopmodules):
    for iiopmodulename in iiopmodules: 
        if (ApplicationUtil.isLRAModule(cellName, appname, iiopmodulename, wksp)):
            members = ApplicationUtil.listLRAEJBNames(cellName, appname, iiopmodulename, wksp)
            matchExpression = ""
            for member in members:
                if (matchExpression == ""):
                    matchExpression = member
                else:
                    matchExpression = matchExpression+","+member
                    
            wcModuleAttributes = [ ["moduleName",iiopmodulename],
                                   ["matchExpression",matchExpression],
                                   ["id",DEFAULT_LRA_WC+":!:"+appname+":!:"+iiopmodulename]]
            workClassModule=AdminConfig.create("WorkClassModule",wcid,wcModuleAttributes)
            print ("INFO: Adding... LRA workclass module: "+iiopmodulename)


#
# Finds the application service policy workclass in WAS repository.
#
# @param aWCName   The name of the application service policy workclass to look up.
# @return name    The name of the application service policy workclass if it exists or 
#                None if it does not exists.
#
def findAppSLAWorkClass(aWCName):
   wcNames=AdminConfig.list("WorkClass").split("\n")
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          name=AdminConfig.showAttribute(wcName,"name")
          if (aWCName == name and wcName.find("/deployments/") > 0 and wcName.find("/"+appname+"/") > 0):
              appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
              if (appName.find(appname) > 0):
                 #print "matched app SLA workclass: " + appName
                 return wcName
   return None

#
# Finds the enterprise application in WAS repository.
#
# @param aAppName   The name of the enterprise application to look up.
# @return name    The name of the enterprise application if it exists or 
#                None if it does not exists.
#
def findDeployment(aAppName):
   appName=AdminConfig.getid("/Deployment:"+aAppName+"/")

   if (appName == ""):
       return None
   else:
       return appName

def getProtocolForWorkClass(protocol):
   if (protocol == "SOAP"):
      protocolType = "SOAPWORKCLASS"
   elif (protocol == "IIOP"):
      protocolType = "IIOPWORKCLASS"
   elif (protocol == "JMS"):
      protocolType = "JMSWORKCLASS" 
   else:
      protocolType = "HTTPWORKCLASS"
   return protocolType

def getWorkClassName(protocol):
   return "Default_"+protocol+"_WC" 

#
# Gets the list of applications installed (public and private).
#
# @return A list of application names.
#
def getApplicationList():
    applications = ""
    deployments = AdminConfig.list('Deployment').split(lineSeparator)    
    
    for deployment in deployments:
        appname = deployment.split("(")[0]

        if (not (appname in applications.split(","))):
            if (applications == ""):
                applications = appname
            else:
                applications = applications + ","+appname
        
    return applications.split(",")


#
# Determines if the application installed is a 60 long running application.
#
# @return true if it is, None if not.
def isXD60LongRunningApp():
    slaWorkClass = findAppSLAWorkClass("Default_IIOP_WC")
    if (slaWorkClass != None):
        wcmList = AdminConfig.showAttribute(slaWorkClass, "workClassModules").replace("[","").replace("]","").split(" ")
        for wcm in wcmList:
          if (wcm == ""):
             break
        
          matchExpressionList = AdminConfig.showAttribute(wcm,"matchExpression").replace("[","").replace("]","").split(",")
        
          for matchExpression in matchExpressionList:
              if (matchExpression != "*:*"):
                  return "true"

    return "false"

def remove60DefaultLRAWC():
    slaWorkClass = findAppSLAWorkClass("Default_IIOP_WC")
    if (slaWorkClass != None):        
        print "INFO: Removing... XD 6.0 long running application workclass Default_IIOP_WC."
        AdminConfig.remove(slaWorkClass)

def createDefaultWCs():
        webModules = ApplicationUtil.listWebModuleNames(cellName, appname, wksp)
        if len(webModules) > 0:
            #print ("INFO: Creating... default HTTP service workclass")
            createAppSLAWorkClass(webModules, "HTTP")

        soapModules = ApplicationUtil.listWebServiceModuleNames(cellName, appname, wksp)
        if len(soapModules) > 0:
            #print ("INFO: Creating... default SOAP service workclass")
            createAppSLAWorkClass(soapModules, "SOAP")
                    
        if (not ApplicationUtil.isAppDeployedOnZOS(appname, cellName)):
            iiopModules = ApplicationUtil.listEJBModuleNames(cellName, appname, wksp)
            if len(iiopModules) > 0:
                #print ("INFO: Creating... default IIOP service workclass")
                createAppSLAWorkClass(iiopModules, "IIOP")
            
            jmsModules = ApplicationUtil.listJMSModuleNames(cellName, appname, wksp)
            if len(jmsModules) > 0:
                #print ("INFO: Creating... default JMS service workclass")
                createAppSLAWorkClass(jmsModules, "JMS")

def create61DefaultLRAWC():
    slaWorkClass=""
    appLongName=findDeployment(appname)
    appShortName=appname
       
    if (appLongName != None):
        slaWorkClass=findAppSLAWorkClass(DEFAULT_LRA_WC)
        if (slaWorkClass == None):
            wclassAttributes = [["matchAction","Default_TC"],
                                ["name",DEFAULT_LRA_WC],
                                ["type","IIOPWORKCLASS"],
                                ["description","This is a default LRA workclass."]]
            slaWorkClass=AdminConfig.create("WorkClass",appLongName,wclassAttributes)
            print ("INFO: Created... default service workclass: "+DEFAULT_LRA_WC)

        if (slaWorkClass != None):
            iiopModules = ApplicationUtil.listEJBModuleNames(cellName, appname, wksp)
            if len(iiopModules) > 0:
                createDefaultLRAModules(slaWorkClass, iiopModules)
    else:
        print "WARNING: The application specified does not exist in this WAS deployment."
        errorExit()

#==========================================================================
# Begin main execution
#==========================================================================
print """
#----------------------------------------------------------
# Migration step: lraworkclassMigration start
"""

appList = getApplicationList()
userID = MonitorUtil.generateUserID()
wksp = MonitorUtil.getWorkSpace(userID)
cellName = AdminConfig.list("Cell").split("(")[0]
print "INFO: Cell name ["+cellName+"], Number of Applications [",str(len(appList)),"]"
appname = ""
DEFAULT_LRA_WC = "Default_LRA_IIOP_WC"
#DEFAULT_LRA_MATCH_EXPR = "com.ibm.ws.batch.BatchJobControllerBean"
#DEFAULT_LRA_MATCH_EXPR2 = "com.ibm.ws.ci.CIControllerBean"


for app in appList:
    #Do a check to see if the application is in need of migration
    print "INFO: Processing... application "+app
    appname = app
                    
    if (isXD60LongRunningApp() == "true"):
        print "INFO: Evaulated... application "+app+"; it is a XD 6.0 long running application."
        remove60DefaultLRAWC()
        createDefaultWCs()        
        create61DefaultLRAWC()
    else:
        print "INFO: Evaulated... application "+app+"; it is not an XD 6.0 long running application."
        
    print ""

print "INFO: Saving default workclass changes... "
AdminConfig.save()
print "INFO: Saving... completed."

MonitorUtil.removeWorkSpace(userID)
print """
# Migration step: lraworkclassMigration finish
#----------------------------------------------------------
"""
