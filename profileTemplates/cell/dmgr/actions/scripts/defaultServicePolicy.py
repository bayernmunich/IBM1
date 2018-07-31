#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# defaultServiceClass - creates default ServiceClass named "Default_SP"
# and a default TransactionClass named "Default_TC"
#
# @author - Michael Smith
# Date Created: 03/21/2005
#

import java.lang.Integer as Integer
import java.util.ArrayList as ArrayList
import java.lang.Exception as JavaException
import java.rmi.server.UID as UID


#
# Finds the service class in WAS repository.
#
# @param aSCName   The name of the service class to look up.
# @return name    The name of the service class if it exists or 
#                None if it does not exists.
# 
def findServiceClass(aSCName):  
   scName = AdminConfig.getid("/ServiceClass:"+aSCName+"/")
   if (scName == ""):
       return None
   else:
       return scName


##
# Creates a Default Service Class and a Default Transaction Class for the
# Default Service Class.
##
def createDefaultServiceClass():
   defaultServiceClass=""
   defaultTransactionClass=""
   cell=AdminConfig.list("Cell")
   if (findServiceClass("Default_SP") == None):
       tcattributes = [ ["name","Default_TC"],
                        ["description",""]]
       scattributes = [ ["name","Default_SP"],
                        ["description",""]]

       defaultServiceClass=AdminConfig.create("ServiceClass",cell,scattributes)
       #Add in the goal type
       AdminConfig.create("DiscretionaryGoal",defaultServiceClass,[])
       #Add a TC
       defaultTransactionClass=AdminConfig.create("TransactionClass",defaultServiceClass,tcattributes)

print "creating... DefaultServiceClass"
createDefaultServiceClass()
print "Default Service Class created."
print "Default Transaction Class created."
print "saving workspace"
AdminConfig.save()
print "finished."
