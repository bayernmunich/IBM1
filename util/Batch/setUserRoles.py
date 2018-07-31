import os
import sys

lineSep = java.lang.System.getProperty('line.separator')

def authorizeAllAuthenticated():
	try:
		AdminApp.edit('LongRunningScheduler', '[ -MapRolesToUsers [[ lrmonitor AppDeploymentOption.No AppDeploymentOption.Yes "" "" AppDeploymentOption.No "" "" ][ lrsubmitter AppDeploymentOption.No AppDeploymentOption.Yes "" "" AppDeploymentOption.No "" "" ][ lradmin AppDeploymentOption.No AppDeploymentOption.Yes "" "" AppDeploymentOption.No "" "" ]]]' )
	except:
		print "Exception occurred setting roles for LongRunningScheduler application"
		return 1
	return 0

def authorizeEveryone():
	try:
		AdminApp.edit('LongRunningScheduler', '[ -MapRolesToUsers [[ lrmonitor AppDeploymentOption.Yes AppDeploymentOption.No "" "" AppDeploymentOption.No "" "" ][ lrsubmitter AppDeploymentOption.Yes AppDeploymentOption.No "" "" AppDeploymentOption.No "" "" ][ lradmin AppDeploymentOption.Yes AppDeploymentOption.No "" "" AppDeploymentOption.No "" "" ]]]' )
	except:
		print "Exception occurred setting roles for LongRunningScheduler application"
		return 1
	return 0
	
def authorizeUser(user,realm):
	try:
		AdminApp.edit('LongRunningScheduler', ['-MapRolesToUsers [[ lrmonitor AppDeploymentOption.No AppDeploymentOption.No ' + user + ' "" AppDeploymentOption.No user:'+realm+'/uid='+user+',o='+realm+' "" ][ lrsubmitter AppDeploymentOption.No AppDeploymentOption.No ' + user + ' "" AppDeploymentOption.No user:'+realm+'/uid='+user+',o='+realm+' "" ][ lradmin AppDeploymentOption.No AppDeploymentOption.No ' + user + ' "" AppDeploymentOption.No user:'+realm+'/uid='+user+',o='+realm+' "" ]]'])
		#AdminApp.edit('LongRunningScheduler', ['-MapRolesToUsers [[ lrmonitor AppDeploymentOption.No AppDeploymentOption.No ' + user + ' "" AppDeploymentOption.No user:defaultWIMFileBasedRealm/uid='+user+',o=defaultWIMFileBasedRealm "" ][ lrsubmitter AppDeploymentOption.No AppDeploymentOption.No ' + user + ' "" AppDeploymentOption.No user:defaultWIMFileBasedRealm/uid='+user+',o=defaultWIMFileBasedRealm "" ][ lradmin AppDeploymentOption.No AppDeploymentOption.No ' + user + ' "" AppDeploymentOption.No user:defaultWIMFileBasedRealm/uid='+user+',o=defaultWIMFileBasedRealm "" ]]'])
	except:
		print "Exception occurred mapping roles for user " + user 
		return 1
	return 0

def enableApplicationSecurity():
	enabled = AdminTask.isAppSecurityEnabled()
	if enabled == 'false':
		print "Enabling application security."
		try:
			AdminTask.setAdminActiveSecuritySettings('-appSecurityEnabled true')
			AdminConfig.save()
		except:
			print "Exception occurred enabling application security"
			return 1
		return 0
#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

option = sys.argv[0]

if option == '-authorizeUser':
	user = sys.argv[1]
	realm = sys.argv[2]

retVal = enableApplicationSecurity()
if retVal == 1:
	print "Could not enable application security"
	sys.exit(retVal)

if option == '-authorizeAllAuthenticated':
	retVal = authorizeAllAuthenticated()
	if retVal == 0:
		print "Saving Config ..."
		AdminConfig.save()
		print "Saved Config"
	else:
		print "Skipping Config Save"
elif option == '-authorizeEveryone':
	retVal = authorizeEveryone()
	if retVal == 0:
		print "Saving Config ..."
		AdminConfig.save()
		print "Saved Config"
	else:
		print "Skipping Config Save"
elif option == '-authorizeUser':
	retval = authorizeUser(user,realm)
	if retVal == 0:
		print "Saving Config ..."
		AdminConfig.save()
		print "Saved Config"
	else:
		print "Skipping Config Save"
		
sys.exit(retVal)