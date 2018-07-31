import java, time, os, os.path, re, sys;
import WAuJ_utilities as WAuJ;

def processFile(result) : 
	
	Old = {}
  	for prop in result.keys() :
    		if prop.startswith( 'Old.' ) :
      			Old[ prop[ 4: ] ] = result[ prop ]
      			if prop != 'Old.filename' :      # Needed by updatePropFile()
        			del( result[ prop ] )
        			
        print 'old is %s \n' %Old
	
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
    	
    	ts  = AdminConfig.list( 'TraceService', configId )
    	print 'ts is %s' %ts
	tsD = WAuJ.showAsDict( ts )
#	print 'tsD is %s\n' %tsD
	tl  = AdminConfig.list( 'TraceLog', ts )
	print 'tl is %s\n' %tl
	tlD = WAuJ.showAsDict( tl )
	print 'tlD is %s\n' %tlD
	
	tsD.update( tlD )
	osName = result.get('os', 'unix') 
    	cell = result.get( 'CellName', '')
    	restart = 	 result.get ( 'ReStartRequired', 'false')
    	setLogRollover = result.get ( 'SetLogRollover', 'false')
    	profile = result.get ( 'profileName' '' ) 
    	username = result.get ( 'username', '')
    	password = result.get ( 'password', '')
    	
	serverRunning = result.get ( 'ServerRunning', 'false')
    	if serverRunning == 'false' : 
    		print 'Server %s was not running during pre - Start not required' %server
    		stopMyServer = 'true'  # will have to  stop server
    		restart = 'true' # keep restart true as well in order to go into that if stmt
    	else : 
    		stopMyServer = 'false'
	
    	if result.has_key('generic.jvm.arguments') :
		oldArgs = Old.get( 'JVMargs', '' ).strip()	
    		restart='true'
    	 
    	if setLogRollover == 'true' : 
    		oldSetLogNumber = Old.get('LogNumber').strip()
    		oldSetLogSize = Old.get('LogSize').strip()
    	
    	if result.has_key('verboseModeClass') :
    		oldVmc = Old.get('verboseModeClass', 'false').strip()
    		restart= 'true'
    		
    	oldWasTraceString=Old.get('TraceString').strip()
    	if oldWasTraceString == '[]' :  
    		oldWasTraceString = '*=info'
    		
    	print 'restart is %s\n' %restart
    	
    	if restart == 'true' :
    		Name = result[ 'Old.filename']
    		fh = open( Name, 'a' );  
		fh.write( '\n\nRestoreStopServer=true' );  
		fh.write( '\nRestoreStartServer='+stopMyServer ) ; 
 		fh.close(); 
    		
    		if jvm :                             # false if jvm == ''
			if jvmDict.has_key( 'genericJvmArguments' ) :
      				args = jvmDict[ 'genericJvmArguments' ];
      				oldArgs = Old.get( 'JVMargs', '' ).strip()	
      				if oldArgs and oldArgs != args :    #
        				if oldArgs == '[]' :              # Special case...
          					oldArgs = '';                   #

			        	AdminConfig.modify( jvm, [ [ 'genericJvmArguments', oldArgs ] ] )
			        	
	      			else :                           #
        				print 'genericJvmArguments unchanged.\n';
		if result.has_key('verboseModeClass') :
			AdminConfig.modify( jvm, [ [ 'verboseModeClass' , oldVmc ]] )
			
		# check log rollover and size
		if setLogRollover == 'true' : 
			changesLog = []
			changesLog.append( [ 'maxNumberOfBackupFiles', oldSetLogNumber ] )
			changesLog.append( [ 'rolloverSize', oldSetLogSize ] )
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
    		changesTrace.append( [ 'startupTraceSpecification', oldWasTraceString ] )
    		parmsTrace = repr( changesTrace ).replace( ',', '' )
    		AdminConfig.modify( ts, parmsTrace )
		
		# (stop) and start server
		if AdminConfig.queryChanges() : 
			AdminConfig.save()
			WAuJ.fullSync()
#		if MBean : 
#			if server == 'nodeagent' :
##				nodeagentID =AdminControl.queryNames('type=NodeAgent,node=%s,*'%node)
##				print 'nodeagentID is %s ' %nodeagentID
##				AdminControl.invoke(nodeagentID, 'stopProcess', '%s' %server  ) 
##				AdminControl.invoke(nodeagentID, 'stopNode'  )
#				
#				try : 
#					
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
#					
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
#			
#		try :     
#			if stopMyServer != 'true' : # the server was stopped to start with - No need to start.
#				
#				profile = result.get('profileName', '') 
#	        		if osName == 'unix' :
#	          			startServer = os.path.join( wasroot, 'bin', 'startServer.sh' )
#	        		else :
#	          			startServer = os.path.join( wasroot, 'bin', 'startServer' )
#	        		cmd = '%s %s -profileName %s' % (startServer, server, profile)
#	        		print 'Starting %s with comamnd %s\n' %(server, cmd)
#				os.system( cmd )
#				if server == 'nodeagent' : 
#					WAuJ.fullSync() # will sync matter to discover nodes ? 
#					time.sleep(10) # sleep so that we can discover nodes
#			else : 
#				print 'Server was not running during pre. Start not required' 
#			
#		except : 
#			print 'Error stop/start server %s' %server
#			
	else : 
		# Use bean as server is running         			
        	tsBean = AdminConfig.getObjectName( ts )
        	AdminControl.setAttribute( tsBean, 'traceSpecification', oldWasTraceString )
        	if setLogRollover == 'true' :
			runTrace = AdminControl.queryNames( 'WebSphere:cell=%s,name=TraceService,type=TraceService,node=%s,process=%s,*' % (cell,node,server) ) 
#			print 'runTrace is %s' %runTrace   	
        		AdminControl.invoke( runTrace,  'setTraceOutputToFile',  [ '',  oldSetLogSize, oldSetLogNumber, '' ]  )  
       		AdminConfig.save() 
       		WAuJ.fullSync() # issue a sync to propogate changes
		

	
	
def main(): 
#print 'Coming into main'
 directory = WAuJ.fixFileName( sys.argv[ 0 ] )
#print directory
 txtfiles = [ x for x in os.listdir( directory ) if x.endswith( '.txt' ) ]
#print txtfiles
 
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
 		print 'result is %s\n' %result
 		processFile(result)
 		
 		print 'End processing : Filename %s\n' %fqname
# 	else : 
# 		result[ 'Old.contents' ] = data
# 		result[ 'Old.filename' ] = filename
 

 

if ( __name__ == '__main__' ) or ( __name__ == 'main' ): 
  if WAuJ.configurable() :
    main()
    print 'End trace-post' 
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
