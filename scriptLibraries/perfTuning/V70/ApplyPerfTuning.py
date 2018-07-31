###############################################################################
# Licensed Material - Property of IBM
# 5724-I63, 5724-H88, 5733-W70 (C) Copyright IBM Corp. 2010 - All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# DISCLAIMER:
# The following source code is sample code created by IBM Corporation.
# This sample code is provided to you solely for the purpose of assisting you
# in the  use of  the product. The code is provided 'AS IS', without warranty or
# condition of any kind. IBM shall not be liable for any damages arising out of your
# use of the sample code, even if IBM has been advised of the possibility of
# such damages.
###############################################################################
#-----------------------------------------------------------------------------
# File Name:
#      ApplyPerfTuning.py
# Purpose:
#      Apply pre-defined performance tuning templates to a specific
#      application server instance or all instances in a cluster. Three
#      templates are pre-defined (default, peak, and development);
#      however, these files can easily be modified to create your own custom
#      tuning template.
#
# This script includes the following procedures :
#	Ex1	PerfTuneProcess		
#
#-----------------------------------------------------------------------------
import os
import re
import shutil
#-------------------------------------------------
# Pre-defined Constants
#-------------------------------------------------
predefinedTemplateList = ["peak.props", "development.props", "default.props"]
IBMJDKoptions = "-Dcom.ibm.xml.xlxp.jaxb.opti.level=3"
# To enable verboseGC log rolling, we could use the following:
#  -Xverbosegclog:,10,80
# This maintains of 10 logs of 80 GC entries each (which is approximately 100MB
# Dictionary containing suggested generic JVM arguments for each platform
platform_genericJVM_params = {
	"windows" : IBMJDKoptions,
	"aix" :     IBMJDKoptions,
	"linux" :   IBMJDKoptions,
	"solaris" : "-XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -Dcom.ibm.xml.xlxp.jaxb.opti.level=3 -Xms256M -Xmx512M",
	"hpux" :    "-XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:+ForceMmapReserved -XX:+UseSpinning -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.DevPollSelectorProvider -Dcom.ibm.xml.xlxp.jaxb.opti.level=3 -Xms256M -Xmx512M",
	"os390" :   "",						# zOS/os390 options are handled seperately below
	"os400" :   IBMJDKoptions			# Note: os400/iSeries JDK tuning options only applicable to IBM J9 Java Technology
}
# The zOS JVMs cannot be updated through property file based config, so must manage those
# settings within the script. Furthermore, the default servant JVM sizes differ from those
# on distributed platforms
zOS_jvm_template_params = {
	"default" :     {"minHeap" : 256, "maxHeap" : 512, "verboseGC" : "false", "genericJVMArgs" : ""},
	"development" : {"minHeap" : 256, "maxHeap" : 512, "verboseGC" : "true",  "genericJVMArgs" : " -Dcom.ibm.xml.xlxp.jaxb.opti.level=3"},
	"peak" :  {"minHeap" : 512, "maxHeap" : 512, "verboseGC" : "true", "genericJVMArgs" : " -Dcom.ibm.xml.xlxp.jaxb.opti.level=3"},
}
# Since property file based config does not support wildcards at this time, must maintain
# logic within the script to update those settings.
datasource_template_params = {
	"default" :     {"minPoolSize" : 1,  "maxPoolSize" : 10, "preparedStmtCache" : 10},
	"development" : {"minPoolSize" : 1,  "maxPoolSize" : 10, "preparedStmtCache" : 10},
	"peak" :  {"minPoolSize" : 10, "maxPoolSize" : 50, "preparedStmtCache" : 50},
}

#--------------------------------------------------------------------------------------------------------------------------
#Function Name	:	PerfTuneProcess
#Input		:	options(Which is of type HashMap contains servername nodename template or clustername and template)
#Description	:	This is the main function which performs all the tuning based on the HashMap it recieves.
#--------------------------------------------------------------------------------------------------------------------------
import sys
def PerfTuneProcess(options) :
        servers = []
        clusterInfo = {}

        if (options.has_key("clusterName")):
                clusterInfo = resolveClusterTarget(options)
                servers = clusterInfo["serverInfoList"]
        elif (options.has_key("nodeName") and options.has_key("serverName")):
                info = resolveServerTarget(options)
                servers.append(info)
        #endIf

        templateFile = resolveTemplateFileTarget(options)
        templateName = templateFile["short"].split(".props")[0]

        for serverInfo in servers:
                print ""
                print "Applying server level tuning parameters for server:"
                printServerInfo(serverInfo)

                print ""
                print "  Applying tuning parameters using property based configuration..."

                # Setup variableMaps for property files
                skipForZOS = "false"
                # Used to skip JVM section in properties file, allowing python script to set z/OS servant JVM options
                if (serverInfo["nodePlatformOS"] == "os390"):
                        skipForZOS = "true"
                #endIf

                # Used to support JVM arguments for different platforms
                osGenericJVMArgs = platform_genericJVM_params[serverInfo["nodePlatformOS"]]
                if (templateName == "default"):
                        osGenericJVMArgs = ""
                #endIf

                variableMap = '['
                variableMap += '["cellName" "' + serverInfo["cell"] + '"]'
                variableMap += '["nodeName" "' + serverInfo["node"] + '"]'
                variableMap += '["serverName" "' + serverInfo["server"] + '"]'
                variableMap += '["skipForZOS" "' + skipForZOS + '"]'
                if (osGenericJVMArgs != ""):
                        variableMap +='["osGenericJVMArgs" "' + osGenericJVMArgs + '"]'
                #endIf
                variableMap += ']'

                #Use logs directory for logfile.
                logFileName = "";
                logFilePath = getLogDirectoryForNode(serverInfo["node"])
                if (logFilePath == ""):
                        print "  NOTE: Logfile will be available in directory, where command was ran"
                        logFileName = 'perfTuning.log'
                else :
                        logFileName = logFilePath+'/logs/perfTuning.log'
                #endIf
                print "  Log File : %s " %logFileName

                # Only for iSeries , copy the template file to logs folder and use it.
                if (serverInfo["nodePlatformOS"] == "os400"):
                        dirForTemplateFile = logFilePath+"/logs"
                        shutil.copy2(templateFile["long"], dirForTemplateFile)
                        templateFile["long"] = dirForTemplateFile+'/'+templateFile["short"]
                #endIf
                print "  Template File : %s " % templateFile["long"]

                # Call the AdminTask to apply the tuning found in the properties file
                AdminTask.applyConfigProperties('-propertiesFileName \"' + templateFile["long"] + '\"  -reportFileName  \"'+logFileName+'\"  -variablesMap ' + variableMap)

                print "  NOTE: Please consult the report.log file to review results of property"
                print "    based configuration."


                print ""
                print "  Applying additional tuning parameters via normal wsadmin processing..."

                # z/OS servant JVMs must be configured via wsadmin scripting
                if (serverInfo["nodePlatformOS"] == "os390"):
                        jvmArgs = zOS_jvm_template_params[templateName]
                        servantJVMs = findZOSServantJVMs(serverInfo["serverId"])
                        applyJvmTuning(servantJVMs, jvmArgs)
                #endIf

                # JDBC DataSource properties must also be configured using wsadmin scripting
                # since property file based config does not support wildcards for config objects
                dsArgs = datasource_template_params[templateName]
                jdbcDatasources = AdminConfig.list("DataSource", serverInfo["serverId"]).splitlines()
                applyJDBCDatasourceTuning(jdbcDatasources, dsArgs)

                print ""
                print "Server level tuning complete!"
        #endFor

        if (options.has_key("clusterName")):
                print ""
                print "Applying cluster level tuning parameters for cluster:"
                printClusterInfo(clusterInfo)

                dsArgs = datasource_template_params[templateName]
                jdbcDatasources = AdminConfig.list("DataSource", clusterInfo["clusterId"]).splitlines()
                applyJDBCDatasourceTuning(jdbcDatasources, dsArgs)

                print ""
                print "Cluster level tuning complete!"
        #endIf

        # Save the configuration changes
        print ""
        print "Saving the configuration changes..."
        AdminConfig.save()
        print "NOTE: Server may require restart for all tuning changes to take effect."
        print "Script completed!"



#-------------------------------------------------
# Utility Methods
#-------------------------------------------------

def getServerInfo(configId):
	result = {}

	# If quotes surround the configId, remove them
	if (configId[0] == '"' and configId[-1] == '"' and configId.count('"') == 2):
		configId = configId[1:-1]
	#endIf

	result["serverId"] = configId

	# Ensure the configId is formated correctly
	mo = re.compile( r'^([\w|\-]+)\(([^|]+)\|[^)]+\)$' ).match(configId)
	if (mo):
		result["server"] = mo.group(1);
		hier = mo.group(2).split('/');

		for i in range(0, len(hier), 2):
			(name, value) = hier[i], hier[i + 1]
			if name.endswith('s') :            # If name is plural, make is singular
				name = name[:-1]
			#endIf
			result[name] = value
		#endFor

		# Save more useful information in the dictionary
		result["serverType"]         = AdminConfig.showAttribute(configId, "serverType")
		result["cellId"]             = cellId = AdminConfig.getid('/Cell:%s/' % result["cell"])
		result["cellType"]           = AdminConfig.showAttribute(cellId, "cellType")
		result["nodeId"]             = AdminConfig.getid('/Node:%s/' % result["node"])
		result["nodePlatformOS"]     = AdminTask.getNodePlatformOS(['-nodeName', result["node"]])
		result["nodeProductVersion"] = AdminTask.getNodeBaseProductVersion(['-nodeName', result["node"]])
	else:
		print "ERROR: Unexpected/invalid configuration ID: %s" % configId
		printUsage()
	#endElse

	return result


def printServerInfo (serverInfo):
	print "  ----------------------------------------------------------------------"
	print "  Cell:%36s  Type:%22s" % (serverInfo["cell"], serverInfo["cellType"])
	print "  Node:%36s  Platform:%18s" % (serverInfo["node"], serverInfo["nodePlatformOS"])
	print "       %36s  Version:%19s" % (" ", serverInfo["nodeProductVersion"])
	print "  Server:%34s  Type:%22s" % (serverInfo["server"], serverInfo["serverType"])
	print "  ----------------------------------------------------------------------"


def printClusterInfo (clusterInfo):
	print "  ----------------------------------------------------------------------"
	print "  Cluster:%33s  Type:%22s" % (clusterInfo["cluster"], clusterInfo["clusterServerType"])
	print "  ----------------------------------------------------------------------"


def findZOSServantJVMs (serverId):
	jvms = []

	print ""
	print "    NOTE: z/OS environment detected - identifying SERVANT processes..."
	processDefs = AdminConfig.list("ProcessDef", serverId).splitlines()

	for pd in processDefs:
		processType = AdminConfig.showAttribute(pd, "processType")
		if (processType == "Servant"):
			jvms.append(AdminConfig.list("JavaVirtualMachine", pd))
		#endif
	#endfor

	return jvms


def isCustomTemplate (template):
	return predefinedTemplateList.index(template) == -1


def resolveClusterTarget (options):
	targetClusterId = ""
	clusterInfo = {}
	serverInfoList = []

	print ""
	print "Resolving cluster targets..."

	targetClusterId = AdminConfig.getid("/ServerCluster:%s/" % options["clusterName"])

	if (targetClusterId == ""):
		clusters = AdminConfig.list("ServerCluster").splitlines()
		print "ERROR: Unable to resolve cluster name: %s." % options["clusterName"]
		print "   Available clusters include: "
		for clusterId in clusters:
			print "      %s" % AdminConfig.showAttribute(clusterId, "name")
		#endFor
		printUsage()
	#endIf

	clusterMembers = AdminConfig.list("ClusterMember", targetClusterId).splitlines()

	for member in clusterMembers:
		targetServer = AdminConfig.getid("/Node:%s/Server:%s/" %  (AdminConfig.showAttribute(member, "nodeName"), AdminConfig.showAttribute(member, "memberName")))
		info = getServerInfo(targetServer)
		serverInfoList.append(info)
	#endFor

	clusterInfo["clusterId"] =         targetClusterId
	clusterInfo["cluster"] =           options["clusterName"]
	clusterInfo["serverInfoList"] =    serverInfoList
	clusterInfo["clusterServerType"] = AdminConfig.showAttribute(targetClusterId, "serverType")

	return clusterInfo



def resolveServerTarget (options):
	targetNodeId = ""
	targetServerId = ""

	print ""
	print "Resolving node and server targets..."

	targetServerId = AdminConfig.getid("/Node:%s/Server:%s/" % (options["nodeName"],options["serverName"]))

	if (targetServerId == ""):
		servers = AdminConfig.list("Server").splitlines()
		print "ERROR: Unable to resolve node or server name: %s, %s." % (options["nodeName"],options["serverName"])
		print "   Available Node and Server combinations include: "
		for serverId in servers:
			info = getServerInfo(serverId)
			if (info["serverType"] == "APPLICATION_SERVER"):
				print "      %s - %s" % (info["node"],info["server"])
			#endIf
		#endFor
		printUsage()
	#endIf

	info = getServerInfo(targetServerId)

	#printServerInfo(info)

	if (info["serverType"] != "APPLICATION_SERVER"):
		print "ERROR: Performance tuning parameters cannot be applied to server type %s." % info["serverType"]
		printUsage()
	#endIf

	if (not info["nodeProductVersion"].startswith("7.0") and not info["nodeProductVersion"].startswith("8.0") and not info["nodeProductVersion"].startswith("8.5")):
		print "ERROR: Performance tuning template can only be applied to v7.0.0.x servers and above."
		printUsage()
	#endIf

	return info


def resolveTemplateFileTarget (options):
        if (not os.path.isfile(options["templateFile"])):
                print "ERROR: Unable to locate template file: %s." % options["templateFile"]
                printUsage()
        #endIf

	templateFileShort = os.path.basename(options["templateFile"])
        templateFileLong = os.path.abspath(options["templateFile"])

        # check for custom template
        if (isCustomTemplate (templateFileShort)):
                print "WARNING: Custom template file (%s) detected." % templateFileShort
        #endIf

        return {"short" : templateFileShort, "long" : templateFileLong}

def printUsage ():
	print ""
	print "Usage: wsadmin -f applyPerfTuningTemplate.py [-nodeName <node> -serverName <server>] [-clusterName <cluster>] -templateFile <file>"
	print ""
	print "      Used together to target a specific server instance for tuning. Cannot be"
	print "      used in conjunction with the -clusterName option."
	print "   -clusterName"
	print "      Used to target all server instances in a cluster for tuning. Cannot be "
	print "      used in conjunction with the -nodeName and -serverName options."
	print "   -templateFile"
	print "      Determines which property file template to use for performance tuning."
	print ""
	sys.exit()

def applyJvmTuning (jvms, jvmArgs):
	for jvmId in jvms:
		print ""
		print "    Applying JVM tuning parameters to " + jvmId
		#print "       Initial Heap Size (old/new):       %s/%s" % (AdminConfig.showAttribute(jvmId, "initialHeapSize"),str(jvmArgs["minHeap"]))
		#print "       Maximum Heap Size (old/new):       %s/%s" % (AdminConfig.showAttribute(jvmId, "maximumHeapSize"),str(jvmArgs["maxHeap"]))
		#print "       Verbose GC (old/new):              %s/%s" % (AdminConfig.showAttribute(jvmId, "verboseModeGarbageCollection"),jvmArgs["verboseGC"])
		#print "       Generic Arguments (old/new):       %s/%s" % (AdminConfig.showAttribute(jvmId, "genericJvmArguments"),jvmArgs["genericJVMArgs"])
		attrs = [["initialHeapSize", jvmArgs["minHeap"]], ["maximumHeapSize", jvmArgs["maxHeap"]], ["genericJvmArguments", jvmArgs["genericJVMArgs"]], ["verboseModeGarbageCollection",jvmArgs["verboseGC"]]]
		AdminConfig.modify(jvmId, attrs)
	#endFor

def applyJDBCDatasourceTuning (datasources, datasourceArgs):
	for dsId in datasources:
		print ""
		print "    Applying Datasource tuning parameters to %s" % AdminConfig.showAttribute(dsId, "name")

		connPoolId = AdminConfig.showAttribute(dsId, "connectionPool")
		#print "       Connection Pool MaxSize [old/new]:   %s/%s" % (AdminConfig.showAttribute(connPoolId, "maxConnections"),str(datasourceArgs["maxPoolSize"]))
		#print "       Connection Pool MinSize [old/new]:   %s/%s" % (AdminConfig.showAttribute(connPoolId, "minConnections"),str(datasourceArgs["minPoolSize"]))
		attrs = [["maxConnections", datasourceArgs["maxPoolSize"]], ["minConnections", datasourceArgs["minPoolSize"]]]
		AdminConfig.modify(connPoolId, attrs)

		#print "       Statement Cache Size [old/new]:      %s/%s" % (AdminConfig.showAttribute(dsId, "statementCacheSize"),str(datasourceArgs["preparedStmtCache"]))
		attrs = [["statementCacheSize", datasourceArgs["preparedStmtCache"]]]
		AdminConfig.modify(dsId, attrs)
	#endFor

def getLogDirectoryForNode(nodeForVar):
		varScope = "Node="+nodeForVar
		varName ="USER_INSTALL_ROOT"
		varValue = AdminTask.showVariables("[ -scope " +  varScope +  "  -variableName  " + varName +" ]" )
		return varValue



