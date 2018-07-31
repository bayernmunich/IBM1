# (C) Copyright IBM Corp. 2006 - All Rights Reserved.
# DISCLAIMER:
# The following source code is sample code created by IBM Corporation.
# This sample code is provided to you solely for the purpose of assisting you
# in the  use of  the product. The code is provided 'AS IS', without warranty or
# condition of any kind. IBM shall not be liable for any damages arising out of your
# use of the sample code, even if IBM has been advised of the possibility of
# such damages.


# These are a set of modules that can be used by other Python scripts to perform
# common WebSphere Admin works or tasks. The intent is to have this be the repository
# of such modules to among other reasons, improve serviceability. There may be scripts
# who that have the same code as that in here, but are not using this class because 
# we can not change their documentation at this point in time. When that becomes 
# possible, we shall remove the code in those scripts and let them call into this
# class to use the common modules. One such example is workclassoperations.py.

# The arguments in these methods, follow those documented for workclassoperations.py
# in syntax. For example, 'aDefaultAction' follows the syntax of workclassoperations.py
# [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# is a valid input.

# Usage: To use these modules, you must do 2 things in your Python scripts
#    1. Define this variable at the top of your scripts file: ModulePath = $WAS_HOME/bin
#       For example, on Windows: ModulePath = "C:\\WebSphere\\AppServer\\bin\\"
#    2. Add this statement in the main section of script
#          execfile(ModulePath+"XDPYModules.py" )
#   You can call any of the methods in XDPYMdules, for example:
#    print findProxyServer("myODR")
#   For methods that throw the NameError exception, the caller should call them inside of
#   a try block. For example,
#             try:
#                  removeAppRoutingWorkClass(wcName,appName)
#             except NameError, detail:
#                  print detail 

#
# Author: O Michael Atogi
# Date Created: 01/24/2006
#
# Change History
# --------------
# 07-30-08 Added service policy specific functions
# 05-10-09 Added performance enhancements

#
# 
import jarray
import time
from java.lang import Exception
from java.lang import System
from com.ibm.ws.classify.definitions import Protocols
from com.ibm.wsspi.classify import Classifier
from com.ibm.wsspi.classify import RuleParserException
from com.ibm.wsspi.expr import Language

#
# Gets the protocol type of the form used by the AdminTask command given a
# communication protocol type.
#
# @param aProtocolType The name of the communication protocol type. Supported
#                      values are SOAP, IIOP, JMS, and it defaults to HTTP.
# @return String  Representing the work class type based on the protocol.
#
def getProtocolForWorkClass(aProtocolType):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
    
   if (aProtocolType == "SOAP"):
      protocolType = "SOAPWORKCLASS"
   elif (aProtocolType == "IIOP"):
      protocolType = "IIOPWORKCLASS"
   elif (aProtocolType == "JMS"):
      protocolType = "JMSWORKCLASS"
   else:
      protocolType = "HTTPWORKCLASS"


   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)

   return protocolType

#
# Gets the language (AKA protocol) from the work class type.
#
# @param aWorkClassType     The type of work class. Supported
#                           values are SOAPWORKCLASS, IIOPWORKCLASS, JMSWORKCLASS, 
#                           and it defaults to HTTPWORKCLASS.
# @return String  Representing the work class type based on the protocol.
#
def getLanguageFromWorkClassType(aWorkClassType):
   if (aWorkClassType == "SOAPWORKCLASS"):
      language = "SOAP"
   elif (aWorkClassType == "IIOPWORKCLASS"):
      language = "IIOP"
   elif (aWorkClassType == "JMSWORKCLASS"):
      language = "JMS"
   else:
      language = "HTTP"
   return language    

#
# Looks up a Service Policy ID 
#
# @param aServicePolicyName      The service policy name being checked
# @return String                 The service policy ID if it exists or None if it does not exist
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def getServicePolicyID(aServicePolicyName):
    
   if (aServicePolicyName == ""):
      raise NameError("ERROR: Must specify the name of the service policy.")
   
   spids = AdminConfig.list("ServiceClass")
   spList = spids.split(lineSeparator)
   for sp in spList:
      if (sp.split("(")[0] == aServicePolicyName):
         return sp

   return None
  

#
# Looks up a Transaction Class
#
# @param aTransactionClassName   The transaction class being checked
# @return aTransactionClassName  The transaction class name if it exists or None if it does not exist
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def getTransactionClassName(aTransactionClassName):

   if (aTransactionClassName == ""):
      raise NameError("ERROR: Must specify the name of the transaction class.")
   
   tcids = AdminConfig.list("TransactionClass")
   tcList = tcids.split(lineSeparator)
   for tc in tcList:
      if (tc.split("(")[0] == aTransactionClassName):
         return aTransactionClassName

   return None


#
# Looks up a Transaction Class Module Name ID
#
# @param aTCID      The transaction class ID
# @param aTCMName   The transaction class module name being validated
# @return String    The transaction class module ID if it exists or None if it does not exist.
#
def getTCMID(aTCID,aTCMName):
    
  tcmList = AdminConfig.showAttribute(aTCID, "TransactionClassModules").replace("[","").replace("]","").split(" ")
  for tcm in tcmList:
     if tcm=="":
        break
     if AdminConfig.showAttribute(tcm, "id")==aTCMName:
        return tcm

  return None


#
# Looks up a Transaction Class Module ID
#
# @param aTransactionClassName   The transaction class name being validated
# @return String                 The transaction class ID if it exists or None if it does not exist.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def getTransactionClassID(aTransactionClassName):
    
   if (aTransactionClassName == ""):
      raise NameError("ERROR: Must specify the name of the transaction class.")
   
   tcids = AdminConfig.list("TransactionClass")
   tcList = tcids.split(lineSeparator)
   for tc in tcList:
      if (tc.split("(")[0] == aTransactionClassName):
         return tc

   return None


#
# Finds the generic server cluster in WAS repository.
#
# @param anAction  The name of the generic server cluster to look up.
# @return name    The name of the generic server cluster if it exists or None
#                 if it does not exists.
#
def findGenericServerCluster(anAction):
   return getObjectId("/GenericServerCluster:"+anAction+"/");
    
#
# Finds the proxy server in WAS repository.
#
# @param anOdrName   The name of the proxy server or ODR to look up.
# @return name    The name of the proxy server if it exists or None
#                 if it does not exists.
#
def findProxyServer(anOdrName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
   psNames=AdminConfig.list("ProxyServer").split("\n")
   for psName in psNames:
       psName=psName.rstrip()
       if (len(psName) > 0 and psName.find("/"+anOdrName+"|") > -1):
             if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                 end = time.clock()
                 print "Total time elapsed = ", end - start, "seconds"
                 setTempTime(-1)
             return psName
         
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
   return None
    
#
# Finds the node in WAS repository.
#
# @param aNode   The name of the node to look up.
# @return name    The name of the node if it exists or None
#                 if it does not exists.
#  
def findNode(aNode):
   return getObjectId("/Node:"+aNode+"/");

#
# Finds the virtual host in WAS repository.
#
# @param aVHost   The name of the virtual host to look up.
# @return name    The name of the virtual host if it exists or None
#                 if it does not exists.
#
def findVirtualHost(aVHost):
   return getObjectId("/VirtualHost:"+aVHost+"/");

##
# Helper method that retrieves the ID of the specified object string.
# Format of aString, "/<objectType>:<objectName>/".
##
def getObjectId(aString):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
        
   objectId = AdminConfig.getid(aString);
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       
   if (objectId == ""):
       return None
   else:
       return objectId
     
#
# Finds application routing work class in WAS repository.
#
# @param aWCName  The name of the work class to look up.
# @param anAppName  The name of the enterprise application for which the work class belongs.
# @return name    The name of the work class if it exists or None
#                 if it does not exists.
# 
def findAppRoutingWorkClass(aWCName,anAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
    
   applicationID = findApplication(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "findAppRoutingWorkClass:findApplication = ", getSeconds()
   if (applicationID == None):
       return None
   
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if (getEnablePerformanceProfile() == "true"):
       print "findAppRoutingWorkClass:listWorkClasses = ", getSeconds()
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          #Ignore everything except application routing work classes.
          if (wcName.find("/routing/") == -1 and wcName.find("/sla/") == -1 and wcName.find("/middlewareappeditions/") == -1 and wcName.find("/deployments/") == -1):
              name=AdminConfig.showAttribute(wcName,"name")
              appName = anAppName.split("-edition")[0]
              if (aWCName == name):
                  if (wcName.find("/"+appName+".ear/") > 0 or wcName.find("/"+appName+"/") > 0):
                     appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
                     if (appName.find(anAppName.split("-edition")[0]) > 0 or appName==""):
                        if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                            end = time.clock()
                            print "Total time elapsed = ", end - start, "seconds"
                            setTempTime(-1)
                            print "Resetting time to:",getTempTime()
                        return wcName

   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
   return None
    
#
# Finds the system application routing work class in WAS repository.
#
# @param aWCName   The name of the system application routing work class to look up.
# @param anAppName  The name of the enterprise application for which the work class belongs.
# @return name    The name of the system application routing work class if it exists or None
#                 if it does not exists.
#
def findSystemAppRoutingWorkClass(aWCName,anAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if (getEnablePerformanceProfile() == "true"):   
       print "findSystemAppRoutingWorkClass:listWorkClass = ", getSeconds()
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          name=AdminConfig.showAttribute(wcName,"name")
          appName = anAppName.split("-edition")[0]          
          if (aWCName == name and wcName.find(appName+".ear") > 0 and wcName.find("systemApps") > 0 and wcName.find("deployments") == -1):
                if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                    end = time.clock()
                    print "Total time elapsed = ", end - start, "seconds"
                    setTempTime(-1)
                    print "Resetting time to:",getTempTime()
                return wcName
            
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
   return None
    
#
# Finds the system application service policy work class in WAS repository.
#
# @param aWCName   The name of the system application service policy work class to look up.
# @param anAppName  The name of the enterprise application for which the work class belongs.
# @return name    The name of the system application service policy work class if it exists or 
#                None if it does not exists.
#
def findSystemAppSLAWorkClass(aWCName,anAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   wcNames=AdminConfig.list("WorkClass").split("\n")
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          name=AdminConfig.showAttribute(wcName,"name")
          appName = anAppName.split("-edition")[0]          
          if (aWCName == name and wcName.find(appName+".ear") > 0 and wcName.find("systemApps") > 0 and wcName.find("deployments") > 0):
                if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                    end = time.clock()
                    print "Total time elapsed = ", end - start, "seconds"
                    setTempTime(-1)
                    print "Resetting time to:",getTempTime()
                return wcName
            
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
   return None
    
#
# Finds the application service policy work class in WAS repository.
#
# @param aWCName   The name of the application service policy work class to look up.
# @param anAppName  The name of the enterprise application for which the work class belongs.
# @return name    The name of the application service policy work class if it exists or 
#                None if it does not exists.
#
def findAppSLAWorkClass(aWCName,anAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   deploymentID = findDeployment(anAppName)
   if (deploymentID == None):
       return None
   
   wcNames = AdminConfig.list("WorkClass", deploymentID).split("\n")
   if (getEnablePerformanceProfile() == "true"):   
       print "findAppSLAWorkClass:listWorkClass = ", getSeconds()
   appnames=anAppName.split("-edition")
   mwApp = findMiddlewareApplication(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "findAppSLAWorkClass:findMiddlewareApplication = ", getSeconds()
   edname = ""
   if (mwApp != None):
      edition=findMiddlewareAppEdition(anAppName)
      edname=AdminConfig.showAttribute(edition,"name")
   for wcName in wcNames:
      wcName=wcName.rstrip()
      if (len(wcName) > 0 ):
         name=AdminConfig.showAttribute(wcName,"name")
         if (aWCName == name and wcName.find("/"+anAppName+"/") > 0 and wcName.find("deployments") > 0):
            if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                end = time.clock()
                print "Total time elapsed = ", end - start, "seconds"
                setTempTime(-1)
                print "Resetting time to:",getTempTime()
            return wcName
         elif (aWCName == name and wcName.find("/"+appnames[0]+"/") > 0 and wcName.find("/middlewareappeditions/"+edname+"/") > 0):
            if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                end = time.clock()
                print "Total time elapsed = ", end - start, "seconds"
                setTempTime(-1)
                print "Resetting time to:",getTempTime()
            return wcName
        
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime() 
   return None
    
#
# Finds the work class for a generic server application in WAS repository.
#
# @param aWCName   The name of the work class to look up.
# @param aPolicyType The policy type for which this work class is for. Acceptable values are {'routing', 'sla'}.
# @param anOdrName  The name of the on demand router server. 
# @return name    The name of the work class if it exists or None if it does not exists.
#
def findWorkClass(aWCName,aPolicyType,anOdrName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if (getEnablePerformanceProfile() == "true"):
       print "listWorkClass = ", getSeconds()
   for wcName in wcNames:
       wcName=wcName.rstrip()
       
       if (len(wcName) > 0 and wcName.find(aPolicyType) > -1 and wcName.find("/"+anOdrName+"/") > 0):
          name=AdminConfig.showAttribute(wcName,"name")
          if (aWCName == name):
              if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                  end = time.clock()
                  print "Total time elapsed = ", end - start, "seconds"
                  setTempTime(-1)
                  print "Resetting time to:",getTempTime() 
              return wcName
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime() 
   return None
  
#
# Finds the service policy 
#
# @param aServicePolicyName   The name of the service policy to look up.
# @return String  The ID of the service policy if it exists or None
#                 if it does not exists.
#
def findServicePolicy(aServicePolicyName):
   return getObjectId("/ServiceClass:"+aServicePolicyName+"/");
   
#
# Finds the transaction class in WAS repository.
#
# @param aTCName   The name of the transaction class to look up.
# @return String   The name of the transaction class if it exists or 
#                  None if it does not exists.
# 
def findTransactionClass(aTCName):
   if (aTCName.find("?") > 0):
       raise NameError("ERROR: The transaction class '"+aTCName+"' does not exist.")
   else:   
       return getObjectId("/TransactionClass:"+aTCName+"/");

def findTransactionClassByServicePolicy(aTCName, aServicePolicyName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   spid = findServicePolicy(aServicePolicyName)
   if (getEnablePerformanceProfile() == "true"):   
       print "findServicePolicy = ", getSeconds()
   if (spid == None):
       return None

   tcNames = AdminConfig.showAttribute(spid,"TransactionClasses").replace("[","").replace("]","").split(" ")
   if (getEnablePerformanceProfile() == "true"):   
       print "listTransactionClasses = ", getSeconds()
    
   for tcName in tcNames:
       name = AdminConfig.showAttribute(tcName, "name")
       if (len(name) > 0 and name == aTCName ):
           if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
               end = time.clock()
               print "Total time elapsed = ", end - start, "seconds"
               setTempTime(-1)
           return tcName
        
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
      end = time.clock()
      print "Total time elapsed = ", end - start, "seconds"
      setTempTime(-1)
   return None
#
# Finds the middleware application edition
#
# @param aAppName   The name of the middleware application to look up.
# @return id        The id of the middleware application if it 
#                   exists or None if it does not exists.
#
def findMiddlewareApplication(aAppName):
   names = aAppName.split("-edition")
   return getObjectId("/MiddlewareApp:"+names[0]+"/");


#
# Finds the middleware application edition
#
# @param appName  The name of the middleware application edition
# @return edition The edition if it exists or None if it does not exist
#    
def findMiddlewareAppEdition(appName):
   names = appName.split("-edition")
   mwApp = findApplication(appName)
   if (mwApp != None):
       editions = AdminConfig.list("MiddlewareAppEdition", mwApp).split("\n")
       for edition in editions:
          if (edition.find("/middlewareapps/" + names[0] + "/") > 0):
             alias = AdminConfig.showAttribute(edition, "alias")
             if (alias == names[1]):
                return edition
   return None

#
# Finds the middleware application alias
#
# @param appName -- the name of the middleware application
# @return alias -- the alias of the middleware application edition
#
def findMiddlewareAppAlias(appName, edName):
   if(appName.find("-edition") > 0):
      names = appName.split("-edition")
      appName = names[0];
   mwApp = findApplication(appName)
   if (mwApp != None):
      editions = AdminConfig.list("MiddlewareAppEdition", mwApp).split("\n")
      for edition in editions:
         if (edition.find("/" + appName + "/middlewareappeditions/" + edName) > 0):
            alias = AdminConfig.showAttribute(edition, "alias")
            return alias

#
# Finds the application in WAS repository.
#
# @param aAppName The name of the application to look up.
# @return name    The name of the application if it exists or 
#                 None if it does not exists.
#
def findApplication(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   appName=getObjectId("/Deployment:"+aAppName+"/");
   if (appName == None):
       appName = findMiddlewareApplication(aAppName)
       if (getEnablePerformanceProfile() == "true"):   
           print "findMiddlewareApplication = ", getSeconds()
       if (appName == None):
          print "ERROR: The application '"+aAppName+"' does not exist."
          return None

   appName = appName.replace("\"","")
   
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
   return appName
    
#
# Finds the enterprise application in WAS repository.
#
# @param aAppName   The name of the enterprise application to look up.
# @return name    The name of the enterprise application if it exists or 
#                None if it does not exists.
#
def findDeployment(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
    
   appName=getObjectId("/Deployment:"+aAppName+"/");
   if (appName == None):
       appName = findMiddlewareAppEdition(aAppName)
       if (getEnablePerformanceProfile() == "true"):   
           print "findMiddlewareApplication = ", getSeconds()
       if (appName == None):
          print "ERROR: The application '"+aAppName+"' does not exist."
          return None

   appName = appName.replace("\"","")
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
   return appName
    
#
# Finds the enterprise application module in WAS repository.
#
# @param aAppName     The name of the enterprise application to look up.
# @param aModuleName  The name of the module to look up.
# @return name        The name of the enterprise application module if it 
#                     exists or None if it does not exists.
#
def findModuleName(aAppName, aModuleName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   names = aAppName.split("-edition")
   mwApp = findMiddlewareApplication(aAppName)
   if (mwApp == None): 
      if (AdminApp.listModules(aAppName).find("#"+aModuleName+"+") > 0):
         if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
             end = time.clock()
             print "Total time elapsed = ", end - start, "seconds"
             setTempTime(-1)
         return aModuleName
   else:
       modules = AdminTask.listMiddlewareAppWebModules('[-app '+names[0]+' -edition '+names[1]+']').split("\n")
       for mod in modules:
          if (mod == aModuleName):
              if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                  end = time.clock()
                  print "Total time elapsed = ", end - start, "seconds"
                  setTempTime(-1)
              return aModuleName
       return None
       
#
# Finds the system application in WAS repository.
#
# @param aAppName   The name of the system application to look up.
# @return name    The name of the system application if it exists or 
#                None if it does not exists.
#
def findSystemApplication(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
    
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if (getEnablePerformanceProfile() == "true"):   
       print "findSystemApplication:listWorkClass = ", getSeconds()
   earAppName=""
   if (aAppName.endswith(".ear")):
       earAppName=aAppName
   else:
       earAppName=aAppName+".ear"
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          name=AdminConfig.showAttribute(wcName,"name")
          if (name.startswith("Default_") and name.endswith("_WC")):
              appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
              if (appName.find(earAppName) > 0):
                 if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
                     end = time.clock()
                     print "Total time elapsed = ", end - start, "seconds"
                     setTempTime(-1)
                 return earAppName
             
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
   return None

#
# Lists work classes for the given application.
#
# @param aAppName   The name of the system application to look up.
# @return work classes    The array of work class names if they exist or 
#                         None if it does not exists.
#
def listApplicationWorkClasses(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Application Work Classes = ", getSeconds()
   wcns=jarray.zeros(10,java.lang.String)
   earAppName=""
   if (aAppName.endswith(".ear")):
       earAppName=aAppName
   else:
       mwapp = findMiddlewareApplication(aAppName)
       if (mwapp == None):
           earAppName=aAppName+".ear"
       else:
           earAppName=aAppName
   k=0
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          name=AdminConfig.showAttribute(wcName,"name")
          if (name.startswith("Default_") and name.endswith("_WC")):
              appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
              if (appName.find(earAppName) > 0):
                 wcns[k]= name
                 k += 1
                 
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
       
   if (k == 0):
     return None
   return resize(wcns)

#
# Lists work class IDs for the given application.
#
# @param aAppName   The name of the system application to look up.
# @return work classes    The array of work class names if they exist or 
#                         None if it does not exists.
#
def listApplicationWorkClassIDs(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Application Work Class IDs = ", getSeconds()
   wcns=jarray.zeros(100,java.lang.String)
   earAppName=""
   if (aAppName.endswith(".ear") > 0):
       earAppName = "/" + aAppName + "/workclasses/"
       aAppName= "/" + aAppName + "/deployments/"
   else:
       mwapp = findMiddlewareApplication(aAppName)
       if (mwapp == None):
          if (aAppName.find("-edition") > 0):
             earAppName = "none"
             aAppName = "/deployments/" + aAppName
          else:
             earAppName = "/" + aAppName + ".ear" + "/workclasses/"
             aAppName = "/" + aAppName + ".ear" + "/deployments/"
       else:
          if(aAppName.find("-edition") > 0):
             edition = findMiddlewareAppEdition(aAppName)
             if(edition != None):
                edname = AdminConfig.showAttribute(edition, "name")
                earAppName = "none"
                appname = aAppName.split("-edition")
                aAppName = "/middlewareapps/" + appname[0] + "/middlewareappeditions/" + edname
          else:
             earAppName = "/middlewareapps/" + aAppName + "/workclasses/"
             aAppName = "/middlewareapps/" + aAppName + "/middlewareappeditions/"
   k=0
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
          if (appName.find(earAppName) > 0):
             wcns[k]= wcName
             k += 1
          if (appName.find(aAppName) > 0):
             wcns[k]= wcName
             k += 1
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
         
   if (k == 0):
     return None
   return resize(wcns)

#
# Lists workclass IDs for Routing Policy Applications 
#       for the given application
#
# @param aAppName  The name of the routing policy application
# @return wcns     The array of workclass names if they exist
#               or None if there are no workclass names
# 
def listRoutingApplicationWorkClassIDs(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Routing Application Work Classes = ", getSeconds()
   wcns=jarray.zeros(100,java.lang.String)
   earAppName=""
   if (aAppName.endswith(".ear") > 0):
       earAppName = "/" + aAppName + "/workclasses/"
   else:
      mwapp = findMiddlewareApplication(aAppName)
      if(mwapp == None):
         earAppName = "/" + aAppName + ".ear" + "/workclasses/"
      else:
         earAppName = "/middlewareapps/" + aAppName + "/workclasses/"
   k=0
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if(len(wcName) > 0):
          appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
          if (appName.find(earAppName) > 0):
              wcns[k]=wcName
              k += 1
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
          
   if (k == 0):
      return None
   return resize(wcns)

#
# Lists workclass IDs for Service Policy Applications
#       for the given application
#
# @param aAppName  The name of the service policy application
# @return wcns     The array of workclass names if they exist
#               or None if there are no workclass names
#
def listServiceApplicationWorkClassIDs(aAppName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Service Application Work Classes = ", getSeconds()
   wcns=jarray.zeros(100,java.lang.String)
   if (aAppName.endswith(".ear") > 0):
      aAppName = "/deployments/" + aAppName.replace(".ear", "")
   else:
      mwapp = findMiddlewareApplication(aAppName)
      if(mwapp == None):
         if (aAppName.find("-edition") > 0):
             aAppName = "/deployments/" + aAppName
         else:
             aAppName = aAppName + ".ear/deployments/" + aAppName 
      else: 
         if(aAppName.find("-edition") > 0):
             edition = findMiddlewareAppEdition(aAppName)
             if(edition != None):
                edname = AdminConfig.showAttribute(edition, "name")
                appname = aAppName.split("-edition")
                aAppName = "/middlewareapps/" + appname[0] + "/middlewareappeditions/" + edname 
         else:
            aAppName = "/middlewareapps/" + aAppName + "/middlewareappeditions/"        


   k=0
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if(len(wcName) > 0):
          appName=AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")[0]
          if (appName.find(aAppName) > 0):
              wcns[k]=wcName
              k += 1

   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()

   if (k == 0):
      return None
   return resize(wcns)


#
# Lists generic server workclass IDs for the given ODR.
#
# @param anOdrName      The name of the on demand router to look up.
# @return work classes   The array of work class names if they exist or 
#                       None if it does not exists.
#
def listGenericServerWorkClassIDs(anOdrName):
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Generic Server Work Class IDs = ", getSeconds()
   wcns=jarray.zeros(100,java.lang.String)

   k=0
   for wcName in wcNames:
       wcName=wcName.rstrip()

       if (wcName.find("/"+anOdrName+"/") > 0):
           wcns[k] = wcName
           k += 1

   if (k == 0):
     return None
   return resize(wcns)

#
# Lists work classes for the given application.
#
# @param aAppName   The name of the system application to look up.
# @return work classes    The array of work class names if they exist or 
#                         None if it does not exists.
#
def listSystemAppWorkClassIDs():
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List System App Work Classes = ", getSeconds()
   wcns=jarray.zeros(100,java.lang.String)

   k=0
   for wcName in wcNames:
       wcName=wcName.rstrip()
       
       if (wcName.find("xd/systemApps/") > 0):
           wcns[k] = wcName
           k += 1

   if (k == 0):
     return None
   return resize(wcns)

#
# Lists all work classes in this cell.
#
# @return work classes    The array of work class names if they exist or 
#                         None if it does not exists.
#
def listWorkClasses():
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Work Classes = ", getSeconds()
   k=0
   wcns=jarray.zeros(200,java.lang.String)
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          name=AdminConfig.showAttribute(wcName,"name")
          wcns[k] = name
          k += 1
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
   if (k == 0):
     return None
   return resize(wcns)

#
# Lists all work classes in this cell.
#
# @return work classes    The array of work class names if they exist or 
#                         None if it does not exists.
#
def listWorkClassIDs():
   wcNames=AdminConfig.list("WorkClass").split("\n")
   if(getEnablePerformanceProfile() == "true"):
       print "List Work Class IDs = ", getSeconds()
   k=0
   wcns=jarray.zeros(200,java.lang.String)
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          wcns[k] = wcName
          k += 1
   if (k == 0):
     return None
   return resize(wcns)

#
# Resizes to create a packed array eliminating empty elements.
#
# @return newarray  A packed array of work class names.
#
def resize(_data):
   count=0
   for j in range(0,len(_data),1):
       if (_data[j] != None):
          count += 1
   wcNames=jarray.zeros(count,java.lang.String)
   for i in xrange(count):
      wcNames[i] = _data[i]
   return wcNames
    
##
# Creates a routing workClass for generic server cluster with user specified work class name, 
# default action, protocol type, rules, URI patterns, virtual host, and odr node.
#
# @param aVirtualHost   The name of the virtual host.
# @param anOdrNode    The name of the odr node.
# @param anOdrName    The name of the ODR.
# @param aDefaultAction The default action for the work class. 
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @param aWorkClassName The name of the work class to be created.
# @param aProtocolType  The protocol type. Possible values are HTTP, SOAP, JMS, IIOP.
# @param aRule   Additional rules for the work class. The aRule follows the syntax of workclassoperations.py addRules option; 
#                 therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
# @param aMembers   A set of generic server members for the ODR following syntax of workclassoperations.py addMembers option.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def createGSCRoutingWorkClass(aVirtualHost,anOdrNode,anOdrName,aDefaultAction,aWorkClassName,aProtocolType,aRule,aMembers):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   vhostName=findVirtualHost(aVirtualHost)
   if (getEnablePerformanceProfile() == "true"):
       print "findVirtualHost = ", getSeconds()
   odrNode=findNode(anOdrNode)
   if (getEnablePerformanceProfile() == "true"):
       print "findNode = ", getSeconds()
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):
       print "findProxyServer = ", getSeconds()   
   
   if (findWorkClass(aWorkClassName,"routing",anOdrName) != None):
       raise NameError("WARNING: WorkClass already exists; therefore, cannot call create.")
   if (getEnablePerformanceProfile() == "true"):
       print "findWorkClass = ", getSeconds()
       
   if (vhostName != None and odrNode != None and odrName != None):
       if (aDefaultAction != ""):
           dParts = aDefaultAction.split("?")
           actionType = dParts[0]
           validateRoutingActionType(actionType)
           actionValue = ""
           try:
              actionValue = dParts[1]
           except IndexError:
              errmsg = "ERROR: missing action for '"+actionType+"'."
              raise NameError(errmsg)               
          
           if (actionType.startswith("permit")):
              gscName=findGenericServerCluster(actionValue)
              if (getEnablePerformanceProfile() == "true"):
                  print "findGenericServerCluster = ", getSeconds()
              if (gscName == None):
                 raise NameError("ERROR: The generic server cluster '"+actionValue+"' does not exist.")

           taskCmdArgs =  "[-odrnode "+ anOdrNode +" -odrname "+ anOdrName+" -wcname "+aWorkClassName+" -type "+aProtocolType+" -actiontype "+actionType+" -action "+actionValue+" -vhost "+aVirtualHost+"]"
           AdminTask.createRoutingPolicyWorkClass(taskCmdArgs)
           if (getEnablePerformanceProfile() == "true"):
               print "createRoutingPolicyWorkClass = ", getSeconds()           
           print "INFO: "+aWorkClassName+" work class created."
           addGSCRoutingRule(aWorkClassName,anOdrName,aRule)
           if (getEnablePerformanceProfile() == "true"):
               print "addGSCRoutingRule = ", getSeconds()
           addGSCRoutingMember(aWorkClassName,anOdrNode,anOdrName,aMembers)
           if (getEnablePerformanceProfile() == "true"):
               print "addGSCRoutingMember = ", getSeconds()
           if (aMembers != ""):
               print "INFO: members "+aMembers+" added successfully."
   else:
      if (vhostName == None):
         errMsg = " virtual host."
      elif (odrNode == None):
         errMsg = " ODR node."
      elif (odrName == None):
         errMsg = " ODR."
      else:
         errMsg = "check command arguments and re-issue command."
      errmsg = "ERROR: The specified arguments are not found in this WAS deployment: "+errMsg
      raise NameError(errmsg)
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds" 
       setTempTime(-1)
       print "Resetting time to:", getTempTime()
          
##
# Creates a service policy work class for a generic server cluster with user specified 
# work class name, default action, protocol type, rules, URI patterns, virtual host, and odr node.
# 
# @param aVirtualHost   The name of the virtual host.
# @param anOdrNode    The name of the odr node.
# @param anOdrName    The name of the ODR.
# @param aDefaultAction The default transaction class for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @param aWorkClassName The name of the work class to be created.
# @param aProtocolType  The protocol type. Possible values are HTTP, SOAP, JMS, IIOP.
# @param aRule   Additional rules for the work class. The aRule follows the syntax of workclassoperations.py addRule option; 
#                 therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
# @param aMembers   A set of web module URIs for the application web module following syntax of workclassoperations.py addMembers option.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def createGSCSLAWorkClass(aVirtualHost,anOdrNode,anOdrName,aDefaultAction,aWorkClassName,aProtocolType,aRule,aMembers):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   vhostName=findVirtualHost(aVirtualHost)
   if (getEnablePerformanceProfile() == "true"):
       print "findVirtualHost = ", getSeconds()
   odrNode=findNode(anOdrNode)
   if (getEnablePerformanceProfile() == "true"):
       print "findNode = ", getSeconds()
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):
       print "findProxyServer = ", getSeconds()
   tcName = findTransactionClass(aDefaultAction)
   if (getEnablePerformanceProfile() == "true"):
       print "findTransactionClass = ", getSeconds()
   if (findWorkClass(aWorkClassName,"sla",anOdrName) != None):
       raise NameError("WARNING: WorkClass already exists; therefore, cannot call create.")
   if (getEnablePerformanceProfile() == "true"):
       print "findWorkClass = ", getSeconds()

   if (vhostName != None and odrNode != None and odrName != None and tcName != None):
       taskCmdArgs =  "[-odrnode "+ anOdrNode +" -odrname "+ anOdrName+" -wcname "+aWorkClassName+" -type "+aProtocolType+" -tcname "+aDefaultAction+" -vhost "+aVirtualHost+"]"
       AdminTask.createServicePolicyWorkClass(taskCmdArgs)
       if (getEnablePerformanceProfile() == "true"):
           print "createGSCServicePolicyWorkClass = ", getSeconds()
       print "INFO: "+aWorkClassName+" work class created."               

       addGSCSLARule(aWorkClassName,anOdrName,aRule)
       if (getEnablePerformanceProfile() == "true"):
           print "addGSCSLARule = ", getSeconds()
       addGSCSLAMember(aWorkClassName,anOdrNode,anOdrName,aMembers)
       if (getEnablePerformanceProfile() == "true"):
           print "addGSCSLAMember = ", getSeconds()
              
       if (aMembers != ""):         
           print "INFO: members "+aMembers+" added successfully."
   else:
      if (vhostName == None):
         errMsg = " virtual host."
      elif (odrNode == None):
         errMsg = " ODR node."
      elif (odrName == None):
         errMsg = " ODR."
      elif (tcName == None):
         errMsg = " transaction class name."
      else:
         errMsg = "check command arguments and re-issue command."
      errmsg = "ERROR: The specified arguments are not found in this WAS deployment: "+errMsg
      raise NameError(errmsg)
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds" 
       setTempTime(-1)
       print "Resetting time to:", getTempTime()
    
##
# Creates an application routing policy work class using specified arguments. 
# 
# @param anAppName The name of the enterprise application.
# @param aModule The name of the module.
# @param aDefaultAction The defaul action for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @param aWorkClassName The name of the work class to be created.
# @param aProtocolType  The protocol type. Possible values are HTTP, SOAP, JMS, IIOP.
# @param aRule   Additional rules for the work class. The aRule follows the syntax of workclassoperations.py addRules option; 
#                 therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
# @param aMembers   A set of web module URIs for the application web module following syntax of workclassoperations.py addMembers option.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def createAppRoutingWorkClass(anAppName,aModule,aDefaultAction,aWorkClassName,aProtocolType,aRule,aMembers):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
   
   routingWorkClass = None
   if (findAppRoutingWorkClass(aWorkClassName,anAppName) != None):
       raise NameError("WARNING: WorkClass already exists; therefore, cannot call create.")
   if (getEnablePerformanceProfile() == "true"):
       print "findAppRoutingWorkClass = ", getSeconds()
       
   appLongName=findApplication(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "findApplication = ", getSeconds()
       
   appShortName=anAppName

   if (appLongName != None):
       if (aDefaultAction != ""):
           dParts = aDefaultAction.split("?")
           actionType = dParts[0]
           validateRoutingActionType(actionType)
           actionValue = ""
           try:
              actionValue = dParts[1]
           except IndexError:
              errmsg = "ERROR: missing action for '"+actionType+"'."
              raise NameError(errmsg)

           if (actionType.startswith("permit")):
               deploymentName=findDeployment(actionValue)
               if (getEnablePerformanceProfile() == "true"):
                   print "findDeployment = ", getSeconds()
               if (deploymentName == None):
                   raise NameError("ERROR: The application deployment '"+actionValue+"' does not exist.")
               
           names=anAppName.split("-edition")
           mwApp = findMiddlewareApplication(anAppName)
           if (getEnablePerformanceProfile() == "true"):
               print "findMiddlewareApplication = ", getSeconds()
           if (mwApp == None):
              taskCmdArgs =  '[-appname "'+ anAppName+'" -wcname '+aWorkClassName+' -type '+aProtocolType+' -actiontype '+actionType+' -action "'+actionValue+'"]'
              routingWorkClass = AdminTask.createRoutingPolicyWorkClass(taskCmdArgs)
              if (getEnablePerformanceProfile() == "true"):
                  print "createRoutingPolicyWorkClass = ", getSeconds()
           else:
              protocolType = getProtocolForWorkClass(aProtocolType) 
              wclassAttributes = [["matchAction",actionType+":"+actionValue],
                                   ["name",aWorkClassName],
                                   ["type",protocolType],
                                   ["description","This is a custom workclass."]]
                                   
              routingWorkClass = AdminConfig.create("WorkClass",mwApp,wclassAttributes)
              if (getEnablePerformanceProfile() == "true"):
                  print "createMiddlewareWorkClass = ", getSeconds()
               
           print "INFO: "+aWorkClassName+" work class created."                 
                 
           addAppRoutingRuleWithIds(aRule,routingWorkClass)
           if (getEnablePerformanceProfile() == "true"):
               print "addAppRoutingRule = ", getSeconds()
           addAppRoutingMembersWithIds(aWorkClassName,anAppName,aModule,aMembers,routingWorkClass)
           if (getEnablePerformanceProfile() == "true"):
               print "addAppRoutingMembers = ", getSeconds()

           if (aMembers != ""):
               print "INFO: members "+aMembers+" added successfully."
   else:
      raise NameError("ERROR: The application '"+appShortName+"' does not exist.")
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()
    
##
# Creates an enterprise application service policy work class using specified arguments.
# 
# @param anAppName      The name of the enterprise application.
# @param aModule        The name of the web module.
# @param anEJBName      The name of the EJB module.
# @param aDefaultAction The default transaction class for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @param aWorkClassName The name of the work class to be created.
# @param aProtocolType  The protocol type. Possible values are HTTP, SOAP, JMS, IIOP.
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py addRules option; 
#                       therefore, "priority?expression?actiontype?action" is the format for aRule. aRule is an array object.
# @param aMembers       A set of module members for the application module following syntax of workclassoperations.py addMembers option.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def createAppSLAWorkClass(anAppName,aModule,anEJBName,aDefaultAction,aWorkClassName,aProtocolType,aRule,aMembers):
    print "WARNING: createAppSLAWorkClass is depreciated in favor of createAppSLAWorkClassSP for performance gains."
    createAppSLAWorkClassSP(anAppName,aModule,anEJBName,aDefaultAction,aWorkClassName,aProtocolType,aRule,aMembers,"");

##
# Creates an enterprise application service policy work class using specified arguments.
# 
# @param anAppName      The name of the enterprise application.
# @param aModule        The name of the web module.
# @param anEJBName      The name of the EJB module.
# @param aDefaultAction The default transaction class for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @param aWorkClassName The name of the work class to be created.
# @param aProtocolType  The protocol type. Possible values are HTTP, SOAP, JMS, IIOP.
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py addRules option; 
#                       therefore, "priority?expression?actiontype?action" is the format for aRule. aRule is an array object.
# @param aMembers       A set of module members for the application module following syntax of workclassoperations.py addMembers option.
# @param ASPName        The name of the service policy that the aDefaultAction belongs to.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def createAppSLAWorkClassSP(anAppName,aModule,anEJBName,aDefaultAction,aWorkClassName,aProtocolType,aRule,aMembers,aSPName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);

   slaWorkClass = None;
   if (findAppSLAWorkClass(aWorkClassName,anAppName) != None):
       raise NameError("WARNING: WorkClass already exists; therefore, cannot call create.")
   if (getEnablePerformanceProfile() == "true"):
       print "start = ", getSeconds()
   protocolType = getProtocolForWorkClass(aProtocolType)
   if (getEnablePerformanceProfile() == "true"):
       print "getProtocolForWorkClass = ", getSeconds()
   appLongName=findDeployment(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "findDeployment = ", getSeconds()
   
   if (appLongName != None):
       if (aDefaultAction != ""):
            tcName = None
            if (aSPName == ""):
                tcName=findTransactionClass(aDefaultAction)
                if (getEnablePerformanceProfile() == "true"):
                    print "findTransactionClass = ", getSeconds()
            else:
                tcName=findTransactionClassByServicePolicy(aDefaultAction,aSPName)
                if (getEnablePerformanceProfile() == "true"):
                    print "findTransactionClassByServicePolicy = ", getSeconds()

            if (tcName != None):
               wclassAttributes = [["matchAction",aDefaultAction],
                                   ["name",aWorkClassName],
                                   ["type",protocolType],
                                   ["description","This is a custom workclass."]]
                                   
               slaWorkClass = AdminConfig.create("WorkClass",appLongName,wclassAttributes)
               if (getEnablePerformanceProfile() == "true"):
                   print "AdminConfig create = ", getSeconds()
               print "INFO: "+aWorkClassName+" work class created."
            else:
               raise NameError("ERROR: The transaction class '"+aDefaultAction+"' does not exist.")

            if (protocolType != "JMSWORKCLASS"):
               addAppSLARuleWithIds(aRule, slaWorkClass)
               if (getEnablePerformanceProfile() == "true"):
                   print "addAppSLARuleWithIds = ", getSeconds()
            addAppSLAMembersWithIds(aWorkClassName,anAppName,aModule,aMembers,anEJBName,slaWorkClass)
            if (getEnablePerformanceProfile() == "true"):
                print "addAppSLAMembersWithIds = ", getSeconds()
            
            if (aMembers != ""):         
               print "INFO: members "+aMembers+" added successfully."
   else:
      raise NameError("ERROR: The application '"+anAppName+"' does not exist.")
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"  
       setTempTime(-1)
       print "Resetting time to:", getTempTime()        
##
# Removes the specified application routing policy workclass.
#
# @param aWorkClassID a valid work class ID to remove.
##
def removeWorkClass(aWorkClass):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);

   aWorkClassName=AdminConfig.showAttribute(aWorkClass,"name")
   if (checkForReservedWC(aWorkClassName) == 1):
       raise NameError("ERROR: A default workclass can not be removed")

   AdminConfig.remove(aWorkClass)
   if(getEnablePerformanceProfile() == "true"):
       print "Removing work class = ", getSeconds()
       
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"  
       setTempTime(-1)
       print "Resetting time to:", getTempTime()        

##
# Removes a rule from the specified Application SLA work class
#
# @param workClassName valid work class name where rule will be removed from
# @param _appname valid application name for work class where rule will be removed
#
# @param _priority of rule to remove
# or
# @param _expression of rule to remove
# --if both _priority and _expression are provided, _priority is used to remove the rule
##

def removeRuleFromAppSLAWorkClass(workClassName, _appname, _priority, _expression):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);

   workClassID = findAppSLAWorkClass(workClassName, _appname)
       
   isRuleFound = 0
   ruleList = AdminConfig.showAttribute(workClassID,"matchRules").replace("[","").replace("]","").split(" ")     
   if (_priority != ""):
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   rulePriority = AdminConfig.showAttribute(rule,"priority")
                   if (_priority == rulePriority):
                       AdminConfig.remove(rule)
                       print "INFO: Rule with priority " + _priority + " has been deleted from SLA work class " + workClassName + "."
                       isRuleFound = 1
                       break
   else:
       #priority?rule?action
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   ruleExpression = AdminConfig.showAttribute(rule,"matchExpression")                     
                   if (_expression == ruleExpression):
                       AdminConfig.remove(rule)                         
                       print "INFO: Rule " + _expression + " has been deleted from SLA work class " + workClassName + "."
                       isRuleFound = 1                         
                       break
   if (isRuleFound == 0):
      if (_priority != ""):
          errorOperationExit("rule with priority '" + _priority + "' does not exist in SLA work class " + workClassName + ".")
      else:
          errorOperationExit("rule " + _expression + " does not exist in SLA work class " + workClassName + ".")
          
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"  
       setTempTime(-1)
       print "Resetting time to:", getTempTime()        
       
##
# Removes a rule from the specified Application Routing work class
#
# @param workClassName valid work class name where rule will be removed from
# @param _appname valid application name for work class where rule will be removed
#
# @param _priority of rule to remove
# or
# @param _expression of rule to remove
# --if both _priority and _expression are provided, _priority is used to remove the rule
##

def removeRuleFromAppRoutingWorkClass(workClassName, _appname, _priority, _expression):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);

   workClassID = findAppRoutingWorkClass(workClassName, _appname)
       
   isRuleFound = 0
   ruleList = AdminConfig.showAttribute(workClassID,"matchRules").replace("[","").replace("]","").split(" ")     
   if (_priority != ""):
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   rulePriority = AdminConfig.showAttribute(rule,"priority")
                   if (_priority == rulePriority):
                       AdminConfig.remove(rule)
                       print "INFO: Rule with priority " + _priority + " has been deleted from routing work class " + workClassName + "."
                       isRuleFound = 1
                       break
   else:
       #priority?rule?action
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   ruleExpression = AdminConfig.showAttribute(rule,"matchExpression")                     
                   if (_expression == ruleExpression):
                       AdminConfig.remove(rule)                         
                       print "INFO: Rule " + _expression + " has been deleted from routing work class " + workClassName + "."
                       isRuleFound = 1                         
                       break
   if (isRuleFound == 0):
      if (_priority != ""):
          errorOperationExit("rule with priority '" + _priority + "' does not exist in routing work class " + workClassName + ".")
      else:
          errorOperationExit("rule " + _expression + " does not exist in routing work class " + workClassName + ".")
          
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"  
       setTempTime(-1)
       print "Resetting time to:", getTempTime()        
       
##
# Removes a rule from the specified GSC SLA work class
#
# @param workClassName valid work class name where rule will be removed from
# @param _odrname valid on demand router name for work class where rule will be removed
#
# @param _priority of rule to remove
# or
# @param _expression of rule to remove
# --if both _priority and _expression are provided, _priority is used to remove the rule
##

def removeRuleFromGSCSLAWorkClass(workClassName, _odrname, _priority, _expression):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);

   workClassID = findWorkClass(workClassName, "sla", _odrname)
       
   isRuleFound = 0
   ruleList = AdminConfig.showAttribute(workClassID,"matchRules").replace("[","").replace("]","").split(" ")     
   if (_priority != ""):
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   rulePriority = AdminConfig.showAttribute(rule,"priority")
                   if (_priority == rulePriority):
                       AdminConfig.remove(rule)
                       print "INFO: Rule with priority " + _priority + " has been deleted from SLA work class " + workClassName + "."
                       isRuleFound = 1
                       break
   else:
       #priority?rule?action
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   ruleExpression = AdminConfig.showAttribute(rule,"matchExpression")                     
                   if (_expression == ruleExpression):
                       AdminConfig.remove(rule)                         
                       print "INFO: Rule " + _expression + " has been deleted from SLA work class " + workClassName + "."
                       isRuleFound = 1                         
                       break
   if (isRuleFound == 0):
      if (_priority != ""):
          errorOperationExit("rule with priority '" + _priority + "' does not exist in SLA work class " + workClassName + ".")
      else:
          errorOperationExit("rule " + _expression + " does not exist in SLA work class " + workClassName + ".")
          
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"  
       setTempTime(-1)
       print "Resetting time to:", getTempTime()            

##
# Removes a rule from the specified GSC Routing work class
#
# @param workClassName valid work class name where rule will be removed from
# @param _odrname valid on demand router name for work class where rule will be removed
#
# @param _priority of rule to remove
# or
# @param _expression of rule to remove
# --if both _priority and _expression are provided, _priority is used to remove the rule
##

def removeRuleFromGSCRoutingWorkClass(workClassName, _odrname, _priority, _expression):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);

   workClassID = findWorkClass(workClassName, "routing", _odrname)
       
   isRuleFound = 0
   ruleList = AdminConfig.showAttribute(workClassID,"matchRules").replace("[","").replace("]","").split(" ")     
   if (_priority != ""):
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   rulePriority = AdminConfig.showAttribute(rule,"priority")
                   if (_priority == rulePriority):
                       AdminConfig.remove(rule)
                       print "INFO: Rule with priority " + _priority + " has been deleted from routing work class " + workClassName + "."
                       isRuleFound = 1
                       break
   else:
       #priority?rule?action
       if len(ruleList) > 0:
           for rule in ruleList:
               if len(rule) > 0:
                   ruleExpression = AdminConfig.showAttribute(rule,"matchExpression")                     
                   if (_expression == ruleExpression):
                       AdminConfig.remove(rule)                         
                       print "INFO: Rule " + _expression + " has been deleted from routing work class " + workClassName + "."
                       isRuleFound = 1                         
                       break
   if (isRuleFound == 0):
      if (_priority != ""):
          errorOperationExit("rule with priority '" + _priority + "' does not exist in routing work class " + workClassName + ".")
      else:
          errorOperationExit("rule " + _expression + " does not exist in routing work class " + workClassName + ".")
          
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"  
       setTempTime(-1)
       print "Resetting time to:", getTempTime()            

##
# Adds members for the specified application service policy work class.
#
# @param aWorkClassName The name of the work class to delete.
# @param anAppShortName The name of the enterprise application to which the work class belongs.
# @param aModule        The name of the web module.
# @param aMembers       A set of module patterns for the application module following syntax of workclassoperations.py -addmember option.
# @param anEJBName      The name of the EJB.
# @param aSLAWorkClass  ID of work class object
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addAppSLAMembersWithIds(aWorkClassName,anAppShortName,aModule,aMembers,anEJBName,aSLAWorkClass):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
        showEndTime = "true";
        start = time.clock()
        setTempTime(start);
        print "addAppSLAMembersWithId start = ", getSeconds()
   slaWorkClassModule=""
   slaRules=""
   oldMember=""

   if (aModule != ""):
       moduleNameValue = findModuleName(anAppShortName, aModule)
       if (getEnablePerformanceProfile() == "true"):
           print "addAppSLAMembers:findModuleName = ", getSeconds()
       if (moduleNameValue == None):
           raise NameError("ERROR: The module '"+aModule+"' does not exist in application "+anAppShortName+".")

       if (anEJBName != ""):
           aMembers = alterMemberHelper(anEJBName, aMembers)

       addMemberHelper(aSLAWorkClass, aWorkClassName, anAppShortName, moduleNameValue, aMembers, "ASP")
       if (getEnablePerformanceProfile() == "true"):
           print "addAppSLAMembers:addMemberHelper = ", getSeconds()
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()

##
# Adds members for the specified application service policy work class.  Looks up the
# work class ID since only the name is given.
#
# @param aWorkClassName The name of the work class to delete.
# @param anAppShortName      The name of the enterprise application to which the work class belongs.
# @param aModule        The name of the web module.
# @param aMembers       A set of module patterns for the application module following syntax of workclassoperations.py -addmember option.
# @param anEJBName      The name of the EJB.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addAppSLAMembers(aWorkClassName,anAppShortName,aModule,aMembers,anEJBName):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
        
   slaWorkClass=findAppSLAWorkClass(aWorkClassName,anAppShortName)
   if (getEnablePerformanceProfile() == "true"):
       print "addAppSLAMembers:findAppSLAWorkClass = ", getSeconds()
   addAppSLAMembersWithIds(aWorkClassName,anAppShortName,aModule,aMembers,anEJBName,slaWorkClass)
   
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Adds members for the specified application routing policy work class.
#
# @param aWorkClassName      The name of the work class to delete.
# @param anAppName           The name of the enterprise application to which the work class belongs.
# @param aModule             The name of the web module.
# @param aMembers            A set of module patterns for the application module following syntax of workclassoperations.py -addmember option.
# @param aRoutingWorkClassId An object ID for a routing work class.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##  
def addAppRoutingMembersWithIds(aWorkClassName,anAppShortName,aModule,aMembers,aRoutingWorkClassId):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   if (aModule != ""):
       moduleNameValue = findModuleName(anAppShortName, aModule)
       if (getEnablePerformanceProfile() == "true"):
           print "addAppRoutingMembers:findModuleName = ", getSeconds()
       if (moduleNameValue == None):
           raise NameError("ERROR: The module '"+aModule+"' does not exist in application "+anAppShortName+".")
   
       addMemberHelper(aRoutingWorkClassId, aWorkClassName, anAppShortName, moduleNameValue, aMembers, "ARP")
       if (getEnablePerformanceProfile() == "true"):
           print "addAppRoutingMembers:addMemberHelper = ", getSeconds()
           
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()
##
# Adds members for the specified application routing policy work class.
#
# @param aWorkClassName The name of the work class to delete.
# @param anAppName      The name of the enterprise application to which the work class belongs.
# @param aModule        The name of the web module.
# @param aMembers       A set of module patterns for the application module following syntax of workclassoperations.py -addmember option.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##  
def addAppRoutingMembers(aWorkClassName,anAppName,aModule,aMembers):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   routingWorkClass = None;
   appLongName=findApplication(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "addAppRoutingMembers:findApplication = ", getSeconds()
   appShortName=anAppName

   if (appLongName != None):   
       routingWorkClass = findAppRoutingWorkClass(aWorkClassName,appShortName)
       if (getEnablePerformanceProfile() == "true"):
           print "addAppRoutingMembers:findAppRoutingWorkClass = ", getSeconds()
       if (routingWorkClass == None):
           raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
   else:
      raise NameError("ERROR: The application '"+appShortName+"' does not exist.")
  
   addAppRoutingMembersWithIds(aWorkClassName,anAppName,aModule,aMembers,routingWorkClass)
   
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()


##
# Adds members for the specified generic server cluster service policy workclass.
#
# @param aWorkClassName The name of the work class to delete.
# @param anOdrNode      The name of the odr node.
# @param anOdrName      The name of the ODR.
# @param aMembers       A set of module patterns for the application module following syntax of workclassoperations.py -addmember option.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##  
def addGSCSLAMember(aWorkClassName,anOdrNode,anOdrName,aMembers):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   odrNode=findNode(anOdrNode)
   if (getEnablePerformanceProfile() == "true"):
       print "findNode = ", getSeconds()
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):
       print "findProxyServer = ", getSeconds()

   if (odrNode != None and odrName != None):
       slaWorkClass=findWorkClass(aWorkClassName,"sla",anOdrName)
       if (getEnablePerformanceProfile() == "true"):
           print "findWorkClass = ", getSeconds()
       addMemberHelper(slaWorkClass, aWorkClassName, anOdrNode, anOdrName, aMembers, "GSP")
       if (getEnablePerformanceProfile() == "true"):
           print "addMemberHelper = ", getSeconds()
       
   else:
      if (odrNode == None):
         errMsg = " ODR node."
      elif (odrName == None):
         errMsg = " ODR."
      else:
         errMsg = "check command arguments and re-issue command."
      errmsg = "ERROR: The arguments are not found in this WAS deployment: "+errMsg
      raise NameError(errmsg)
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Adds members for the specified generic server cluster routing policy work class.
#
# @param aWorkClassName The name of the work class to delete.
# @param anOdrNode      The name of the odr node.
# @param anOdrName      The name of the ODR.
# @param aMembers       A set of module patterns for the application module following syntax of workclassoperations.py -addmember option.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addGSCRoutingMember(aWorkClassName,anOdrNode,anOdrName,aMembers):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   odrNode=findNode(anOdrNode)
   if (getEnablePerformanceProfile() == "true"):
       print "findNode = ", getSeconds()
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):
       print "findProxyServer = ", getSeconds()

   if (odrNode != None and odrName != None):
       slaWorkClass=findWorkClass(aWorkClassName,"routing",anOdrName)
       if (getEnablePerformanceProfile() == "true"):
           print "findWorkClass = ", getSeconds()
       addMemberHelper(slaWorkClass, aWorkClassName, anOdrNode, anOdrName, aMembers, "GRP")
       if (getEnablePerformanceProfile() == "true"):
           print "addMemberHelper = ", getSeconds()
       
   else:
      if (odrNode == None):
         errMsg = " ODR node."
      elif (odrName == None):
         errMsg = " ODR."
      else:
         errMsg = "check command arguments and re-issue command."
      errmsg = "ERROR: The arguments are not found in this WAS deployment: "+errMsg
      raise NameError(errmsg)
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# CAUTION: This is a helper method for all the add member methods.  
# This is not intended to be used directly.  Doing so will by pass
# error checking and possibly result in a corrupted configuration.
##
def addMemberHelper(aWorkClass, aWorkClassName, appOrNode, moduleOrODR, aMembers, aWCType):
   if (aWorkClass != None):
       if (checkForReservedWC(aWorkClassName) == 1):
           raise NameError("WARNING: Cannot add members to a default work class.")
       if (getEnablePerformanceProfile() == "true"):
           print "addMemberHelper:checkForReservedWC = ", getSeconds()
   
       if (aMembers == ""):
           return None
       else:
           memberExpression = ""
           for member in aMembers.split("?"):
               if (memberExpression == ""):
                   memberExpression = member
               else:
                   memberExpression = memberExpression +","+member

       wcmId = ""
       if (memberExpression == "/*"):
           memberExpression = "*"
       fExpression=memberExpression

       wcmList = AdminConfig.showAttribute(aWorkClass, "workClassModules").replace("[","").replace("]","").split(" ")
       if (getEnablePerformanceProfile() == "true"):
           print "addMemberHelper:showWorkClassModules = ", getSeconds()
       for wcm in wcmList:
          if (wcm == ""):
             break

          if (AdminConfig.showAttribute(wcm, "moduleName") == moduleOrODR):
             wcmId = wcm
             break
          if (getEnablePerformanceProfile() == "true"):
              print "addMemberHelper:showModuleName = ", getSeconds()
            
       if (wcmId == ""):
          workclassID = aWorkClassName+":!:"+appOrNode+":!:"+moduleOrODR

          if (aWCType == "GSP" or aWCType == "GRP"):
              #Generic Server work class so switch the vars.
              workclassID = aWorkClassName+":!:"+moduleOrODR+":!:"+appOrNode

          if (getEnablePerformanceProfile() == "true"):
              print "addMemberHelper:findProxyServer = ", getSeconds()
          wcModuleAttributes = [ ["moduleName",moduleOrODR],
                                 ["matchExpression",memberExpression],
                                 ["id",workclassID]]
                                 
          aWorkClassModule=AdminConfig.create("WorkClassModule",aWorkClass,wcModuleAttributes)
          if (getEnablePerformanceProfile() == "true"):
              print "addMemberHelper:createWorkClassModules = ", getSeconds()
       else:
          oldMember = AdminConfig.showAttribute(wcmId,"matchExpression").replace("[","").replace("]","")
          if (getEnablePerformanceProfile() == "true"):
              print "addMemberHelper:showMatchExpression = ", getSeconds() 
          fExpression = oldMember + "," +fExpression
          AdminConfig.modify(wcmId,[["matchExpression", fExpression]])
          if (getEnablePerformanceProfile() == "true"):
              print "addMemberHelper:modifyMatchExpression = ", getSeconds()
   else: 
       raise NameError("ERROR: The workclass '"+aWorkClassName+"' does not exist.")


##
# This is a helper method that alters the membership if an EJB name is specified
# for JMS work classes.
##
def alterMemberHelper(anEJBName, aMembers):
    anAlteredMembers = ""
    for member in aMembers.split("?"):        
        if (anAlteredMembers == ""):
            anAlteredMembers = anEJBName +":"+ member
        else:
            anAlteredMembers = anAlteredMembers+"?"+anEJBName +":"+ member
            
    return anAlteredMembers

##
# Modifies the default action for the specified application service policy work class.
#
# @param aWorkClassName   The name of the work class to delete.
# @param anAppName   The name of the enterprise application to which the work class belongs.
# @param aDefaultAction The default transaction class for the work class.
# @param isSystemApp    system application flag. 0 means false, 1 means true.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##   
def modifyAppSLADefaultAction(aWorkClassName,anAppName,aDefaultAction, isSystemApp):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   appLongName=None
   slaWorkClass=None
   
   if (isSystemApp == 1):
       appLongName = findSystemApplication(anAppName)
       if (getEnablePerformanceProfile() == "true"):   
           print "findSystemApplication = ", getSeconds()
   else:
       appLongName=findDeployment(anAppName)       
       if (getEnablePerformanceProfile() == "true"):   
           print "findDeployment= ", getSeconds()       

   if (appLongName != None):
       tcName=findTransactionClass(aDefaultAction)
       if (getEnablePerformanceProfile() == "true"):   
           print "findTransactionClass = ", getSeconds() 
       
       if (tcName != None):
           if (isSystemApp == 1):
               slaWorkClass = findSystemAppSLAWorkClass(aWorkClassName,anAppName)
               if (getEnablePerformanceProfile() == "true"):   
                   print "findSystemAppRoutingWorkClass = ", getSeconds()
           else:
               slaWorkClass = findAppSLAWorkClass(aWorkClassName,anAppName)
               if (getEnablePerformanceProfile() == "true"):   
                   print "findAppRoutingWorkClass = ", getSeconds()
               
           if (slaWorkClass != None):
               AdminConfig.modify(slaWorkClass,[["matchAction", aDefaultAction]])
               if (getEnablePerformanceProfile() == "true"):   
                   print "modifyMatchAction = ", getSeconds()
           else:
               raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
       else:
           raise NameError("ERROR: The transaction class '"+aDefaultAction+"' does not exist.")
   else:
      raise NameError("ERROR: The application '"+appShortName+"' does not exist.")
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Modifies the default action for the specified application routing policy work class.
#
# @param aWorkClassName   The name of the work class to delete.
# @param anAppName   The name of the enterprise application to which the work class belongs.
# @param aDefaultAction The default transaction class for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @param isSystemApp    system application flag. 0 means false, 1 means true.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##   
def modifyAppRoutingDefaultAction(aWorkClassName,anAppName,aDefaultAction,isSystemApp):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   routingWorkClass=None
   appLongName=None
   appShortName=anAppName

   if (isSystemApp == 1):
       appLongName = findSystemApplication(anAppName)
       if (getEnablePerformanceProfile() == "true"):   
           print "findSystemApplication = ", getSeconds()
   else:
       appLongName=findApplication(anAppName)
       if (getEnablePerformanceProfile() == "true"):   
           print "findApplication = ", getSeconds()
       
   if (appLongName != None):
       if (aDefaultAction != ""):
           dParts = aDefaultAction.split("?")
           actionType = dParts[0]
           validateRoutingActionType(actionType)
           actionValue = ""
           try:
              actionValue = dParts[1]
           except IndexError:
              errmsg = "ERROR: missing action for '"+actionType+"'."
              raise NameError(errmsg)

           if (actionType.startswith("permit")):
               deploymentName=findDeployment(actionValue)
               if (getEnablePerformanceProfile() == "true"):   
                   print "findDeployment = ", getSeconds()
               if (deploymentName == None):
                   raise NameError("ERROR: The application deployment '"+actionValue+"' does not exist.")

           if (isSystemApp == 1):
               routingWorkClass = findSystemAppRoutingWorkClass(aWorkClassName,anAppName)
               if (getEnablePerformanceProfile() == "true"):   
                   print "findSystemAppRoutingWorkClass = ", getSeconds()
           else:
               routingWorkClass = findAppRoutingWorkClass(aWorkClassName,appShortName)
               if (getEnablePerformanceProfile() == "true"):   
                   print "findAppRoutingWorkClass = ", getSeconds()
               
           if (routingWorkClass != None):
               AdminConfig.modify(routingWorkClass,[["matchAction", actionType+":"+actionValue]])
               if (getEnablePerformanceProfile() == "true"):   
                   print "modifyMatchAction = ", getSeconds()
           else:            
               raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
   else:
      raise NameError("ERROR: The application '"+appShortName+"' does not exist.")
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Modifies the default action for the specified generic server cluster service policy work class.
#
# @param aWorkClassName   The name of the work class to delete.
# @param anOdrName    The name of the ODR.
# @param aDefaultAction The default transaction class for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##   
def modifyGSCSLADefaultAction(aWorkClassName,anOdrName,aDefaultAction):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   odrName=findProxyServer(anOdrName) 
   if (getEnablePerformanceProfile() == "true"):   
       print "findProxyServer = ", getSeconds()
       
   if (odrName != None):
       if (aDefaultAction != ""):
           dParts = aDefaultAction.split("?")           
           txclsName = dParts[0]
           tcName=findTransactionClass(txclsName)
           if (getEnablePerformanceProfile() == "true"):   
               print "findTransactionClass = ", getSeconds()
           if (tcName != None):   
               slaWorkClass = findWorkClass(aWorkClassName,"sla",anOdrName)
               if (getEnablePerformanceProfile() == "true"):   
                   print "findWorkClass = ", getSeconds()
               if (slaWorkClass != None):
                   aMatchAction = AdminConfig.showAttribute(slaWorkClass, "matchAction")
                   mParts = aMatchAction.split(":")
                   vhostName = mParts[0]
                   AdminConfig.modify(slaWorkClass,[["matchAction", vhostName+":"+txclsName]])
                   if (getEnablePerformanceProfile() == "true"):   
                       print "modifyMatchAction = ", getSeconds()
               else:
                   raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
           else:
               raise NameError("ERROR: The transaction class '"+txclsName+"' does not exist.")
   else:
      raise NameError("ERROR: The ODR '"+anOdrName+ "'` does not exist.")
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Modifies the default action for the specified generic server cluster routing policy work class.
#
# @param aWorkClassName   The name of the work class to delete.
# @param anOdrName    The name of the ODR.
# @param aDefaultAction The default transaction class for the work class.
#                       The value of aDefaultAction follows the syntax of workclassoperations.py
#                       [-setdefaultaction ["actiontype?action"]]; therefore, aDefaultAction="permit?StockTrade"
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##   
def modifyGSCRoutingDefaultAction(aWorkClassName,anOdrName,aDefaultAction):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):   
       print "findProxyServer = ", getSeconds()
   
   if (odrName != None):
       if (aDefaultAction != ""):
           dParts = aDefaultAction.split("?")
           actionType = dParts[0]
           validateRoutingActionType(actionType)
           if (getEnablePerformanceProfile() == "true"):   
               print "validateRoutingActionType = ", getSeconds()
           actionValue = ""
           try:
              actionValue = dParts[1]
           except IndexError:
              errmsg = "ERROR: missing action for '"+actionType+"'."
              raise NameError(errmsg)
          
           if (actionType.startswith("permit")):
              gscName=findGenericServerCluster(actionValue) 
              if (getEnablePerformanceProfile() == "true"):   
                  print "findGenericServerCluster = ", getSeconds()
              if (gscName == None):
                 raise NameError("ERROR: The generic server cluster '"+actionValue+"' does not exist.") 

           routingWorkClass = findWorkClass(aWorkClassName,"routing",anOdrName)
           if (getEnablePerformanceProfile() == "true"):   
               print "findWorkClass = ", getSeconds()
           if (routingWorkClass != None):
                 aMatchAction = AdminConfig.showAttribute(routingWorkClass, "matchAction")
                 mParts = aMatchAction.split(":")
                 vhostName = mParts[0]               
                 AdminConfig.modify(routingWorkClass,[["matchAction", vhostName+":"+actionType+":"+actionValue]])
                 if (getEnablePerformanceProfile() == "true"):   
                     print "modifyMatchAction = ", getSeconds()
           else:
                 raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")             
   else:
      raise NameError("ERROR: The ODR '"+anOdrName+ "'` does not exist.")
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Modifies the virtual host for the specified generic server cluster service policy work class.
#
# @param aWorkClassName   The name of the work class to delete.
# @param anOdrName    The name of the ODR.
# @param aVirtualHost   The name of the virtual host.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##   
def modifyGSCSLAVirtualHost(aWorkClassName,anOdrName,aVirtualHost):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   vhostName=findVirtualHost(aVirtualHost)
   if (getEnablePerformanceProfile() == "true"):   
       print "findVirtualHost = ", getSeconds()    
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):   
       print "findProxyServer = ", getSeconds() 

   if (odrName != None):
       if (vhostName != None):
           slaWorkClass = findWorkClass(aWorkClassName,"sla",anOdrName)
           if (getEnablePerformanceProfile() == "true"):   
               print "findWorkClass = ", getSeconds() 
           if (slaWorkClass != None):
               aMatchAction = AdminConfig.showAttribute(slaWorkClass, "matchAction")
               mParts = aMatchAction.split(":")
               actionType = mParts[1]
               AdminConfig.modify(slaWorkClass,[["matchAction", aVirtualHost+":"+actionType]])
               if (getEnablePerformanceProfile() == "true"):   
                   print "modifyMatchAction = ", getSeconds() 
           else:
               raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
       else:
           raise NameError("ERROR: The virtual host '"+aVirtualHost+"' does not exist.")           
   else:
      raise NameError("ERROR: The ODR '"+anOdrName+ "'` does not exist.")
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Modifies the default action for the specified generic server cluster routing policy work class.
#
# @param aWorkClassName   The name of the work class to delete.
# @param anOdrName    The name of the ODR.
# @param aVirtualHost   The name of the virtual host.
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##   
def modifyGSCRoutingVirtualHost(aWorkClassName,anOdrName,aVirtualHost):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true"
       start = time.clock()
       setTempTime(start);
       print "start = ", getSeconds()
       
   vhostName=findVirtualHost(aVirtualHost)
   if (getEnablePerformanceProfile() == "true"):   
       print "findVirtualHost = ", getSeconds()    
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):   
       print "findProxyServer = ", getSeconds()
   
   if (odrName != None):
       if (vhostName != None):
           routingWorkClass = findWorkClass(aWorkClassName,"routing",anOdrName)
           if (getEnablePerformanceProfile() == "true"):   
               print "findWorkClass = ", getSeconds()           
           if (routingWorkClass != None):
               aMatchAction = AdminConfig.showAttribute(routingWorkClass, "matchAction")
               mParts = aMatchAction.split(":")
               actionType = mParts[1]
               actionValue = mParts[2]
               AdminConfig.modify(routingWorkClass,[["matchAction", aVirtualHost+":"+actionType+":"+actionValue]])
               if (getEnablePerformanceProfile() == "true"):   
                   print "modifyMatchAction = ", getSeconds()
           else:
               raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
       else:
           raise NameError("ERROR: The virtual host '"+aVirtualHost+"' does not exist.")
   else:
      raise NameError("ERROR: The ODR '"+anOdrName+ "'` does not exist.")
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Adds rule for the specified application service policy work class.
#
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py -addrule option; 
#                       therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
# @param aSLAWorkClassId The Id of an SLA work class.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addAppSLARuleWithIds(aRule,aSLAWorkClassId):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   type = AdminConfig.showAttribute(aSLAWorkClassId,"type")
   if (type == "JMSWORKCLASS"):
       raise NameError("WARNING: Cannot add rules to a JMS work class.")
   for k in range(0,len(aRule),1):
       if (aRule[k] != None):
           rParts = aRule[k].split("?")
           priority = rParts[0]
           validateRulePriority(priority, aSLAWorkClassId)
           expr = rParts[1]
           validateExpression(expr, getLanguageFromWorkClassType(type))
           txclsName = rParts[2]
           #print "priority = "+priority+ " expr="+expr+ " TransactionClass="+txclsName
           tcName=findTransactionClass(txclsName)
           if (tcName != None):
               wcRuleAttributes = '[[matchAction "%s"][matchExpression "%s"][priority "%s"]]' % (txclsName, expr, priority)
               slaRules=AdminConfig.create("MatchRule",aSLAWorkClassId,wcRuleAttributes)
               if (getEnablePerformanceProfile() == "true"):
                   print "addAppSLARuleWithIds:createMatchRule = ", getSeconds()
               print "INFO: rule "+expr+" created in work class "+aSLAWorkClassId+"."
           else:
              raise NameError("ERROR: The transaction class '"+txclsName+"' does not exist.")
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()                       

##
# Adds rule for the specified application service policy work class.
#
# @param aWorkClassName The name of the work class to delete.
# @param anAppShortName The name of the enterprise application to which the work class belongs.
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py -addrule option; 
#                       therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addAppSLARule(aWorkClassName,anAppName,aRule):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   slaWorkClass=None
   appShortName=anAppName   
   appLongName=findDeployment(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "addAppSLARule:findDeployment = ", getSeconds()     

   if (appLongName != None):
       slaWorkClass = findAppSLAWorkClass(aWorkClassName,appShortName)
       if (getEnablePerformanceProfile() == "true"):
           print "addAppSLARule:findAppSLAWorkClass = ", getSeconds()
       if (slaWorkClass == None):
          raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
   else:
      raise NameError("ERROR: The application '"+appShortName+"' does not exist.")  
   addAppSLARuleWithIds(aRule,slaWorkClass);
   
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Adds rule for the specified application routing policy work class.
#
# @param aRule               Additional rules for the work class. The aRule follows the syntax of workclassoperations.py -addrule option; 
#                            therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
# @param aRoutingWorkClassId An object ID for a routing work class.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addAppRoutingRuleWithIds(aRule,aRoutingWorkClassId):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);

   actionValue=""

   type = AdminConfig.showAttribute(aRoutingWorkClassId,"type")
   for k in range(0,len(aRule),1):
     if (aRule[k] != None):
       #print " the aRule = " + aRule[k] + " and k = %i"  %k
       rParts = aRule[k].split("?")
       priority = rParts[0]
       validateRulePriority(priority, aRoutingWorkClassId)               
       #print "priority = " + priority
       expr = rParts[1]
       validateExpression(expr, getLanguageFromWorkClassType(type))
       actionType = rParts[2]
       validateRoutingActionType(actionType)
       actionValue = ""
       try:
          actionValue = rParts[3]
       except IndexError:
          errmsg = "ERROR: missing action for '"+actionType+"'."
          raise NameError(errmsg)
      
       if (actionType.startswith("permit")):
           deploymentName=findDeployment(actionValue)
           if (getEnablePerformanceProfile() == "true"):
               print "addAppRoutingRule:findDeployment = ", getSeconds()
           if (deploymentName == None):
               raise NameError("ERROR: The application deployment '"+actionValue+"' does not exist.")
           
       #print "priority = "+priority+ " expr="+expr+ " actionType="+actionType + " action="+actionValue
       wcRuleAttributes = '[[matchAction "%s:%s"][matchExpression "%s"][priority "%s"]]' % (actionType, actionValue, expr, priority)
       routingRules=AdminConfig.create("MatchRule",aRoutingWorkClassId,wcRuleAttributes)
       if (getEnablePerformanceProfile() == "true"):
           print "addAppRoutingRule:createMatchRule = ", getSeconds()
       print "INFO: rule "+expr+" created in work class "+aRoutingWorkClassId+"."
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to:",getTempTime()

##
# Adds rule for the specified application routing policy work class.
#
# @param aWorkClassName The name of the   to delete.
# @param anAppName      The name of the enterprise application to which the work class belongs.
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py -addrule option; 
#                       therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
##
def addAppRoutingRule(aWorkClassName,anAppName,aRule):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   routingWorkClass=None
   actionValue=""
   appShortName=anAppName
   appLongName=findApplication(anAppName)
   if (getEnablePerformanceProfile() == "true"):
       print "addAppRoutingRule:findApplication = ", getSeconds()

   if (appLongName != None):
       routingWorkClass = findAppRoutingWorkClass(aWorkClassName,appShortName)
       if (getEnablePerformanceProfile() == "true"):      
           print "addAppRoutingRule:findAppRoutingWorkClass = ", getSeconds()
       if (routingWorkClass == None):
          raise NameError("ERROR: The work class '"+aWorkClassName+"' does not exist.")
   else:
      errmsg = "ERROR: The application '"+appShortName +"' does not exist in this WAS deployment"
      raise NameError(errmsg)
  
   addAppRoutingRuleWithIds(aRule,routingWorkClass);
   
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Adds rule for the specified generic server cluster service policy work class.
#
# @param aWorkClassName The name of the work class to delete.
# @param anOdrName      The name of the ODR.
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py -addrule option; 
#                       therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
## 
def addGSCSLARule(aWorkClassName,anOdrName,aRule):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
    
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):
       print "findNode = ", getSeconds()

   if (odrName != None):       
       slaWorkClass=findWorkClass(aWorkClassName,"sla",anOdrName)
       if (getEnablePerformanceProfile() == "true"):
           print "findWorkClass = ", getSeconds()
       if (slaWorkClass != None):
          type = AdminConfig.showAttribute(slaWorkClass,"type")
          for k in range(0,len(aRule),1):
            if (aRule[k] != None):
               rParts = aRule[k].split("?")
               priority = rParts[0]
               validateRulePriority(priority, slaWorkClass)
               if (getEnablePerformanceProfile() == "true"):
                   print "fvalidateRulePriority = ", getSeconds()               
               expr = rParts[1]
               validateExpression(expr, getLanguageFromWorkClassType(type))
               if (getEnablePerformanceProfile() == "true"):
                   print "validateExpression = ", getSeconds()
               actionValue = rParts[2]
               #gscName=findGenericServerCluster(actionValue)  
               tcName=findTransactionClass(actionValue)
               if (getEnablePerformanceProfile() == "true"):
                   print "findTransactionClass = ", getSeconds()
               #print "priority = "+priority+ " expr="+expr+ " actionType="+actionType + " action="+actionValue
               if (tcName != None):
                   wcRuleAttributes = '[[matchAction "%s"][matchExpression "%s"][priority "%s"]]' % (actionValue, expr, priority)
                   slaRules=AdminConfig.create("MatchRule",slaWorkClass,wcRuleAttributes)
                   if (getEnablePerformanceProfile() == "true"):
                       print "createMatchRule = ", getSeconds()
                   print "INFO: rule "+expr+" created in work class "+aWorkClassName+"."                   
               else:
                   errmsg = "ERROR: The transaction class '"+actionValue +"' does not exist."
                   raise NameError(errmsg)                     
       else:
          errmsg = "ERROR: The work class '"+aWorkClassName+"' does not exist in this WAS deployment."
          raise NameError(errmsg)
   else:
      errmsg = "ERROR: The ODR '"+anOdrName+"' does not exist in this WAS deployment."
      raise NameError(errmsg)
  
   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

##
# Adds rule for the specified generic server cluster routing policy work class.
#
# @param aWorkClassName The name of the work class to delete.
# @param anOdrName      The name of the ODR.
# @param aRule          Additional rules for the work class. The aRule follows the syntax of workclassoperations.py -addrule option; 
#                       therefore, "priority?expr?actiontype?action" is the format for aRule. aRule is an array object.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
## 
def addGSCRoutingRule(aWorkClassName,anOdrName,aRule):
   showEndTime = "false"
   if (getTempTime() == -1 and getEnablePerformanceProfile() == "true"):
       showEndTime = "true";
       start = time.clock()
       setTempTime(start);
       
   odrName=findProxyServer(anOdrName)
   if (getEnablePerformanceProfile() == "true"):
       print "findProxyServer = ", getSeconds()
   workclass = aWorkClassName

   if (odrName != None):
       routingWorkClass=findWorkClass(aWorkClassName,"routing",anOdrName)
       if (getEnablePerformanceProfile() == "true"):
           print "findWorkClass = ", getSeconds()
       if (routingWorkClass != None):
          type = AdminConfig.showAttribute(routingWorkClass,"type")
          for k in range(0,len(aRule),1):
            if (aRule[k] != None):
               rParts = aRule[k].split("?")
               priority = rParts[0]
               validateRulePriority(priority, routingWorkClass)
               if (getEnablePerformanceProfile() == "true"):
                   print "validateRulePriority = ", getSeconds()
               expr = rParts[1]
               validateExpression(expr, getLanguageFromWorkClassType(type))
               if (getEnablePerformanceProfile() == "true"):
                   print "validateExpression = ", getSeconds()               
               actionType = rParts[2]
               validateRoutingActionType(actionType)
               
               try:
                  actionValue = rParts[3]
               except IndexError:
                  errmsg = "ERROR: missing action for '"+actionType+"'."
                  raise NameError(errmsg)
               if (actionType.startswith("permit")):
                   gscName=findGenericServerCluster(actionValue)
                   if (getEnablePerformanceProfile() == "true"):
                        print "findGenericServerCluster = ", getSeconds()
                   if (gscName == None):
                       errmsg = "ERROR: The generic server cluster '"+actionValue +"' is not valid."
                       raise NameError(errmsg)
               #print "priority = "+priority+ " expr="+expr+ " actionType="+actionType + " action="+actionValue
               wcRuleAttributes = '[[matchAction "%s:%s"][matchExpression "%s"][priority "%s"]]' % (actionType, actionValue, expr, priority)
               routingRules=AdminConfig.create("MatchRule",routingWorkClass,wcRuleAttributes)
               if (getEnablePerformanceProfile() == "true"):
                    print "createMatchRule = ", getSeconds()
               print "INFO: rule "+expr+" created in work class "+aWorkClassName+"."               
       else:
          errmsg = "ERROR: The work class '"+aWorkClassName +"' does not exist in this WAS deployment, so no other operation was performed."
          raise NameError(errmsg)               
   else:
      errmsg = "ERROR: The ODR '"+anOdrName+"' does not exist in this WAS deployment."
      raise NameError(errmsg)

   if (showEndTime == "true" and getEnablePerformanceProfile() == "true"):
       end = time.clock()
       print "Total time elapsed = ", end - start, "seconds"
       setTempTime(-1)
       print "Resetting time to: ", getTempTime()

#
# Creates a Discretionary Service Policy with the specified options. The new service policy will not
# have any transaction classes associated with it. Transaction classes must be created and associated separately.
#
# @param aServicePolicyName      The name of the service policy (unique service policy name)
# @param aServicePolicyDesc      (optional) Service Policy Description
# @param anImportanceValue       (optional) Service Policy Importance
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def createDiscretionaryServicePolicy(aServicePolicyName,aServicePolicyDesc,anImportanceValue):
   cellid = AdminConfig.list("Cell")
  
   # Make sure the necessary parameters were provided ...
   if (aServicePolicyName == ""):
       raise NameError("ERROR: Must specify Service Policy name.")
   if (findServicePolicy(aServicePolicyName)):
       raise NameError("WARNING: Service Policy "+aServicePolicyName+" already exists; therefore, cannot call create.")

   #default value of importance is 4 when not specified
   if (anImportanceValue == ""): 
       anImportanceValue = 4

   # Check service policy importance & normalized value   
   normalizedImportance = validateImportance(anImportanceValue)

   #Check to see if disableResponseTimeGoals is set to true. If set to true, need to validate importance value
   responseTimeGoalsEnabled = areResponseTimeGoalsEnabled();

   gtype = "DiscretionaryGoal"          
   #don't pass in importance if response time goals are enabled
   if (responseTimeGoalsEnabled == "true"): 
       gattributes = []
   else: 
       gattributes = [["importance",normalizedImportance]]
   
   # finished processing parameters, now create the policy
   print "INFO: Creating Service Policy ..."
   spid = AdminConfig.create("ServiceClass", cellid, [["name",aServicePolicyName],["description", aServicePolicyDesc]])
   goalid = AdminConfig.create(gtype, spid, gattributes,"ServiceClassGoal")
   print "INFO: "+aServicePolicyName+" service policy successfully created. New Service Policy ID = "+spid


#
# Creates an Average Response Time Service Policy with the specified options. The new service policy will not
# have any transaction classes associated with it. Transaction classes must be created and associated separately.
#
# @param aServicePolicyName      The name of the service policy (cell unique service policy name)
# @param aGoalValue              The service policy goal value (positive integer number, assumed milliseconds if units not specified)
# @param aGoalValueUnits         The service policy goal value units (0=milliseconds,1=seconds,2=minutes)
# @param anImportanceValue       The service policy importance (range 1-7)
#
# @param isGoalViolationEnabled      "true" - goal violation enabled | "false" - goal violation disabled 
#                                    The following goal & time params are ignored if goal violation is disabled ("false") 
# @param aGoalDeltaValue             (optional) Goal delta value (positive integer number, assumed milliseconds if units not specified)
# @param aGoalDeltaValueUnits        (optional) Goal delta value units (0=milliseconds,1=seconds,2=minutes)
# @param aTimePeriodValue            (optional) Time Period value (positive integer number, assumed milliseconds if units not specified) 
# @param aTimePeriodValueUnits       (optional) Time Period value units (0=milliseconds,1=seconds,2=minutes)
#
# @param aServicePolicyDesc      (optional) Service Policy Description
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def createARTServicePolicy(aServicePolicyName,aGoalValue,aGoalValueUnits,anImportanceValue,isGoalViolationEnabled,aGoalDeltaValue,aGoalDeltaValueUnits,aTimePeriodValue,aTimePeriodValueUnits,aServicePolicyDesc):
   cellid = AdminConfig.list("Cell")

   #If response time goals are disabled, cannot create this type of service policy
   responseTimeGoalsEnabled = areResponseTimeGoalsEnabled();
   if (responseTimeGoalsEnabled == "false"):
       print "ERROR: Resopnse time goals are currently disabled. Cannont create a response time service policy at this time."
       return None

   # Make sure the necessary parameters were provided ...
   if (aServicePolicyName == ""):
       raise NameError("ERROR: Must specify Service Policy name.")
   if (findServicePolicy(aServicePolicyName)):
       raise NameError("WARNING: Service Policy "+aServicePolicyName+" already exists; therefore, cannot call create.")

   # Check Goal Value & units -- default is 0=milliseconds
   validateValue("goal value",aGoalValue)
   if ((aGoalValueUnits == -1) or (aGoalValueUnits == "")):
       aGoalValueUnits = 0
   else:
       validateValueUnits("goal value",aGoalValueUnits)
       
   # Check service policy importance & normalized value   
   normalizedImportance = validateImportance(anImportanceValue)    

   # Check goal validation values if enabled -- "true"   
   validateGoalViolation(isGoalViolationEnabled)
   if (isGoalViolationEnabled == "true"):
      
       validateValue("goal delta value",aGoalDeltaValue)
       if ((aGoalDeltaValueUnits == -1) or (aGoalDeltaValueUnits == "")):
           aGoalDeltaValueUnits = 0
       else:
           validateValueUnits("goal delta value",aGoalDeltaValueUnits)
       
       validateValue("time period value",aTimePeriodValue)
       if ((aTimePeriodValueUnits == -1) or (aTimePeriodValueUnits == "")):
           aTimePeriodValueUnits = 0           
       else:
           validateValueUnits("time period value",aTimePeriodValueUnits)

   else:
       aGoalDeltaValue = 0
       aGoalDeltaValueUnits = 0
       aTimePeriodValue = 0
       aTimePeriodValueUnits = 0

   gtype = "AverageResponseTimeGoal"          
   gattributes = [["goalValue",aGoalValue],["importance",normalizedImportance],["goalValueUnits",aGoalValueUnits],["violationEnabled",isGoalViolationEnabled],["goalDeltaValue",aGoalDeltaValue],["goalDeltaValueUnits",aGoalDeltaValueUnits],["timePeriodValue",aTimePeriodValue],["timePeriodValueUnits",aTimePeriodValueUnits]]
   
   # finished processing parameters, now create the policy
   print "INFO: Creating Service Policy ..."
   spid = AdminConfig.create("ServiceClass", cellid, [["name",aServicePolicyName],["description", aServicePolicyDesc]])
   goalid = AdminConfig.create(gtype, spid, gattributes,"ServiceClassGoal")
   print "INFO: "+aServicePolicyName+" service policy successfully created. New Service Policy ID = "+spid

#
# Creates a Percentile Response Time Service Policy with the specified options. The new service policy will not
# have any transaction classes associated with it. Transaction classes must be created and associated separately.
#
# @param aServicePolicyName      The name of the service policy (cell unique service policy name)
# @param aGoalValue              The service policy goal value (positive integer number, assumed milliseconds if units not specified)
# @param aGoalValueUnits         The service policy goal value units (0=milliseconds,1=seconds,2=minutes)
# @param aPercentileValue        The percentile value for service policy with a percentile response time goal (integer number, 1-100) 
# @param anImportanceValue       The service policy importance (range 1-7)
#
# @param isGoalViolationEnabled      "true" - goal violation enabled | "false" - goal violation disabled 
#                                    The following goal & time params are ignored if goal violation is disabled ("false") 
# @param aGoalDeltaPercentileValue   (optional) Goal delta percentile value (positive integer number)
# @param aTimePeriodValue            (optional) Time Period value (positive integer number, assumed milliseconds if units not specified) 
# @param aTimePeriodValueUnits       (optional) Time Period value units (0=milliseconds,1=seconds,2=minutes)
#
# @param aServicePolicyDesc      (optional) Service Policy Description
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def createPRTServicePolicy(aServicePolicyName,aGoalValue,aGoalValueUnits,aPercentileValue,anImportanceValue,isGoalViolationEnabled,aGoalDeltaPercentileValue,aTimePeriodValue,aTimePeriodValueUnits,aServicePolicyDesc):
   cellid = AdminConfig.list("Cell")
 
   #If response time goals are disabled, cannot create this type of service policy
   responseTimeGoalsEnabled = areResponseTimeGoalsEnabled();
   if (responseTimeGoalsEnabled == "false"):
       print "ERROR: Resopnse time goals are currently disabled. Cannont create a response time service policy at this time."
       return None
  
   # Make sure the necessary parameters were provided ...
   if (aServicePolicyName == ""):
       raise NameError("ERROR: Must specify Service Policy name.")
   if (findServicePolicy(aServicePolicyName)):
       raise NameError("WARNING: Service Policy "+aServicePolicyName+" already exists; therefore, cannot call create.")

   # Check Goal Value & units -- default is 0=milliseconds
   validateValue("goal value",aGoalValue)
   if ((aGoalValueUnits == -1) or (aGoalValueUnits == "")):
       aGoalValueUnits = 0
   else:
       validateValueUnits("goal value",aGoalValueUnits)
       
   # Check service policy importance & normalized value   
   normalizedImportance = validateImportance(anImportanceValue)    
       
   # Check Percentile Value 
   validatePercentileValue(aPercentileValue)

   # Check goal validation values if enabled -- "true"   
   validateGoalViolation(isGoalViolationEnabled)
   if (isGoalViolationEnabled == "true"):
      
       validateValue("goal delta percentage value",aGoalDeltaPercentileValue)
       validateValue("time period value",aTimePeriodValue)
       if ((aTimePeriodValueUnits == -1) or (aTimePeriodValueUnits == "")):
           aTimePeriodValueUnits = 0
       else:
           validateValueUnits("time period value",aTimePeriodValueUnits)
           
   else:
       aGoalDeltaPercentileValue = 0
       aTimePeriodValue = 0
       aTimePeriodValueUnits = 0


   gtype = "PercentileResponseTimeGoal"        
   gattributes = [["goalValue",aGoalValue],["importance",normalizedImportance],["goalValueUnits",aGoalValueUnits],["goalPercent",aPercentileValue],["violationEnabled",isGoalViolationEnabled],["goalDeltaPercent",aGoalDeltaPercentileValue],["timePeriodValue",aTimePeriodValue],["timePeriodValueUnits",aTimePeriodValueUnits]]
  
   # finished processing parameters, now create the policy
   print "INFO: Creating Service Policy ..."
   spid = AdminConfig.create("ServiceClass", cellid, [["name",aServicePolicyName],["description", aServicePolicyDesc]])
   goalid = AdminConfig.create(gtype, spid, gattributes,"ServiceClassGoal")
   print "INFO: "+aServicePolicyName+" service policy successfully created. New Service Policy ID = "+spid

#
# Creates a Completion Time Service Policy with the specified options. The new service policy will not
# have any transaction classes associated with it. Transaction classes must be created and associated separately.
#
# @param aServicePolicyName      The name of the service policy (cell unique service policy name)
# @param aGoalValue              The service policy goal value (positvie integer number, assumed milliseconds if units not specified)
# @param aGoalValueUnits         The service policy goal value units (0=milliseconds,1=seconds,2=minutes)
# @param anImportanceValue       The service policy importance (range 1-7)
#
# @param isGoalViolationEnabled      "true" - goal violation enabled | "false" - goal violation disabled 
#                                    The following goal & time params are ignored if goal violation is disabled ("false") 
# @param aGoalDeltaValue             (optional) Goal delta value (positive integer number, assumed milliseconds if units not specified)
# @param aGoalDeltaValueUnits        (optional) Goal delta value units (0=milliseconds,1=seconds,2=minutes)
# @param aTimePeriodValue            (optional) Time Period value (positive integer number, assumed milliseconds if units not specified) 
# @param aTimePeriodValueUnits       (optional) Time Period value units (0=milliseconds,1=seconds,2=minutes)
#
# @param aServicePolicyDesc      (optional) Service Policy Description
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def createCTServicePolicy(aServicePolicyName,aGoalValue,aGoalValueUnits,anImportanceValue,isGoalViolationEnabled,aGoalDeltaValue,aGoalDeltaValueUnits,aTimePeriodValue,aTimePeriodValueUnits,aServicePolicyDesc):
   cellid = AdminConfig.list("Cell")
  
   # Make sure the necessary parameters were provided ...
   if (aServicePolicyName == ""):
       raise NameError("ERROR: Must specify Service Policy name.")
   if (findServicePolicy(aServicePolicyName)):
       raise NameError("WARNING: Service Policy "+aServicePolicyName+" already exists; therefore, cannot call create.")

   # Check Goal Value & units -- default is 0=milliseconds
   validateValue("goal value",aGoalValue)
   if ((aGoalValueUnits == -1) or (aGoalValueUnits == "")):
       aGoalValueUnits = 0
   else:
       validateValueUnits("goal value",aGoalValueUnits)
       
   # Check service policy importance & normalized value   
   normalizedImportance = validateImportance(anImportanceValue)    

   # Check goal validation values if enabled -- "true"   
   validateGoalViolation(isGoalViolationEnabled)
   if (isGoalViolationEnabled == "true"):
      
       validateValue("goal delta value",aGoalDeltaValue)
       if ((aGoalDeltaValueUnits == -1) or (aGoalDeltaValueUnits == "")):
           aGoalDeltaValueUnits = 0
       else:
           validateValueUnits("goal delta value",aGoalDeltaValueUnits)
       
       validateValue("time period value",aTimePeriodValue)
       if ((aTimePeriodValueUnits == -1) or (aTimePeriodValueUnits == "")):
           aTimePeriodValueUnits = 0           
       else:
           validateValueUnits("time period value",aTimePeriodValueUnits)

   else:
       aGoalDeltaValue = 0
       aGoalDeltaValueUnits = 0
       aTimePeriodValue = 0
       aTimePeriodValueUnits = 0

   gtype = "CompletionTimeGoal"   
   gattributes = [["goalValue",aGoalValue],["importance",normalizedImportance],["goalValueUnits",aGoalValueUnits],["violationEnabled",isGoalViolationEnabled],["goalDeltaValue",aGoalDeltaValue],["goalDeltaValueUnits",aGoalDeltaValueUnits],["timePeriodValue",aTimePeriodValue],["timePeriodValueUnits",aTimePeriodValueUnits]]     
   
   # finished processing parameters, now create the policy
   print "INFO: Creating Service Policy ..."
   spid = AdminConfig.create("ServiceClass", cellid, [["name",aServicePolicyName],["description", aServicePolicyDesc]])
   goalid = AdminConfig.create(gtype, spid, gattributes,"ServiceClassGoal")
   print "INFO: "+aServicePolicyName+" service policy successfully created. New Service Policy ID = "+spid

#
# Removes the specified service policy.
#
# @param aServicePolicyName      The name of the service policy to be removed.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def removeServicePolicy(aServicePolicyName):

   # Make sure the necessary parameters were provided ...
   if (aServicePolicyName == ""):
       raise NameError("ERROR: Must specify Service Policy name.")
   if (aServicePolicyName == "Default_SP"):
       raise NameError("ERROR: Default service policy can not be removed.")
      
   # Get Service Policy ID ...   
   spid = getServicePolicyID(aServicePolicyName) 
   if (spid == None):
       raise NameError("ERROR: Service Policy not found with the name: "+aServicePolicyName+". Cannot remove.")
   else:
       print "INFO: Removing Service Policy: "+spid
       AdminConfig.remove(spid)
       print "INFO: Service Policy successfully removed."


# Creates a transaction class with the specified options and associates it with the service policy specified.
# The transaction class will be empty until Uri's are associated with it.
#
# @param aServicePolicyName      The name of the service policy associated with transaction class (cell unique service policy name) 
# @param aTransactionClassName   The name of the transaction class to be created (cell unique transaction class name)
# @param aTransactionClassDesc   (optional) Transaction Class Description
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def createTransactionClass(aServicePolicyName,aTransactionClassName,aTransactionClassNameDesc):
   cellid = AdminConfig.list("Cell")
  
   # Make sure transaction class name is provided and is unique
   if (aTransactionClassName == ""):
       raise NameError("ERROR: Must specify the name of the transaction class.")
   if (getTransactionClassName(aTransactionClassName) != None):
       raise NameError("WARNING: Transaction class "+aTransactionClassName+" already exists; therefore, cannot call create.")

   # Make sure service policy is provided and exists
   spid = getServicePolicyID(aServicePolicyName)
   if (spid == None):
      raise NameError("ERROR: Service Policy "+aServicePolicyName+" does not exist. Please specify an existing service policy for the parent of the new transaction class.")

   # Finished processing parameters, now create the transaction class
   print "INFO: Creating Transaction Class ..."
   tcid = AdminConfig.create("TransactionClass", spid, [["name",aTransactionClassName],["description", aTransactionClassNameDesc]],"TransactionClasses")
   print "INFO: "+aTransactionClassName+" transaction class successfully created."


#
# Removes the specified transaction class. All Uri's in the transaction class will no longer be associated 
# with the parent service policy. If a request comes in for these Uri's and they have not been associated with
# a new service policy and transaction class, they will be classified to the default service policy with a 
# discretionary goal.
#
# @param aTransactionClassName    The name of the transaction class to be removed.
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def removeTransactionClass(aTransactionClassName):

   # Make sure the necessary parameters were provided ...
   if (aTransactionClassName == ""):
       raise NameError("ERROR: Must specify Transaction Class name.")
   if (aTransactionClassName == "Default_TC"):
       raise NameError("ERROR: Default transaction class can not be removed.")
    
   # Get Transaction Class ID ...   
   tcid = getTransactionClassID(aTransactionClassName) 
   if (tcid == None):
       raise NameError("ERROR: Transaction Class not found with the name: "+aTransactionClassName+". Cannot remove.")
   else:
       print "INFO: Removing Transaction Class: "+tcid
       AdminConfig.remove(tcid)
       print "INFO: Transaction Class successfully removed."

#
# Adds a set of URIs associated with a specific application and J2EE module pair with an existing transaction class.  
# The URIs should NOT include the context root of the URI as it will automatically be associated with the URI since 
# the application and module is specified.  If the validate flag is specified, each URI pattern will be checked to see
# if it already has been mapped to an existing transaction class (exaction match); otherwise it is assumed that the
# URI pattern has not already been mapped and will be added to the transaction class with out any validation.
#
# @param aTransactionClassName    The name of the transaction class to be removed.
# @param anAppName                The name of the application of which the Uri's are associated with.
# @param aModuleName              The J2EE module within the application of which the Uri's are associated with.
# @param aURIs                    "uri1,uri2,..." the collection of URI patterns to associate with the transaction class from the application j2ee module pair  
# @param isValidated              (optional) "true"  - URIs specified will be checked to make sure they have not already been mapped to an existing transaction class
#                                            "false" - URIs specified will not be checked.  
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def addUrisToTransactionClass(aTransactionClassName,anAppName,aModuleName,aURIs,isValidated):

   # Make sure the necessary parameters were provided ...
   if (aTransactionClassName == ""):
       raise NameError("ERROR: Must specify Transaction Class name.")

   # Get Transaction Class ID ...   
   tcid = getTransactionClassID(aTransactionClassName) 
   if (tcid == None):
       raise NameError("ERROR: Must specify an existing Transaction Class. Could not locate Transaction Class "+aTransactionClassName)
      
   # Make sure name of application is provided and valid (installed)  
   if (anAppName == ""):
       raise NameError("ERROR: Must specify the name of the application that the URIs are associated with.")
   if (validateAppName(anAppName) == "false"):
       raise NameError("ERROR: Must specify an installed application. Could not locate application "+anAppName)
      
   # Make sure name of web module is provided and valid (installed)  
   if (aModuleName == ""):
       raise NameError("ERROR: Must specify the name of the web module the URIs are associated with.")
   if (validateModuleName(aModuleName) == "false"):
       raise NameError("ERROR: Must specify an installed web module. Could not locate the module "+aModuleName+" for application "+anAppName)
                       
   # Make sure URIs are provided ...
   if len(aURIs) == 0:
       raise NameError("Must provide 1 or more URI patterns to add to the Transaction Class.")
   # Normalize URIs (make sure each starts with leading '/'
   for uri in uris:
       if not uri[0] == '/':
           uri = "/"+uri

   # Create the TCM name ...
   tcmodname = aTransactionClassName+":!:"+anAppName+":!:"+aModuleName

   # Check to see if TCM name already exists ...
   tcmid = getTCMID(tcid,tcmodname)

   # If validation enabled (default is "false")
   if validate == "true":
       validURIs = validateURIs(anAppName,aModuleName,aURIs)
       if len(validURIs) == 0:
           raise NameError("Must provide 1 or more URI patterns to add to the Transaction Class.")
   else:
       validURIs = uris                           
       print "INFO: Skipping validation ..."

   # Finished processing parameters, now create the transaction class module 
   print "INFO: Adding URIs to Transaction Class ..."

   # If TCM does not exist ... Create ... else Modify
   # Note - I am adding these URIs one by one only because adding them as a list did not seem to work...
   if tcmid == None:
#     tcmid = AdminConfig.create("TransactionClassModule", tcid, [["id",tcmodname],["URIs", validURIs]],"TransactionClassModules")
      tcmid = AdminConfig.create("TransactionClassModule", tcid, [["id",tcmodname]],"TransactionClassModules")
#  else:
#     AdminConfig.modify(tcmid, [["URIs", uris]])
   for uri in validURIs:
      AdminConfig.modify(tcmid,[["URIs", uri]])
                       
   print "INFO: URIs successfully added to Transaction Class "+aTransactionClassName                        

#
# Checks to determine if response time goals are enabled or not
#
def areResponseTimeGoalsEnabled(): 

   #response time goals are only disabled when the custom property disableResponseTimeGoals is set to true
   disableResponseTimeGoals = AdminConfig.list("Property", "disableResponseTimeGoals*").split("/n")
   if (disableResponseTimeGoals[0] != ""):
       attr = AdminConfig.showAttribute(disableResponseTimeGoals[0], "value")
       attr = attr.strip().lower()
       if (attr == "true"):
           return "false"

   return "true"

#
# Validates values for service policies with non-discretionary goals.
#
# @param aValueType              The type of value being validated 
# @param aGoalValue              The service policy goal value (integer number)
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def validateValue(aValueType,aGoalValue):

   if ((aGoalValue == -1) or (aGoalValue == "")):
      raise NameError("ERROR: Must specify a "+aValueType+" for the service policy.")

   if (aGoalValue <= 0):
      raise NameError("ERROR: Must specify a positive integer value for the "+aValueType)


#
# Validates value Units for service policies with non-discretionary goals.
#
# @param aValueType          The type of value being validated 
# @param aValueUnits         The service policy value units (0=milliseconds,1=seconds,2=minutes)
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def validateValueUnits(aValueType,aValueUnits):
        
    if ((aValueUnits < 0) or (aValueUnits > 2)):        
       raise NameError("ERROR: Value specified for the service policy "+aValueType+ " units is not recognized. Please use a value of 0-2.")


#        
# Validates importance level for service policies with non-discretionary goals and "normalize" the value.
# The importance value can be in a range of 1-100, but the UI "normalizes" it to one of 7 levels. 
#       
# @param anImportanceValue      The service policy importance level (range 1-7)
# @return normalizedValue       The service policy importance value "normalized" between 1-100 
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def validateImportance(anImportanceValue):
   if ((anImportanceValue == -1) or (anImportanceValue == "")):
      raise NameError("ERROR: Must specify an importance for the service policy.")
   elif ((anImportanceValue < 0) or (anImportanceValue > 7)):
      raise NameError("ERROR: Value specified for service policy importance is not recognized. Please use a value of 1-7.")
   
   if anImportanceValue == 1:
      return 1
   elif anImportanceValue == 2:
      return 15
   elif anImportanceValue == 3:
      return 35
   elif anImportanceValue == 4:
      return 50
   elif anImportanceValue == 5:
      return 65
   elif anImportanceValue == 6:
      return 85
   elif anImportanceValue == 7:
      return 99


#   
# Validates Goal Violation enablement flag for service policies with non-discretionary goals  
#       
# @param isGoalViolationEnabled      "true" - goal violation enabled | "false" - goal violation disabled
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def validateGoalViolation(isGoalViolationEnabled):
   if ((isGoalViolationEnabled != "true") and (isGoalViolationEnabled != "false")):
      raise NameError("ERROR: Value specified for the service policy goal violation enabled is not recognized. Please enter true or false.")


#
# Validates percentile value for service policies with percentile response time goals  
#       
# @param aPercentileValue    The percentile value (range 1-100)
#
# @exception NameError  Is raised for bad input. The message is preceded with either WARNING: or ERROR: to indicate severity.
def validatePercentileValue(aPercentileValue):

   if ((aPercentileValue == -1) or (aPercentileValue == "")):
      raise NameError("ERROR: Must specify a percentage for the Percentile Response Time goal (1-100).")
    
   if ((aPercentileValue > 100) or (aPercentileValue <= 0)):
      raise NameError("ERROR: Must specify a percentage in the range of 1-100. "+aPercentileValue+" is not a valid percentage.")

#
# Validates an Application Name
#
# @param anAppName     The application name being validated
# @return appFound     "true" - if the application exists | "false" if it does not exist. 
#
def validateAppName(anAppName):
       
   # Find the application name    
   apps = AdminApp.list()
   appList = apps.split(lineSeparator)
   appFound = "false"
   for app in appList:
      if app == anAppName:
         appFound = "true"
         break
       
   return appFound

#
# Validates a Module Name
# @param aModuleName   The web module name being validated
# @param modFound      "true" - if the module exists | "false" if it does not exist. 
#
def validateModuleName(aModuleName):
    
   # find the web module
   mods = AdminApp.listModules(appname)
   modList = mods.split(lineSeparator)
   modFound = "false"
   for mod in modList:
      mname = mod.split("#")[1].split("+")[0]
      if mname == modname:
         modFound = "true"
         break

   return modFound

#
# Validates URIs 
# @param anAppName     The application name 
# @param aModuleName   The web module name
# @param validURIs        The URIs (normalized)
#                       
# @return validURIs      The validated URIs (invalid URIs removed)
#
def validateURIs(anAppName,aModuleName,validURIs):

   # Check if the URIs are already specified in a different TranClass ...
   tcs = AdminConfig.list("TransactionClass")
   tcList = tcs.split(lineSeparator)
   for tc in tcList:
      tcmList = AdminConfig.showAttribute(tc, "TransactionClassModules").replace("[","").replace("]","").split(" ")
      for tcm in tcmList:
         if tcm == "":
            break
         tcm_id = AdminConfig.showAttribute(tcm, "id")
         tcm_names = tcm_id.split(":!:")
         if tcm_names[1]==anAppName and tcm_names[2]==aModuleName:
           tcm_uris = AdminConfig.showAttribute(tcm,"URIs").replace("[","").replace("]","").split(";")
           for tcm_uri in tcm_uris:
              for uri in uris:
                 if tcm_uri == uri:
                    print "WARNING: URI Pattern "+uri+" for application "+anAppName+" and web module "+aModuleName+" already is mapped to transaction class "+tc+". This URI Pattern will not be added to the specified Transaction Class "+tcname+"."
                    validURIs.remove(uri)

   return validURIs

def checkForReservedWC(aWorkClass):
    wcid = aWorkClass.split("(cells/")
    if (wcid[0].startswith("Default_") and wcid[0].endswith("_WC")):
        return 1

    return 0
                   
##
# Validates that a specified priority is not already taken with in a specified
# work class ID.
# 
# @param aPriority the priority represented by an integer
# @param aWorkClass the work class ID to check for taken rule priority
# @NameError this is thrown if the priority is already taken.
##
def validateRulePriority(aPriority, aWorkClass):
    rules = AdminConfig.showAttribute(aWorkClass,"matchRules").replace("[","").replace("]","").split(" ")
    for k in range(0,len(rules),1):
        if (rules[k] == None or rules[k] == ""):
            break
        
        priority = AdminConfig.showAttribute(rules[k],"priority")
        matchExpression = AdminConfig.showAttribute(rules[k],"matchExpression")
        if (aPriority == priority):
            errmsg = "ERROR: the rule priority "+priority+" is already assigned to rule: "+matchExpression
            raise NameError(errmsg)
    
def validateRoutingActionType(aActionType):
    if (aActionType != "permit" and aActionType != "permitsticky" and aActionType != "reject" and aActionType != "redirect"):
        if (aActionType.find(":") > 0):
            errmsg = "ERROR: invalid action type '"+aActionType+"'. Try "+aActionType.replace(":","?")+" instead."
            raise NameError(errmsg)            
        else:
            errmsg = "ERROR: invalid action type '"+aActionType+"'.  Valid values are permit, permitsticky, reject and redirect."
            raise NameError(errmsg)            

    
def validateExpression(anExpr, aProtocolType):
    try:
        language = Protocols.getLanguage(aProtocolType);
        classifier = Protocols.createClassifier(language);
        classifier.createBooleanExpression(anExpr);
    except RuleParserException, msg:
        errmsg = "ERROR: The rule expression is invalid: ", msg
        raise NameError(errmsg)

def getSeconds():
    #print ">> getTempTime(): ", getTempTime();
    #print ">> time.clock(): ", time.clock();
    #aNewTime = time.clock() - _tempTime;
    currentTime = time.clock()
    aNewTime = currentTime - getTempTime();
    #_tempTime = aNewTime;
    setTempTime(currentTime);
    #print "aNewTime: ", aNewTime;
    return aNewTime;

def setTempTime(aTime):
    #print "aTime: ",aTime
    global _tempTime;
    _tempTime = aTime;
    #print ">> set:_tempTime: ",_tempTime
    
def getTempTime():
    #print "get:_tempTime: ",_tempTime
    try:
        return _tempTime;
    except NameError, detail:
      return -1;

def setPerformanceProfile(aFlag):
    global _enablePeformance;
    _enablePeformance = aFlag;

def getEnablePerformanceProfile():
    try:
      return _enablePeformance;
    except NameError, detail:
      return "false";

#def normalExit(self):
#    java.lang.System.exit(0)
 
#def errorExit(self):
#    java.lang.System.exit(1)
