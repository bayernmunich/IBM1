#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# setupExtWasServerVariables - creates variables referenced by foreign server templates
#
# @author - Mcgill Quinn
#
# Change History
# --------------
# 07-27-2007 initial version created
# 
#=======================================================================================
from java.lang import String
from com.ibm.websphere.management.metadata import ManagedObjectMetadataHelper

def removeCellVariable(varNames):
	# check if something of the same name already exists
	varEntries_str = AdminConfig.showAttribute(getCellVariables(),"entries")
	if (len(varEntries_str) > 2):
	   varEntries = String(varEntries_str).substring(1,len(varEntries_str)-1).split(" ")
	   for var in varEntries:
	      name = AdminConfig.showAttribute(var,"symbolicName")
	      if(name in varNames):
		   print("Removing "+name)
		   AdminConfig.remove(var)
        return
	

def createCellVariable(varName, varValue, varDesc):
	# check if something of the same name already exists
	varEntries_str = AdminConfig.showAttribute(getCellVariables(),"entries")
	if (len(varEntries_str) > 2):
	   varEntries = String(varEntries_str).substring(1,len(varEntries_str)-1).split(" ")
	   for var in varEntries:
	      name = AdminConfig.showAttribute(var,"symbolicName")
	      if(name == varName):
		   print("Variable "+varName+" already exists, skipping creation.")
		   return
	   
        vse = AdminConfig.create("VariableSubstitutionEntry",getCellVariables(),[["symbolicName",varName],["value",varValue],["description",varDesc]])
	print("Variable "+varName+" created.")
	return vse

def getMajorityNodeOS():
	names = getNodeNames()
	osMap = {}
	for name in names:
	   os = AdminTask.getNodePlatformOS(['-nodeName',name])
           counter = 1
	   if (osMap.has_key(os)):
	      counter = osMap[os]
	      counter = counter+1
	   osMap[os] = counter
	keys = osMap.keys()
	p = 0
	name = ""
	for key in keys:
	    c = osMap[key]
	    if (c > p):
               p = c
	       name = key
	return name
 	   
def getNodeNames():
	nodes = AdminConfig.list("Node").split("\n")
	names = []
	for node in nodes:
		node = node.rstrip()
		if (node != ""):
			name = AdminConfig.showAttribute(node,"name")
			names.append(name)
	return names

def getCellVariables():
	cellName = getCellName()
	varMap = AdminConfig.getid('/Cell:'+cellName+'/VariableMap:/')
	return varMap


def getCellName():
	cell = AdminConfig.getid('/Cell:/')
	name = AdminConfig.showAttribute(cell,"name")
	return name

#############################
# Begin main execution
#############################
if (len(sys.argv) > 0):
    option = sys.argv[0]
    if (option == "-cleanup"):
	    varNames = ["WAS51_HOME","WAS6_HOME"]
	    removeCellVariable(varNames)

#    else:
#       osname = getMajorityNodeOS()
    
       # Set up variables for External WebSphere Application Server
#       print("Create External WebSphere Application Server variables...")
#       if (osname == ManagedObjectMetadataHelper.NODE_OS_WINDOWS):
#           createCellVariable("WAS51_HOME", "C:\\Program Files\\IBM\\WebSphere", "WebSphere AppServer 5.1 Default Install Location for Windows")
#           createCellVariable("WAS6_HOME", "C:\\Program Files\\IBM\\WebSphere", "WebSphere AppServer 6.x Default 6.x Install Location for Windows")
#       else:
#           createCellVariable("WAS51_HOME", "/opt/IBM/WebSphere", "WebSphere AppServer 5.1 Default Install Location for Unix")
#           createCellVariable("WAS6_HOME", "/opt/IBM/WebSphere", "WebSphere AppServer 6.x Default Install Location for Unix")
    	   
print("External WebSphere Application Server variable creation completed.")
    		 
    
# Save off configuration
print ("Saving variables")
AdminConfig.save()
print("variable creation successful.")
    


