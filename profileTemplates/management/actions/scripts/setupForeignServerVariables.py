#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# setupForeignServerVariables - creates variables referenced by foreign server templates
#
# @author - annblack
#
# Change History
# --------------
# 08-11-2006 initial version created
# 01-09-2007 removed the WASCE_ADMINNAME, WASCE_ADMINPSWD, WEBLOGIC_ADMINNAME, WEBLOGIC_ADMINPSWD
#            variables since they are now stored as part of process definition
# 08-15-2007 added the WAS51_HOME and WAS6_HOME variables
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
option = ""
if (len(sys.argv) > 0):
    option = sys.argv[0]

if (option == "-cleanup"):
    varNames = ["WLP_INSTALL_DIR","WLP_USER_DIR","WLP_OUTPUT_DIR","GERONIMO_HOME","WASCE_ADMINNAME","WASCE_ADMINPSWD","JBOSS_HOME","CATALINA_HOME","WEBLOGIC_ADMINHOST","WEBLOGIC_ADMINPORT","WEBLOGIC_ADMINPROTOCOL","WEBLOGIC_ADMINURL","WEBLOGIC_SERVERROOT","WEBLOGIC_HOME","WEBLOGIC_DOMAINNAME","WEBLOGIC_ADMINNAME","WEBLOGIC_ADMINPSWD","WEBLOGIC_DOMAINDIR","BEA_HOME","WAS51_HOME","WAS6_HOME"]
    removeCellVariable(varNames)
else:
    osname = getMajorityNodeOS()
    # Set up variables for WASCE/Geronimo
    print("Creating WASCE/Geronimo variables ... ")
    if (osname == ManagedObjectMetadataHelper.NODE_OS_WINDOWS):
       createCellVariable("GERONIMO_HOME","C:\\Program Files\\IBM\\WebSphere\\AppServerCommunityEdition","WebSphere Community Edition Default Install Location for Windows")
    else:
       createCellVariable("GERONIMO_HOME","/opt/IBM/WebSphere/AppServerCommunityEdition","WebSphere Community Edition Default Install Location for Unix")

    print("WASCE/Geronimo variable creation completed.")

    # Set up variables for JBoss
    print("Creating JBoss variables ... ")
    if (osname == ManagedObjectMetadataHelper.NODE_OS_WINDOWS):
       createCellVariable("JBOSS_HOME","C:\\Program Files\\jboss","JBoss Distribution Default Install Location for Windows")
    else:
       createCellVariable("JBOSS_HOME","/usr/local/jboss","JBoss Distribution Default Install Location for Unix")
    print("JBoss variable creation completed.")

    # Set up variables for TomCat
    print("Creating TomCat variables ... ")
    if (osname == ManagedObjectMetadataHelper.NODE_OS_WINDOWS):
       createCellVariable("CATALINA_HOME","C:\\Program Files\\Apache Software Foundation\\Tomcat","TomCat Default Install Location for Windows")
    else:
       createCellVariable("CATALINA_HOME","/usr/local/apache-tomcat","TomCat Default Install Location for Unix")
    print("TomCat variable creation completed.")

    # Set up variables for Liberty
    print("Creating Liberty variables ... ")
    createCellVariable("WLP_INSTALL_DIR", "${WAS_INSTALL_ROOT}/wlp", "Liberty Default Install Location")
    createCellVariable("WLP_USER_DIR",    "${WLP_INSTALL_DIR}/usr",  "Liberty Default usr Directory Location")
    createCellVariable("WLP_OUTPUT_DIR",  "${WLP_USER_DIR}/servers", "Liberty Default Output Directory Location")
    print("Liberty variable creation completed.")
    
    # Set up variables for WebLogic
    print("Creating WebLogic variables ... ")
    createCellVariable("WEBLOGIC_ADMINHOST","localhost","HostName of the WebLogic Admin Server")
    createCellVariable("WEBLOGIC_ADMINPORT","7001","Administrative port of the WebLogic Admin Server")
    createCellVariable("WEBLOGIC_ADMINPROTOCOL","t3","Communication protocol for the WebLogic Admin Server")
    createCellVariable("WEBLOGIC_ADMINURL","${WEBLOGIC_ADMINPROTOCOL}://${WEBLOGIC_ADMINHOST}:${WEBLOGIC_ADMINPORT}","Admin URL for the WebLogic Admin Server")
    createCellVariable("WEBLOGIC_SERVERROOT","${WEBLOGIC_DOMAINDIR}","WebLogic Server Root")
    createCellVariable("WEBLOGIC_HOME","${BEA_HOME}\\weblogic","Home directory of the WebLogic installation")
    createCellVariable("WEBLOGIC_DOMAINNAME","myDomain","Name of the WebLogic Domain")
    createCellVariable("WEBLOGIC_DOMAINDIR","${BEA_HOME}\\user_projects\\domains\\${WEBLOGIC_DOMAINNAME}","WebLogic domain directory")
    if (osname == ManagedObjectMetadataHelper.NODE_OS_WINDOWS):
       createCellVariable("BEA_HOME","C:\\bea","Home directory of the BEA product installations")
    else:
       createCellVariable("BEA_HOME","/opt/bea","Home directory of the BEA product installations")
    print("WebLogic variable creation completed.")

# Save off configuration
print ("Saving variables")
AdminConfig.save()
print("variable creation successful.")



