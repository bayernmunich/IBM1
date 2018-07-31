import java, time, os, os.path, re, sys;
import WAuJ_utilities as WAuJ;


def processFile(result) : 

	node    = result.get( 'NodeName', '' )
    	server  = result.get( 'ServerName', '' )
    	
    	print 'Node/%s and Server/%s \n' % (node, server)
    	configId = AdminConfig.getid( '/Node:%s/Server:%s/' % ( node, server ) )

    	try :  #look for a reachable MBean -if not, empty string
    		MBean = AdminConfig.getObjectName( configId )
    	except : 
    		MBean = '' 
    	print 'MBean is %s\n' %MBean
    	
    	sad = WAuJ.showAsDict( configId )
#    	print 'sad is %s\n' %sad
    	pd  = sad.get( 'processDefinitions', '[]' )[ 1:-1 ].split( ' ' )
#    	print 'pd is %s' %pd
    	pdDict = WAuJ.showAsDict( pd[ 0 ] );
    	jvm = pdDict.get( 'jvmEntries', '[]' )[ 1:-1 ].split( ' ' );
#    	print 'jvm is %s' %jvm
    	jvm = jvm[ 0 ]
    	jvmDict = WAuJ.showAsDict( jvm )
#    	print 'jvmDict is %s\n' %jvmDict
    	if jvmDict.has_key( 'genericJvmArguments' ) :
    		oldJvmArgs = jvmDict[ 'genericJvmArguments' ]
    	else : 
    		oldJvmArgs = ' '
    	if jvmDict.has_key( 'verboseModeClass' ) :
    		oldVMC = jvmDict[ 'verboseModeClass' ]
    	else : 
    		oldVMC = ''
    	
	ts  = AdminConfig.list( 'TraceService', configId )
	print 'ts is %s\n' %ts
	tsD = WAuJ.showAsDict( ts )
#	print 'tsD is %s\n' %tsD
	tl  = AdminConfig.list( 'TraceLog', ts )
	print 'tl is %s\n' %tl
	tlD = WAuJ.showAsDict( tl )
	print 'tlD is %s\n' %tlD
	
	tsD.update( tlD )
	tsD[ 'oldJvmArgs' ] = oldJvmArgs
	tsD[ 'oldVMC'  ] = oldVMC
	tsD[ 'logRoot' ] = logRoot = WAuJ.unravel( tlD[ 'fileName' ], configId )
	print 'tsD is %s\n' %tsD
	
	restoreVals=''' 
Old.JVMargs=%(oldJvmArgs)s
Old.verboseModeClass=%(oldVMC)s
Old.enable=%(enable)s
Old.TraceString=%(startupTraceSpecification)s
Old.format=%(traceFormat)s
Old.Type=%(traceOutputType)s
Old.fileName=%(fileName)s
Old.LogNumber=%(maxNumberOfBackupFiles)d
Old.LogSize=%(rolloverSize)d
Old.LogRoot=%(logRoot)s
''' %tsD
	result [ 'Restore.values' ] = restoreVals
#	print 'result now is %s\n' %result	
	
	old = result[ 'Old.contents']
	Name = result[ 'Old.filename']
#	Name += '.new'
	new = result [ 'Restore.values' ]
	ws = re.compile( '^\s*$' );      # RegExp to match empty lines
	pre  = re.compile( '(Old|New)\.' );# Key starting with "Old." or "New."
	info = '\n'.join( [ x for x in old.splitlines() if not ws.match( x ) and not pre.match( x ) ] );
	info += '\n' + new; 
	fh = open( Name, 'w' );  
	fh.write( info );   
 	fh.close(); 
# end of file write

#get values from input prop file
    	profile = result.get( 'profileName', '')
    	osName = result.get( 'os', 'unix' )  
    	cell = result.get( 'CellName', '') 
    	managed = result.get( 'ManagedServer','') 
    	security = result.get ( 'security', 'false')
    	username = result.get ( 'username', '')
    	password = result.get ( 'password', '')
    	serverRunning = result.get ( 'ServerRunning', 'false')
    	restart = result.get ( 'ReStartRequired', 'false')
    	setLogRollover = result.get ( 'SetLogRollover', 'false')
    	wasTraceString = result.get ( 'was.trace.string', '')
#    	args = result.get('generic.jvm.arguments').strip()
#    	vmc = result.get('verboseModeClass').strip()
#    	setLogNumber = result.get('SetLogNumber').strip()
#    	SetLogSize = result.get('SetLogSize').strip()
    	
    	if serverRunning == 'false' : 
    		print 'Server %s not running - Start required' %server
    		restart = 'true'  # will have to (re)start server
    	
    	if result.has_key('generic.jvm.arguments') :
    		args = result.get('generic.jvm.arguments').strip()
    		print 'JVM Args set. Restart required'
    		restart='true'
    	 
    	if setLogRollover == 'true' : 
    		print 'SetLogRollover required' 
    		setLogNumber = result.get('SetLogNumber').strip()
    		SetLogSize = result.get('SetLogSize').strip()
    	
    	if result.has_key('verboseModeClass') :
    		print 'VerboseModeClass set. Restart required'
    		vmc = result.get('verboseModeClass').strip()
    		restart= 'true'

    		
    	print 'restart is %s\n' %restart
    			
	if restart == 'true' :
		#if you are starting, make sure you make an entry here. 
		fh = open( Name, 'a' );  
		fh.write( '\n'+'StartServer=true' );   
 		fh.close(); 
		
		# check for jvm arguments and verboseclass
		if result.has_key('generic.jvm.arguments') :
#			print '1'
			AdminConfig.modify( jvm, [ [ 'genericJvmArguments' , args ]] )
		if result.has_key('verboseModeClass') :
#			print '2'
			AdminConfig.modify( jvm, [ [ 'verboseModeClass' , vmc ]] )
			
		# check log rollover and size
		if setLogRollover == 'true' : 
			changesLog = []
			changesLog.append( [ 'maxNumberOfBackupFiles', setLogNumber ] )
			changesLog.append( [ 'rolloverSize', SetLogSize ] )
#			print 'changesLog is %s ' %changesLog
			params = repr(changesLog).replace(',', '')
#			print 'params is %s ' %params
			AdminConfig.modify( tl, params)
		# update tracespecfication
		changesTrace = []
		if tsD[ 'enable' ] == 'false' :
			changesTrace.append( [ 'enable', 'true' ] );

		if tsD[ 'traceOutputType' ] != 'SPECIFIED_FILE' :
    			changesTrace.append( [ 'traceOutputType', 'SPECIFIED_FILE' ] );

		if tsD[ 'traceFormat' ] != 'BASIC' :
    			changesTrace.append( [ 'traceFormat', 'BASIC' ] );
    		changesTrace.append( [ 'startupTraceSpecification', wasTraceString ] )
    		parmsTrace = repr( changesTrace ).replace( ',', '' )
    		AdminConfig.modify( ts, parmsTrace )
		
		
		if AdminConfig.queryChanges() : 
			AdminConfig.save()
		if managed == 'true' :  # Please dont sync if server is not managed - just save is good enough.
			WAuJ.fullSync()
		# (stop) and start server
#		if MBean : 
#			if server == 'nodeagent' :
##				nodeagentID =AdminControl.queryNames('type=NodeAgent,node=%s,*'%node)
##				print 'nodeagentID is %s ' %nodeagentID
##				AdminControl.invoke(nodeagentID, 'stopProcess', '%s' %server  ) 
##				AdminControl.invoke(nodeagentID, 'stopNode'  )
				
#				try : 
#					if osName == 'unix' : 
#						stopNode = os.path.join ( wasroot, 'profiles', profile, 'bin', 'stopNode.sh' )
#					else : 
#						stopNode = os.path.join ( wasroot, 'profiles', profile, 'bin', 'stopNode' ) 
#					if username != '' :
#						cmd = '%s -username %s -password %s' % (stopNode, username, password)
#					else : 
#						cmd =  '%s ' % stopNode
#					print 'Stopping %s with command %s\n' % (server, cmd) 
#					os.system( cmd )
#				except : 
#					print 'Error stopping nodeagent' 
#			else : 
#				try : 
##					AdminControl.stopServer( server, node)
#					if osName == 'unix' : 
#						stopServer = os.path.join ( wasroot, 'profiles', profile, 'bin', 'stopServer.sh' )
#					else : 
#						stopServer = os.path.join ( wasroot, 'profiles', profile, 'bin', 'stopServer' ) 
#					if username != '' :
#						cmd = '%s %s -username %s -password %s' % (stopServer, server, username, password)
#					else : 
#						cmd = '%s %s ' % (stopServer, server)
#					print 'Stopping %s with command %s\n' % (server, cmd) 	 
#					os.system( cmd )
#				except : 
#					print 'Problem stopping %s with command' %server
#			time.sleep(5) # sleep after all stop's
#		try :      
#       		if osName == 'unix' :
#          			startServer = os.path.join( wasroot, 'bin', 'startServer.sh' )
#       		else :
#          			startServer = os.path.join( wasroot, 'bin', 'startServer' )
#       		cmd = '%s %s -profileName %s' % (startServer, server, profile)
#        		
#        		print 'Starting %s with comamnd %s\n' %(server, cmd)
#			os.system( cmd )
#			if server == 'nodeagent' : 
#				WAuJ.fullSync() # will sync matter to discover nodes ? 
#				time.sleep(10) # sleep so that we can discover nodes
#		except : 
#			print 'Error stop/start server %s\n' %server
		
	else : # restart != 'true'
	# Update trace specifications
	# check log rollover and size 	
		if serverRunning == 'true' : # create the log root if it does not exist 
			try :
        			f = open( logRoot, 'w' )
        			f.close()
      			except IOError, e :
        			print 'Error creating log root file' 
# Use bean as server is running         			
        	tsBean = AdminConfig.getObjectName( ts )
        	AdminControl.setAttribute( tsBean, 'traceSpecification', wasTraceString )
        	if setLogRollover == 'true' :
			runTrace = AdminControl.queryNames( 'WebSphere:cell=%s,name=TraceService,type=TraceService,node=%s,process=%s,*' % (cell,node,server) ) 
#			print 'runTrace is %s' %runTrace   	
        		AdminControl.invoke( runTrace,  'setTraceOutputToFile',  [ '',  SetLogSize, setLogNumber, '' ]  )  
       		AdminConfig.save() 
       		WAuJ.fullSync() # issue a sync to propogate changes
 	
	
def main(): 

 directory = WAuJ.fixFileName( sys.argv[ 0 ] )

 txtfiles = [ x for x in os.listdir( directory ) if x.endswith( '.txt' ) ]

 for filename in txtfiles :
	result = {}
 	fqname = os.path.join( directory, filename );
 	if os.path.isfile( fqname ) : 
 		print '\nBegin processing : Filename %s\n' %fqname
 		fh = open( fqname ) 
 		data = fh.read()
 		fh.close()
 		for line in data.splitlines() :
 			line = line.strip()
 			if line and not line.startswith( '#' ):
 				name, value = line.split( '=', 1 )
 				result[ name ] = value
 		result[ 'Old.contents' ] = data
 		result[ 'Old.filename' ] = fqname
 		print 'Result is %s\n' %result
 		processFile(result)
 		
 		print 'End processing : Filename %s\n' %fqname
# 	else : 
# 		result[ 'Old.contents' ] = data
# 		result[ 'Old.filename' ] = filename
 

 

if __name__ == '__main__' or __name__ == 'main' : 
  if WAuJ.configurable() :
    main()
    print 'End trace-pre' 
  else :
#   env_dump();
    print '''
Error: For some reason, the WebSphere Application Server (WSAS) scripting
       objects are not available.\n
       This can occur, for example, if wsadmin is connected to the SOAP
       port of a Managed Server, instead of to the Deployment Manager.\n
       This script can not function without accessing the WSAS scripting
       objects.\n
       Please correct this situation before using this script.
    '''
