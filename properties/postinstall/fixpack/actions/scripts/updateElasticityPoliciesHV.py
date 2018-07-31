#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# updateElasticityPoliciesHV  - updates default Elasticity Polices
# @author - sunj
# Date Created: 5/15/2012
#

import sys
lineSeparator = java.lang.System.getProperty('line.separator')

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split(lineSeparator)
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def doesActionTypeExist(ep, typeName):
   print "INFO: input action type name is " +typeName+ "." 
   eaList = convertToList(AdminConfig.showAttribute(ep,"ElasticityAction"))
   for ea in eaList:
      eac=AdminConfig.showall(ea)
      if (eac.find(typeName) != -1):
         print "INFO: Elacticitiy action type " +typeName+ " found."
         return 1        
   return 0

def updateAddElasticityPolicyActionType(ep):
   if not doesActionTypeExist(ep, "ADDVMFROMWCA"):
       ea=AdminConfig.create("ElasticityAction",ep,[["actionType","ADDVMFROMWCA"],["stepNum","1"]])
   if not doesActionTypeExist(ep, "ADDNODETODCACTION"):
       ea=AdminConfig.create("ElasticityAction",ep,[["actionType","ADDNODETODCACTION"],["stepNum","2"]])

def updateRemoveElasticityPolicyActionType(ep):
    if not doesActionTypeExist(ep, "REMOVENODEACTION"):
        ea=AdminConfig.create("ElasticityAction",ep,[["actionType","REMOVENODEACTION"],["stepNum","1"]])
    if not doesActionTypeExist(ep, "REMOVEVMFROMWCA"):
        ea=AdminConfig.create("ElasticityAction",ep,[["actionType","REMOVEVMFROMWCA"],["stepNum","2"]])


epids = AdminConfig.list("ElasticityClass")
epList = epids.split(lineSeparator)
for ep in epList:
  if (AdminConfig.showAttribute(ep,"name") == "Add"):
     print "Updating... AddElasticityPolicyActionType"
     updateAddElasticityPolicyActionType(ep)
  elif (AdminConfig.showAttribute(ep,"name") == "Remove"):
     print "Updating... RemoveElasticityPolicyActionType"
     updateRemoveElasticityPolicyActionType(ep)

print "Saving workspace"
AdminConfig.save()
print "Finished."
