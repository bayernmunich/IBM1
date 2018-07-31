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
# This file contains a series of operations to help automate the administration of service policies.
# For General Help:
#     >> ./wsadmin.sh -lang jython -f servicepolicy.py
# For Operation Specific Help:
#     >> ./wsadmin.sh -lang jython -f servicepolicy.py <operation> --help
#
# Supported Operations:
#   createServicePolicy [options]
#   removeServicePolicy [options]
#   createTransactionClass [options]
#   removeTransactionClass [options]
#   addUrisToTransactionClass [options]
#   removeUrisFromTransactionClass [options]

#
# Author: Ann Black annblack@us.ibm.com
#
# Change History
# --------------
# 11-14-04 initial version created
# 06-13-05 Fix spi problem and added Default SP & TC removal prevention
# 09-15-05 Added service policy violation feature
# 07-25-08 Modified to use code moved to XDPYModules.py
# 09-13-12 Moved moduel code to IMPPYModules.py
#=======================================================================================================================================================

import sys
from java.lang import String
from java.lang import System

lineSeparator = java.lang.System.getProperty('line.separator')

#=======================================================================================================================================================
#
# performCreateServicePolicy description:
#
#     Creates a service policy with the specified options.  The new service policy will
#     not have any transaction classes associated with it.  Transaction classes must be
#     created and associated separately.
#
#     options:
#     --spname  cell unique name for the service policy
#     --spgt    integer representation of the service policy goal type
#                0 = discretionary
#                1 = average response time
#                2 = percentile response time
#                4 = completion time  (only valid with Compute Grid)
#     --spgv    service policy goal Value for non-discretionary goals (integer number, assumed to be milliseconds if units not specified)
#     --spgvu   optional integer representation of the units of the goal value (assumed to be milliseconds if not provided)
#                0 = milliseconds
#                1 = seconds
#                2 = minutes
#     --sppgv   percentile value for service policy with percentile response time goal (integer, 1-100)
#     --spi     integer representation of the importance level for service policies with non-discretionary goals
#                1 = highest
#                2 = higher
#                3 = high
#                4 = medium
#                5 = low
#                6 = lower
#                7 = lowest
#     --spgve   optional service policy goal violation enabled (true or false)
#     --spgdv   optional service policy goal delta value for average response or queue time goals (integer number, assumed to be milliseconds if units not specified)
#     --spgdvu  optional integer representation of the units of the goal delta value (assumed to be milliseconds if not provided)
#                0 = milliseconds
#                1 = seconds
#                2 = minutes
#     --spgdp   optional service policy goal delta percentile value for percentile response time goal
#     --sptpv   optional service policy time period value for non-discretionary goals (integer number, assumed to be milliseconds if units not specified)
#     --sptpvu  optional integer representation of the units of the time period value (assumed to be milliseconds if not provided)
#                0 = milliseconds
#                1 = seconds
#                2 = minutes
#     --spd     optional service policy description
#
#     examples:
#      Average Response Time Service Policy:
#           >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Platinum --spgt 1 --spgv 1 --spgvu 1 --spi 1
#      Average Response Time Service Policy with violation detection:
#          >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Platinum2 --spgt 1 --spgv 1 --spgvu 1 --spi 1 --spgve true --spgdv 5 --spgdvu 2 --sptpv 5 --sptpvu 2
#      Percentile Response Time Service Policy:
#          >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Bronze --spgt 2 --spgv 3000 --spgvu 0 --sppgv 80 --spi 5
#      Percentile Response Time Service Policy with violation detection:
#          >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Bronze2 --spgt 2 --spgv 3000 --spgvu 0 --sppgv 80 --spi 5 --spgve true --spgdp 5 --sptpv 5 --sptpvu 2
#      Completion Time Service Policy:
#          >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname CompleteTime --spgt 4 --spgv 1 --spgvu 2 --spi 1
#      Completion Time Service Policy with violation detection:
#          >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname CompleteTime2 --spgt 4 --spgv 1 --spgvu 2 --spi 1 --spgve true --spgdv 5 --spgdvu 2 --sptpv 5 --sptpvu 2
#      Discretionary Service Policy:
#           >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname BestEffort --spgt 0 --spd "best effort service policy"
#
#=======================================================================================================================================================
def performCreateServicePolicy():
    
  # make sure service policy name provided  
  if spname == "":
     print "ERROR: Must specify the name of the service policy."
     printCreateServicePolicyHelp()
     return 1
  # make sure service policy name is unique
  if (findServicePolicy(spname)):
     print "ERROR: Service policy of name "+spname+" already exists. Please provide a unique name."
     return 1
  # make sure goal type is valid
  if spgt == -1:
     print "ERROR: Must specify the goal type of the service policy."
     printCreateServicePolicyHelp()
     return 1
  elif spgt == 0:
     # discretionary goal service policy
     print "INFO: Discretionary Goal specified"
     createDiscretionaryServicePolicy(spname,spd,spi)
  elif spgt == 1:
     # performance goal service policy
     print "INFO: Average Response Time Goal specified"
     createARTServicePolicy(spname,spgv,spgvu,spi,spgve,spgdv,spgdvu,sptpv,sptpvu,spd)
  elif spgt == 2:
     # percentile response time goal service policy
     print "INFO: Percentile Response Time Goal specified"
     createPRTServicePolicy(spname,spgv,spgvu,sppgv,spi,spgve,spgdp,sptpv,sptpvu,spd)
  elif spgt == 4:
     # completion time goal service policy (only valid with Compute Grid)
     print "INFO: Completion Time Goal specified"
     createCTServicePolicy(spname,spgv,spgvu,spi,spgve,spgdv,spgdvu,sptpv,sptpvu,spd)
  else:
     # unrecognized goal type was input
     print "ERROR: Value specified for the service policy is not recognized.  Please use a value of 0,1,2 or 4."
     printCreateServicePolicyHelp()
     return 1

  # finished creating service policy ...
  print "INFO: Saving Config update ..."
  AdminConfig.save()
  print "INFO: Config update saved successfully"
  return 0

def printCreateServicePolicyHelp():
  print """
    createServicePolicy [options]

       Creates a service policy with the specified options.  The new service policy will
       not have any transaction classes associated with it.  Transaction classes must be
       created and associated separately.

       options:
       --spname cell unique name for the service policy
       --spgt   integer representation of the service policy goal type
                 0 = discretionary
                 1 = average response time
                 2 = percentile response time
                 4 = completion time (only valid for Compute Grid)
       --spgv   service policy goal Value for non-discretionary goals (integer number, assumed to be milliseconds if units not specified)
       --spgvu   optional integer representation of the units of the goal value (assumed to be milliseconds if not provided)"
                 0 = milliseconds
                 1 = seconds
                 2 = minutes
       --sppgv  percentile value for service policy with percentile response time goal (integer, 1-100)"
       --spi    integer representation of the importance level for service policies with non-discretionary goals"
                 1 = highest
                 2 = higher
                 3 = high
                 4 = medium
                 5 = low
                 6 = lower
                 7 = lowest
       --spgve  optional service policy goal violation enabled (true or false)
       --spgdv  optional service policy goal delta value for average response or queue time goals (integer number, assumed to be milliseconds if units not specified)
       --spgdvu optional integer representation of the units of the goal delta value (assumed to be milliseconds if not provided)
                 0 = milliseconds
                 1 = seconds
                 2 = minutes
       --spgdp  optional service policy goal delta percentile value for percentile response time goal
       --sptpv  optional service policy time period value for non-discretionary goals (integer number, assumed to be milliseconds if units not specified)
       --sptpvu optional integer representation of the units of the time period value (assumed to be milliseconds if not provided)
                 0 = milliseconds
                 1 = seconds
                 2 = minutes
       --spd    optional service policy description

       Examples:
         Average Response Time Service Policy:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Platinum --spgt 1 --spgv 1 --spgvu 1 --spi 1
         Average Response Time Service Policy with violation detection:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Platinum2 --spgt 1 --spgv 1 --spgvu 1 --spi 1 --spgve true --spgdv 5 --spgdvu 2 --sptpv 5 --sptpvu 2
         Percentile Response Time Service Policy:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Bronze --spgt 2 --spgv 3000 --spgvu 0 --sppgv 80 --spi 5
         Percentile Response Time Service Policy with violation detection:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname Bronze2 --spgt 2 --spgv 3000 --spgvu 0 --sppgv 80 --spi 5 --spgve true --spgdp 5 --sptpv 5 --sptpvu 2
         Completion Time Service Policy:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname CompleteTime --spgt 4 --spgv 1 --spgvu 2 --spi 1
         Completion Time Service Policy with violation detection:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname CompleteTime2 --spgt 4 --spgv 1 --spgvu 2 --spi 1 --spgve true --spgdv 5 --spgdvu 2 --sptpv 5 --sptpvu 2
         Discretionary Service Policy:
             >> ./wsadmin.sh -lang jython -f servicepolicy.py createServicePolicy --spname BestEffort --spgt 0 --spd "best effort service policy"

   """
#=======================================================================================================================================================
#
# performRemoveServicePolicy description:
#
#      Removes the service policy named.  All transaction classes associated with the service policy
#      will also be removed in this operation.  If you want to preserve any of the transaction classes
#      first move them to a service policy you wish to keep.
#
#      options:
#      --spname cell unique name for the service policy
#
#      Examples:
#        >> ./wsadmin.sh -lang jython -f servicepolicy.py removeServicePolicy --spname Platinum
#
#=======================================================================================================================================================
def performRemoveServicePolicy():
  
  # make sure service polcy name provided  
  if spname == "":
     print "ERROR: Must specify the name of the service policy."
     printRemoveServicePolicyHelp()
     return 1
  elif spname == "Default_SP":
     print "ERROR: Can not remove the default service policy."
     printRemoveServicePolicyHelp()
     return 1
  else:
     removeServicePolicy(spname)

  # finished removing service policy ...
  print "INFO: Saving Config update ..."
  AdminConfig.save()
  print "INFO: Config update saved successfully"
  return 0

def printRemoveServicePolicyHelp():
  print """
    removeServicePolicy [options]

       Removes the service policy named.  All transaction classes associated with the service policy
       will also be removed in this operation.  If you want to preserve any of the transaction classes
       first move them to a service policy you wish to keep.

       options:
       --spname cell unique name for the service policy

       Examples:
         >> ./wsadmin.sh -lang jython -f servicepolicy.py removeServicePolicy --spname Platinum

   """

#=======================================================================================================================================================
#
# performCreateTransactionClass description:
#
#    createTransactionClass [options]
#
#       Creates a transaction class with the specified options and associates it with the
#       service policy specified.  The transaction class will be empty until Uri's are
#       associated with it.
#
#       options:
#       --spname cell unique name for the service policy
#       --tcname cell unique name for the transaction classes (name is cell unique due to the ability to move transaction classes)
#       --tcd    optional transaction class description
#
#       Examples:
#         >> ./wsadmin.sh -lang jython -f servicepolicy.py createTransactionClass --spname Platinum --tcname PlatinumWorkload --tcd "my platinum workload"
#
#=======================================================================================================================================================
def performCreateTransactionClass():

  # make sure transaction class name provided
  if tcname == "":
     print "ERROR: Must specify the name of the transaction class."
     printCreateTransactionClassHelp()
     return 1
  # make sure service policy name provided 
  if spname == "":
     print "ERROR: Must specify the name of the service policy."
     printCreateTransactionClassHelp()
     return 1
   
  # create transaction class 
  createTransactionClass(spname,tcname,tcd)
     
  # finished creating transaction class ...
  print "INFO: Saving Config update ..."
  AdminConfig.save()
  print "INFO: Config update saved successfully"
  return 0

def printCreateTransactionClassHelp():
  print """
    createTransactionClass [options]

       Creates a transaction class with the specified options and associates it with the
       service policy specified.  The transaction class will be empty until Uri's are
       associated with it.

       options:
       --spname cell unique name for the service policy
       --tcname cell unique name for the transaction classes (name is cell unique due to the ability to move transaction classes)
       --tcd    optional transaction class description

       Examples:
         >> ./wsadmin.sh -lang jython -f servicepolicy.py createTransactionClass --spname Platinum --tcname PlatinumWorkload --tcd \"my platinum workload\"

   """

#=======================================================================================================================================================
#
# performRemoveTransactionClass description
#
#   removeTransactionClass [options]
#
#      Removes the TransactionClass.  All Uri's in the transaction class will no longer be associated
#      with the parent service policy.  If a request comes in for these Uri's and they have not been
#      associated with a new service policy and transaction class, they will be classified to the
#      default service policy with a discretionary goal.
#
#      options:
#      --tcname cell unique name for the transaction class to remove.
#
#      Examples:
#        >> ./wsadmin.sh -lang jython -f servicepolicy.py removeTransactionClass --tcname PlatinumWorkload
#
#=======================================================================================================================================================
def performRemoveTransactionClass():

  # make sure transaction class name provided
  if tcname == "":
     print "ERROR: Transaction Class name not specified."
     printRemoveTransactionClassHelp()
     return 1
  elif tcname == "Default_TC":
     print "ERROR: Can not remove a default transaction class."
     printRemoveTransactionClassHelp()
     return 1

  # remove transaction class
  removeTransactionClass(tcname)

  # finished removing transaction class ...
  print "INFO: Saving Config update ..."
  AdminConfig.save()
  print "INFO: Config update saved successfully"
  return 0

def printRemoveTransactionClassHelp():
  print """
    removeTransactionClass [options]

       Removes the TransactionClass.  All Uri's in the transaction class will no longer be associated
       with the parent service policy.  If a request comes in for these Uri's and they have not been
       associated with a new service policy and transaction class, they will be classified to the
       default service policy with a discretionary goal.

       options:
       --tcname cell unique name for the transaction class to remove.

       Examples:
         >> ./wsadmin.sh -lang jython -f servicepolicy.py removeTransactionClass --tcname PlatinumWorkload

   """
#=======================================================================================================================================================
#
# performAddUrisToTransactionClass description:
#
#    addUrisToTransactionClass [options]
#
#       Adds a set of Uri's associated with a specific application and J2EE module pair with an existing
#       transaction class.  The Uri's should NOT include the context root of the URI as it will automatically
#       be associated with the URI since the application and module is specified.  If the validate flag is
#       specified, each URI pattern will be checked to see if it already has been mapped to an existing
#       transaction class (exaction match); otherwise it is assumed that the URI pattern has not already been mapped and
#       will be added to the transaction class with out any validation.
#
#       options:
#       --tcname   name of the transaction class to add the Uri's to
#       --appname  name of the application of which the Uri's are associated with
#       --modname  name of the J2EE module within the application of which the Uri's are associated with
#       --uris     "uri1,uri2,..." the collection of URI patterns to associate with the transaction class from the application j2ee module pair
#       --validate (optional) If this flag is provided, the Uri's specified will be checked to make sure they have not already been mapped to an existing transaction class
#
#       Examples:
#         >> ./wsadmin.sh -lang jython -f servicepolicy.py addUrisToTransactionClass --tcname PlatinumWorkload --appname StockTrade --modname trade.war --uris "/trade*.do, /trade*.jsp"
#
#=======================================================================================================================================================
def performAddUrisToTransactionClass():
  tcid = ""

  # make sure transaction class name provided
  if tcname == "":
     print "ERROR: Must specify the name of the transaction class."
     printAddUrisToTransactionClassHelp()
     return 1
  # make sure application name provided
  if appname == "":
     print "ERROR: Must specify the name of the application that the Uri's are associated with."
     printAddUrisToTransactionClassHelp()
     return 1
  # make sure module name provided
  if modname == "":
     print "ERROR: Must specify the name of the web module the Uri's are associated with."
     printAddUrisToTransactionClassHelp()
     return 1
  # make sure at least 1 URI pattern provided
  if len(uris) == 0:
     print "ERROR: Must provide 1 or more URI patterns to add to the Transaction Class."
     printAddUrisToTransactionClassHelp()
     return1

  # add URIs to transaction class
  addUrisToTransactionClass(tcname,appname,modname,uris,validate)

  # finished adding URIs ...
  print "INFO: Saving Config update ..."
  AdminConfig.save()
  print "INFO: Config update saved successfully"
  return 0


def printAddUrisToTransactionClassHelp():
  print """
    addUrisToTransactionClass [options]

       Adds a set of Uri's associated with a specific application and J2EE module pair with an existing
       transaction class.  The Uri's should NOT include the context root of the URI as it will automatically
       be associated with the URI since the application and module is specified.  If the validate flag is
       specified, each URI pattern will be checked to see if it already has been mapped to an existing
       transaction class (exact match); otherwise it is assumed that the URI pattern has not already been mapped and
       will be added to the transaction class with out any validation.

       options:
       --tcname   name of the transaction class to add the Uri's to
       --appname  name of the application of which the Uri's are associated with
       --modname  name of the J2EE module within the application of which the Uri's are associated with
       --uris     \"uri1,uri2,...\" the collection of URI patterns to associate with the transaction class from the application j2ee module pair
       --validate (optional) If this flag is provided, the Uri's specified will be checked to make sure they have not already been mapped to an existing transaction class

       Examples:
         >> ./wsadmin.sh -lang jython -f servicepolicy.py addUrisToTransactionClass --tcname PlatinumWorkload --appname StockTrade --modname trade.war --uris \"/trade*.do, /trade*.jsp\"
   """

#=======================================================================================================================================================
#
#    removeUrisFromTransactionClass [options]
#
#       Removes a set of Uri's associated with an Application and Web Module and optionally a specific Transaction
#       Class.  If specific Uri's are specified, only those Uri's will be unmapped.  If no Uri's are specified, then
#       all Uri's for the specific Application/web module and optionally transaction class will be unmapped.  If
#       no transaction class is specified, then each transaction class is searched to see if it contains the specified
#       Uri's (or if no Uri's are specified than any Uri's) for the application/module specified and are removed.
#       The Uri's should NOT include the context root of the URI, and exact matches will be used for removal.
#
#       options:
#       --appname  name of the application
#       --modname  name of the web module within the application
#       --tcname   (optional) name of the transaction class - if not specified all transaction classes will be searched
#       --uris     (optional) \"uri1,uri2,...\" the collection of URI patterns to unmapp from all or the specified transaction class(es)
#                  if not specified, all Uri's for the app/module/{tran class} tuple will be removed
#
#       Examples:
#         Unmap from a specific Transaction Class a specific set of Uri's associated with a specific application/web module:
#           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war --tcname PlatinumWorkload --uris \"/trade*.do, /trade*.jsp\"
#         Unmap from any Transaction Class a specific set of Uri's associated with a specific application/web module:
#           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war --uris \"/trade*.do, /trade*.jsp\"
#         Unmap from a specific Transaction Class all Uri's associated with a specific application/web module
#           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war --tcname PlatinumWorkload
#         Unmap from any Transaction Class all Uri's associated with a specified application and web module
#           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war
#
#=======================================================================================================================================================
def removeUrisFromTransactionClass():
  tcid = ""

  # process the necessary parameters
  if appname == "":
     print "ERROR: Must specify the name of the application that the Uri's are associated with."
     printRemoveUrisFromTransactionClassHelp()
     return 1
  else:
     # find the application
     apps = AdminApp.list()
     appList = apps.split(lineSeparator)
     appFound = "false"
     for app in appList:
        if app == appname:
           appFound = "true"
           break
     if appFound=="false":
        print "ERROR: Must specify an installed application.  Could not locate application "+appname
        printRemoveUrisFromTransactionClassHelp()
        return 1

  if modname == "":
     print "ERROR: Must specify the name of the web module the Uri's are associated with."
     printRemoveUrisFromTransactionClassHelp()
     return 1
  else:
     # find the web module
     mods = AdminApp.listModules(appname)
     modList = mods.split(lineSeparator)
     modFound = "false"
     for mod in modList:
        mname = mod.split("#")[1].split("+")[0]
        if mname == modname:
           modFound = "true"
           break
     if modFound=="false":
        print "ERROR: Must specify an installed web module.  Could not locate the module "+modname+" for application "+appname
        printRemoveUrisFromTransactionClassHelp()
        return 1

  if tcname == "":
     print "INFO: No TransactionClass was specified, therefore will search all Transaction Classes for Uri's associated with application "+appname+" and web module "+modname
  else:
     # find the tran class
     tcids = AdminConfig.list("TransactionClass")
     tcList = tcids.split(lineSeparator)
     for tc in tcList:
       if (tc.split("(")[0] == tcname):
         tcid = tc
         break

  if tcid == "":
     print "WARNING: Could not locate specified Transaction Class "+tcname+". Therefore will search all Transaction Classes for Uri's associated with application "+appname+" and web module "+modname

  if len(uris) == 0:
     print "INFO: No Uri's were specified - will remove ALL Uri's associated with the specific application and module"

  # normalize Uri's, make sure each starts with a leading '/'
  for uri in uris:
     if not uri[0] == '/':
          uri = "/"+uri

  # create the Tran Class Module name
  tcmodname = tcname+":!:"+appname+":!:"+modname

  print "INFO: Removing Uri's..."
  tcm_rl = {}
  # start to remove ...
  if not tcid == "":
    tcmid = ""
    tcmList = AdminConfig.showAttribute(tcid, "TransactionClassModules").replace("[","").replace("]","").split(" ")
    for tcm in tcmList:
       if tcm=="":
          break
       if AdminConfig.showAttribute(tcm, "id")==tcmodname:
          tcmid = tcm
          break
    if tcmid == "":
       print "ERROR: Could not locate any Uri's for application "+appname+" and web module "+modname+" for transaction class "+tcname+"."
       printRemoveUrisFromTransactionClassHelp()
       return 1
    tcm_rl[tcmid] = tcid
  else:
    tcs = AdminConfig.list("TransactionClass")
    tcList = tcs.split(lineSeparator)
    for tc in tcList:
      tcmList = AdminConfig.showAttribute(tc, "TransactionClassModules").replace("[","").replace("]","").split(" ")
      for tcm in tcmList:
        if tcm == "":
           break
        tcm_id = AdminConfig.showAttribute(tcm, "id")
        tcm_names = tcm_id.split(":!:")
        if tcm_names[1]==appname and tcm_names[2]==modname:
           tcm_rl[tcm] = tc
           print "INFO: Removing Uri's from Transaction Class "+tcm_names[0]
    if len(tcm_rl)==0:
       print "WARNING: Could not locate any mappings of Uri's from the specified application/web module to any transaction class... nothing to remove."
       return 1

  if len(uris)==0:
     # remove all tcms for the app/module
     print "INFO: No Uri's specified, removing all Uri's for the matched application/web module and optionally transaction class tuple ..."
     for tcmid in tcm_rl.keys():
        AdminConfig.remove(tcmid)
        print "INFO: Removing Uri's for application "+appname+" and web module "+modname+" from Transaction Class "+tcm_rl[tcmid]
  else:
     # search the tcm removal list for the uris
     for tcmid in tcm_rl.keys():
       # get the currently mapped Uri's and then remove the ones that need to be unmapped
       tcm_uris = AdminConfig.showAttribute(tcm,"URIs").replace("[","").replace("]","").split(";")
       uri_orig_count = len(tcm_uris)
       for uri in uris:
          if tcm_uris.count(uri)>0:
              tcm_uris.remove(uri)
              print "INFO: Removing URI "+uri+" from Transaction Class "+tcm_rl[tcmid]
          else:
              print "INFO: URI Pattern "+uri+" not found in Transaction Class "+tcm_rl[tcmid]+" and will not be removed from this Transaction Class."

       #what is left in tcm_uris should just be the applicable Uri's, remove and recreate the TCM
       if not uri_orig_count==len(tcm_uris):
          tcm_id = AdminConfig.showAttribute(tcm, "id")
          AdminConfig.remove(tcm)
          tcm = AdminConfig.create("TransactionClassModule",tcm_rl[tcmid],[["id",tcm_id]],"TransactionClassModules")
          for tcm_uri in tcm_uris:
            AdminConfig.modify(tcm,[["URIs", tcm_uri]])
       else:
          print "INFO: Transaction Class "+tcm_rl[tcmid]+" is not affected by URI remove."

  AdminConfig.save()
  print "INFO: URIs successfully removed."
  return 0

def printRemoveUrisFromTransactionClassHelp():
  print """
    removeUrisFromTransactionClass [options]

       Removes a set of URIs associated with an Application and Web Module and optionally a specific Transaction
       Class.  If specific URIs are specified, only those URIs will be unmapped.  If no URIs are specified, then
       all URIs for the specific Application/web module and optionally transaction class will be unmapped.  If
       no transaction class is specified, then each transaction class is searched to see if it contains the specified
       URIs (or if no URIs are specified than any URIs) for the application/module specified and are removed.
       The URIs should NOT include the context root of the URI, and exact matches will be used for removal.

       options:
       --appname  name of the application
       --modname  name of the web module within the application
       --tcname   (optional) name of the transaction class - if not specified all transaction classes will be searched
       --uris     (optional) \"uri1,uri2,...\" the collection of URI patterns to unmapp from all or the specified transaction class(es)
                  if not specified, all URIs for the app/module/{tran class} tuple will be removed

       Examples:
         Unmap from a specific Transaction Class a specific set of URIs associated with a specific application/web module:
           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war --tcname PlatinumWorkload --uris \"/trade*.do, /trade*.jsp\"
         Unmap from any Transaction Class a specific set of URIs associated with a specific application/web module:
           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war --uris \"/trade*.do, /trade*.jsp\"
         Unmap from a specific Transaction Class all URIs associated with a specific application/web module
           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war --tcname PlatinumWorkload
         Unmap from any Transaction Class all URIs associated with a specified application and web module
           >> ./wsadmin.sh -lang jython -f servicepolicy.py removeUrisFromTransactionClass --appname StockTrade --modname trade.war
   """

#=======================================================================================================================================================
#
# Generic servicepolicy.py Operations:
#
#=======================================================================================================================================================

def printHelp():
  print """

  For General Help:
      >> ./wsadmin.sh -lang jython -f servicepolicy.py
  For Operation Specific Help:
      >> ./wsadmin.sh -lang jython -f servicepolicy.py <operation> --help

  Supported Operations:
    createServicePolicy [options]
    removeServicePolicy [options]
    createTransactionClass [options]
    removeTransactionClass [options]
    addUrisToTransactionClass [options]
    removeUrisFromTransactionClass [options]

  """

def processArguments():
  global  spname, spgt, spgv, spgvu, sppgv, spi, spgve, spgdv, spgdvu, spgdp, sptpv, sptpvu, spd, tcname, tcd, appname, modname, uris, validate
  spname = ""
  spgt = -1
  spgv = -1
  spgvu = -1
  sppgv = -1
  spi = -1
  spgve = "false"
  spgdv = 0
  spgdvu = 0
  spgdp = 0
  sptpv = 0
  sptpvu = 0
  spd = ""
  tcname = ""
  tcd = ""
  uris = []
  validate = "false"
  for i in range(1,len(sys.argv)):
    arg = sys.argv[i]
    if(arg == "--spname"):
      spname= sys.argv[i + 1]
      print "INFO: Service Policy Name = "+spname
    elif(arg == "--spgt"):
      spgt = int(sys.argv[i + 1])
      print "INFO: Service Policy Goal Type = "+str(spgt)
    elif(arg == "--spgv"):
      spgv = int(sys.argv[i + 1])
      print "INFO: Service Policy Goal Value = "+str(spgv)
    elif(arg == "--spgvu"):
      spgvu = int(sys.argv[i + 1])
      print "INFO: Service Policy Goal Value Units = "+str(spgvu)
    elif(arg == "--sppgv"):
      sppgv = int(sys.argv[i + 1])
      print "INFO: Service Policy Percentile Goal Percentage = "+str(sppgv)
    elif(arg == "--spi"):
      spi = int(sys.argv[i + 1])
      print "INFO: Service Policy Importance = "+str(spi)
    elif(arg == "--spgve"):
      spgve = sys.argv[i + 1]
      print "INFO: Service Policy Goal Violation Enabled = "+spgve
    elif(arg == "--spgdv"):
      spgdv = int(sys.argv[i + 1])
      print "INFO: Service Policy Goal Delta Value = "+str(spgdv)
    elif(arg == "--spgdvu"):
      spgdvu = int(sys.argv[i + 1])
      print "INFO: Service Policy Goal Delta Value Units = "+str(spgdvu)
    elif(arg == "--spgdp"):
      spgdp = int(sys.argv[i + 1])
      print "INFO: Service Policy Goal Delta Percentage = "+str(spgdp)
    elif(arg == "--sptpv"):
      sptpv = int(sys.argv[i + 1])
      print "INFO: Service Policy Time Period Value = "+str(sptpv)
    elif(arg == "--sptpvu"):
      sptpvu = int(sys.argv[i + 1])
      print "INFO: Service Policy Time Period Value Units = "+str(sptpvu)
    elif(arg == "--spd"):
      spd = sys.argv[i + 1]
      print "INFO: Service Policy Description = "+spd
    elif(arg == "--tcname"):
      tcname= sys.argv[i + 1]
      print "INFO: Transaction Class Name = "+tcname
    elif(arg == "--tcd"):
      tcd = sys.argv[i + 1]
      print "INFO: Transaction Class Description = "+tcd
    elif(arg == "--appname"):
      appname= sys.argv[i + 1]
      print "INFO: Application Name = "+appname
    elif(arg == "--modname"):
      modname= sys.argv[i + 1]
      print "INFO: Web Module Name = "+modname
    elif(arg == "--uris"):
      uris= sys.argv[i + 1].split(",")
      uristr = "["
      for uri in uris:
         uristr = uristr +uri+","
      uristr = uristr+"]"
      print "INFO: URIs = "+uristr
    elif(arg == "--validate"):
      validate = "true"
      print "INFO: Validation enabled"
    elif(arg.find("--")==0):
      print "WARNING: Unknown option: " +arg

#=======================================================================================================================================================
#
# Main servicepolicy.py execution logic:
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
  if (option == 'createServicePolicy'):
    if (help == 1):
      printCreateServicePolicyHelp()
    else:
      # Make sure units is valid
      if (spgvu == -1):
         print "INFO: No units specified for goal value, assuming milliseconds."
         spgvu=0
      elif (spgvu >2):
         print "ERROR: Value specified for the service policy goal value units is not recognized. Please use a value of 0-2."
         printCreateServicePolicyHelp()
         java.lang.System.exit(1)
      sys.exit(performCreateServicePolicy())
  elif (option == 'removeServicePolicy'):
    if (help == 1):
      printRemoveServicePolicyHelp()
    else:
      sys.exit(performRemoveServicePolicy())
  if (option == 'createTransactionClass'):
    if (help == 1):
      printCreateTransactionClassHelp()
    else:
      sys.exit(performCreateTransactionClass())
  elif (option == 'removeTransactionClass'):
    if (help == 1):
      printRemoveTransactionClassHelp()
    else:
      sys.exit(performRemoveTransactionClass())
  elif (option == 'addUrisToTransactionClass'):
    if (help == 1):
      printAddUrisToTransactionClassHelp()
    else:
      sys.exit(performAddUrisToTransactionClass())
  elif (option == 'removeUrisFromTransactionClass'):
    if (help == 1):
      printRemoveUrisFromTransactionClassHelp()
    else:
      sys.exit(removeUrisFromTransactionClass())
  else:
    printHelp()
else:
  printHelp()
