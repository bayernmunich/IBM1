# This program may be used, executed, copied, modified and distributed
# without royalty for the purpose of developing, using, marketing, or distribution

#-------------------------------------------------------------------------
# This is a sample script to remove the MapPlatformSubject JAAS login module from the
# system login entries in order to enable the z/OS SAF feature of identity propagation.
# The script can update the global security configuration
# or a specific security domain. 
#
# If no options are specified, the script will remove the login module from
# the global security configuration.
# If the -securityDomain option is specified, the script will remove the login
# module from the security domain.
#
# The DeploymentManager server does not need to be running for the script to work.
# However, the node synchronization will not work. 
#
# Any running server should be synchronized and restarted after this script finishes 
# to pick up the changes.
#
# Typical syntax would be:
#   wsadmin.sh -conntype NONE -lang jython -f /path/to/script/removeMapPlatformSubject.py
#		-securityDomain <securityDomainName>
#
#   wsadmin.sh -conntype NONE -lang jython -f /path/to/script/removeMapPlatformSubject.py 
#		-scripthelp
#-------------------------------------------------------------------------

from time import sleep
import java
import sys

#-------------------------------------------------------------------------------
# the class name of the JAAS login module to remove
#-------------------------------------------------------------------------------
className = "com.ibm.ws.security.common.auth.module.MapPlatformSubject"
proxyClassName = "com.ibm.ws.security.common.auth.module.proxy.WSLoginModuleProxy"

#-------------------------------------------------------------------------------
# the comma-separated list of JAAS system logins to check
#-------------------------------------------------------------------------------
systemLoginList = ["DEFAULT", "RMI_INBOUND", "WEB_INBOUND", "SWAM_ZOSMAPPING"]

#-------------------------------------------------------------------------------
# internal variables
#-------------------------------------------------------------------------------
lineSeparator = java.lang.System.getProperty('line.separator')
debug = 0 # 1 prints each map as it goes, 2 also prints attribute name and value of each attribute
flag = ""
helpSpecified  = 'false'
securityDomain = None
parm = 0

#-------------------------------------------------------------------------------
# check if base or nd environment
#-------------------------------------------------------------------------------
def whatEnv():
	global AdminControl, lineSeparator, cellName, nodeName, flag
	try:
		nodeName = AdminControl.getNode()
		cellName = AdminControl.getCell()
	except:
		print "\nAdminControl.getNode() caught an exception. If this is an ND environment, rerun without CONNTYPE=NONE. \nException:", sys.exc_info()
		return
	command = "AdminControl.completeObjectName('type=Server,node=" + nodeName + ",cell=" + cellName + ",*')"
	serverList = eval(command)
	server = serverList.split(lineSeparator)[0]
	processType = AdminControl.getAttribute(server,'processType')
	# find out what environment
	if processType == "DeploymentManager":
   		# nd environment
   		flag = 'nd'
	elif (processType == "ManagedProcess" or processType == "NodeAgent"):
		print "\nThis script was not run by connecting to dmgr process"
		print "\nPlease rerun the script connecting to dmgr process"
		return
	elif (processType == "AdminAgent"):
		flag = 'adminagent'
	else:
		# base environment
		flag = 'base'
	return
	
#-------------------------------------------------------------------------------
# Split the config id's into a list
#-------------------------------------------------------------------------------
def split_ids(cfgIds):
	"""
	Splits the given space-separated config-id's into a list. A single config-id is assumed if leading & trailing quotes are present.
	"""
	# eliminate the beginning "[" and the end "]"
	cfgIds = cfgIds[1:len(cfgIds)-1]
	if not (cfgIds.startswith('"') and cfgIds.endswith('"')): return cfgIds.split()
	return [ cfgIds[1:len(cfgIds)-1] ]

	
#-------------------------------------------------------------------------------
# remove specified entry from list of System Logins
#-------------------------------------------------------------------------------
def removeLoginModule():
	global AdminControl, AdminTask, systemLoginList, securityDomain
	foundLogin = "false"
	if len(systemLoginList) != 0:
		securityConfigId = ""
		try:
			if (securityDomain is None):
				securityConfigId = AdminConfig.list('Security')
			else:
				securityConfigId = AdminConfig.list('AppSecurity', '(waspolicies/default/securitydomains/'+securityDomain+'|domain-security.xml#AppSecurity_*')
		except:
			print "\nAdminConfig.list() caught an exception:\n", sys.exc_info()
			return
		if (securityConfigId == ""):
			print "\nCould not get the security configuration ID. No action will be taken."
			return
		if debug > 0: print '\nsecurityConfigId: ' + securityConfigId
		try:
			systemLoginConfig = AdminConfig.showAttribute(securityConfigId, "systemLoginConfig")
		except:
			print "\nThe security configuration does not have any system logins defined. No action will be taken."
			return
		try:
			systemLogins = AdminConfig.showAttribute(systemLoginConfig,"entries")
		except:
			print "\nThe security configuration does not have any entries defined for the system logins. No action will be taken."
			return
		
		systemLogins = split_ids(systemLogins)
		for systemLogin in systemLogins:
			try:
				alias = AdminConfig.showAttribute(systemLogin, "alias")
			except:
				if debug > 0: print '\nNo alias was found for the system login.'
			if debug > 0: print '\nChecking for match in ' + alias 
			if (alias in systemLoginList):
				if debug > 0: print '\nFound matching systemLogin'
				try:
					loginModules = AdminConfig.showAttribute(systemLogin, "loginModules")
				except:
					if debug > 0: print '\nNo login Modules were found for the system login.'
					continue
				loginModules = split_ids(loginModules)
				for loginModule in loginModules:
					try:
						loginClass = AdminConfig.showAttribute(loginModule, "moduleClassName")
					except:
						if debug > 0: print '\nNo moduleClassName was found for the system login.'
						continue
					if debug > 0: print '\nLogin class is: ' + loginClass
					if (loginClass == className):
						removeLoginCommand = ""
						if (securityDomain is None):
							removeLoginCommand = "-loginType system -loginEntryAlias " + alias	+	" -loginModule " + loginClass
						else:
							removeLoginCommand = "-loginType system -loginEntryAlias " + alias	+	" -loginModule " + loginClass + " -securityDomainName " + securityDomain
						try:
							AdminTask.unconfigureLoginModule(removeLoginCommand)
						except:
							print "\nAdminTask.unconfigureLoginModule(" + removeLoginCommand + ") caught an exception\n", sys.exc_info()
							return	
						print "\nRemoved login " + loginClass + " from systemLogin : " + alias
						foundLogin = "true"
					elif (loginClass == proxyClassName):
						try:
							loginOptions = AdminConfig.showAttribute(loginModule, "options")
						except:
							if debug > 0: print '\nNo login options were found for the system login.'
							continue
						loginOptions =  split_ids(loginOptions)
						for loginOption in loginOptions:
							try:
								optionName = AdminConfig.showAttribute(loginOption, "name")
							except:
								if debug > 0: print '\nNo name was found for the login option.'
								continue
							if debug > 0: print "\nLogin option name: " + optionName
							if (optionName == "delegate"):
								try:
									optionValue = AdminConfig.showAttribute(loginOption, "value")
								except:
									if debug > 0: print '\nNo value was found for the login option.'
									continue
								if debug > 0: print "\nLogin option value: " + optionValue
								if (optionValue == className):
									if debug > 0: print "\nFound login set as delegate."
									try:
										AdminConfig.remove(loginModule)
									except:
										print "\nAdminConfig.remove(loginModule) caught an exception\n", sys.exc_info()
										return
									print "\nRemoved login " + loginClass + " that was set as delegate from systemLogin : " + alias
									foundLogin = "true"
									
	if (foundLogin == "false"):
		print "\nNo matches were found. No action will be taken."
	
	return foundLogin

#-------------------------------------------------------------------------------
# force to do the sync here and put in wait to give time for sync to finish
#-------------------------------------------------------------------------------
def forceSync():
	global AdminControl
	try:
		nodeSyncObjects = AdminControl.queryNames("type=NodeSync,*")
		if len(nodeSyncObjects) > 0:
			nodeSyncObjectList = nodeSyncObjects.split("\r\n")
			for nodeSync in nodeSyncObjectList:
				syncResult = "false"
				count = 0
				while syncResult != "true" and count < 5:
					print "\nForce NodeSync on " + nodeSync
					try:
						syncResult = AdminControl.invoke(nodeSync, "sync", "")
						print "\nSync result on " + nodeSync + " is " + syncResult
					except:
						print "\nAdminControl.invoke(" + nodeSync + ", 'sync', '') caught an exception\n", sys.exc_info()
					count = count + 1
				if syncResult != "true":
					print "\nUnable to sync " + nodeSync
			print "\nTime out for 30 seconds to make sure sync is done"
			sleep(30)
	except:
		print "\nAdminControl.queryNames('type=NodeSync,*') caught an exception\n", sys.exc_info()
	return

#-------------------------------------------------------------------------------
# Call the function to search for and remove the JAAS login module, 
# then save and sync the changes.
#-------------------------------------------------------------------------------
def callRemoveAndSave():
	global classname, systemLoginList, securityDomain
	if (securityDomain is None):
		print "\nUpdating the global security configuration. Will remove the JAAS login module " + className + " from the following JAAS system logins: " 
		print  systemLoginList 
	else:
		print "\nUpdating the security domain " + securityDomain + ". Will remove the JAAS login module " + className + " from the following JAAS system logins: "
		print  systemLoginList
	foundLogin = removeLoginModule()
	if (foundLogin == "true"):
		AdminConfig.save()
		print "\nChanges have been saved.\n"
		whatEnv()
		if (flag != 'base' and flag != ""):
			forceSync()
		if (flag == ""):
			print "\nChanges were NOT synchronized.  You must synchronize the changes."
	print "\nEnd of script."

	return

#-------------------------------------------------------------------------------
# Main entry. Parse the command line parameters
#-------------------------------------------------------------------------------
for thisarg in sys.argv :
	if thisarg == '-trace':
		debug = 1
	if thisarg == '-securityDomain':
		securityDomain = sys.argv[parm+1]
	if thisarg == '-scripthelp':
		print "\nThis script removes the specified JAAS login module from the specified list of system logins from the security configuration. If the -securityDomain option is not specified, they are removed from the global security configuration."
		print "\nUsage: wsadmin.sh -lang jyton -f removeJAASLoginModulesForIdentityPropagation.py [-secyrityDomain <securityDomainName>] [-scripthelp] [-trace]"
		helpSpecified = 'true'
	parm = parm + 1

if (helpSpecified == 'false'):
	callRemoveAndSave()