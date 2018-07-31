#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# script for setting the customer property HAManagedItemPreferred_apc 
#
# author: sunj

import sys            

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
#        elif (propName == "HAManagedItemPreferred_cellagent"):
#          AdminConfig.remove(property)
      print "Pinning APC and cell agent controllers to DMGR"
#        AdminConfig.create('Property', jvmEntry, '[[name "HAManagedItemPreferred_cellagent"] [value "true"]]')
      AdminConfig.create('Property', jvmEntry, '[[name "HAManagedItemPreferred_apc"] [value "true"]]')
        
      break
    break


#
# main program
#

pinAPCToDMGR()
       
print "saving workspace"
AdminConfig.save()
print "finished."

