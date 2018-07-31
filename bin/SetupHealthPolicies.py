#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# Sets up different health policies
#
# @author - Anil Ambati
# Date Created: 02/02/2010
#

import sys
lineSeparator = java.lang.System.getProperty('line.separator')

age = 7
ageUnit = "day"
totalRequests = 20000000
timeoutPercent  = 5
sensitivity  = "NORMAL"
responseTime  = 120
responseTimeUnit = 1
reactionMode = "supervised"
actions = ["restart"]
healthPolicyName = None
offendingTimePeriod = 1
highWaterHeapPercentage = 95
samplingPeriod = 2
samplingUnit = 2
garbageCollectionPercent = 10

def getHealthPolicy(healthPolicyName):
   hpids = AdminConfig.list("HealthClass")
   hpList = hpids.split(lineSeparator)
   for hp in hpList:
     hp1 = hp.rstrip()
     hp1 = hp1.replace("\"","")
     if (hp1.split("(")[0] == healthPolicyName):
        print "Health policy "+healthPolicyName+" already exists"
        return hp
   return None

def doesHealthPolicyExist(healthPolicyName):
   hp = getHealthPolicy(healthPolicyName)
   if (hp == None):
     return 0
   return 1
   
def createDefaultHealthPolicies():
  print "Creating... DefaultMemoryLeakPolicy"
  createDefaultMemoryLeakPolicy()
  print "Creating... DefaultExcessiveMemoryUsagePolicy"
  createDefaultExcessiveMemoryUsagePolicy()
  print "Creating... DefaultExcessiveRequestTimeoutPolicy"
  createDefaultExcessiveRequestTimeoutPolicy()
  print "Creating... DefaultExcessiveResponseTimePolicy"
  createDefaultExcessiveResponseTimePolicy()
  print "Creating... DefaultStormDrainPolicy"
  createDefaultStormDrainPolicy()
  print "Creating...DefaultGarbageCollectionPercentagePolicy"
  createDefaultGarbageCollectionPercentagePolicy()

def createDefaultMemoryLeakPolicy():
   healthPolicyName="Default_Memory_Leak"
   if not doesHealthPolicyExist(healthPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
     mc=AdminConfig.create("MemoryLeakAlgorithm",hc,[["level","NORMAL"]])
     tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum","1"]],"healthActions")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum","2"]],"healthActions")

def createDefaultExcessiveMemoryUsagePolicy():
   healthPolicyName="Default_Excessive_Memory_Usage"
   if not doesHealthPolicyExist(healthPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
     mc=AdminConfig.create("MemoryCondition",hc,[["timeOverThreshold","1"],["memoryUsed","95"]])
     tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum","1"]],"healthActions")
     
def createDefaultExcessiveRequestTimeoutPolicy():
   healthPolicyName="Default_Excessive_Request_Timeout"
   if not doesHealthPolicyExist(healthPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
     mc=AdminConfig.create("StuckRequestCondition",hc,[["timeoutPercent","5"]])
     tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum","1"]],"healthActions")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum","2"]],"healthActions")
     
def createDefaultExcessiveResponseTimePolicy():
   healthPolicyName="Default_Excessive_Response_Time"
   if not doesHealthPolicyExist(healthPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
     mc=AdminConfig.create("ResponseCondition",hc,[["responseTime","120"],["responseTimeUnits","1"]])
     tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum","1"]],"healthActions")
     
def createDefaultStormDrainPolicy():
   healthPolicyName="Default_Storm_Drain"
   if not doesHealthPolicyExist(healthPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
     mc=AdminConfig.create("StormDrainCondition",hc,[["level","NORMAL"]])
     tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum","1"]],"healthActions")
 
def createDefaultGarbageCollectionPercentagePolicy():
   healthPolicyName="Default_Garbage_Collection_Percentage"
   if not doesHealthPolicyExist(healthPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
     mc=AdminConfig.create("GCPercentageCondition",hc,[["samplingPeriod","2"],["samplingUnits","2"],["garbageCollectionPercent","10"]])
     tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
     ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum","1"]],"healthActions")
    
def createMaxRequestsPolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   mc=AdminConfig.create("WorkloadCondition",hc,[["totalRequests",totalRequests]])

   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1
     
def createMaxAgePolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   if (ageUnit == "hour"):
     mc=AdminConfig.create("AgeCondition",hc,[["maxAge",age],["ageUnits","3"]])
   elif (ageUnit == "day"):
     mc=AdminConfig.create("AgeCondition",hc,[["maxAge",age]])  
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1
     
def createMemoryLeakPolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   mc=AdminConfig.create("MemoryLeakAlgorithm",hc,[["level",sensitivity]])
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1
     
def createStormDrainPolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   mc=AdminConfig.create("StormDrainCondition",hc,[["level",sensitivity]])
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1

def createExcessiveRequestTimeoutPolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   mc=AdminConfig.create("StuckRequestCondition",hc,[["timeoutPercent",timeoutPercent]])
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1
         
def createExcessiveResponseTimePolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   mc=AdminConfig.create("ResponseCondition",hc,[["responseTime",responseTime],["responseTimeUnits",responseTimeUnit]])
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1

def createExcessiveMemoryUsagePolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
     print "Removing health policy "+healthPolicyName
     AdminConfig.remove(hc)
     hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName + " with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   mc=AdminConfig.create("MemoryCondition",hc,[["timeOverThreshold",offendingTimePeriod],["memoryUsed",highWaterHeapPercentage]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1
     
def createGarbageCollectionPercentagePolicy():
   hc = getHealthPolicy(healthPolicyName)
   if (hc != None):
      print "Removing health policy "+healthPolicyName
      AdminConfig.remove(hc)
      hc = None

   cell=AdminConfig.list("Cell")
   cellname=AdminConfig.showAttribute(cell,"name")
   print "Creating health policy "+healthPolicyName+" with specified values"
   if (reactionMode == "supervised"):
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","2"]])
   else:
     hc=AdminConfig.create("HealthClass",cell,[["name",healthPolicyName],["description",""],["reactionMode","3"]])
   mc=AdminConfig.create("GCPercentageCondition",hc,[["samplingPeriod",samplingPeriod],["samplingUnits",samplingUnit],["garbageCollectionPercent",garbageCollectionPercent]])
   tm=AdminConfig.create("TargetMembership",hc,[["memberString",cellname],["type","4"]],"targetMemberships")
   iter = 1
   for action in actions:
     if (action == "restart"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","RESTART"],["stepNum",iter]],"healthActions")
     elif (action == "threaddump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","THREADDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "heapdump"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","HEAPDUMP"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     elif (action == "setmaintenancemode-break"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","SETMAINTENANCEMODE_BREAK"],["stepNum",iter]],"healthActions")
     elif (action == "unsetmainenancemode"):
       ha=AdminConfig.create("HealthAction",hc,[["actionType","UNSETMAINTENANCEMODE"],["stepNum",iter]],"healthActions")
     iter = iter + 1

def printExcessiveMemoryUsageHelp(arg):
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                                Name of the policy. This is optional. If name is not specified, 'Default_Excessive_Memory_Usage' is used"
  print "\t-highWaterHeapPercentage:<percent heap size>       Excessive memory usage condition that will trigger action "
  print "\t-offendingTimePeriod:<time in minutes>             Time in minutes to wait after maximum memory usage condition is met before specified action(s) are taken"
  print "\t-reactionMode:<supervised/automatic>               Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>                     Comma separated actions. Use:"
  print "\t                                                       'restart' to restart server"
  print "\t                                                       'threaddump' to take thread dumps"
  print "\t                                                       'heapdump' to take heap dumps"
  print "\t                                                       'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                       'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                       'unsetmaintenancemode' to place server out of maintenance"

def printExcessiveRequestTimeoutHelp(arg):
   print "Unrecognized option: "+arg
   print "Available options:"
   print "\t-name:<policy name>                         Name of the policy. This is optional. If name is not specified, 'Default_Excessive_Request_Timeout' is used"
   print "\t-timeoutPercent:<% timed out requests>      Excessive request timeout condition that will trigger action. Represents % timed out request in last 1 minute"
   print "\t-reactionMode:<supervised/automatic>        Specifies reaction mode is 'supervised' or 'automatic'"
   print "\t-actions:<actions to be taken>              Comma separated actions. Use:"
   print "\t                                                      'restart' to restart server"
   print "\t                                                      'threaddump' to take thread dumps"
   print "\t                                                      'heapdump' to take heap dumps"
   print "\t                                                      'setmaintenancemode' to place server in maintenance mode"
   print "\t                                                      'setmaintenancemode-break' to place server in maintenance mode and break affinity"
   print "\t                                                      'unsetmaintenancemode' to place server out of maintenance"

def printExcessiveResponseTimeHelp(arg):
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                         Name of the policy. This is optional. If name is not specified, 'Default_Excessive_Response_Time' is used"
  print "\t-responseTime:<response time>               Excessive response time condition that will trigger action. Response time must be between 1 millisecond and 1 hour"
  print "\t-responseTimeUnit:<response time unit>      Unit for response time. Valid values are 'millisecond', 'second', 'minute'"
  print "\t-reactionMode:<supervised/automatic>        Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>              Comma separated actions. Use:"
  print "\t                                                    'restart' to restart server"
  print "\t                                                    'threaddump' to take thread dumps"
  print "\t                                                    'heapdump' to take heap dumps"
  print "\t                                                    'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                    'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                    'unsetmaintenancemode' to place server out of maintenance"
  
def printMemoryLeakHelp(arg):
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                         Name of the policy. This is optional. If name is not specified, 'Default_Memory_Leak' is used"
  print "\t-sensitivity:<detection level>              Excessive memory leak condition (detection level) that will trigger action. standard, slow, fast are allowed values"
  print "\t-reactionMode:<supervised/automatic>        Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>              Comma separated actions. Use:"
  print "\t                                                      'restart' to restart server"
  print "\t                                                      'threaddump' to take thread dumps"
  print "\t                                                      'heapdump' to take heap dumps"
  print "\t                                                      'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                      'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                      'unsetmaintenancemode' to place server out of maintenance"

def printStormDrainHelp(arg):
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                         Name of the policy. This is optional. If name is not specified, 'Default_Storm_Drain' is used"
  print "\t-sensitivity:<standard/slow>                Sensitivity of condition. standard, slow are allowed values"
  print "\t-reactionMode:<supervised/automatic>        Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>              Comma separated actions. Use:"
  print "\t                                                      'restart' to restart server"
  print "\t                                                      'threaddump' to take thread dumps"
  print "\t                                                      'heapdump' to take heap dumps"
  print "\t                                                      'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                      'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                      'unsetmaintenancemode' to place server out of maintenance"

def printMaximumAgeHelp(arg):   
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                         Name of the policy. This is optional. If name is not specified, 'Default_Maximum_Requests' is used"
  print "\t-totalRequests:<max age>                    Maximum requests condition (total number of requests serviced by a server) that will trigger action"
  print "\t-reactionMode:<supervised/automatic>        Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>              Comma separated actions. Use:"
  print "\t                                                      'restart' to restart server"
  print "\t                                                      'threaddump' to take thread dumps"
  print "\t                                                      'heapdump' to take heap dumps"
  print "\t                                                      'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                      'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                      'unsetmaintenancemode' to place server out of maintenance"

def printMaximumRequestsHelp(arg):
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                         Name of the policy. This is optional. If name is not specified, 'Default_Maximum_Age' is used"
  print "\t-age:<max age>                              Maximum age condition (age of a server) that will trigger action"
  print "\t-ageUnit:<day/hour>                         age unit. Valid values are 'day' or 'hour'"
  print "\t-reactionMode:<supervised/automatic>        Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>              Comma separated actions. Use:"
  print "\t                                                      'restart' to restart server"
  print "\t                                                      'threaddump' to take thread dumps"
  print "\t                                                      'heapdump' to take heap dumps"
  print "\t                                                      'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                      'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                      'unsetmaintenancemode' to place server out of maintenance"
                             
def printGarbageCollectionPercentageUsageHelp(arg):
  print "Unrecognized option: "+arg
  print "Available options:"
  print "\t-name:<policy name>                                                           Name of the policy. This is optional. If name is not specified, 'Default_Garbage_Collection_Percentage' is used"
  print "\t-garbageCollectionPercent:<percent of time spent in garbage collection>       Garbage collection condition that will trigger action "
  print "\t-samplingPeriod:<time in minutes/hours>                                       Sampling period in minutes/hours over which to collect data about amount of time spent in garbage collection"
  print "\t-samplingUnit:<minute/hour>                                                   Valid values are 'minute' and 'hour'"
  print "\t-reactionMode:<supervised/automatic>                                          Specifies reaction mode is 'supervised' or 'automatic'"
  print "\t-actions:<actions to be taken>                                                Comma separated actions. Use:"
  print "\t                                                                                   'restart' to restart server"
  print "\t                                                                                   'threaddump' to take thread dumps"
  print "\t                                                                                   'heapdump' to take heap dumps"
  print "\t                                                                                   'setmaintenancemode' to place server in maintenance mode"
  print "\t                                                                                   'setmaintenancemode-break' to place server in maintenance mode and break affinity"
  print "\t                                                                                   'unsetmaintenancemode' to place server out of maintenance"


#
#  Start off main() program
#
if(len(sys.argv) > 0):
  option = sys.argv[0]
  ignore = 0

  if (option == "setupMaximumAgePolicy"):
    healthPolicyName = "Default_Maximum_Age"
    ageSpecified = 0
    ageUnitSpecified = 0  
    if (len(sys.argv) > 0):
       for arg in sys.argv:
          if (ignore == 0):
            ignore = 1
          elif (arg.startswith("-age:")):
            parts = arg.split(":")
            if (parts[1] != ""):
               age = int(parts[1])
               ageSpecified = 1
          elif (arg.startswith("-ageUnit:")):
            parts = arg.split(":")
            if (parts[1] != ""):
               if (parts[1] == "hour" or parts[1] == "day"):
                  ageUnit = parts[1]
                  ageUnitSpecified = 1
               else:
                  print "Age unit must be either 'day' or 'hour'"
                  sys.exit(1)
          elif (arg.startswith("-reactionMode:")):
               parts = arg.split(":")
               if (parts[1] == "supervised" or parts[1] == "automatic" ):
                 reactionMode=parts[1]
          elif (arg.startswith("-actions:")):
           parts = arg.split(":")
           if (parts[1] != ""):
             actions=parts[1].split(",")
          elif (arg.startswith("-name:")):
             parts = arg.split(":")
             if (parts[1] != ""):
                healthPolicyName = parts[1]
          else:
             printMaximumRequestsHelp(arg)
             sys.exit(1)

    if (ageSpecified == 1 and ageUnitSpecified == 0):
      print "If -age is specified then -ageUnit must also be specified"
      sys.exit(1)
      
    createMaxAgePolicy()
    
  elif (option == "setupMaximumRequestsPolicy"):
    healthPolicyName = "Default_Maximum_Requests"
    if (len(sys.argv) > 0):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-totalRequests:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            totalRequests = int(parts[1])
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
            reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printMaximumAgeHelp(arg)
          sys.exit(1)
          
    createMaxRequestsPolicy()

  elif (option == "setupStormDrainPolicy"):
    healthPolicyName = "Default_Storm_Drain"
    if (len(sys.argv)>0):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-sensitivity:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            if (parts[1] == "standard"):
              sensitivity = "NORMAL"
            elif (parts[1] == "slow"):
              sensitivity = "CONSERVATIVE"
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
             reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printStormDrainHelp(arg)
          sys.exit(1)
   
    createStormDrainPolicy()
    
  elif (option == "setupMemoryLeakPolicy"):
    healthPolicyName = "Default_Memory_Leak"
    actions = ["heapdump","restart"] 
    if (len(sys.argv)>0):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-sensitivity:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            if (parts[1] == "standard"):
              sensitivity = "NORMAL"
            elif (parts[1] == "slow"):
              sensitivity = "CONSERVATIVE"
            elif (parts[1] == "fast"):
              sensitivity = "AGGRESSIVE"
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
            reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printMemoryLeakHelp(arg)
          sys.exit(1)
 
    createMemoryLeakPolicy()
  elif (option == "setupExcessiveResponseTimePolicy"):
    healthPolicyName = "Default_Excessive_Response_Time"
    needUnits = 0
    unitsSpecified = 0
    if (len(sys.argv) > 0):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-responseTime:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            try:
              responseTime=int(parts[1])
              needUnits = 1
            except ValueError:
              print "Response time must be a number"
              sys.exit(1)
        elif (arg.startswith("-responseTimeUnit:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            unitsSpecified = 1
            responseTimeUnitStr = parts[1]
            if (parts[1] == "minute"):
              responseTimeUnit=2
            elif (parts[1] == "second"):
              responseTimeUnit=1
            elif (parts[1] == "millisecond"):
              responseTimeUnit=0
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
            reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printExcessiveResponseTimeHelp(arg)
          sys.exit(1)

    if (needUnits == 1 and unitsSpecified == 0):
      print "If -responseTime is specified then -responseTimeUnit must also be specified"
      sys.exit(1)
   
    createExcessiveResponseTimePolicy()

  elif (option == "setupExcessiveRequestTimeoutPolicy"):
    healthPolicyName = "Default_Excessive_Request_Timeout"
    actions = ["heapdump","restart"] 
    if (len(sys.argv)>0):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-timeoutPercent:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            try:
              timeoutPercent=int(parts[1])
            except ValueError:
              print "A number between 1 and 100 that represents % of requests timed out in last 1 minute"
              sys.exit(1)
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
            reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printExcessiveRequestTimeoutHelp(arg)
          sys.exit(1)

    createExcessiveRequestTimeoutPolicy()

  elif (option == "setupExcessiveMemoryUsagePolicy"):
    healthPolicyName = "Default_Excessive_Memory_Usage"
    if (len(sys.argv) > 0 ):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-highWaterHeapPercentage:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            try:
              highWaterHeapPercentage=int(parts[1])
              if (highWaterHeapPercentage < 1 or highWaterHeapPercentage > 99):
                print "High water heap percentage should be a number between 1 and 99"
                sys.exit(1)
            except ValueError:
                print "High water heap percentage should be a number between 1 and 99"
                sys.exit(1)
        elif (arg.startswith("-offendingTimePeriod:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            offendingTimePeriod=int(parts[1])
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
            reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printExcessiveMemoryUsageHelp(arg)
          sys.exit(1)

    createExcessiveMemoryUsagePolicy()

  elif (option == "setupGarbageCollectionPercentagePolicy"):
    healthPolicyName = "Default_Garbage_Collection_Percentage"
    if (len(sys.argv) > 0 ):
      for arg in sys.argv:
        if (ignore == 0):
          ignore = 1
        elif (arg.startswith("-garbageCollectionPercent:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            try:
              garbageCollectionPercent=int(parts[1])
              if (garbageCollectionPercent < 1 or garbageCollectionPercent > 99):
                print "Garbage collection percentage should be a number between 1 and 99"
                sys.exit(1)
            except ValueError:
                print "Garbage collection percentage should be a number between 1 and 99"
                sys.exit(1)
        elif (arg.startswith("-samplingPeriod:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            samplingPeriod=int(parts[1])
        elif (arg.startswith("-samplingUnit:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            samplingUnitParam=parts[1]
            if (samplingUnitParam == "minute"):
               samplingUnit = 2
            elif (samplingUnitParam == "hour"):
               samplingUnit = 3
        elif (arg.startswith("-reactionMode:")):
          parts = arg.split(":")
          if (parts[1] == "supervised" or parts[1] == "automatic" ):
            reactionMode=parts[1]
        elif (arg.startswith("-actions:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            actions=parts[1].split(",")
        elif (arg.startswith("-name:")):
          parts = arg.split(":")
          if (parts[1] != ""):
            healthPolicyName = parts[1]
        else:
          printGarbageCollectionPercentageUsageHelp(arg)
          sys.exit(1)

    createGarbageCollectionPercentagePolicy()
    
  elif (option == "setupDefaultPolicies"):
    createDefaultHealthPolicies()
    
  else:
     print "First option must be setupDefaultPolicies or setupExcessiveMemoryUsagePolicy or setupExcessiveRequestTimeoutPolicy or setupExcessiveResponseTimePolicy or setupMemoryLeakPolicy or setupStormDrainPolicy or setupMaximumAgePolicy or setupMaximumRequestsPolicy or setupGarbageCollectionPercentagePolicy"
     sys.exit(1)
     
  print "Saving workspace"
  AdminConfig.save()
  print "Done."

else:
  print "This script must be run with one of these options: setupDefaultPolicies or setupExcessiveMemoryUsagePolicy or setupExcessiveRequestTimeoutPolicy or setupExcessiveResponseTimePolicy or setupMemoryLeakPolicy or setupStormDrainPolicy or setupMaximumAgePolicy or setupMaximumRequestsPolicy or setupGarbageCollectionPercentagePolicy"

