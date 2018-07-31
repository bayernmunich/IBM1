#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# setupBusinessGridVariables - creates variables required by Business Grid
#
# @author - Alvin Tan
#
# Change History
# --------------
# 09-25-2006 initial version created
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
	    varNames = ["GRID_JOBLOG_ROOT"]
	    removeCellVariable(varNames)

else:
    osname = getMajorityNodeOS()
    
    # Set up variables for Grid job log location
    print("Creating Business Grid variables ... ")
    createCellVariable("GRID_JOBLOG_ROOT","${WAS_INSTALL_ROOT}/joblogs","Grid endpoint job logs directory")
    createCellVariable("DERBY_JDBC_DRIVER_PATH","${WAS_INSTALL_ROOT}/derby/lib","Derby driver directory for default grid database")
    
    
# Save off configuration
print ("Saving variables")
AdminConfig.save()
print("variable creation successful.")
    


