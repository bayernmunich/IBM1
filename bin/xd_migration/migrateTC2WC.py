#=======================================================================================================================================================
#(C) Copyright IBM Corp. 2004,2005 - All Rights Reserved.
#DISCLAIMER:
#The following source code is sample code created by IBM Corporation.
#This sample code is provided to you solely for the purpose of assisting you 
#in the  use of  the product. The code is provided 'AS IS', without warranty or 
#condition of any kind. IBM shall not be liable for any damages arising out of your
#use of the sample code, even if IBM has been advised of the possibility of
#such damages.
#=======================================================================================================================================================

#=======================================================================================================================================================
# This file contains a series of operations to help automate the administration of migrating mapped uris in
# transaction classes to HTTP type work classes.
#
# For General Help:
#     >> ./wsadmin.sh -lang jython -f migrateTC2WC.py
# For Operation Specific Help:
#     >> ./wsadmin.sh -lang jython -f migrateTC2WC.py <operation> --help
# 
# Supported Operations:
#   list51TransactionClasses
#   migrate51TransactionClass [options]
#   migrateAll51TransactionClasses
#   
# Author: Michael Smith miksmith@us.ibm.com
# 
# Change History
# --------------
# 04-22-2005 initial version created
#=======================================================================================================================================================

import sys

#=======================================================================================================================================================
#
# list51TransactionClasses description:
#
#    list51TransactionClasses
#  
#       Lists all XD 5.1 transaction classes that have mapped URIs within the cell.
#  
#       Examples:
#         >> ./wsadmin.sh -lang jython -f migrateTC2WC.py list51TransactionClasses
#
#=======================================================================================================================================================
def list51TransactionClasses():
  # finished processing parameters, now create the work class  
  print "INFO: Listing XD 5.1 Transaction Classes ..."
  tcids = AdminConfig.list("TransactionClass")
  tcList = tcids.split("\n")

  for tc in tcList:
    tc = tc.rstrip()
    tcm_ids = AdminConfig.showAttribute(tc, "TransactionClassModules")

    if len(tcm_ids) > 2:                        
        tcname = AdminConfig.showAttribute(tc, "name")
        print tcname

  print "INFO: XD 5.1 Transaction Classes successfully listed."
  return 0

def printList51TransactionClassesHelp():
  print """
    list51TransactionClasses
  
       Lists all XD 5.1 transaction classes that have mapped URIs within the cell.
  
       Examples:
         >> ./wsadmin.sh -lang jython -f migrateTC2WC.py list51TransactionClasses
   
   """

#=======================================================================================================================================================
#
# migrate51TransactionClass description:
#
#    migrate51TransactionClass [options]
#  
#      Migrates the specified 5.1 Transaction Class to HTTP type work class(es).
#      In XD 5.1, Transaction Classes had mapped URIs members from multiple
#      applications.  This means multiple work classes may need to be created.
#      The HTTP work classes created will follow this format:
#    
#      <tcname>_<appname>_HTTPWorkClass, where <tcname> is the transaction class
#      name specified and <appname> is the application name. 
#
#      Use migrateAll51TransactionClasses if you want to migrate all possible 
#      transaction classes.
#
#       options:
#       --tcname cell unique name for the transaction class
#
#       Examples:
#         >> ./wsadmin.sh -lang jython -f migrateTC2WC.py migrate51TransactionClass --tcname my51TransactionClass
#
#=============================================================================================================
def migrate51TransactionClass():

  #process the necessary paramenters
  if tcname == "":
     print "ERROR: Must specify the name of the transaction class."
     printMigrate51TransactionClassHelp()
     return 1
  else:
     # find the transaction class 
     tcids = AdminConfig.list("TransactionClass")
     tcList = tcids.split("\n")

     for tc in tcList:
       tc = tc.rstrip()

       if (AdminConfig.showAttribute(tc,"name") == tcname):
         tcid = tc
         break   

  if tcid == "":
     print "ERROR: Must specify an existing Transaction Class. Cound not locate Transaction Class "+tcname
     printMigrate51TransactionClassHelp()
     return 1

  tcm_ids = AdminConfig.showAttribute(tc, "TransactionClassModules")
  if (len(tcm_ids)>2):
     tcm_ids = AdminConfig.showAttribute(tcid, "TransactionClassModules").replace("[","").replace("]","").replace(";",",").split(" ")      
     #First create all the Work Classes
     print "INFO: Start creating Work Class"
     for tcmid in tcm_ids:
         #Now add the Work Class Modules/URIs
         id = AdminConfig.showAttribute(tcmid, "id")
         #tcname+":!:"+appname+":!:"+modname
         ids = id.split(":!:")
         wcname = ids[0]+"_"+ids[1]+"_HTTPWorkClass"
         
         createHTTPWorkClass(wcname, ids[1], ids[0])
         tcm_uris = AdminConfig.showAttribute(tcmid,"URIs")
         addUrisToHTTPWorkClass(wcname, ids[1], ids[2], tcm_uris.split(";"), "")
         print "INFO: Removing URIs from XD 5.1 Transaction Class: "+tcm_uris.replace(";",",")
         AdminConfig.remove(tcmid)
         print "INFO: URIs successfully removed from XD 5.1 Transaction Class "+ids[0]
  else:
     print "ERROR: Must specify a 5.1 Transaction Class. Transaction Class "+tcname+" is not a 5.1 Transaction Class."
     printMigrate51TransactionClassHelp()
     return 1      

  AdminConfig.save()
  return 0	 


def printMigrate51TransactionClassHelp():
  print """
    migrate51TransactionClass [options]
  
      Migrates the specified 5.1 Transaction Class to HTTP type work class(es).
      In XD 5.1, Transaction Classes had mapped URIs members from multiple
      applications.  This means multiple work classes may need to be created.
      The HTTP work classes created will follow this format:
    
      <tcname>_<appname>_HTTPWorkClass, where <tcname> is the transaction class
      name specified and <appname> is the application name. 

      Use migrateAll51TransactionClasses if you want to migrate all possible 
      transaction classes.

       options:
       --tcname cell unique name for the transaction class

       Examples:
         >> ./wsadmin.sh -lang jython -f migrateTC2WC.py migrate51TransactionClass --tcname my51TransactionClass

   """


#=======================================================================================================================================================
#
# migrateAll51TransactionClasses description:
#
#    migrateAll51TransactionClasses
#  
#       Migrates all XD 5.1 Transaction Classes with mapped Uris to HTTP Type Work Classes.
#  
#       options: none
#
#       Examples:
#         >> ./wsadmin.sh -lang jython -f migrateTC2WC.py migrateAll51TransactionClasses
#
#=======================================================================================================================================================   
def migrateAll51TransactionClasses():
  print "INFO: Migrating XD 5.1 Transaction Classes ..."
  tcids = AdminConfig.list("TransactionClass")
  tcList = tcids.split("\n")

  for tc in tcList:
    tc = tc.rstrip()
    tcm_ids = AdminConfig.showAttribute(tc, "TransactionClassModules")
    
    if len(tcm_ids) > 2:      
       tcm_ids = AdminConfig.showAttribute(tc, "TransactionClassModules").replace("[","").replace("]","").replace(";",",").split(" ")
       #First create all the Work Classes 
       for tcmid in tcm_ids:
           #Now add the Work Class Modules/URIs
           id = AdminConfig.showAttribute(tcmid, "id")
           #tcname+":!:"+appname+":!:"+modname
           ids = id.split(":!:")
           wcname = ids[0]+"_"+ids[1]+"_HTTPWorkClass"
          
           createHTTPWorkClass(wcname, ids[1], ids[0])
           tcm_uris = AdminConfig.showAttribute(tcmid,"URIs")
           addUrisToHTTPWorkClass(wcname, ids[1], ids[2], tcm_uris.split(";"), "")
           print "INFO: Removing URIs from XD 5.1 Transaction Class: "+tcm_uris.replace(";",",")
           AdminConfig.remove(tcmid)
           print "INFO: URIs successfully removed from XD 5.1 Transaction Class "+ids[0]

  AdminConfig.save()
  print "INFO: Any XD 5.1 Transaction Classes available were migrated successfully"
  return 0	 

def printMigrateAll51TransactionClassesHelp():
  print """
    migrateAll51TransactionClasses
  
       Migrates all XD 5.1 Transaction Classes with mapped Uris to HTTP Type Work Classes.
  
       options: none

       Examples:
         >> ./wsadmin.sh -lang jython -f migrateTC2WC.py migrateAll51TransactionClasses
         
   """  


#=======================================================================================================================================================
# Helper Method -- adapted from workclass.py
#=======================================================================================================================================================
# createHTTPWorkClass description:
#
#    createHTTPWorkClass [options]
#  
#       Creates a work class with the specified options and associates it with the
#       transaction class specified.  The work class will be empty until URIs are 
#       associated with it.
#  
#       options:
#       --wcname cell unique name for the work classes (name is cell unique due to the ability to move work classes)
#       --appname cell unique name for the application
#       --tcname cell unique name for the transaction class (tcname is optional and if not provided will default to the default TC)
#
#  
#       Examples:
#         >> ./wsadmin.sh -lang jython -f workclass.py createHTTPWorkClass --wcname myWorkClass --appname myApplication --tcname Default_TC
#
#=======================================================================================================================================================
def createHTTPWorkClass(wcname, appname, tcname):
  cellid = AdminConfig.list("Cell")
  appid = ""
  application = "";

  #find the application
  appid = AdminConfig.getid("/Deployment:"+appname+"/")
  if (appid==""):
      print "ERROR: Specified application name does not exist. Please specify an existing application to associated to the new work class."
      return 1  

  # make sure the name is unique
  wcid = AdminConfig.getid("/Deployment:"+appname+"/WorkClass:"+wcname+"/") 
  if (wcid!=""):
      print "ERROR: Work class of name "+wcname+" already exists. Please provide a unique name."
      return 1

  #find the transaction class
  tcid = AdminConfig.getid("/TransactionClass:"+tcname+"/")
  if (tcid==""):
     print "ERROR: Specified Transaction Class does not exist. Please specify an existing transaction class to associated to the new work class."
     return 1
  
  # finished processing parameters, now create the work class  
  print "INFO: Creating Work Class ..."
  wcid = AdminConfig.create("WorkClass", appid, [["name",wcname],["description", ""],["type", "HTTPWORKCLASS"],["matchAction",tcname]])
  #print "INFO: Saving Work Class ..."
  #AdminConfig.save()
  print "INFO: Work Class successfully created. New Work Class id ="+wcid
  return 0

#=======================================================================================================================================================
# Helper Method -- adapted from workclass.py
#=======================================================================================================================================================
# addUrisToHTTPWorkClass description:
#
#    addUrisToHTTPWorkClass [options]
#  
#       Adds a set of URIs associated with a specific application and J2EE module pair with an existing
#       work class.  The URIs should NOT include the context root of the URI as it will automatically
#       be associated with the URI since the application and module is specified.  If the validate flag is 
#       specified, each URI pattern will be checked to see if it already has been mapped to an existing
#       work class (exaction match); otherwise it is assumed that the URI pattern has not already been mapped and 
#       will be added to the work class with out any validation.
#  
#       options:
#       --wcname   name of the work class to add the URIs to
#       --appname  name of the application of which the URIs are associated with
#       --modname  name of the J2EE module within the application of which the URIs are associated with
#       --uris     "uri1,uri2,..." the collection of URI patterns to associate with the work class from the application j2ee module pair
#       --validate (optional) If this flag is provided, the URIs specified will be checked to make sure they have not already been mapped to an existing work class
#  
#       Examples:
#         >> ./wsadmin.sh -lang jython -f workclass.py addUrisToHTTPWorkClass --wcname myWorkClass --appname StockTrade --modname trade.war --uris "/trade*.do, /trade*.jsp"
#
#=======================================================================================================================================================
def addUrisToHTTPWorkClass(wcname, appname, modname, uris, validate):
  #wcid = ""

  #process the necessary paramenters
  #Find the work class -- this is done in the createHTTPWorkClass
  wcid = AdminConfig.getid("/Deployment:"+appname+"/WorkClass:"+wcname+"/")  

  #find the application -- this is done in the createHTTPWorkClass
  #appid = AdminConfig.getid("/Deployment:"+appname+"/")
  
  if modname == "":
     print "ERROR: Must specify the name of the web module the uris are associated with."
     return 1
  else:
     # find the web module
     mods = AdminApp.listModules(appname)
     modList = mods.split("\n")
     modFound = "false"

     for mod in modList:
        mod = mod.rstrip()
        mname = mod.split("#")[1].split("+")[0]

        if mname == modname:
           modFound = "true"
           break

     if modFound=="false":
        print "ERROR: Must specify an installed web module.  Could not locate the module "+modname+" for application "+appname
        printAddUrisToHTTPWorkClassHelp()
        return 1

  if len(uris) == 0:
     print "ERROR: Must provide 1 or more URI patterns to add to the Work Class."
     printAddUrisToHTTPWorkClassHelp()
     return 1

  # normalize URIs, make sure each starts with a leading '/'
  for uri in uris:
     if not uri[0] == '/':
          uri = "/"+uri

  # create the Work Class Module name
  wcmodname = wcname+":!:"+appname+":!:"+modname 
  
  # check if the WCM already exists
  wcmid = ""
  wcmList = AdminConfig.showAttribute(wcid, "workClassModules").replace("[","").replace("]","").split(" ")

  for wcm in wcmList:
     if wcm=="":
        break
        
     if AdminConfig.showAttribute(wcm, "moduleName")==modname:
        wcmid = wcm
        break    

  # if validation enabled - check if the URIs are already specified in a different Work Class
  if validate == "true":
     wcs = AdminConfig.list("WorkClass")
     wcList = wcs.split("\n")
     
     for wc in wcList:
       wc = wc.rstrip()
       wcmList = AdminConfig.showAttribute(wc, "workClassModules").replace("[","").replace("]","").split(" ")

       for wcm in wcmList:
         if wcm == "":
            break

         wcm_id = AdminConfig.showAttribute(wcm, "id")
         wcm_names = wcm_id.split(":!:")

         if wcm_names[1]==appname and wcm_names[2]==modname:
           wcm_matchExpression = AdminConfig.showAttribute(wcm,"URIs").replace("[","").replace("]","").split(";")

	   wcm_uris = wcm_matchExpression.split(",")

           for wcm_uri in wcm_uris:
              for uri in uris:
                 if wcm_uri == uri:
                    print "WARNING: URI Pattern "+uri+" for application "+appname+" and web module "+modname+" already is mapped to work class "+wc+". This URI Pattern will not be added to the specified Work Class "+wcname+"."
                    uris.remove(uri)
  else:
      print "INFO: Skipping validation ..."
  
  if len(uris) == 0:
     print "ERROR: Must provide 1 or more unique URI patterns to add to the Work Class."
     return 1
                                
  # finished processing paraemeters, now create the Work Mod class  
  print "INFO: Adding URIs to Work Class ..."
  matchExpression=""
  
  for uri in uris:
     if (uri.startswith("/") == 0):
         uri = "/"+uri
     if matchExpression=="":
        matchExpression = uri
     else:
        matchExpression = matchExpression + "," + uri

  # if wcm doesn't exist, create else modify
  # Note - I am adding these URIs one by one only because adding them as a list did not seem to work...
  if wcmid == "":
     wcmid = AdminConfig.create("WorkClassModule", wcid, [["moduleName",modname],["id",wcmodname]],"workClassModules")
  else:
     e_uris = AdminConfig.showAttribute(wcm,"matchExpression").replace("[","").replace("]","") 
     matchExpression = matchExpression + "," + e_uris

  AdminConfig.modify(wcmid,[["matchExpression", matchExpression]])

  #print "INFO: Saving Work Class ..."
  #AdminConfig.save()
  print "INFO: URIs suceessfully added to Work Class "+wcname
  return 0

def printAddUrisToHTTPWorkClassHelp():
  print """
    addUrisToHTTPWorkClass [options]
  
       Adds a set of URIs associated with a specific application and J2EE module pair with an existing
       work class.  The URIs should NOT include the context root of the URI as it will automatically
       be associated with the URI since the application and module is specified.  If the validate flag is 
       specified, each URI pattern will be checked to see if it already has been mapped to an existing
       work class (exaction match); otherwise it is assumed that the URI pattern has not already been mapped and 
       will be added to the work class with out any validation.
  
       options:
       --wcname   name of the work class to add the URIs to
       --appname  name of the application of which the URIs are associated with
       --modname  name of the J2EE module within the application of which the URIs are associated with
       --uris     "uri1,uri2,..." the collection of URI patterns to associate with the work class from the application j2ee module pair
       --validate (optional) If this flag is provided, the URIs specified will be checked to make sure they have not already been mapped to an existing work class
  
       Examples:
         >> ./wsadmin.sh -lang jython -f workclass.py addUrisToHTTPWorkClass --wcname myWorkClass --appname StockTrade --modname trade.war --uris "/trade*.do, /trade*.jsp"
   """


#=======================================================================================================================================================
#
# Generic migrateTC2WC.py Operations:
# 
#=======================================================================================================================================================
def printHelp():
  print """

  For General Help:
      >> ./wsadmin.sh -lang jython -f migrateTC2WC.py

  For Operation Specific Help:
      >> ./wsadmin.sh -lang jython -f migrateTC2WC.py <operation> --help
 
  Supported Operations:
    list51TransactionClasses
    migrate51TransactionClass [options]
    migrateAll51TransactionClasses
  """

def processArguments():
  global  tcname
  tcname = ""

  for i in range(1,len(sys.argv)):
    arg = sys.argv[i]

    if(arg == "--tcname"):
      tcname= sys.argv[i + 1]
      print "INFO: Transaction Class Name = "+tcname
    elif(arg.find("--")==0):
      print "WARNING: Unknown option: " +arg

#=======================================================================================================================================================
#
# Main migrateTC2WC.py execution logic:
#
#=======================================================================================================================================================
if(len(sys.argv) > 0):
  option = sys.argv[0]
  help = 0

  if (len(sys.argv) > 1):
     if (sys.argv[1] == "--help"):
        help = 1

  if not help:
    processArguments()

  if (option == 'list51TransactionClasses'):
    if (help == 1):
      printList51TransactionClassesHelp()
    else:
      sys.exit(list51TransactionClasses())
  elif (option == 'migrate51TransactionClass'):
    if (help == 1):
      printMigrate51TransactionClassHelp()
    else:
      sys.exit(migrate51TransactionClass())
  elif (option == 'migrateAll51TransactionClasses'):
    if (help == 1):
      printMigrateAll51TransactionClassesHelp()
    else:
      sys.exit(migrateAll51TransactionClasses())
  else:
    printHelp()
else:
  printHelp()
