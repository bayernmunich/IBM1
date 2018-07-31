import sys
import java.lang.System  as  jsys

fileSeparator  = jsys.getProperty('file.separator')

scriptName         = "redeployLRS.py"

defaultAppName     = "LongRunningScheduler"

PGCControllerName  = "PGCProxyController";
                                          

#------------------------------------------------------------------------------
# Redeploy the application
#------------------------------------------------------------------------------

def redeploy():

    wasHome     = java.lang.System.getenv('WAS_HOME')
    systemApps  = wasHome + fileSeparator + "systemApps"
    earPath     = systemApps + fileSeparator + defaultAppName + ".ear"
    pgcEarPath  = systemApps + fileSeparator + PGCControllerName + ".ear"


    print "Redeploying " + defaultAppName + "..."
    AdminApp.update(defaultAppName,'app','[-operation update -contents ' + earPath + ']')


    print "Redeploying " + PGCControllerName  + "..."
    AdminApp.update(PGCControllerName,'app','[-operation update -contents ' + pgcEarPath + ']')


    print "Saving config..."
    save()


#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------

def usage(msg):
    print ""
    print scriptName + " : " + msg
    print ""
    print "Usage: wsadmin " + scriptName 
    print ""
    sys.exit(101)

#------------------------------------------------------------------------------
# Save the configuration
#------------------------------------------------------------------------------
def save():
    AdminConfig.save()
    dmgrbean = AdminControl.queryNames("type=DeploymentManager,*")
    if dmgrbean != "":
        AdminControl.invoke(dmgrbean, "syncActiveNodes", "true")
        msg = "Configuration was saved and synchronized to the active nodes"
    else:
        msg = "Configuration was saved"

    print scriptName + " INFO: " + msg  

#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------

failOnError = "false" 

if len(sys.argv) > 0:
	usage( "too many or too few arguments" )

redeploy()

