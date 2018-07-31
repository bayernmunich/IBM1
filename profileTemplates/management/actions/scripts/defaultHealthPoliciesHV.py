#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# defaultHealthPolicies  - creates default health policies
#
# @author - bkmartin, hee
# Date Created: 11/28/2005
#

import sys
lineSeparator = java.lang.System.getProperty('line.separator')

def doesHealthPolicyExist(healthPolicyName):
   hpids = AdminConfig.list("HealthClass")
   hpList = hpids.split(lineSeparator)
   for hp in hpList:
     hp = hp.rstrip()
     hp = hp.replace("\"","")
     if (hp.split("(")[0] == healthPolicyName):
        print "INFO: Health policy of name "+healthPolicyName+" already exists."
        return 1
   return 0

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

print "Creating... DefaultMemoryLeakPolicy"
createDefaultMemoryLeakPolicy()
print "Creating... DefaultExcessiveMemoryUsagePolicy"
createDefaultExcessiveMemoryUsagePolicy()
print "Creating... DefaultExcessiveRequestTimeoutPolicy"
createDefaultExcessiveRequestTimeoutPolicy()
print "Creating... DefaultExcessiveResponseTimePolicy()"
createDefaultExcessiveResponseTimePolicy()
print "Saving workspace"
AdminConfig.save()
print "Finished."
