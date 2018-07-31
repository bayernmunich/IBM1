#=======================================================================================================================================================
#(C) Copyright IBM Corp. 2004-2006 - All Rights Reserved.
#DISCLAIMER:
#The following source code is sample code created by IBM Corporation.
#This sample code is provided to you solely for the purpose of assisting you
#in the  use of  the product. The code is provided 'AS IS', without warranty or
#condition of any kind. IBM shall not be liable for any damages arising out of your
#use of the sample code, even if IBM has been advised of the possibility of
#such damages.
#=======================================================================================================================================================

#=======================================================================================================================================================
# This file contains a series of operations to help automate the administration of work classes.
#
# workclassoperations.py - creates, updates work classes for enterprise
# applications and generic server clusters. It can also, list rules in a 
# work class, list members in a work class, fetch default action, set default 
# action, add rule, delete rule, delete members, and delete work classes for 
# the various policies and communication protocols. 
#
# For General Help:
#     >> ./wsadmin.sh -lang jython -f workclassoperations.py
# For Operation Specific Help:
#     >> ./wsadmin.sh -lang jython -f workclassoperations.py <operation> --help
# 
# Supported Operations:
#   listWorkClasses [options]
#   createWorkClass [options]
#   removeWorkClass [options]
#   addMembers [options]
#   removeMembers [options]
#   listMembers [options]
#   addRules [options]
#   removeRule [options]
#   listRules [options]
#   modifyDefaultAction [options]
#   getDefaultAction [options]
#   modifyVirtualHost [options]
#   getVirtualHost [options]
# 
# Common options:
#   --type        type of work class to create
#                 ASP = application service policy
#                 ARP = application routing policy
#                 GSP = generic server service policy
#                 GRP = generic server routing policy
#   --appname     optional name of application
#                 optional [required-if] the "--type" parameter is specified as ASP or ARP
#   --odrname     optional name of odr
#                 [required-if] the "--type" parameter is specified as GSP or GRP
#   --nodename    optional name of node
#                 [required-if] the "--type" parameter is specified as GSP or GRP
#
# Author: Michael Atogi atogi@us.ibm.com
# 
# Change History
# --------------
# 04-28-2005 Initial version
# 02-28-2006 Altered user experience
#=======================================================================================================================================================

import jarray
import java
from java.lang import System
from com.ibm.ws.classify import Expression
from com.ibm.ws.xd.config.workclass.util import ApplicationUtil
from com.ibm.ws.xd.config.workclass.util import WorkClassConstants
from com.ibm.wsspi.classify import RuleParserException

#=======================================================================================================================================================
#
# listWorkClasses description:
#
#    listWorkClasses [options]
#
#      Lists all work classes by the type specified.
#      Format of listing:
#      workclassname type appname/odrname deploymentname
#
#      options:
#      --type     [see common options] [optional]
#      --appname  [see common options] [optional]
#      --odrname  [see common options] [optional]
#
#      examples:
#       list all work classes:
#        >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses
#       List all work classes for application Trade:
#        >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --appname Trade
#       List all routing policy work classes for application Trade:
#        >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --type ARP --appname Trade
#       List all generic server work classes for ODR myODR:
#        >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --odrname myODR
#       List all generic server routing policy work classes for ODR myODR:
#        >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --type GRP --odrname myODR
#
#=======================================================================================================================================================
def listWorkClasses01():
    print ""
    print "***************************Listing work classes****************************"
                
    wcList = None  
 
    if (isSystemApp == 1):
        wcList = listSystemAppWorkClassIDs()
   
    if (_appname != ""):
        if(_wctype == "ASP"):
           wcList = listServiceApplicationWorkClassIDs(_appname)
        elif(_wctype == "ARP"):
           wcList = listRoutingApplicationWorkClassIDs(_appname)
        elif(_wctype == ""):
           wcList = listApplicationWorkClassIDs(_appname)
        else:
           errorOperationExit("type " + _wctype + " is not valid with application work classes")
        if(wcList == None):
            name = findApplication(_appname)
            if(name == None):
               errorOperationExit("application is not valid "+_appname+".")
            else:
               errorOperationExit("No workclasses found for application "+_appname+" of type "+_wctype+".")
    elif (_odrname != ""):
        wcList = listGenericServerWorkClassIDs(_nodename,_odrname)
        if wcList == None:
            errorOperationExit("ODR is not valid "+_odrname+".")
    elif (_wctype != ""):
        missingParameter("--appname or --odrname")
        errorOperationExit("")
    else:
        wcList = listWorkClassIDs()
        
    for wcid in wcList:
        listNames = wcid.split("(")
        listName = listNames[0].replace("\"","")
        listPath = listNames[1]
        
        listType = ""
        listAppname = ""
        listDeploymentname = ""
        listOdrname = ""
        listXDdeploymentname = ""
        listSystemappname = ""
        if (listPath.find("applications") > 0):
            if (listPath.find("deployments") > 0):
                listType = "ASP"
                listPaths = listPath.split("applications/")
                listPaths = listPaths[1].split("/deployments")
                listAppname = listPaths[0]
                listPaths = listPath.split("deployments/")
                listPaths = listPaths[1].split("/workclasses")
                listDeploymentname = listPaths[0]
            else:
                listType = "ARP"
                listPaths = listPath.split("applications/")
                listPaths = listPaths[1].split("/workclasses")
                listAppname = listPaths[0]
        elif (listPath.find("middlewareapps") > 0):
            if (listPath.find("middlewareappeditions") > 0):
                listType = "ASP"
                listPaths = listPath.split("middlewareapps/")
                listPaths = listPaths[1].split("/middlewareappeditions")
                listAppname = listPaths[0]
                listPaths = listPath.split("/middlewareappeditions/")
                listPaths = listPaths[1].split("/workclasses")
                listDeploymentname = findMiddlewareAppAlias(listAppname, listPaths[0])
            else:
                listType = "ARP"
                listPaths = listPath.split("middlewareapps/")
                listPaths = listPaths[1].split("/workclasses")
                listAppname = listPaths[0]
        elif (listPath.find("nodes") > 0):
            if (listPath.find("sla") > 0):
                listType = "GSP"
                listPaths = listPath.split("sla/")
                listPaths = listPaths[1].split("/workclasses")
                listOdrname = listPaths[0]                
            elif (listPath.find("routing") > 0):
                listType = "GRP"
                listPaths = listPath.split("routing/")
                listPaths = listPaths[1].split("/workclasses")
                listOdrname = listPaths[0]       
        elif (listPath.find("xd/systemApps") > 0):
            if (listPath.find("xddeployments") > 0):
                listType = "ASP"
                listPaths = listPath.split("xd/systemApps/")
                listPaths = listPaths[1].split("/xddeployments")
                listSystemappname = listPaths[0]
                listPaths = listPath.split("xddeployments/")
                listPaths = listPaths[1].split("/workclasses")
                listXDdeploymentname = listPaths[0]
            else:
                listType = "ARP"
                listPaths = listPath.split("xd/systemApps/")
                listPaths = listPaths[1].split("/workclasses")
                listSystemappname = listPaths[0]                

        if (_wctype == "") or (_wctype == listType):
            if (listAppname != ""):
                if (listDeploymentname != ""):
                    print listName+" "+listType+" "+listAppname+" "+listDeploymentname
                else:
                    print listName+" "+listType+" "+listAppname
            elif (listOdrname != ""):
                print listName+" "+listType+" "+listOdrname
            elif (listSystemappname != ""):
                if (listXDdeploymentname != ""):
                    print listName+" "+listType+" (system app) "+listSystemappname+" "+listXDdeploymentname
                else:
                    print listName+" "+listType+" (system app) "+listSystemappname
    print ""   
    print "INFO:",len(wcList),"work classes found." 
    print "INFO: finished." 
    print "***************************************************************************"    
            
def printListWorkClassesHelp():
    print """
     listWorkClasses [options]
 
       Lists all work classes by the type specified.
       Format of listing:
       workclassname type appname/odrname deploymentname
 
       options:
       --type     [see common options] [optional]
       --appname  [see common options] [optional]
       --odrname  [see common options] [optional]
 
       examples:
        list all work classes:
         >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses
        List all work classes for application Trade:
         >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --appname Trade
        List all routing policy work classes for application Trade:
         >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --type ARP --appname Trade
        List all generic server work classes for ODR myODR:
         >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --odrname myODR
        List all generic server routing policy work classes for ODR myODR:
         >> ./wsadmin.sh -lang jython -f workclassoperations.py listWorkClasses --type GRP --odrname myODR
   
   """    

#=======================================================================================================================================================
#
# createWorkClass description:
#
#    createWorkClass [options]
#  
#     Creates a work class with the specified options.  The new service policy will
#     not have any application modules or classification rules.  Application modules and
#     classification rules must be created and associated separately.
#
#     options:
#     --type        [see common options] [required]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --nodename    [see common options]
#     --wcname      [required] unique name for the work class within type
#     --protocol    [required] (HTTP | IIOP | JMS | SOAP)
#     --wcaction    [required] default action to take when a request is matched to 
#                   a member for this work class
#     --module      application module to associate members
#                   [required-if] the --member and --appname parameters are used
#     --members     Protocol specific pattern
#                   HTTP = /test1?/test2/*
#                   IIOP = <ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>
#                   SOAP = <webService>:<operationName>?<webSerivce>:<operationName>
#                   JMS  = <bus>:<destination>?<bus>:<destination>
#     --rule        [optional] a classification rule in the format "priority?rule?action"
#     --virtualhost the virtual host
#                   [required-if] --type parameter is used with GSP or GRP.
#
#     examples:
#      Create a HTTP application routing policy work class for application Trade with a default action of reject and reject code of 404:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type ARP --wcname CustomWorkClass --protocol HTTP --wcaction "reject?404" --appname Trade --module myModule.war --members "/test1?/test2"
#      Create a JMS application service policy work class for application Trade-edition1.0 with a default action of Default_TC:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type ASP --wcname CustomWorkClass --protocol JMS --wcaction "Default_TC" --appname Trade-edition1.0 --module myModule.war --members "/test1?/test2"
#      Create a HTTP generic server service policy work class for odr myODR on node myNode with a default action of permit and generic server cluser myGSC:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type GSP --wcname CustomWorkClass --protocol HTTP --wcaction "permit?myGSC" --odrname myODr --nodename myNode --virtualhost default_host
#      Create enterprise application work class for routing policy. It has the default action of reject with a reject code of 404 and priority of 2. The escape sequence (\%%) should be replaced by (\%).
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type ARP --wcname CustomWorkClass --protocol HTTP --wcaction  "reject?404" --appname A --module myWebModule.war --members "/test1?/test2/*" --rule "1?clienthost=\'localhost\' and serverhost like \'\%%.ibm.com\'?permit:A"
#
#=======================================================================================================================================================
def createWorkClass():
    print ""
    print "****************************Creating work class*****************************"

    #Check for common required parameters.
    errorFlag = "false"
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with createWorkClass option.")
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
    if (_wcaction == ""):
        missingParameter("--wcaction")        
        errorFlag = "true"
    if (_protocol == ""):
        missingParameter("--protocol")
        errorFlag = "true"
    if (_members != ""):
        if (_module == "") and (_wctype == "ASP" or _wctype == "ARP"):
            missingParameter("--module (required with --members parameter)")
        
    if (errorFlag == "true"):
        errorOperationExit("")

    validateMemberFormat(_protocol)
    validateMembership(_protocol)

    try:    
        if (_appname != ""):
            if (_wctype == "ASP"):
                if (_serviceClass == ""):
                    createAppSLAWorkClassSP(_appname, _module, _ejbname, _wcaction, _wcname, _protocol, _rules, _members, _serviceClass)
                else:
                    createAppSLAWorkClass(_appname, _module, _ejbname, _wcaction, _wcname, _protocol, _rules, _members)
            elif (_wctype == "ARP"):
                createAppRoutingWorkClass(_appname, _module, _wcaction, _wcname, _protocol, _rules, _members)
            else:
                errorOperationExit("only specify application name when using ASP or ARP work classes")                        
        elif ((_odrname != "") and (_nodename != "")):
            if (_virtualhost == ""):
                missingParameter("--virtualhost")
                errorOperationExit("")
            
            if (_wctype == "GSP"):
                createGSCSLAWorkClass(_virtualhost, _nodename, _odrname, _wcaction, _wcname, _protocol, _rules, _members)
            elif (_wctype == "GRP"):
                createGSCRoutingWorkClass(_virtualhost, _nodename, _odrname, _wcaction, _wcname, _protocol, _rules, _members)
            else:
                errorOperationExit("only specify the odr name and node name when using GSP or GRP work classes.")
        else:
            missingParameter("--appname or --odrname and --nodename")
            errorOperationExit("")
    except NameError, detail:
        print detail
        errorOperationExit("")
    
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""
    
def printCreateWorkClassHelp():
    print """
     createWorkClass [options]
   
      Creates a work class with the specified options.  The new service policy will
      not have any application modules or classification rules.  Application modules and
      classification rules must be created and associated separately.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --nodename    [see common options]
      --wcname      unique name for the work class within type
      --protocol    (HTTP | IIOP | JMS | SOAP)
      --wcaction    default action to take when a request is matched to 
                    a member for this work class
      --module      application module to associate members
                    [required-if] the --member and --appname parameters are used
      --members     Protocol specific pattern
                    HTTP = /test1?/test2/*
                    IIOP = <ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>
                    SOAP = <webService>:<operationName>?<webSerivce>:<operationName>
                    JMS  = <bus>:<destination>?<bus>:<destination>
      --rule        [optional] a classification rule in the format "priority?rule?action"
      --virtualhost the virtual host
                    [required-if] --type parameter is used with GSP or GRP.
 
      examples:
       Create a HTTP application routing policy work class for application Trade with a default action of reject and reject code of 404:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type ARP --wcname CustomWorkClass --protocol HTTP --wcaction "reject?404" --appname Trade --module myModule.war --members "/test1?/test2"
       Create a JMS application service policy work class for application Trade-edition1.0 with a default action of Default_TC:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type ASP --wcname CustomWorkClass --protocol JMS --wcaction "Default_TC" --appname Trade-edition1.0 --module myModule.war --members "/test1?/test2"
       Create a HTTP generic server service policy work class for odr myODR on node myNode with a default action of permit and generic server cluser myGSC:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type GSP --wcname CustomWorkClass --protocol HTTP --wcaction "permit?myGSC" --odrname myODr --nodename myNode --virtualhost default_host
       Create enterprise application work class for routing policy. It has the default action of reject with a reject code of 404 and priority of 2. The escape sequence (\%%) should be replaced by (\%).
        >> ./wsadmin.sh -lang jython -f workclassoperations.py createWorkClass --type ARP --wcname CustomWorkClass --protocol HTTP --wcaction  "reject?404" --appname A --module myWebModule.war --members "/test1?/test2/*" --rule "1?clienthost=\'localhost\' and serverhost like \'\%%.ibm.com\'?permit:A"
   
   """  

#=======================================================================================================================================================
#
# removeWorkClass description:
#
#    removeWorkClass [options]
#  
#     Remove a work class with the specified options.  The new service policy will
#     not have any application modules or classification rules.  Application modules and
#     classification rules must be created and associated separately.
#
#     options:
#     --type        [see common options]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --wcname      unique name for the work class within type
#
#
#     examples:
#      Remove a HTTP application routing policy work class for application Trade:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeWorkClass --type ARP --wcname CustomWorkClass --appname Trade
#      Remove a HTTP generic server service policy work class for odr myODR:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeWorkClass --type GSP --wcname CustomWorkClass --odrname myODR --nodename odrNodeName
#
#
#=======================================================================================================================================================
def removeWC():
    print ""
    print "****************************Removing work class*****************************"
    global _nodename

    #Check for common required parameters.
    errorFlag = "false"
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with removeWorkClass option.")    
    if _appname == "":
        if (_odrname == ""):
            missingParameter("--appname or --odrname")
            errorFlag = "true"
        else:
            if (_nodename == ""):
               _nodename = getProxyNode(_odrname)
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
        
    if (errorFlag == "true"):
        errorOperationExit("")
    
    wc = getWorkClassByType()
    removeWorkClass(wc)

    print "INFO: "+_wcname+" work class removed."
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""            
            
def printRemoveWorkClassHelp():
    print """
     removeWorkClass [options]
   
      Remove a work class with the specified options.  The new service policy will
      not have any application modules or classification rules.  Application modules
      and classification rules must be created and associated separately.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --wcname      unique name for the work class within type
 
 
      examples:
       Remove a HTTP application routing policy work class for application Trade:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeWorkClass --type ARP --wcname CustomWorkClass --appname Trade
       Remove a HTTP generic server service policy work class for odr myODR:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeWorkClass --type GSP --wcname CustomWorkClass --odrname myODR
   
   """ 

#=======================================================================================================================================================
#
# modifyDefaultAction description:
#
#    modifyDefaultAction [options]
#  
#     Edits the default action for a specified work class with the specified options.
#
#     options:
#     --type        [see common options]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --nodename    [see common options]
#     --wcname      unique name for the work class within type
#     --wcaction    default action to take when a request is matched to 
#                   a member for this work class
#
#
#     examples:
#      Change the virutal host in a HTTP application routing policy work class for application Trade:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyDefaultAction --type ARP --wcname CustomWorkClass --wcaction "reject?404" --appname Trade
#      Change the default action to Default_TC in a HTTP application service policy work class for application Trade-edition1.0:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyDefaultAction --type ASP --wcname CustomWorkClass --wcaction "Default_TC" --appname Trade-edition1.0 
#      Change the default action to a default action of permit and generic server cluser myGSC in a HTTP generic server policy work class for odr myODR:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyDefaultAction --type GSP --wcname CustomWorkClass --wcaction "permit?myGSC" --odrname myODr --nodename odrNodeName 
#
#
#=======================================================================================================================================================
def modifyDefaultAction():
    print ""
    print "***************************Modify default action****************************"
    global _nodename
  
    #Check for common required parameters.
    errorFlag = "false"
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
    if (_wcaction == ""):
        missingParameter("--wcaction")
        errorFlag = "true"        
        
    if (errorFlag == "true"):
        errorOperationExit("")
    
    try:
        if (_appname != ""):
            if (_wctype == "ASP"):
                modifyAppSLADefaultAction(_wcname, _appname, _wcaction, isSystemApp)
            elif (_wctype == "ARP"):
                modifyAppRoutingDefaultAction(_wcname, _appname, _wcaction, isSystemApp)
            else:
                errorOperationExit("only specify application name when using ASP or ARP work classes.")
        elif (not _odrname == ""):
            if (_nodename == ""):
              _nodename = getProxyNode(_odrname)
                         
            if (_wctype == "GSP"):
              modifyGSCSLADefaultAction(_wcname,_nodename,_odrname, _wcaction)
            elif (_wctype == "GRP"):
              modifyGSCRoutingDefaultAction(_wcname,_nodename,_odrname, _wcaction)
            else:
              errorOperationExit("only specify the odr name when using GSP or GRP work classes.")
        else:
            missingParameter("--appname or --odrname")
            errorOperationExit("")
    except NameError, detail:
        print detail
        errorOperationExit("")

    print "INFO: default action changed to "+_wcaction+"."
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print "" 
            
def printModifyDefaultActionHelp():
    print """
     modifyDefaultAction [options]
   
      Edits the default action for a specified work class with the specified options.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --wcname      unique name for the work class within type
      --wcaction    default action to take when a request is matched to 
                    a member for this work class
 
 
      examples:
       Change the virutal host in a HTTP application routing policy work class for application Trade:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyDefaultAction --type ARP --wcname CustomWorkClass --wcaction "reject?404" --appname Trade
       Change the default action to Default_TC in a HTTP application service policy work class for application Trade-edition1.0:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyDefaultAction --type ASP --wcname CustomWorkClass --wcaction "Default_TC" --appname Trade-edition1.0 
       Change the default action to a default action of permit and generic server cluser myGSC in a HTTP generic server policy work class for odr myODR:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyDefaultAction --type GSP --wcname CustomWorkClass --wcaction "permit?myGSC" --odrname myODr
   
   """ 

#=======================================================================================================================================================
#
# getDefaultAction description:
#
#    getDefaultAction [options]
#  
#     View the default action for a specified work class with the specified options.
#
#     options:
#     --type        [see common options]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --wcname      unique name for the work class within type
#
#
#     examples:
#      View the default action of a HTTP application routing policy work class for application Trade:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py getDefaultAction --type ARP --wcname CustomWorkClass --appname Trade
#      View the default action of a  HTTP application service policy work class for application Trade-edition1.0:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py getDefaultAction --type ASP --wcname CustomWorkClass --appname Trade-edition1.0 
#      View the default action of a  HTTP generic server policy work class for odr myODR:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py getDefaultAction --type GSP --wcname CustomWorkClass --odrname myODr
#
#
#=======================================================================================================================================================
def getDefaultAction():
    print ""
    print "*****************************Get default action*****************************"

    #Check for common required parameters.
    errorFlag = "false"
    if _appname == "":
        if (_odrname == ""):
            missingParameter("--appname or --odrname")
            errorFlag = "true"        
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"        
        
    if (errorFlag == "true"):
        errorOperationExit("")
    
    aWorkClass = getWorkClassByType()
    aDefaultAction = AdminConfig.showAttribute(aWorkClass, "matchAction")
    
    if (_odrname != ""):
        actions = aDefaultAction.split(":")
        if (_wctype == "GSP"):
            aDefaultAction = actions[1]
        else:
            aDefaultAction = actions[1]+":"+actions[2]

    print "INFO: default action for "+_wctype+" workclass "+_wcname+" is '"+aDefaultAction+"'."
    print "INFO: finished."
    print "****************************************************************************"
    print ""
                    
            
def printGetDefaultActionHelp():
    print """
     getDefaultAction [options]
   
      View the default action for a specified work class with the specified options.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --wcname      unique name for the work class within type
 
 
      examples:
       View the default action of a HTTP application routing policy work class for application Trade:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py getDefaultAction --type ARP --wcname CustomWorkClass --appname Trade
       View the default action of a  HTTP application service policy work class for application Trade-edition1.0:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py getDefaultAction --type ASP --wcname CustomWorkClass --appname Trade-edition1.0 
       View the default action of a  HTTP generic server policy work class for odr myODR:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py getDefaultAction --type GSP --wcname CustomWorkClass --odrname myODr
   
   """ 
   
#=======================================================================================================================================================
#
# modifyVirtualHost description:
#
#    modifyVirtualHost [options]
#  
#     Edits the virtual host for a specified work class with the specified options.
#
#     options:
#     --type        [see common options]
#     --odrname     [see common options]
#     --wcname      unique name for the work class within type
#     --virtualhost the virtual host
#                   "--type" parameter must be GSP or GRP to use this parameter
#
#     examples:
#      Change the default action to a default action of permit and generic server cluser myGSC in a HTTP generic server policy work class for odr myODR:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyVirtualHost --type GSP --wcname CustomWorkClass --virtualhost "default_host" --odrname myODR --nodename odrNodeName
#
#
#=======================================================================================================================================================
def modifyVirtualHost():
    print ""
    print "****************************Modify virtual host*****************************"
    global _nodename
    
    #Check for common required parameters.
    errorFlag = "false"
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with modfiyVirtualHost option.")    
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"        
    if (_virtualhost == ""):
        missingParameter("--virtualhost")
        errorFlag = "true"        
    
    if (errorFlag == "true"):
        errorOperationExit("")

    try:
        if (_odrname != ""):
            if (_nodename == ""):
              _nodename = getProxyNode(_odrname)

            if (_wctype == "GSP"):
              modifyGSCSLAVirtualHost(_wcname,_nodename, _odrname, _virtualhost)
            elif (_wctype == "GRP"):
              modifyGSCRoutingVirtualHost(_wcname,_nodename,_odrname, _virtualhost)
            else:
              errorOperationExit("only specify the odr name and node name when using GSP or GRP work classes.")
        else:
            missingParameter("--odrname")
            errorOperationExit("")
    except NameError, detail:
        print detail
        errorOperationExit("")

    print "INFO: virtual host is changed to "+_virtualhost+"."
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""
            
def printModifyVirtualHostHelp():
    print """
     modifyVirtualHost [options]
   
      Edits the default action for a specified work class with the specified options.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --nodename    [see common options]
      --wcname      unique name for the work class within type
      --wcaction    default action to take when a request is matched to 
                    a member for this work class
 
 
      examples:
       Change the default action to a default action of permit and generic server cluser myGSC in a HTTP generic server policy work class for odr myODR:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyVirtualHost --type GSP --wcname CustomWorkClass --virtualhost "default_host" --odrname myODR
   
   """    
   
#=======================================================================================================================================================
#
# getVirtualHost description:
#
#    getVirtualHost [options]
#  
#     View the virtual host for a specified work class with the specified options.
#
#     options:
#     --type        [see common options]
#     --odrname     [see common options]
#     --wcname      unique name for the work class within type
#
#     examples:
#      View the virtual host in a HTTP generic server policy work class for odr myODR:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyVirtualHost --type GSP --wcname CustomWorkClass --odrname myODr --nodename odrNodeName
#
#
#=======================================================================================================================================================
def getVirtualHost():
    print ""
    print "*****************************Get virtual host*******************************"
    global _nodename
    
    #Check for common required parameters.
    errorFlag = "false"
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with getVirtualHost option.")    
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"        
    
    if (errorFlag == "true"):
        errorOperationExit("")    
    
    aWorkClass = None
                
    try:
        if (_odrname != ""):
           if (_nodename == ""):
             _nodename=getProxyNode(_odrname)

           if (_wctype == "GSP"):
              aWorkClass = findWorkClass(_wcname,"sla",_nodename,_odrname)
           elif (_wctype == "GRP"):
              aWorkClass = findWorkClass(_wcname,"routing",_nodename_odrname)
           else:
              errorOperationExit("only specify the odr name and node name when using GSP or GRP work classes.")
        else:
            missingParameter("--odrname")
            errorOperationExit("")
    except NameError, detail:
        print detail
        errorOperationExit("")
      
    aMatchAction = AdminConfig.showAttribute(aWorkClass, "matchAction")
    mParts = aMatchAction.split(":")
    aVirtualHost = mParts[0]

    print "INFO: virtual host for "+_wctype+" workclass "+_wcname+" is '"+aVirtualHost+"'."
    print "INFO: finished."
    print "****************************************************************************"
    print ""
            
def printGetVirtualHostHelp():
    print """
     getVirtualHost [options]
   
      View the virtual host for a specified work class with the specified options.
 
      options:
      --type        [see common options]
      --odrname     [see common options]
      --wcname      unique name for the work class within type
 
      examples:
       View the virtual host in a HTTP generic server policy work class for odr myODR:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py modifyVirtualHost --type GSP --wcname CustomWorkClass ---odrname myODr
   
   """    

#=======================================================================================================================================================
#
# addMembers description:
#
#    addMembers [options]
#  
#     Adds work class members to the work class specified.  The new member will
#     be used to by the ODR to match incoming requests against.
#
#     options:
#     --type        [see common options]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --nodename    [see common options]
#     --wcname      type unique name for the work class
#     --module      application module to associate members
#     --members     Protocol specific pattern
#                   HTTP = "/test1?/test2/*"
#                   IIOP = "<ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>"
#                   SOAP = "<webService>:<operationName>?<webSerivce>:<operationName>"
#                   JMS  = "<bus>:<destination>?<bus>:<destination>"
#     --ejbname     only used when protocol is JMS and an IIOP module is being specified
#
#
#     examples:
#      Add members "/test1" and "/test2/*" in module myWebModule to a HTTP application routing policy work class for application Trade:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py addMembers --type ARP --wcname CustomWorkClass --appname Trade --module myWebModule.war --members "/test1?/test2/*"
#      Add members "bus1:destination1" and "bus2:destination2" in module myModule to a JMS application service policy work class for application edition Trade-edition1.0:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py addMembers --type ASP --wcname CustomWorkClass --appname Trade-edition1.0 --module myModule.war --members "bus1:destination1?bus2:destination2"
#      Add members "/test3" to a HTTP generic server routing policy work class in odr myODR on node myNode:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py addMembers --type GRP --wcname CustomWorkClass --odrname myODr --nodename myNode --members "/test3"
#
#=======================================================================================================================================================
def addMembers():
    print ""
    print "*********************************Add Members********************************"

    #Check for common required parameters.
    errorFlag = "false"
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with addMembers option.")
    if _appname == "":
        if (_odrname == "" and _nodename == ""):
            missingParameter("--appname or --odrname and --nodename")
            errorFlag = "true"
        elif (_odrname == "" and _nodename != ""):
            missingParameter("--odrname")
            errorFlag = "true"
        elif (_odrname != "" and _nodename == ""):
            missingParameter("--nodename")
            errorFlag = "true"
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
    if (_members == ""):
        missingParameter("--members")
        errorFlag = "true"
    if (_module == "") and (_wctype == "ASP" or _wctype == "ARP"):
        missingParameter("--module")
        errorFlag = "true"
        
    if (errorFlag == "true"):
        errorOperationExit("")

    #Get protocol if not specified
    aProtocol = _protocol
    if (aProtocol == ""):
        wc = getWorkClassByType()
        aProtocol = getProtocolFromWorkClassType(AdminConfig.showAttribute(wc, "type"))

    validateMemberFormat(aProtocol)
    validateMembership(aProtocol)
    
    try:
        if (_appname != ""):
            if (_wctype == "ASP"):
                addAppSLAMembers(_wcname, _appname, _module, _members, _ejbname)
            elif (_wctype == "ARP"):
                addAppRoutingMembers(_wcname, _appname, _module, _members)
            else:
                errorOperationExit("only specify application name when using ASP or ARP work classes.")
        elif (_odrname != "") and (_nodename != ""):
            if (_wctype == "GSP"):
                addGSCSLAMember(_wcname, _nodename, _odrname, _members)
            elif (_wctype == "GRP"):
                addGSCRoutingMember(_wcname, _nodename, _odrname, _members)
            else:
                errorOperationExit("only specify the odr name and node name when using GSP or GRP work classes.") 
    except NameError, detail:
        print detail
        errorOperationExit("")
    #else:
    #    missingParameter("--appname or --odrname and --nodename")
    #    errorOperationExit("")

    members = _members.split("?")
    for member in members:
        print "INFO: "+member+" added to "+_wcname+" membership."
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""
            
def printAddMembersHelp():
    print """
  addMembers description:
 
     addMembers [options]
   
      Adds work class members to the work class specified.  The new member will
      be used to by the ODR to match incoming requests against.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --nodename    [see common options]
      --wcname      type unique name for the work class
      --module      application module to associate members
      --members     Protocol specific pattern
                    HTTP = "/test1?/test2/*"
                    IIOP = "<ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>"
                    SOAP = "<webService>:<operationName>?<webSerivce>:<operationName>"
                    JMS  = "<bus>:<destination>?<bus>:<destination>"
 
 
     examples:
       Add members "/test1" and "/test2/*" in module myWebModule to a HTTP application routing policy work class for application Trade:
       >> ./wsadmin.sh -lang jython -f workclassoperations.py addMembers --type ARP --wcname CustomWorkClass --appname Trade --module myWebModule.war --members "/test1?/test2/*"
       Add members "bus1:destination1" and "bus2:destination2" in module myModule to a JMS application service policy work class for application edition Trade-edition1.0:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py addMembers --type ASP --wcname CustomWorkClass --appname Trade-edition1.0 --module myModule.war --members "bus1:destination1?bus2:destination2"
       Add members "/test3" to a HTTP generic server routing policy work class in odr myODR on node myNode:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py addMembers --type GRP --wcname CustomWorkClass --odrname myODr --nodename myNode --members "/test3"
   
   """ 

#=======================================================================================================================================================
#
# removeMembers description:
#
#    removeMembers [options]
#  
#     Removes work class members from the work class specified.  The member will no longer
#     be used by the ODR.
#
#     options:
#     --type        [see common options]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --protocol    protocol of work class created (HTTP | IIOP | JMS | SOAP)
#     --wcname      unique name for the work class
#     --module      application module to associate members
#     --members     Protocol specific pattern
#                   HTTP = "/test1?/test2/*"
#                   IIOP = "<ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>"
#                   SOAP = "<webService>:<operationName>?<webSerivce>:<operationName>"
#                   JMS  = "<bus>:<destination>?<bus>:<destination>"
#
#
#     examples:
#      Remove members "/test1" and "/test2/*" in module myWebModule to a HTTP application routing policy work class for application Trade:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeMembers --type ARP --wcname CustomWorkClass --protocol HTTP --appname Trade --module myWebModule.war --member "/test1?/test2/*"
#      Remove members "bus1:destination1" and "bus2:destination2" in module myModule to a JMS application service policy work class for application edition Trade-edition1.0:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeMembers --type ASP --wcname CustomWorkClass --protocol JMS --appname Trade-edition1.0 --module myModule.war --member "bus1:destination1?bus2:destination2"
#      Remove members "/test3" and "/test4" to a HTTP generic server routing policy work class in odr myODR on node myNode:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeMembers --type GRP --wcname CustomWorkClass --protocol HTTP --odrname myODr --nodename odrNodeName --member "/test3?/test4"
#
#=======================================================================================================================================================
def removeMembers():
    print ""
    print "********************************Remove Members******************************"
    global _nodename
    
    #Check for common required parameters.
    errorFlag = "false"
    moduleLocation = ""
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with removeMembers option.")    
    if _appname == "":
        if (_odrname == ""):
            missingParameter("--appname or --odrname")
            errorFlag = "true"
        else:
            if (_nodename == ""):
               _nodename = getProxyNode(_odrname)
            odrName=findProxyServer(_nodename,_odrname)
            if (odrName == None):
                print "ERROR: The ODR '"+_odrname+"' does not exist."
                errorOperationExit("")
            moduleLocation = _odrname
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"    
    if (_members == ""):
        missingParameter("--members")
        errorFlag = "true"
    if (_wctype.startswith("A") > 0):
        if (_module == ""):
            missingParameter("--module")
            errorFlag = "true"
        else:
            moduleName = findModuleName(_appname, _module)
            if (moduleName == None):
                print "ERROR: The module '"+_module+"' does not exist in application "+_appname+"."
                errorOperationExit("")
            moduleLocation = moduleName
        
    if (errorFlag == "true"):
        errorOperationExit("")
    
    #Get protocol if not specified
    aProtocol = _protocol
    if (aProtocol == ""):
        wc = getWorkClassByType()
        aProtocol = getProtocolFromWorkClassType(AdminConfig.showAttribute(wc, "type"))

    
    validateMemberFormat(aProtocol)    
    wc = getWorkClassByType()
              
    if (wc != ""):
       aProtocol = getProtocolFromWorkClassType(AdminConfig.showAttribute(wc, "type"))
       
       if (aProtocol == "JMS" and _ejbname != "" and _wctype == "ASP"):
           alteredMembers = alterMemberHelper(_ejbname, _members)
       else:
           alteredMembers = _members
       
       memberList = alteredMembers.split("?")                
       newMemberList=""
       
       wcmList = AdminConfig.showAttribute(wc, "workClassModules").replace("[","").replace("]","").split(" ")
       for wcm in wcmList:
           if (wcm == ""):
               break

           if (moduleLocation == AdminConfig.showAttribute(wcm, "moduleName")):
               wcmMembers = AdminConfig.showAttribute(wcm,"matchExpression").split(",")
               
               for aMemberToRemove in memberList:
                   if (aProtocol == "HTTP" and aMemberToRemove[0] != '/'):
                       aMemberToRemove = "/"+aMemberToRemove

                   if (aMemberToRemove in wcmMembers):
                       wcmMembers.remove(aMemberToRemove)
                       print "INFO: "+aMemberToRemove+" removed from "+_wcname+" membership."
                   else:
                       errorOperationExit("member '"+aMemberToRemove+"' does not exist in workclass "+_wcname+".")
                   
               for wcmMember in wcmMembers:
                   if (newMemberList == ""):
                       newMemberList = wcmMember
                   else:
                       newMemberList = newMemberList+","+wcmMember

               print "INFO: new module membership is: ", newMemberList
               AdminConfig.modify(wcm,[["matchExpression", newMemberList]])
    else:
        errorOperationExit("the work class, '" + _wcname + "', was not found.")
        
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""
            
def printRemoveMembersHelp():
    print """
     removeMembers [options]
   
      Removes work class members to the work class specified.  The member will no longer
      be used by the ODR.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --protocol    protocol of work class created (HTTP | IIOP | JMS | SOAP)
      --wcname      type unique name for the work class
      --module      application module to associate members
      --members     Protocol specific pattern
                    HTTP = "/test1?/test2/*"
                    IIOP = "<ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>"
                    SOAP = "<webService>:<operationName>?<webSerivce>:<operationName>"
                    JMS  = "<bus>:<destination>?<bus>:<destination>"
 
 
      examples:
       Remove members "/test1" and "/test2/*" in module myWebModule to a HTTP application routing policy work class for application Trade:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeMembers --type ARP --wcname CustomWorkClass --protocol HTTP --appname Trade --module myWebModule.war --member "/test1?/test2/*"
       Remove members "bus1:destination1" and "bus2:destination2" in module myModule to a JMS application service policy work class for application edition Trade-edition1.0:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeMembers --type ASP --wcname CustomWorkClass --protocol JMS --appname Trade-edition1.0 --module myModule.war --member "bus1:destination1?bus2:destination2"
       Remove members "/test3" and "/test4" to a HTTP generic server routing policy work class in odr myODR on node myNode:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeMembers --type GRP --wcname CustomWorkClass --protocol HTTP --odrname myODr --nodename myNode --member "/test3?/test4"
   
   """ 

#=======================================================================================================================================================
#
# listMembers description:
#
#    listMembers [options]
#  
#     Lists all work class members of the work class specified.
#
#     options:
#     --type        [see common options]
#     --appname     [see common options]
#     --odrname     [see common options]
#     --protocol    protocol of work class created (HTTP | IIOP | JMS | SOAP)
#     --wcname      unique name for the work class within type
#
#
#     examples:
#      List all members in a specific work class:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py listMembers --wcname CustomWorkClass --type ASP --appname A
#      List all members in a specific work class:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py listMembers --wcname CustomWorkClass --type GRP --odrname myODR --nodename odrNodeName
#
#=======================================================================================================================================================
def listMembers():
    print ""
    print "*********************************List Members*******************************"    
    global _nodename

    #Check for common required parameters.
    errorFlag = "false"
    if _appname == "":
        if (_odrname == ""):
            missingParameter("--appname or --odrname")
            errorFlag = "true"
        else:
            if (_nodename == ""):
              _nodename = getProxyNode(_odrname)
               
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"    
       
    if (errorFlag == "true"):
        errorOperationExit("")

    wc = getWorkClassByType()

    count = 0
    if (wc != None):
        moduleList = AdminConfig.showAttribute(wc, "workClassModules").replace("[","").replace("]","").split(" ")        
        for module in moduleList:
            if (module == ""):
                break
            moduleNames = AdminConfig.showAttribute(module,"id").split(":!:")
            moduleMembers = AdminConfig.showAttribute(module,"matchExpression").split(",")
            print "Members for "+_wctype+" work class '"+_wcname+"':"
            for moduleMember in moduleMembers:
                if (moduleMember == ""):
                    break
                
                if (_wctype[0] == "A"):
                    aProtocol = getProtocolFromWorkClassType(AdminConfig.showAttribute(wc, "type"))
                    if (aProtocol == "HTTP"):
                        if (moduleMember[0] != '/'):
                            separator = "/"
                        else:
                            separator = ""
                        print "/" +_appname +separator +moduleMember+" ("+moduleNames[2]+")"
                    else:
                        print moduleMember+" ("+moduleNames[2]+")"
                else:
                    print moduleMember+" ("+moduleNames[1]+" / "+moduleNames[2]+")"
                count = count+1
                    
    print ""
    print "INFO:",count,"member(s) found."
    print "INFO: finished."
    print "***************************************************************************"
  
def printListMembersHelp():
    print """
     listMembers [options]
   
      Lists all the work class members of the work class specified.
 
      options:
      --type        [see common options]
      --appname     [see common options]
      --odrname     [see common options]
      --protocol    protocol of work class created (HTTP | IIOP | JMS | SOAP)
      --wcname      unique name for the work class within typ
  

      examples:
       List all members in a specific work class:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py listMembers --wcname CustomWorkClass --type ASP --appname A
       List all members in a specific work class:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py listMembers --wcname CustomWorkClass --type GRP --odrname myODR
   
   """       
   
#=======================================================================================================================================================
#
# addRules description:
#
#    addRules [options]
#  
#     Adds a classification rule to the work class specified.  The rule will
#     be used by the ODR.  If issuing a command with the like wildcard '%' on a Unix base operating 
#     system, the escape sequence (\%%) should be replaced by (\%).
#
#
#     options:
#     --type     [see common options]
#     --appname  [see common options]
#     --odrname  [see common options]
#     --nodename [see common options]
#     --wcname   name of new work class
#     --rule     a classification rule in the format "priority?rule?action"
#
#     examples:
#      Adds classification rules to the application routing policy work class:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py addRules --wcname CustomWorkClass --appname A --type ARP --rule "1?clienthost=\'localhost\' and serverhost like \'\%%.ibm.com\'?permit?A"
#
#
#=======================================================================================================================================================
def addRules():
    print ""
    print "**********************************Add Rules*********************************"
    global _nodename

    #Check for common required parameters.
    errorFlag = "false"
    if (isSystemApp == 1):
        errorOperationExit("--systemapp is not supported with addRules option.")        
    if _appname == "":
        if (_odrname == ""):
            missingParameter("--appname or --odrname")
            errorFlag = "true"
        else:
            if (_nodename == ""):
               _nodename = getProxyNode(_odrname)
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
    if (_rules[0] == None):        
        missingParameter("--rule")
        errorFlag = "true"
        
    if (errorFlag == "true"):
        errorOperationExit("")        
        
    try:
        if (_appname != ""):
            if (_wctype == "ASP"):
                addAppSLARule(_wcname, _appname, _rules)
            elif (_wctype == "ARP"):
                addAppRoutingRule(_wcname, _appname, _rules)
            else:
                errorOperationExit("only specify application name when using ASP or ARP work classes.")                        
        elif (_odrname != "" and _nodename != ""):
            if (_wctype == "GSP"):
                addGSCSLARule(_wcname, _nodename,_odrname, _rules)
            elif (_wctype == "GRP"):
                addGSCRoutingRule(_wcname,_nodename, _odrname, _rules)
            else:
                errorOperationExit("only specify application name when using GSP or GRP work classes.")
    except NameError, detail:
        print detail
        errorOperationExit("")
                    
    #for member in members:
    #    print "INFO: "+member+" added to "+_wcname+" membership."
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""            
            
def printAddRuleHelp():
    print """
  addRule description:
 
     addRule [options]
   
      Adds a classification rule to the work class specified.  The rule will
      be used by the ODR.  If issuing a command with the like wildcard '%' on 
      a Unix base operating system, the escape sequence (\%%) should be 
      replaced by (\%).
 
 
      options:
      --type     [see common options]
      --appname  [see common options]
      --odrname  [see common options]
      --nodename [see common options]
      --wcname   name of new work class
      --rule     a classification rule in the format "priority?rule?action"
 
      examples:
       Adds a classification rule to the application service policy work class:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py addRules --wcname CustomWorkClass --appname A --type ARP --rule "1?clienthost=\'localhost\' and serverhost like \'\%%.ibm.com\'?permit?A"
   
   """    
   
#=======================================================================================================================================================
#
# removeRule description:
#
#    removeRule [options]
#  
#     Removes a classification rule from the work class specified.  The rule will
#     be used by the ODR.  If issuing a command with the like wildcard '%' on a Unix base operating 
#     system, the escape sequence (\%%) should be replaced by (\%).
#
#
#     options:
#     --type         [see common options]
#     --appname      [see common options]
#     --odrname      [see common options]
#     --wcname       name of work class
#     --expression   rule expression
#     --priority     priority of rule to match (lowest is matched first)
#
#     examples:
#      Removes a classification rule by priority from the application service policy work class:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeRule --wcname CustomWorkClass --appname A --type ARP --priority 1
#      Removes a classification rule by the rule definition from the application service policy work class:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py removeRule --wcname CustomWorkClass --appname A --type ARP --expression "clienthost=\'localhost\' and serverhost like \'\%%.ibm.com\'" 
#
#=============================================================================================================   
def removeRule():
    print ""
    print "*********************************Remove Rules*******************************"    
    global _nodename

    #Check for common required parameters.
    errorFlag = "false"
    if _appname == "":
        if (_odrname == ""):

            missingParameter("--appname or --odrname")
            errorFlag = "true"
        else:
            if (_nodename == ""):
              _nodename = getProxyNode(_odrname)
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
    if (_priority == "" and _expression == ""):
        missingParameter("--priority or --expression")
        errorFlag = "true"
        
    if (errorFlag == "true"):
        errorOperationExit("")
    
    wc = getWorkClassByType()        
    removeRuleFromWorkClass(wc) 
    
    print "INFO: saving changes..."
    AdminConfig.save()
    print "INFO: finished." 
    print "****************************************************************************"
    print ""
            
def printRemoveRuleHelp():
    print """
     removeRule [options]
   
      Removes a classification rule to the work class specified.  The rule will
      be used by the ODR.  If issuing a command with the like wildcard '%' on a
      Unix base operating system, the escape sequence (\%%) should be 
      replaced by (\%).
 
 
      options:
      --type     [see common options]
      --appname  [see common options]
      --odrname  [see common options]
      --wcname   name of work class
      --expression   rule expression
      --priority     priority of rule to match (lowest is matched first)
 
      examples:
       Removes a classification rule by priority from the application service policy work class:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeRule --wcname CustomWorkClass --appname A --type ARP --priority 1
       Removes a classification rule by the rule definition from the application service policy work class:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py removeRule --wcname CustomWorkClass --appname A --type ARP --expression "clienthost=\'localhost\' and serverhost like \'\%%.ibm.com\'" 
   
   """    
   
#=======================================================================================================================================================
#
# listRules description:
#
#    listRules [options]
#  
#     List the classification rules by specified filters.
#
#
#     options:
#     --type     [see common options]
#     --appname  [see common options]
#     --odrname  [see common options]
#     --wcname   name of work class
#
#     examples:
#      Lists classification rules for a specific work class:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py listRules --wcname CustomWorkClass --type ASP --appname A
#      Lists classification rules for a specific work class that is generic server routing policy type:
#       >> ./wsadmin.sh -lang jython -f workclassoperations.py listRules --wcname customWorkClass --type GSP --odrname myODR
#
#=============================================================================================================
def listRules():
    print ""
    print "**********************************List Rules********************************"
    
    #Check for common required parameters.
    errorFlag = "false"
    if _appname == "":
        if (_odrname == ""):
            missingParameter("--appname or --odrname")
            errorFlag = "true"
    if (_wctype == ""):
        missingParameter("--type")
        errorFlag = "true"
    if (_wcname == ""):
        missingParameter("--wcname")
        errorFlag = "true"
        
    if (errorFlag == "true"):
        errorOperationExit("")    
            
    print "INFO: Rule syntax"
    print "INFO: priority(<priority>) expression(<expression) action(<action>)"
    print "****************************************************************************"
                
    wc = getWorkClassByType()
    displayRules(wc)
  
    print "INFO: finished."
    print "***************************************************************************"
  
def printListRulesHelp():
    print """
     listRules [options]
   
      List the classification rules by specified filters.
 
 
      options:
      --type     [see common options]
      --appname  [see common options]
      --odrname  [see common options]
      --wcname   name of work class
 
      examples:
       Lists classification rules for a specific work class:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py listRules --wcname CustomWorkClass --type ASP --appname A
       Lists classification rules for a specific work class that is generic server routing policy type:
        >> ./wsadmin.sh -lang jython -f workclassoperations.py listRules --wcname customWorkClass --type GSP --odrname myODR
   
   """       

  
####   
#   
# workclassoperations.py helper methods  
#   
####    
def getWorkClassByType():    
    wc = None
    
    try:
        if (_appname != ""):     
            if (isSystemApp == 1):                    
                appname = findSystemApplication(_appname)
                if (appname == None):
                    print "ERROR: The system application '"+_appname+"' does not exist."
                    errorOperationExit("")
                                    
                if (_wctype == "ASP"):
                    wc = findSystemAppSLAWorkClass(_wcname,_appname)
                elif (_wctype == "ARP"):
                    wc = findSystemAppRoutingWorkClass(_wcname,_appname)
                else:
                    errorOperationExit("only types ASP and ARP are allowed with system applications.")        
            else:
                if (_wctype == "ARP"):
                    wc=findAppRoutingWorkClass(_wcname, _appname)
                elif (_wctype == "ASP"):
                    wc=findAppSLAWorkClass(_wcname, _appname)
                else:
                    errorOperationExit("only specify application name when using ASP or ARP work classes.")
        elif (_odrname != "" and _nodename != ""):
            odrname = findProxyServer(_nodename,_odrname)
            if (odrname == None):
                print "ERROR: The ODR '"+_odrname+"' does not exist in this WAS deployment."
                errorOperationExit("")
                                
            if (_wctype == "GSP"):
                wc=findWorkClass(_wcname,"sla",_nodename,_odrname)
            elif (_wctype == "GRP"):
                wc=findWorkClass(_wcname,"routing", _nodename,_odrname)
            else:
                errorOperationExit("only specify application name when using GSP or GRP work classes.")
    except NameError, detail:
        print detail
        errorOperationExit("")

    if (wc == None):
        errorOperationExit(_wctype+" work class '"+_wcname+"' does not exist.")
    return wc


def getProtocolFromWorkClassType(aProtocol):
    if (aProtocol == "SOAPWORKCLASS"):
        return "SOAP"
    elif (aProtocol == "IIOPWORKCLASS"):
        return "IIOP"
    elif (aProtocol == "JMSWORKCLASS"):
        return "JMS"
    else:
        return "HTTP"
 
    
def setProtocolForWorkClass():
   if (_protocol == "SOAP"):
      protocolType = "SOAPWORKCLASS"
   elif (_protocol == "IIOP"):
      protocolType = "IIOPWORKCLASS"
   elif (_protocol == "JMS"):
      protocolType = "JMSWORKCLASS"
   else:
      protocolType = "HTTPWORKCLASS"
   return protocolType 


def displayRules(wcId):
   count = 0
   mAction=""
   mExpr=""
   rList = AdminConfig.showAttribute(wcId,"matchRules").replace("[","").replace("]","").split(" ")
   dAction = AdminConfig.showAttribute(wcId,"matchAction")
   #print "Len of rList is %i" %(len(rList))
   for aRule in rList:
     try:
       mPriority=AdminConfig.showAttribute(aRule,"priority")
       mAction=AdminConfig.showAttribute(aRule,"matchAction")
       mExpr=AdminConfig.showAttribute(aRule,"matchExpression")
     except:
         print "WARNING: problem in getting rule data."
     if (mExpr != "" and mAction != ""):
         count = count+1
         print "INFO: priority("+mPriority+") expression("+mExpr + ") action("+mAction+")"

   print ""
   print "INFO:",count,"rule(s) found."
           
 
def isMatchOverlapping(aMatch, aProtocol):
    patternOverlaps = ""
    
    if (_wctype == "ARP" or _wctype == "ASP"):    
        if (_wctype == "ARP"):
            patternOverlaps = getAppRoutingWorkClassesURIs(aProtocol)
        elif (_wctype == "ASP"):
            patternOverlaps = getAppSLAWorkClassesURIs(aProtocol)

        patternOverlaps = patternOverlaps.split(",")
        
        module = _module.split(".")
        for pattern in patternOverlaps:
            if (pattern == aMatch+" ("+module[0]+")"):
                return "true"
            
    if (_wctype == "GRP" or _wctype == "GSP"):
        if (_wctype == "GRP"):
            patternOverlaps = getGSCWorkClassesURIs("routing")
        elif (_wctype == "GSP"):
            patternOverlaps = getGSCWorkClassesURIs("sla")
        
        patternOverlaps = patternOverlaps.split(",")
        
        for pattern in patternOverlaps:
            if (pattern == "*" and "/"+pattern == aMatch):
                return "true"
            if (pattern == aMatch):
                return "true"
    
    return "false"
 
      
def getAppRoutingWorkClassesURIs(aProtocol):
   wcNames=AdminConfig.list("WorkClass").split("\n")
   
   if (aProtocol == ""):
      wc = getWorkClassByType()
      aProtocol = getProtocolFromWorkClassType(AdminConfig.showAttribute(wc, "type"))
   
   wcURIs = ""
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          if (checkForReservedWC(wcName) == 0):
              appName = _appname.split("-edition")[0]  
              mwApp = AdminConfig.getid("/MiddlewareApp:" + _appname + "/")
              if (mwApp != ""):
                 appName = _appname

              if (aProtocol == getProtocolFromWorkClassType(AdminConfig.showAttribute(wcName, "type"))):
                  if ((wcName.find(appName+".ear") > 0 and wcName.find("odr") == -1 and wcName.find("deployments") == -1) or (wcName.find(appName) > 0 and wcName.find("odr") == -1 and wcName.find("middlewareappeditions") == -1)):
                     wcmList = AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")
    
                     for wcm in wcmList: 
                        if (wcm == ""):
                           break                   
                        wcmId = wcm
                        wcmName = AdminConfig.showAttribute(wcmId, "moduleName")
                        uris = AdminConfig.showAttribute(wcmId, "matchExpression")
                        uris = uris.split(",")
                        wcmName = wcmName.split(".")[0]
                        
                        for uri in uris:
                           if (wcURIs == ""):
                              wcURIs = uri+" ("+wcmName+")"
                           else:
                              wcURIs = wcURIs+","+uri+" ("+wcmName+")"
   return wcURIs 
  
 
def getAppSLAWorkClassesURIs(aProtocol):
   deploymentID = findDeployment(_appname)
   wcNames = AdminConfig.list("WorkClass", deploymentID).split("\n")
   
   if (aProtocol == ""):
      wc = getWorkClassByType()
      aProtocol = getProtocolFromWorkClassType(AdminConfig.showAttribute(wc, "type"))
   
   wcURIs = ""
   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 ):
          if (checkForReservedWC(wcName) == 0):
              if (aProtocol == getProtocolFromWorkClassType(AdminConfig.showAttribute(wcName, "type"))):
                  mwApp = AdminConfig.getid("/MiddlewareApp:" + _appname + "/")
                  if (mwApp == ""):
                     if ((wcName.find("/"+_appname+"/") > 0 and wcName.find("deployments") > 0) or (wcName.find("/"+_appname+"/") > 0 and wcName.find("middlewareappeditions") > 0)):
                        wcmList = AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")
                        for wcm in wcmList: 
                           if (wcm == ""):
                              break                   
                           wcmId = wcm
                           wcmName = AdminConfig.showAttribute(wcmId, "moduleName")
                           uris = AdminConfig.showAttribute(wcmId, "matchExpression")
                           uris = uris.split(",")
                           wcmName = wcmName.split(".")[0]
                        
                           for uri in uris:
                              if (wcURIs == ""):
                                 wcURIs = uri+" ("+wcmName+")"
                              else:
                                  wcURIs = wcURIs+","+uri+" ("+wcmName+")" 

   return wcURIs  
 

def getGSCWorkClassesURIs(aPolicyType):
   wcNames=AdminConfig.list("WorkClass").split("\n")
   wcURIs = ""

   for wcName in wcNames:
       wcName=wcName.rstrip()
       if (len(wcName) > 0 and wcName.find(aPolicyType) > 0 and wcName.find(_odrname) > 0):
             wcmList = AdminConfig.showAttribute(wcName, "workClassModules").replace("[","").replace("]","").split(" ")
             for wcm in wcmList: 
                if (wcm == ""):
                   break              
                wcmId = wcm
                wcmName = AdminConfig.showAttribute(wcmId, "moduleName")
                uris = AdminConfig.showAttribute(wcmId, "matchExpression")
                uris = uris.split(",")
                wcmName = wcmName.split(".")[0]
                
                for uri in uris:
                   if (wcURIs == ""):
                       wcURIs = uri
                   else:
                       wcURIs = wcURIs+","+uri
   
   return wcURIs 

                        
def removeRuleFromWorkClass(anId):
     isRuleFound = 0
     ruleList = AdminConfig.showAttribute(anId,"matchRules").replace("[","").replace("]","").split(" ")     
     if (_priority != ""):
         if len(ruleList) > 0:
             for rule in ruleList:
                 if len(rule) > 0:
                     rulePriority = AdminConfig.showAttribute(rule,"priority")
                     if (_priority == rulePriority):
                         AdminConfig.remove(rule)
                         print "INFO: Rule with priority " + _priority + " has been deleted from "+_wctype+" work class " +_wcname
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
                         print "INFO: Rule " + _expression + " has been deleted from "+_wctype+" work class " +_wcname
                         isRuleFound = 1                         
                         break

     if (isRuleFound == 0):
         if (_priority != ""):
             errorOperationExit("rule with priority '" + _priority + "' does not exist in "+_wctype+" work class " +_wcname+".")
         else:
             errorOperationExit("rule " + _expression + " does not exist in "+_wctype+" work class " +_wcname+".")

                  
def validateMembership(aProtocol):
    if (_members != ""):
        for match in _members.split("?"):
            if (isMatchOverlapping(match, aProtocol) == "true"):
                if (_wctype.startswith("A") > 0):
                    invalidCommandExit("the match pattern '"+match+"' has already been mapped to this Application/Module.")
                if (_wctype.startswith("G") > 0):
                    invalidCommandExit("the match pattern '"+match+"' has already been mapped to odr '"+_odrname+"'.")

def validateMemberFormat(aProtocol):
    #Validate members
    if (aProtocol != "HTTP"):
        if (_members != ""):
            #matchExpression is not empty so validate
            matchExpression = ""
            valid = "false"
            for match in _members.split("?"):
                matchExpression = match
                name = matchExpression.split(":")
                if len(name) == 2:
                    valid = "true"
                else:
                    valid = "false"
                    if (aProtocol == "SOAP" and match == "*"):
                        valid = "true"
        else:
            #empty matchExpression is valid
            valid = "true"
        
        if valid == "false":
            exampleURIs = "";
            if (aProtocol == "SOAP"):
                exampleURIs = "<webService>:<operationName>?<webSerivce>:<operationName>"
            elif (aProtocol == "IIOP"):
                exampleURIs = "<ejbName>:<ejbMethod>?<ejbName>:<ejbMethod>"
            else:
                exampleURIs = "<bus>:<destination>?<bus>:<destination>"            
            invalidCommandExit(aProtocol+" work classes require the following format '"+exampleURIs+"' .")

def validateExpression(anExpr):
    validateExpression(anExpr, _protocol)
        
def normalExit():
    java.lang.System.exit(0)
 
def errorExit():
    java.lang.System.exit(1)
 
def invalidCommandExit(aMessage):
    print ""
    print "*******************************Invalid Command******************************"
    print "WARNING: "+aMessage
    print "WARNING: no changes have been saved. Goodbye."
    print "********************************Unsuccessful********************************"    
    print ""
    errorExit()
    
def invalidOperationExit(aMessage):
    print ""
    print "******************************Invalid Operation*****************************"
    print "WARNING: "+aMessage
    print """
  Supported Operations:    
    listWorkClasses [options]
    createWorkClass [options]
    removeWorkClass [options]
    addMembers [options]
    removeMembers [options]
    listMembers [options]
    addRules [options]
    removeRule [options]
    listRules [options]
    modifyDefaultAction [options]
    getDefaultAction [options]
    modifyVirtualHost [options]
    getVirtualHost [options]
    """    
    print "WARNING: no changes have been saved. Goodbye."
    print "********************************Unsuccessful********************************"    
    print ""
    errorExit()
    
def errorOperationExit(aMessage):
    if (aMessage != ""):
        print "WARNING: "+aMessage
    print "WARNING: no changes have been saved. Goodbye."
    print "********************************Unsuccessful********************************"    
    print ""
    errorExit()
    
def missingParameter(aParameter):
    print "WARNING: missing parameter "+aParameter+"."
 
def showRemoveWCHelp():
    print """
        DESCRIPTION
        This command option is used to remove an existing application work class. 
        
        Usage: wsadmin 
                      [-lang jython]
                      [-f workclassoperations.py]
                      [-wctype ARP|ASP|GRP|GSP]
                      [-odrname odrName] 
                      [-wcname workClassName]
                      [-appname applName]
                      [-deletewc]
                      [-systemapp]
                      
        COMMAND LINE OPTIONS
          -appname appName is used to specify the name of the enterprise application without the .ear extension. This option is required if deleting enterprise application work class.
          -deletewc is the operation to be performed, deletes the specified work class.
          -odrname odrName is used to specify the name of your On Demand Router (ODR) proxy server. This option is required if deleting generic server cluster work class. 
          -systemapp is used to indicate whether the application specified is a system application.
          -wcname workClassName is used to specify the name of the workclass, no spaces are allowed in the work class name. This option is required.
          -wctype takes a constant value of either ARP for enterprise application routing policy work class, ASP for enterprise application service policy work class, GRP for generic server cluster routing policy work class, or GSP for generic server cluster service policy work class. There is no default, so a value must be specified.
        
        EXAMPLES
        Example 1, wsadmin -lang jython -f workclassoperations.py -deletewc -wctype GSP -odrname ODR -wcname CustomWorkClass
        The example above is used to remove a work class named CustomWorkClass for a service policy in the generic server cluster identified through the ODR name.
        
        Example 2, wsadmin -lang jython -f workclassoperations.py -deletewc -wctype ARP -appname A -wcname CustomWorkClass
        The example above is used to remove a work class named CustomWorkClass for a routing policy in the enterprise application called A.

    """
    java.lang.System.exit(1)      
    
    
def printHelp(): 
    print """   
  DESCRIPTION
      This command is used to create or update work classes for a deployed application and/or generic server cluster, list rules in a work class, get default action defined in a work class, delete rule in a work class, add URI to a work class web module, modify URIs, list URIs, or remove work classes. 
      Each invocation can only create one work class; either for routing policy or for service policy. To create a set of work classes for enterprise application and generic server cluster, the command must be executed at least twice. While some options like -wctype and -wcname are required for all command invocations, others are required based on the combination of options and the intended operation. The examples below will aid you in knowing the required options for each operation.
      In general, when the command usage is displayed because of incorrect or incomplete input options, the cause of failure will be printed on top of the usage message, so scroll up to find out specific error messages. Also, in the examples, certain characters have been escaped to prevent the command-line processor from interpreting them as special charaters. In such cases, there may be variations based on the operating system. For example, on Windows, to escape the percent sign (%), the character sequence (\%%) is used while on Unix type operating systems, to escape the percent sign, the escape sequence is (\%).    
 
  For General Help:
   >> ./wsadmin.sh -lang jython -f workclassoperations.py
  For Operation Specific Help:
   >> ./wsadmin.sh -lang jython -f workclassoperations.py <operation> --help
  
  Supported Operations:
    listWorkClasses [options]
    createWorkClass [options]
    removeWorkClass [options]
    addMembers [options]
    removeMembers [options]
    listMembers [options]
    addRule [options]
    removeRule [options]
    listRules [options]
    modifyDefaultAction [options]
    getDefaultAction [options]
    modifyVirtualHost [options]
    getVirtualHost [options]
  
  Common options:
    --type        type of work class to create
                  ASP = application service policy
                  ARP = application routing policy
                  GSP = generic server service policy
                  GRP = generic serverrouting policy
    --appname     optional name of application
                  [required-if] the --type parameter is specified as ASP or ARP
    --odrname     optional name of odr
                  [required-if] the --type parameter is specified as GSP or GRP
    --nodename    optional name of node
                  [required-if] the --type parameter is specified as GSP or GRP    
     """
    errorExit()
    

def processArguments():
    global _odrname,_wcname,_nodename,isSystemApp,wasinstallroot
    global _wctype, _wcaction, _protocol, _members, _appname, _module, _ejbname, _rules
    global _virtualhost, _priority, _expression, _serviceClass
    
    isSystemApp=0
    _protocol=""
    _odrname=""
    _wcname=""
    _nodename=""
    _virtualhost=""
    _appname=""
    _module=""
    _wctype=""
    _wcaction=""
    _members=""
    _ejbname=""
    _priority=""
    _expression=""
    _serviceClass=""
    count=0
    _rules=jarray.zeros(9,java.lang.String)

    #========================================================================================
    # Load parameter list
    #
    #========================================================================================
    for i in range(1,len(sys.argv),1): 
      option = sys.argv[i]
      if (option == "--odrname"):
          _odrname = sys.argv[i+1].rstrip()
          #print "INFO: ODR name = "+_odrname
      elif (option == "--nodename"):
          _nodename = sys.argv[i+1].rstrip()
          #print "INFO: node name = "+_nodename
      elif (option == "--wcname"):
          _wcname = sys.argv[i+1].rstrip()
          #print "INFO: work class name = "+_wcname      
      elif (option == "--ejbname"):
          _ejbname = sys.argv[i+1].rstrip()      
          #print "INFO: ejb name = "+_ejbname            
      elif (option == "--systemapp"):
          isSystemApp = 1
          #print "INFO: system application flagged"
      elif (option == "--protocol"):
          _protocol = sys.argv[i+1].rstrip()
          if (_protocol != "HTTP" and _protocol != "SOAP" and _protocol != "IIOP" and _protocol != "JMS"):
              invalidCommandExit("--type must be HTTP, SOAP, IIOP or JMS.")
          #print "INFO: protocol type = "+_protocol
      elif (option == "--virtualhost"):
          _virtualhost = sys.argv[i+1].rstrip()
          #print "INFO: virtual host = "+_virtualhost
      elif (option == "--appname" ):
          _appname = sys.argv[i+1].rstrip()
          #print "INFO: application name = "+_appname
      elif (option == "--module"):
          _module = sys.argv[i+1].rstrip()
          tempModule = _module.split(".")
          #if (len(tempModule) <= 1):
          #    invalidCommandExit("extension is missing. For example, try '"+_module+".jar' .")
          #print "INFO: name of module = "+_module
      elif (option == "--wcaction"):
          _wcaction = sys.argv[i+1].rstrip()
          #print "INFO: default action = "+_wcaction
      elif (option == "--members"):
          _members = sys.argv[i+1].rstrip()
          #print "INFO: members = "+_members
      elif (option == "--priority"):
          _priority = sys.argv[i+1].rstrip()
          #print "INFO: virtual host = "+_priority
      elif (option == "--expression"):
          _expression = sys.argv[i+1].rstrip()
          #print "INFO: virtual host = "+_expression
      elif (option == "--spname"):
          _serviceClass = sys.argv[i+1].rstrip()
          #print "INFO: virtual host = "+_serviceClass        
      elif (option == "--rule"):
          _rules[count] = sys.argv[i+1].rstrip().replace("\\","")
          if (len(_rules[count].split("?")) < 3):
              invalidCommandExit("--rule specified is invalid. Expected format: \"priority?expression?action\".")
          count = count + 1
      elif (option == "--type"):
          _wctype = sys.argv[i+1].rstrip()
          if (_wctype != "ASP" and _wctype != "ARP" and _wctype != "GSP" and _wctype != "GRP"):
              invalidCommandExit("--type must be ASP, ARP, GSP or GRP")
      elif (option.startswith("--") > 0):
          invalidCommandExit(option+" is not a supported option.")

    #
    # Find out what the caller is trying to do and check to make
    # sure they've got the correct options to do what they want
    #

    #TODO -- move this to validateProtocol method
    cellName = AdminConfig.showAttribute(AdminConfig.list("Cell"),"name")    
    if (_protocol == "IIOP" or _protocol == "JMS"):
        if (ApplicationUtil.isAppDeployedOnZOS(_appname, cellName)):
            invalidCommandExit(_protocol+" work classes are not supported on this platform at this time.")
        
        if (_wctype != "ASP"):
            invalidCommandExit(_protocol+" work classes of "+_wctype+" type are not supported at this time.")

    if (_protocol == "SOAP" and _wctype.startswith("G") > 0):
        invalidCommandExit(_protocol+" work classes of "+_wctype+" type are not supported at this time.")
        
    if (_protocol == "JMS"):
        if (ApplicationUtil.isEJBModule(_appname, _module, cellName)):
            if (_ejbname == ""):
                invalidCommandExit("when specifying an ejb module for a JMS workclass please specify an EJB with the -ejbName parameter.") 
        else:
            if (not(_ejbname == "")):
                invalidCommandExit("the --ejbname parameter is reserved for JMS work classes and ejb jar modules.")
    
#=======================================================================================================================================================
#
# Main workclassoperations.py execution logic:
#
#=======================================================================================================================================================
wasinstallroot=System.getProperty("was.install.root")
execfile(wasinstallroot+"/bin/IMPPYModules.py")    

if(len(sys.argv) > 0):
  option = sys.argv[0]
  help = 0
  if (len(sys.argv) > 1):
     if (sys.argv[1] == "--help"):
        help = 1
  if not help:
      processArguments()
    
  if (option == 'listWorkClasses'):
    if (help == 1):
      printListWorkClassesHelp()
    else:
      sys.exit(listWorkClasses01())
  elif (option == 'createWorkClass'):
    if (help == 1):
      printCreateWorkClassHelp()
    else:
      sys.exit(createWorkClass())
  elif (option == 'removeWorkClass'):
    if (help == 1):
      printRemoveWorkClassHelp()
    else:
      sys.exit(removeWC())
  elif (option == 'addMembers'):
    if (help == 1):
      printAddMembersHelp()
    else:
      sys.exit(addMembers())
  elif (option == 'removeMembers'):
    if (help == 1):
      printRemoveMembersHelp()
    else:
      sys.exit(removeMembers())
  elif (option == 'listMembers'):
    if (help == 1):
      printListMembersHelp()
    else:
      sys.exit(listMembers())
  elif (option == 'addRules'):
    if (help == 1):
      printAddRuleHelp()
    else:
      sys.exit(addRules())                    
  elif (option == 'removeRule'):
    if (help == 1):
      printRemoveRuleHelp()
    else:
      sys.exit(removeRule())
  elif (option == 'listRules'):
    if (help == 1):
      printListRulesHelp()
    else:
      sys.exit(listRules())                  
  elif (option == 'modifyDefaultAction'):
    if (help == 1):
      printModifyDefaultActionHelp()
    else:
      sys.exit(modifyDefaultAction())                  
  elif (option == 'getDefaultAction'):
    if (help == 1):
      printGetDefaultActionHelp()
    else:
      sys.exit(getDefaultAction())  
  elif (option == 'modifyVirtualHost'):
    if (help == 1):
      printModifyVirtualHostHelp()
    else:
      sys.exit(modifyVirtualHost())              
  elif (option == 'getVirtualHost'):
    if (help == 1):
      printGetVirtualHostHelp()
    else:
      sys.exit(getVirtualHost())      
  else:      
    printHelp()
else:
  printHelp()
