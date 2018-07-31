#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# defaultElasticityPoliciesHV  - creates default Elasticity Polices
# @author - mcgillq
# Date Created: 4/12/2011
# 
# Updated to handle VSYS.NEXT environment - rvscott - 6/19/2014

import os, sys
lineSeparator = java.lang.System.getProperty('line.separator')

from java.util import Properties
from java.io import BufferedReader
from java.io import InputStreamReader
from java.io import FileReader
from java.lang import Runtime

##################################################################
# These next three functions are to determine how the current HyperVisor
# system is set up and who is handling the Elasticity requests. 
##################################################################
def getPropertyFromFile(pfile, prop) :
   input = BufferedReader(FileReader(pfile))
   props = Properties()
   props.load(input)
   input.close()
   return props.getProperty(prop,"")

def runElasticityProviderScript(elasticityProviderScript) :
   cmd = "sudo python " + elasticityProviderScript
   process = Runtime.getRuntime().exec(cmd)
   output = BufferedReader(InputStreamReader(process.getInputStream()))
   sysType = "UNKNOWN"
   while 1:
     data = output.readLine()
     if (data == "CLASSIC") or (data == "VSYS.NEXT") :
       sysType = data
     if not data : break
   return sysType

def getElasticityProvider() :
   virtProp = "/etc/virtualimage.properties"
   maestroProp = "/etc/maestro.properties"
   topoJson = "/0config/topology.json"
   if not os.path.exists(virtProp) :
     return "UNKNOWN"
   if (not os.path.exists(maestroProp)) or (not os.path.exists(topoJson)) :
     return "CLASSIC"
   elasticityProviderScript = getPropertyFromFile(virtProp, "WAS_CONTROL_HOME") + "/getElasticityProvider.py"
   if not os.path.exists(elasticityProviderScript) :
     return "UNKNOWN"
   return runElasticityProviderScript(elasticityProviderScript)


##################################################################
# The Elasticity actions will be configured depending on the 
# Elasticity provider determined above.
# The Class and Actions are set up if not configured.
# If configured, then they are verified and corrected if needed.
##################################################################
def getElasticityPolicyClass(cell, elasticityPolicyName):
   global configChanged
   hpids = AdminConfig.list("ElasticityClass", cell)
   if len(hpids) > 0 :
     for hp in hpids.split(lineSeparator) :
       epn = AdminConfig.showAttribute(hp, "name")
       if  epn == elasticityPolicyName : 
         print "INFO: Elasticity policy of name "+elasticityPolicyName+" already exists."
         return hp
   print "INFO: Elasticity policy of name "+elasticityPolicyName+" was created."
   configChanged=1
   return AdminConfig.create("ElasticityClass",cell,[["name",elasticityPolicyName],["description",""],["reactionMode","2"]])

def updateElasticityAction(cell, policyName, newActions, removeAction) :
   global configChanged
   curActions=[]
   policyId = getElasticityPolicyClass(cell, policyName)
   eal=AdminConfig.list("ElasticityAction", policyId)
   if len(eal) > 0 :
     for action in eal.split(lineSeparator) :
       type=AdminConfig.showAttribute(action, "actionType")
       if type==removeAction :    # we must be a promoted pattern.  Delete old action.
         print "INFO: Removing the " + type + " action from the " + policyName + " Policy."
         ea=AdminConfig.remove(action)
         configChanged=1
       else :
         curActions.append(type)
   index=0
   for action in newActions :
     if not action in curActions :
       print "INFO: Adding the " + action + " action to the " + policyName + " Policy."
       ea=AdminConfig.create("ElasticityAction",policyId,[["actionType",action],["stepNum",index+1]])
       configChanged=1
     index = index+1

def createAddElasticityPolicy(provider, cell):
   elasticityPolicyName="Add"
   if provider =="CLASSIC":
     orderedActionList = ["ADDVMFROMWCA","ADDNODETODCACTION"]
     eActionToDelete="ADDVMFROMMAESTRO"
   else :
     orderedActionList = ["ADDVMFROMMAESTRO","ADDNODETODCACTION"]
     eActionToDelete="ADDVMFROMWCA"
   updateElasticityAction(cell, elasticityPolicyName, orderedActionList, eActionToDelete)

def createRemoveElasticityPolicy(provider, cell):
   elasticityPolicyName="Remove"
   if provider == "CLASSIC" :
     orderedActionList = ["REMOVENODEACTION","REMOVEVMFROMWCA"]
     eActionToDelete="REMOVEVMFROMMAESTRO"
   else :
     orderedActionList = ["REMOVENODEACTION","REMOVEVMFROMMAESTRO"]
     eActionToDelete="REMOVEVMFROMWCA"
   updateElasticityAction(cell, elasticityPolicyName, orderedActionList, eActionToDelete)

def increaseElasticityTimeout(cell):
   apc=AdminConfig.list("AppPlacementController", cell)
   oldTimeout=AdminConfig.showAttribute(apc, "modeTimeOut")
   if int(oldTimeout) < 20 :
     attrs=[["modeTimeOut", "20"]]
     AdminConfig.modify(apc, attrs)
     configChanged=1
     print "INFO: The elasticity timeout value has been increased to 20 minutes for the VSYS.NEXT elasticity actions." 
	
##################################################################
# MAIN STARTS HERE   
elasticityProvider=getElasticityProvider()
print "INFO: This script validates and updates the elasticity configuration settings for a HyperVisor " + elasticityProvider + " system type."
if elasticityProvider=="CLASSIC" or elasticityProvider=="VSYS.NEXT" :
  configChanged=0
  cell=AdminConfig.list("Cell")
  print "Creating... AddElasticityPolicy"
  createAddElasticityPolicy(elasticityProvider, cell)
  print "Creating... RemoveElasticityPolicy"
  createRemoveElasticityPolicy(elasticityProvider, cell)
  if elasticityProvider=="VSYS.NEXT" :
    increaseElasticityTimeout(cell)
  if configChanged :
    print "Saving workspace"
    AdminConfig.save()
  else :
    print "INFO: The elasticity commands and actions were already configured correctly."
else :
  print "INFO: Could not determine elasticity provider.  The elasticity commands and actions were not changed."

print "Finished."