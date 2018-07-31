import sys
import java.lang.System  as  jsys

lineSeparator  = jsys.getProperty('line.separator')
fileSeparator  = jsys.getProperty('file.separator')

defaultAppName     = "PGCController"

scriptName         = "pgc.py"


#------------------------------------------------------------------------------
# Install the application
#------------------------------------------------------------------------------

def install(wasHome, cell, cluster, node, server, appname):

    
    webModuleName = "PGCController"
    warName     = webModuleName + ".war"
    xmlName     = warName + ",WEB-INF/web.xml"
    
    cellName    = "WebSphere:cell=" + cell
    systemApps  = "$(WAS_INSTALL_ROOT)" + fileSeparator + "systemApps"         
    earPath     = wasHome + fileSeparator + "systemApps" + fileSeparator + defaultAppName + ".ear"
    

    if cluster != "":
        msg = "cluster " + cluster
        installTarget         = [ "-cluster", cluster ]
        MapModulesToServers   = [ [".*", ".*", cellName + ",cluster=" + cluster ] ]

    else:
        msg = "node/server " + node + "/" + server
        installTarget         = [ "-node", node, "-server", server ]
        MapModulesToServers   = [ [".*", ".*", cellName + ",node=" + node + ",server=" + server ] ]


    
    uninstall(cluster,appname)
    

    options = [ 
                "-nopreCompileJSPs",
                "-distributeApp",
                "-noreloadEnabled",
                "-noprocessEmbeddedConfig",
                "-usedefaultbindings",
                "-zeroEarCopy",

                installTarget,

    
                "-MapModulesToServers",             MapModulesToServers,
    

                "-appname",                         appname, 
                "-installed.ear.destination",       systemApps
              ]
    
    AdminApp.install(earPath, options)
    
    save(cluster)
    
    startApplication(cell, cluster, node, server, appname)

    if appname != defaultAppName:
        msg = msg + " using application name " + appname

    print "INFO: installed " + defaultAppName + " to " + msg 


#------------------------------------------------------------------------------
# Start the application 
#------------------------------------------------------------------------------

def startApplication(cell, cluster, node, server, appname):

    if cluster != "":
        appManager = AdminControl.completeObjectName( "WebSphere:*,type=AppManagement,process=dmgr" )
        parameters = "[ " +  appname + " null null ]"
        signature = "[ java.lang.String java.util.Hashtable java.lang.String ]"
        AdminControl.invoke( appManager, 'startApplication', parameters, signature )
    else:
        appManager = AdminControl.queryNames( "cell=" + cell + ",node=" + node + ",type=ApplicationManager,process=" + server + ",*" )
        AdminControl.invoke( appManager, 'startApplication', appname )



#------------------------------------------------------------------------------
# Uninstall the PGCProxyController
#------------------------------------------------------------------------------

def uninstall(cluster,appname):
    try: 
        AdminApp.uninstall(appname)
        result = "removed"
    except:
        result = ""

    if result == "removed":
        save(cluster)


#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------

def usage(msg):
    print ""
    print scriptName + " : " + msg
    print ""
    print "Usage: wsadmin " + scriptName + " -install -cluster <clusterName>"
    print "  or:  wsadmin " + scriptName + " -install -node <nodeName> -server <serverName>"
    print "  or:  wsadmin " + scriptName + " -remove -cluster <clusterName>"
    print "  or:  wsadmin " + scriptName + " -remove -node <nodeName> -server <serverName>"
    print ""
    print "  -install is the default if -remove is not specified"
    print ""
    print "  either  -cluster  or  -node and -server  is required"
    print ""
    print ""
    print "  the following option may be specified with -install and must be"
    print "    specified with -remove if not defaulted"
    print "  -appname <appname> is optional and defaults to "   + defaultAppName
    print ""
    sys.exit(101)

#------------------------------------------------------------------------------
# Save the configuration
#------------------------------------------------------------------------------
def save(cluster):
    AdminConfig.save()
    if cluster != "":
        dmgrbean = AdminControl.queryNames("type=DeploymentManager,*")
        AdminControl.invoke(dmgrbean, "syncActiveNodes", "true")
        msg = "Configuration was saved and synchronized to the active nodes"
    else:
        msg = "Configuration was saved"

    print scriptName + " INFO: " + msg

#------------------------------------------------------------------------------
# Set the variable to the passed value if it has not already been set
#------------------------------------------------------------------------------
def setOpt(oldValue, newValue):
    if oldValue != "":
        usage( "duplicate option" )
    else:
        return newValue

#------------------------------------------------------------------------------
# Set the variable to the next arg value if it has not already been set
#------------------------------------------------------------------------------
def setArg(oldValue, argIndex):
    if oldValue != "":
        usage( "duplicate argument" )
    elif argIndex == len(sys.argv):
        usage( "missing value" )
    else:
        return sys.argv[argIndex]

#------------------------------------------------------------------------------
# Process the passed arguements
#------------------------------------------------------------------------------
def getArgs():
    actionType  = ""
    clusterName = ""
    nodeName    = ""
    serverName  = ""
    appName     = ""
    

    i = 0

    while i < len(sys.argv):

        if sys.argv[i] == "-install":
            actionType = setOpt(actionType, "install")
        elif sys.argv[i] == "-remove":
            actionType = setOpt(actionType, "remove")
        elif sys.argv[i] == "-appname":
            i += 1
            appName = setArg(appName, i)
        elif sys.argv[i] == "-cluster":
            i += 1
            clusterName = setArg(clusterName, i)
        elif sys.argv[i] == "-node":
            i += 1
            nodeName = setArg(nodeName, i)
        elif sys.argv[i] == "-server":
            i += 1
            serverName = setArg(serverName, i)
        else:
            usage( "unrecognized argument: " + sys.argv[i] )

        i += 1

    

    if clusterName != "":
        if nodeName != "":
            usage( "either -cluster or -node and -server required" )
        elif serverName != "":
            usage( "either -cluster or -node and -server required" )
    elif nodeName == "":
        usage( "either -cluster or -node and -server required" )
    elif serverName == "":
        usage( "either -cluster or -node and -server required" )

    if actionType == "":
        actionType = "install"

    if appName == "":
        appName = defaultAppName
    

    return (actionType, clusterName, nodeName, serverName, appName)

#------------------------------------------------------------------------------
# Get the directory, as a string, where WAS is installed.
#------------------------------------------------------------------------------
def getWASHome(cell, cluster, node):
    nodeName = node;
    if nodeName == "":
        topology = getCellNodeServer()
        nodeName = topology[1]
    varMap = AdminConfig.getid("/Cell:" + cell + "/Node:" + nodeName + "/VariableMap:/")
    entries = AdminConfig.list("VariableSubstitutionEntry", varMap)
    eList = entries.splitlines()
    for entry in eList:
        name =  AdminConfig.showAttribute(entry, "symbolicName")
        if name == "WAS_INSTALL_ROOT":
            value = AdminConfig.showAttribute(entry, "value")
            return value
    
    return java.lang.System.getenv('WAS_HOME')

#------------------------------------------------------------------------------
# Get a tuple containing the cell, node, server name, and type
#------------------------------------------------------------------------------
def getCellNodeServer():
    servers = AdminConfig.list("Server").splitlines()
    for serverId in servers:
        serverName = serverId.split("(")[0]
        server = serverId.split("(")[1]  #remove name( from id
        server = server.split("/")
        cell = server[1]
        node = server[3]
        cellId = AdminConfig.getid("/Cell:" + cell + "/")
        cellType = AdminConfig.showAttribute(cellId, "cellType")
        print "cell: " + cell
        print "node: " + node
        #print "cellId: " + cellId
        #print "cellType: " + cellType
        if cellType == "DISTRIBUTED":
            if AdminConfig.showAttribute(serverId, "serverType") == "DEPLOYMENT_MANAGER":
                return (cell, node, serverName, "DEPLOYMENT_MANAGER") 
        elif cellType == "STANDALONE":
            if AdminConfig.showAttribute(serverId, "serverType") == "APPLICATION_SERVER":
                return (cell, node, serverName, "APPLICATION_SERVER") 
    return None	

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

failOnError = "false" 

if len(sys.argv) < 1 or len(sys.argv) > 5:
	usage( "too many or too few arguments" )

args = getArgs()

action   = args[0]
cluster  = args[1]
node     = args[2]
server   = args[3]
appname  = args[4]


if action == "install":
    print ""
    print "appname:  " + appname
    if cluster != "":
        print "cluster:  " + cluster
    else:
        print "node:     " + node
        print "server:   " + server
    print ""

cell = AdminControl.getCell()

wasHome = getWASHome(cell,cluster,node)


if action == "install":
    install(wasHome,cell,cluster,node,server,appname)
else:
    uninstall(cluster,appname)

