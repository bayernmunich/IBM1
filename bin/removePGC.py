#=======================================================================================================================================================
#(C) Copyright IBM Corp. 2007 - All Rights Reserved.
#DISCLAIMER:
#The following source code is sample code created by IBM Corporation.
#This sample code is provided to you solely for the purpose of assisting you
#in the  use of  the product. The code is provided 'AS IS', without warranty or
#condition of any kind. IBM shall not be liable for any damages arising out of your
#use of the sample code, even if IBM has been advised of the possibility of
#such damages.
#=======================================================================================================================================================

#=======================================================================================================================================================
# This file contains a series of operations to remove the Grid Execution Environment (GEE) application
#
# Change History
# --------------
# 30-10-07 initial version created
#=======================================================================================================================================================

import sys
lineSeparator  = java.lang.System.getProperty("line.separator")
fileSeparator  = java.lang.System.getProperty("file.separator")
wasInstallRoot = java.lang.System.getProperty("was.install.root")
osname         = java.lang.System.getProperty("os.name");


def printHelp():
  print """

  Show help:
      >> wsadmin -lang jython -f removePGC.py --help

  List the targets which have Grid Execution Environment (GEE):
      >> wsadmin -lang jython -f removePGC.py --list

  Remove GEE from a target:
      >> wsadmin -lang jython -f removePGC.py <target>

      Example:
      >> wsadmin -lang jython -f removePGC.py cell=myCell,cluster=Endpoint1
  
  You may have to modify wsadmin to wsadmin.sh or wsadmin.bat, depending upon your operating environment.
  
  """
    


def getTargets(option):

    targetList = []
    count = 0
    geeAppName = ""

    try:
        list = AdminConfig.list('Deployment')
        results = list.split(lineSeparator)
        for result in results: 
           appls = result.split("(")        
           name = appls[0].split("_")
           if name[0] == "PGCController":
              output = AdminApp.view(appls[0], ["-MapModulesToServers"])
              lines = output.split(lineSeparator)
              for line in lines:
                  server = line.split(":  ")
                  if server[0] == "Server":
                      targets = server[1].split("+")
                      for target in targets:
                          targetList.append(target[10:len(target)])
                          if option == target[10:len(target)]:
                             geeAppName = appls[0]
                             count = count + 1
                      break
    except:
        pass
        
    return targetList, geeAppName, count



def listTargets(option):

    print ""
    targets, name, count = getTargets(option)
    
    if len(targets) == 0:
        print "INFO: No Grid Execution Environment was found"
        return

    if len(targets) == 1:
        print "INFO: Grid Execution Environment was found on following target: "
        print "      " + targets[0]
        return
       
    print "INFO: Grid Execution Environment was found on following targets: "
    for target in targets:
         print "      " + target



def isTarget(target):
    targets, name, count = getTargets(target)
    for t in targets:
         if t == target:
             return "true"
    return "false"



def getClusterName(target):
    names = target.split(",")
    for name in names:
        cluster = name.split("=")
        if cluster[0] == "cluster":
            return cluster[1]
    
    return ""

def getNodeName(target):
    names = target.split(",")
    for name in names:
        node = name.split("=")
        if node[0] == "node":
            return node[1]
    
    return ""

def getServerName(target):
    names = target.split(",")
    for name in names:
        server = name.split("=")
        if server[0] == "server":
            return server[1]
    
    return ""

def getCellName(target):
    names = target.split(",")
    for name in names:
        cell = name.split("=")
        if cell[0] == "cell":
            return cell[1]
    
    return "*"
    


def isGEEStartedOn(target):

    cluster = getClusterName(target)

    if cluster == "":
        beans = AdminControl.queryNames("WebSphere:type=Application,name=PGCController," + target + ",*")
        if len(beans) == 0:
           if getNodeName(target) == "":
              name = "PGCController_" + getServerName(target)
           else:
           	  name = "PGCController_" + getNodeName(target) + "_" + getServerName(target)
           beans = AdminControl.queryNames("WebSphere:type=Application,name=" + name + "," + target + ",*")	     
           if len(beans) == 0:
              retryTarget = target.split("server=")
              if len(retryTarget) == 2:
                  beans = AdminControl.queryNames("WebSphere:type=Application,name=PGCController," + retryTarget[0] + "Server=" + retryTarget[1] + ",*")
                  if len(beans) == 0:
                    beans = AdminControl.queryNames("WebSphere:type=Application,name=" + name + "," + retryTarget[0] + "Server=" + retryTarget[1] + ",*")
                    if len(beans) == 0:
                      return "false"
        return "true"

    clusterBean = AdminControl.queryNames("WebSphere:type=Cluster,name=" + cluster + ",*")
    clusterInfo = AdminControl.invoke(clusterBean, "dumpClusterInfo")
    clusterInfoLines = clusterInfo.splitlines()
    for line in clusterInfoLines:
        if line.find("Member Object Name:") > -1:
            if line.find("WebSphere:") > -1:
                return "true"
    
    # second try
    beans = AdminControl.queryNames("WebSphere:type=Application,name=PGCController,*")
    if len(beans) == 0:
      beans = AdminControl.queryNames("WebSphere:type=Application,name=PGCController_" + cluster + ",*")
      geeMBeans = beans.split(lineSeparator)
      for geeMBean in geeMBeans:
        if geeMBean.find(cluster) > -1:
            return "true"

    return "false"
    

def save():
  print "INFO: Saving configuration..."
  AdminConfig.save()
  dmgrbean = AdminControl.queryNames("type=DeploymentManager,*")
  AdminControl.invoke(dmgrbean, "syncActiveNodes", "true")
  print "INFO: Configuration was saved and synchronized to the active nodes"

  

def removeTarget(target):

    print ""

    if isTarget(target) == "false":
        print "INFO: Grid Execution Environment was not found on " + target
        return
    
    if isGEEStartedOn(target) == "true":
        print "WARN: Unable to remove Grid Execution Environment (PGCController) since PGCController is running on " + target + ". " + \
              "Please stop the target and then retry."
        return

    targets, geeAppName, count = getTargets(target)
    
    if count == 1:
        print AdminApp.uninstall(geeAppName)
    else:
        print AdminApp.edit(geeAppName, ['-MapModulesToServers', [['.*', '.*', '-WebSphere:' + target]]])        
    print "INFO: Removed Grid Execution Environment (" + geeAppName + ") at target " + target
    save()    



#=======================================================================================================================================================
#
# Main execution logic:
#
#=======================================================================================================================================================

if len(sys.argv) > 0:
    option = sys.argv[0]
    if option == "--help":
        printHelp()
    elif option == "--list":
        sys.exit(listTargets(option))
    else:
        sys.exit(removeTarget(option))
else:
    printHelp()
