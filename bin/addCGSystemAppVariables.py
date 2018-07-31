#------------------------------------------------------------------------------
# add WebSphere Variable
#------------------------------------------------------------------------------
def createCellVariable(varName, varValue, varDesc):
	# check if something of the same name already exists
	varEntries_str = AdminConfig.showAttribute(getCellVariables(),"entries")
	if (len(varEntries_str) > 2):
	   varEntries_str =  varEntries_str[1:len(varEntries_str)-1] 
	   varEntries = varEntries_str.split(" ")
	   for var in varEntries:
	      name = AdminConfig.showAttribute(var,"symbolicName")
	      if(name == varName):
		   print "Variable "+varName+" already exists, skipping creation."
		   return
        AdminConfig.create("VariableSubstitutionEntry",getCellVariables(),[["symbolicName",varName],["value",varValue],["description",varDesc]])
	print "Variable "+varName+" created."
	return 
	
def getCellVariables():
	cellName = getCellName()
	varMap = AdminConfig.getid('/Cell:'+cellName+'/VariableMap:/')
	return varMap

def getCellName():
	cell = AdminConfig.getid('/Cell:/')
	name = AdminConfig.showAttribute(cell,"name")
	return name


#------------------------------------------------------------------------------
# add WebSphere Variable at Node
#------------------------------------------------------------------------------
def createNodeVariable(varName, varValue, varDesc, nodeName):
  print "createNodeVar" + nodeName
  cellName = getCellName()
  
  varMap = AdminConfig.getid("/Cell:" + cellName + "/Node:" + nodeName + "/VariableMap:/")
  
  entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
  
  eList = entries.splitlines()
  
  for entry in eList:
     name = AdminConfig.showAttribute(entry, "symbolicName")
     
     if name == varName:
        print "Variable "+varName+" already exists, skipping creation."
        return
    
  AdminConfig.create("VariableSubstitutionEntry",varMap,[["symbolicName",varName],["value",varValue],["description",varDesc]])
  print "Variable "+varName+" created."
  
  return        


def printHelp():
  print """

  Show help:
      >> wsadmin -lang jython -f addCGSystemAppVariables.py --help
      
  setup cell for migration from wcg :
      >> wsadmin -lang jython -f addCGSystemAppVariables.py -level <level to migrate from>

      valid values of level are wcg, wcg8, was8 and fep

  You may have to modify wsadmin to wsadmin.sh or wsadmin.bat, depending upon your operating environment.
  
  """
  
def createCGSystemVariable(level):
    cg6SystemAppLocation = "${WAS_INSTALL_ROOT}/systemApps"

    was8systemAppLocation = "${WAS_INSTALL_ROOT}/systemApps"

    fepSystemAppLocation =  "${WAS_INSTALL_ROOT}/feature_packs/BATCH/systemApps"

    cg8SystemAppLocation = "${WAS_INSTALL_ROOT}/stack_products/WCG/systemApps"

    sysAppLocation = ""
    isManaged = ""

    # Create cell level variable to be used to update the binaries_URL of  CG system apps
    createCellVariable("CG_SYSTEM_APP_LOCATION","${WAS_INSTALL_ROOT}/systemApps","Location of WCG system Apps")
    
    # create node level variable for CG system apps
    nodeList = AdminConfig.list("Node").split(lineSeparator)
    for node in nodeList:
        nodeName = AdminConfig.showAttribute(node,"name")
        serverEntries = AdminConfig.list("ServerEntry", node).split(lineSeparator)

        for serverEntry in serverEntries:
            if len(serverEntry) > 0:
                 serverType = AdminConfig.showAttribute(serverEntry, "serverType" )
                 if serverType == "NODE_AGENT":
                      isManaged = "true"
                 elif serverType == "DEPLOYMENT_MANAGER":
                      isManaged = "true"

        if isManaged == "true":
            if level == "wcg":
                sysAppLocation = cg6SystemAppLocation
            elif level == "was8":
                 sysAppLocation = was8systemAppLocation
            elif level == "wcg8":
                 sysAppLocation = cg8SystemAppLocation
            else:
                sysAppLocation = fepSystemAppLocation

        if isManaged == "true":
            createNodeVariable("CG_SYSTEM_APP_LOCATION",sysAppLocation,"Location of WCG system Apps",nodeName.split("(")[0])

        isManaged = ""

   
    print "saving workspace.."
    AdminConfig.save()
  

#=======================================================================================================================================================
#
# Main execution logic:
#
#=======================================================================================================================================================
level = "wcg"
if len(sys.argv) > 0:
    option = sys.argv[0]
    if option == "--help":
        printHelp()
    elif option == "-level":
        level = sys.argv[1]
        createCGSystemVariable(level)
    else:
        print "Invalid option specified."  
else:
    createCGSystemVariable(level)
    