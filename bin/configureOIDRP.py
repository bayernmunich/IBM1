#------------------------------------------------------------------------------
# OIDC Client application deployment/undeployment script
#  configure:
# wsadmin.sh -f configureOIDRP.py config oidOpHost oidOpPort realmName [name=value ...]
# wsadmin.sh -f configureOIDRP.py setproperty name=value ...
#
#  unconfigure:
# wsadmin.sh -f configureOIDRP.py unconfig
#------------------------------------------------------------------------------
import sys


#------------------------------------------------------------------------------
# Print script usage
#------------------------------------------------------------------------------
def printUsage():
	print "Usage: wsadmin -f <WAS_HOME>/bin/configureOIDRP.py help"
	print "  or:  wsadmin -f <WAS_HOME>/bin/configureOIDRP.py config (oidOpUrl) (realmName) [(name)=(value) ... ]"
	print "  or:  wsadmin -f <WAS_HOME>/bin/configureOIDRP.py config (oidOpUrl)  norealm    [(name)=(value) ... ]"
	print "  or:  wsadmin -f <WAS_HOME>/bin/configureOIDRP.py setproperty (name)=(value) ... "
	print "  or:  wsadmin -f <WAS_HOME>/bin/configureOIDRP.py unconfig"
	print ""

#------------------------------------------------------------------------------
# Unconfigure the application
#------------------------------------------------------------------------------
def doUnconfig():
	failOnError = "false"
	print "Unconfigureing the OpenID Relying Party interceptor..."
	try:
		AdminTask.unconfigureInterceptor("-interceptor com.ibm.ws.security.openid20.client.OpenIDRelyingPartyTAI")
		# AdminTask.configureTrustAssociation("-enable false")
		AdminConfig.save()
	except:
		print 'Failed to unconfigure the OID RP TAI interceptor ', sys.exc_info()[1]
	failOnError = "true"

#------------------------------------------------------------------------------
# Configure a custom property for the OpenID RP Trust Association Intercaptor (TAI)
#------------------------------------------------------------------------------
def setCustomProperty(pNameValue): 
	print "Configuring OpenID Relying Party interceptor custom property \"" + pNameValue + "\""
	AdminTask.configureInterceptor("-interceptor com.ibm.ws.security.openid20.client.OpenIDRelyingPartyTAI -customProperties '\""+pNameValue+"\"'")
	# AdminTask.configureInterceptor("-interceptor com.ibm.ws.security.openid20.client.OpenIDRelyingPartyTAI -customProperties '\"pName=pValue\"'")

#------------------------------------------------------------------------------
# Configure custom properties from argv for the OpenID RP Trust Association Intercaptor (TAI)
#------------------------------------------------------------------------------
def setCustomPropertiesFromArgv(argv, startAt):
	nowAt=startAt
        stopAt=len(argv)
	while nowAt < stopAt:
		setCustomProperty(argv[nowAt])
		nowAt += 1
	# Save the config after setting all custom properties requested
	AdminConfig.save()
	

#------------------------------------------------------------------------------
# given a URL, get the port number (assumes port 443 by default for https URLS)
#------------------------------------------------------------------------------
def getPortFromUrl(oidOpUrl):
	from java.net import URL
	url = URL(oidOpUrl)
	port = url.getPort()
	if port==-1 and	url.getProtocol()=="https":
		port=443
	return str(port)

#------------------------------------------------------------------------------
# given a URL, get the host string
#------------------------------------------------------------------------------
def getHostFromUrl(oidOpUrl):
	from java.net import URL
	url = URL(oidOpUrl)
	host = url.getHost()
	return host

#------------------------------------------------------------------------------
# Get the public signer certificate for a given HTTPS URL, and configure it into WebSphere's trust store
#------------------------------------------------------------------------------
def getOidOpSignerCert(oidOpUrl):
	# 
	failOnError = "false"
	cell=AdminControl.getCell()
	node=AdminControl.getNode()
	scope='(cell):%s:(node):%s' % (cell, node)
	oidophost=getHostFromUrl(oidOpUrl)
	oidopport=getPortFromUrl(oidOpUrl)
	#
	alias=oidOpUrl
	#
	# delete existing certificate
	try:
		AdminTask.deleteSignerCertificate('[-keyStoreName NodeDefaultTrustStore -keyStoreScope %s -certificateAlias %s ]' % (scope, alias))
	except:
		print 'Failed to delete OID OP certificate ', sys.exc_info()[1]
	# import OID OP certificate
	try:
		print 'AdminTask.retrieveSignerFromPort(' + scope + ',' + oidophost + ',' +  oidopport + ',' +  alias + ',' +  scope + ')'
		AdminTask.retrieveSignerFromPort('[-keyStoreName NodeDefaultTrustStore -keyStoreScope %s -host %s -port %s -certificateAlias %s -sslConfigName NodeDefaultSSLSettings -sslConfigScopeName %s ]' % (scope, oidophost, oidopport, alias, scope))
	except:
		print 'Failed to add the OID OP certificate ', sys.exc_info()[0], sys.exc_info()[1]
	AdminConfig.save()
	#
	certlist=AdminTask.listSignerCertificates('[-keyStoreName NodeDefaultTrustStore -keyStoreScope %s ]' % scope) 
	if certlist.find(alias) == -1:
		print 'Failed to import the certficate from OID OP server.. may need to correct it manually'
	else:
		print 'Successfully imported OID OP server certificate'
	failOnError = "true"

#------------------------------------------------------------------------------
# Initial Configuration for the OpenID RP Trust Association Interceptor (TAI)
#------------------------------------------------------------------------------
def doConfigure(oidOpUrl,realmName):
	getOidOpSignerCert(oidOpUrl)
	print "Cleaning up any existing OpenID Relying Party interceptor configurtion..."
	doUnconfig()
	if realmName=="norealm":
		print "norealm is specified - skipping the addTrustedRealms step"
	else: 
		print "Configuring the OpenID Relying Party interceptor..."
		AdminTask.addTrustedRealms('[-communicationType inbound -realmList ' + realmName + ']')
		setCustomProperty('realmName=%s' % realmName)
		print 'Added ' + realmName + ' as trusted Realm'
	AdminTask.configureTrustAssociation("-enable true")
	print 'Enabled trust association'
	AdminTask.setAdminActiveSecuritySettings('-customProperties  \'"com.ibm.websphere.security.performTAIForUnprotectedURI=true"\'')
	print 'performTAIForUnprotectedURI set to true'
	sys.stderr.write("about to call setCustomProperty for providerIdentifier=" + oidOpUrl + "\n")
	setCustomProperty("providerIdentifier="+oidOpUrl);
	sys.stderr.write("RETURNED FROM call setCustomProperty for " + oidOpUrl + "\n")
	AdminConfig.save()

#------------------------------------------------------------------------------
# runscript - run the script as a subroutine
#------------------------------------------------------------------------------
def runscript(args):
  failOnError = "true"

  mode = args[0]
  if mode == "help":
  	printUsage()
  else:
  	if mode == "config":
                  if len(args) > 2:
  			oidOpUrl = args[1]
  			realmName = args[2]
  			doConfigure(oidOpUrl, realmName)
  			setCustomPropertiesFromArgv(args,3)
                  else:
  			sys.stderr.write("Invalid number of arguments for config operation\n")
  	                printUsage()
  	                sys.exit(101)
  	elif mode == "setproperty":
                  if len(args) > 1 :
  			setCustomPropertiesFromArgv(args,1)
                  else:
  			sys.stderr.write("Invalid number of arguments for setproperty operation\n")
  	                printUsage()
  	                sys.exit(101)
  	elif mode == "unconfig":
                  if len(args) == 1:
  			doUnconfig()
                  else:
  			sys.stderr.write("Invalid number of arguments for unconfig operation\n")
  	                printUsage()
  	                sys.exit(101)
  	else:
  		sys.stderr.write("Invalid operation\n")
  		printUsage()
  		sys.exit(101)
  
#------------------------------------------------------------------------------
# Main entry point
#------------------------------------------------------------------------------
if len(sys.argv) > 0:
	runscript(sys.argv)

