#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
#
# script for enabling/disabling dynamic cluster elasticity mode
#
# author: Anil Ambati (aambati@us.ibm.com)

import sys

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split("\"")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist
     
def updateElasticityClasses():
   elasticityAddClass="Add"
   elasticityRemoveClass="Remove"
   ecids = AdminConfig.list("ElasticityClass")
   ecList = ecids.split(lineSeparator)
   for ec in ecList:
     name = AdminConfig.showAttribute(ec,"name")
     if (name == elasticityAddClass):
		ea1=AdminConfig.create("ElasticityAction",ec,[["actionType","ADDVMFROMWCA"],["stepNum","1"]])
		ea2=AdminConfig.create("ElasticityAction",ec,[["actionType","ADDNODETODCACTION"],["stepNum","2"]])
		print "Update Elasticity Class "+elasticityAddClass
     elif (name == elasticityRemoveClass):
		ea1=AdminConfig.create("ElasticityAction",ec,[["actionType","REMOVENODEACTION"],["stepNum","1"]])
		ea2=AdminConfig.create("ElasticityAction",ec,[["actionType","REMOVEVMFROMWC A"],["stepNum","2"]])
		print "Update Elasticity Class "+elasticityRemoveClass

def pinAPCToDMGR():
 nodes = convertToList(AdminConfig.list("Node"))
 for node in nodes:
    nodeName = AdminConfig.showAttribute(node,"name")
    serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:dmgr/")
    if (serverid != None and serverid != ""):
      setHAMItemCustomProperty(serverid)
 
def setHAMItemCustomProperty(dmgrId):
 processDefs = convertToList(AdminConfig.showAttribute(dmgrId,"processDefinitions"))
 for processDef in processDefs:
    jvmEntries = convertToList(AdminConfig.showAttribute(processDef,"jvmEntries"))
    for jvmEntry in jvmEntries:
      properties = convertToList(AdminConfig.list('Property', jvmEntry))
      for property in properties:
        propName = AdminConfig.showAttribute(property,"name")
        if (propName == "HAManagedItemPreferred_apc"):
          AdminConfig.remove(property)
        elif (propName == "HAManagedItemPreferred_cellagent"):
          AdminConfig.remove(property)
      if (enableConsolidationMode == 1):
        print "Pinning APC and cell agent controllers to DMGR"
        AdminConfig.create('Property', jvmEntry, '[[name "HAManagedItemPreferred_cellagent"] [value "true"]]')
        AdminConfig.create('Property', jvmEntry, '[[name "HAManagedItemPreferred_apc"] [value "true"]]')
        
      break
    break
 
#
# main()
#
enableConsolidationMode = 0
mode = 1
timeout = 120
timeoutUnit = 2
if (len(sys.argv)>0):
  for arg in sys.argv:
    if (arg == "enable"):
      enableConsolidationMode = 1
    elif (arg == "disable"):
      enableConsolidationMode = 0
    elif (arg.startswith("-mode:")):
      parts = arg.split(":")
      modeStr=parts[1]
      if (modeStr == "Supervised"):
        mode = 1
      elif (modeStr == "Automatic"):
        mode = 0
    elif (arg.startswith("-timeout:")):
      parts = arg.split(":")  
      try:
        timeout=int(parts[1])
      except ValueError:
        print "Elasticity operations time out must be a number"
        sys.exit(1)
    elif (arg.startswith("-timeoutUnit:")):
      parts = arg.split(":")  
      timeoutUnitStr = parts[1]
      if (timeoutUnitStr == "minute"):
        timeoutUnit = 2
    else:
      print "unrecognized option: "+arg
      print "available options:"
      print "\t-mode:<elasticity mode>                Elasticity mode. Valid values are 'Supervised' and 'Automatic'"
      print "\t-timeout:<time out value>              Elasticity operations time out. It must be a number"
      print "\t-timeoutUnit:<time out unit>           Elasticity operations time out unit. Valid values are 'minute'"
      sys.exit(1)
             
apc = AdminConfig.list("AppPlacementController")

if (enableConsolidationMode == 1):
  if (apc != ""):
    AdminConfig.modify(apc, [['enableElasticity',"true"],['consolidationMode',mode],['modeTimeOut', timeout],['modeTimeOutUnits', timeoutUnit]])
else:
    AdminConfig.modify(apc, [['enableElasticity',"false"],['consolidationMode', mode],['modeTimeOut',timeout],['modeTimeOutUnits',timeoutUnit]])

pinAPCToDMGR()

print "Saving the changes..."
AdminConfig.save()


