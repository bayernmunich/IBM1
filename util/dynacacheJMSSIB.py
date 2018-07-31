import sys
import time
import os

def splitList(s):
    """Given a string of the form [item item item], return a list of strings, one per item.
    WARNING: does not yet work right when an item has spaces.  I believe in that case we'll be
    given a string like '[item1 "item2 with spaces" item3]'.
    """
    if s[0] != '[' or s[-1] != ']':
        raise "Invalid string: %s" % s
    return s[1:-1].split(' ')

def getObjectAttribute(objectid, attributename):
    """Return the value of the named attribute of the config object with the given ID.
    If there's no such attribute, returns None.
    If the attribute value looks like a list, converts it to a real python list.
    TODO: handle nested "lists"
    """
    result = AdminConfig.showAttribute(objectid, attributename)
    if result != None and result.startswith("[") and result.endswith("]"):
        # List looks like "[value1 value2 value3]"
        result = splitList(result)
    return result

def getObjectsOfType(typename, scope = None):
    """Return a python list of objectids of all objects of the given type in the given scope
    (another object ID, e.g. a node's object id to limit the response to objects in that node)
    Leaving scope default to None gets everything in the Cell with that type.
    ALWAYS RETURNS A LIST EVEN IF ONLY ONE OBJECT.
    """
    lineSeparator = java.lang.System.getProperty('line.separator')
    if scope:
        return AdminConfig.list(typename, scope).split(lineSeparator)
    else:
        return AdminConfig.list(typename).split(lineSeparator)

def getCellName():
    """Return the name of the cell we're connected to"""
    # AdminControl.getCell() is simpler, but only
    # available if we're connected to a running server.
    cellObjects = getObjectsOfType('Cell')  # should only be one
    cellname = getObjectAttribute(cellObjects[0], 'name')
    return cellname
	
def generalUsage():
    """Display configuration options available with the script"""
    print "The available setup options for each command can be displayed by specifying \"--help\" and the appropriate \"--setup=XXXX\"."
    print "./wsadmin.sh -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=SETUPOPTION --help"
    print ""
    print "The following setup options are available and should be executed in the following \
    order: 1) dynacacheInSIB, 2) dynacacheOutSIB, and 3) dynacacheECA:"
    print ""
    print "--setup=dynacacheInSIB   Configures inbound infrastructure to allow invalidations to be received.  \
    Includes creating SIBus, JMS queue, and activation specification and installs invalidation application on specified server(s). "
    print ""
    print "--setup=dynacacheOutSIB  Configures outbound infrastucture to allow invalidations to be sent.  \
    Includes configuring the outbound connection factory."
    print ""
    print "--setup=dynacacheECA     Configures cluster members to send invalidations to remote cells. \
    Includes creating an exernal cache adapter on each cluster member that will send invalidations using \
    the outbound connection factory."
    print ""
    print "NOTE: The script has to be executed from WAS_INSTALL_ROOT/profiles/PROFILE_NAME/bin \
    (Ex: WAS_INSTALL_ROOT/profiles/Dmgr01/bin) for it to work correctly."
	
def inSibUsage():
    """Display how to configure inbound portion of SIBus"""
    print ""
    print "USAGE: wsadmin -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=dynacacheInSIB --cluster=CLUSTERNAME --datasourceJNDI=DATASOURCEJNDINAME [OPTIONS]..."        
    print ""	    
    print "USAGE: wsadmin -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=dynacacheInSIB --cluster=CLUSTERNAME --datasourceJNDI=DATASOURCEJNDINAME --delete [OPTIONS]..."        
    print ""	    
    print "Creates SIBus, JMS queue, and activation specification and installs invalidation application on specified server(s).  "
    print ""	
    print "--cluster=CLUSTERNAME         Name of cluster to include in SIBus and install MDB application on"
    print ""	
    print "--datasourceJNDI=DATASOURCEJNDINAME  The JNDI name of the datasource used by the specified cluster."    
    print ""	
    print "--localCellID=IDENTIFIER      Identifier to use in the names of configuration objects.  The local cell name is used by default.  \
    Typically, this option should only be used when configuring communication between multiple core groups in the same cell."
    print ""    
    print "--delete                      Deletes specified bus, associated config objects, and uninstalls invalidation application"
	
def outSibUsage():
    """Display how to configure outbound portion of SIBus"""
    print ""
    print "USAGE: wsadmin -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=dynacacheOutSIB --remoteCellSIBServers=9.9.9.9:8901,9.9.9.8:8888 --remoteCellID=REMOTECELLNAME [OPTIONS]..."	
    print ""
    print "USAGE: wsadmin -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=dynacacheOutSIB --remoteCellSIBServers=9.9.9.9:8901,9.9.9.8:8888 --remoteCellID=REMOTECELLNAME --delete [OPTIONS]..."	
    print ""	
    print "Creates outbound connection factory for communicating with SIBus in a remote cell or core group"
    print ""
    print "--remoteCellSIBServers=ip:port,ip:port    The IP address and SIB_ENDPOINT_ADDRESS port of SIBus members."
    print ""	
    print "--remoteCellID=REMOTECELLNAME          Identifier used to create remote cell configuration objects.  The name \
    of the remote cell is sufficient in most cases.  If the --localCellID option was used to create the inbound \
    configuration in the remote cell or core group, then use that value here also. "
    print ""	
    print "--localCellID=IDENTIFIER               Identifier for defining the name of configuration objects.  Only specify this \
    option if it was used when configuring the inbound configuration (--setup=dynacacheInSIB).  If it was not specified, then \
    do not specify the option here either."
    print ""	
    print "--delete                               Deletes the outbound connection factory."

def ecaUsage():
    """Display how to configure external cache adapter"""
    print ""    
    print "USAGE: wsadmin -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=dynacacheECA --cluster=CLUSTERNAME --remoteCellID=REMOTECELLNAME [OPTIONS]..."		    
    print ""    
    print "USAGE: wsadmin -lang jython -f ../../../util/dynacacheJMSSIB.py --setup=dynacacheECA --cluster=CLUSTERNAME --remoteCellID=REMOTECELLNAME --delete [OPTIONS]..."		        
    print ""	
    print "Creates the RemoteJMSInvalidator External Cache Adapter (ECA) on the specified server(s)"
    print ""
    print "--cluster=CLUSTERNAME                  Name of cluster to configure external cache adapter on"
    print ""
    print "--remoteCellID=REMOTECELLNAME          Identifier used to construct the names of the configuration objects in the remote cell.  The name of the remote cell is sufficient in most cases. If the --localCellID option was used to create the inbound configuration in the remote cell, then use that value here also."
    print ""
    print "--localCellID=LOCALCELLIDENTIFIER	  Identifier for defining the name of configuration objects.  The value here should match the value used when defining the inbound configuration (--setup=dynacacheInSIB).  If it was not specified (defaults to local cell name), then do not specify the option here either."
    print ""
    print "--delete                               Deletes the specified external cache adapter"	

def getDefaultECGName():
	return 	"RemoteJMSInvalidator"

def deleteECA(serverid,ecgName):
    """Removes all external cache groups of a given name"""
    lineSeparator = java.lang.System.getProperty('line.separator')
    ecas=AdminConfig.list('ExternalCacheGroup', serverid).split(lineSeparator)
    for e in ecas:
        name=AdminConfig.showAttribute(e,'name')
        if(name == ecgName):
            AdminConfig.remove(e)
            print "Deleted External Cache Group '%s' from %s " % (ecgName,serverid)
       

def createECA(serverid,localJNDIQueueConnectionFactory,remoteCellJNDIQueueDest,ecgName):
    """Creates external cache group for a server"""
    dc1=AdminConfig.list('DynamicCache',serverid)	
    ecg=AdminConfig.create('ExternalCacheGroup', dc1, '[[name "'+ ecgName+'"]]')
    ecgm=AdminConfig.create('ExternalCacheGroupMember', ecg, '[[adapterBeanName "com.ibm.websphere.servlet.cache.RemoteInvalidator "][address '+localJNDIQueueConnectionFactory+','+remoteCellJNDIQueueDest+']]')    
    print "Created External Cache Group '%s' on %s " % (ecgName,serverid)
            
def configureECA(localCellID,server,cluster,ecgName,remoteCellID,localJNDIQueueConnectionFactory,remoteCellJNDIQueueDest,delete):
    """Configures or deletes external cache adapter for specified server(s)"""
    print "Configure External Cache Group"
    if(localCellID==''):
        localCellID=getCellName()	
    sParts=server.split('/')
    if(ecgName==''):
        ecgName=getDefaultECGName()        
    if(localJNDIQueueConnectionFactory==''):
        localJNDIQueueConnectionFactory='jms/'+getOutboundConnectionFactoryName(localCellID)
    if(remoteCellJNDIQueueDest==''):
        remoteCellJNDIQueueDest=getQueueDestinationName(remoteCellID)                
    if(cluster==''):
        #ECA on server
        s1=AdminConfig.getid('/Node/'+ sParts[0]+'/Server/'+sParts[1])	
        if(delete!=''):
            deleteECA(s1,ecgName)
        else:
            createECA(s1,localJNDIQueueConnectionFactory,remoteCellJNDIQueueDest,ecgName)
    else:
        #ECA on cluster members
        clid = AdminConfig.getid("/ServerCluster:"+cluster)
        temp = AdminConfig.showAttribute(clid, "members")
        # remove beginning and end brackets
        members = temp[1:-1]
        print "Deleting external cache group of cluster", cluster
        for member in members.split():
            server=AdminConfig.showAttribute(member, "memberName")
            node=AdminConfig.showAttribute(member, "nodeName")
            s1=AdminConfig.getid('/Node/'+ node+'/Server/'+server)    
            if(delete!=''):
                deleteECA(s1,ecgName)
            else:
                createECA(s1,localJNDIQueueConnectionFactory,remoteCellJNDIQueueDest,ecgName)
	
def configureSIB(nameKey,server,cluster,datasourceJNDI,delete):
    """Configures SIB for specified servers"""
    print "Configure dynacache inbound SIB"	
    localCell=getCellName()
    if(nameKey==''):
        nameKey=localCell
        print "Using the following cell name to construct SIB object names:",nameKey
    else:
        print "Using the following key to construct SIB object names:",nameKey
    if(cluster==''): 
        sParts=server.split('/')
        configureBus(nameKey,sParts[0],sParts[1],cluster,datasourceJNDI,localCell,delete)
    else:
        configureBus(nameKey,'','',cluster,datasourceJNDI,localCell,delete)

def configureOutConnFactory(key,remoteCellBus,remoteCellEndpoints,remoteCellKey,delete):
    """Creates or deletes outbound connection factory"""
    print "Configure outbound connection factory:"
    localCellName=getCellName()
    if(key==''):
        key=localCellName
        print "Using the following cell name to construct SIB object names:",key
    else:
        print "Using the following key to construct SIB object names:",key
        
    qFactName=getOutboundConnectionFactoryName(key)	
    if(remoteCellBus==''):
        remoteCellBus=getBusName(remoteCellKey)

    try:
        if(delete !=''):
            tmp=AdminConfig.getid('/J2CConnectionFactory:'+qFactName)
            if(tmp!=''):
                AdminTask.deleteSIBJMSConnectionFactory(tmp) 
                print "Removed J2CConnectionFactory:", qFactName
            else:
                print 'J2CConnectionFactory does not exist',qFactName
            return
    except:
        print 'J2CConnectionFactory does not exit:',qFactName
    tmp=AdminConfig.getid('/J2CConnectionFactory:'+qFactName)

    if(tmp==''):
        AdminTask.createSIBJMSConnectionFactory('\''+localCellName+'(cells/'+localCellName+'|cell.xml)', '[-type queue -name '+ qFactName+' -jndiName jms/'+qFactName+' -description \'Dynacache connection factory \'-category -busName '+remoteCellBus+' -nonPersistentMapping ExpressNonPersistent -readAhead Default -tempQueueNamePrefix -target -targetType BusMember -targetSignificance Preferred -targetTransportChain -providerEndPoints '+ remoteCellEndpoints+' -connectionProximity Bus -authDataAlias -shareDataSourceWithCMP false -logMissingTransactionContext false -manageCachedHandles false -xaRecoveryAuthAlias -persistentMapping ReliablePersistent]') 
        print "Created J2CConnectionFactory:", qFactName 
        #print "NOTE: The dmgr may need to be restarted to recognize a newly created outbound connection factory"
    else:
        print qFactName, "already exists"
		
def uninstallMDB(key):
    """Uninstalls dynacache MDB application"""
    try:
        AdminApp.uninstall(getMDBAppName(key))
        print "MDB is uninstalled"
    except:
        print 'MDB is already uninstalled:', getMDBAppName(key)

def installClusterMDB(key,localCellName,cluster):
    """Installs dynacache MDB application"""
    print "Installing Invalidation MDB"
    AdminApp.install('../../../installableApps/DynacacheMessageHandler.ear', 
    '[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -deployejb -appname "'+ getMDBAppName(key)+
    '" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -MapModulesToServers \
    [[ "Dynacache Message Processor" EJBProject.jar,META-INF/ejb-jar.xml WebSphere:cell='+localCellName+',cluster='+cluster+' ]] \
    -BindJndiForEJBMessageBinding [[ "Dynacache Message Processor" MessageProcessor EJBProject.jar,META-INF/ejb-jar.xml "" eis/'+
    getActivationSpecName(key)+' "" ]]]' )
        
def installMDB(key,localCellName,node,server):
    """Installs dynacache MDB"""
    print "Installing Invalidation MDB"
    AdminApp.install('../../../installableApps/DynacacheMessageHandler.ear', 
    '[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -deployejb -appname "'+ getMDBAppName(key)+
    '" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -MapModulesToServers \
    [[ "Dynacache Message Processor" EJBProject.jar,META-INF/ejb-jar.xml WebSphere:cell='+localCellName+',node='+node+',server='+server+
    ' ]] -BindJndiForEJBMessageBinding [[ "Dynacache Message Processor" MessageProcessor EJBProject.jar,META-INF/ejb-jar.xml "" eis/'+
    getActivationSpecName(key)+' "" ]]]' )
		
		
def configureQueue(key,busName,destName,localCellName):
    """Creates JMS queue"""
    queueName=getInboundQueueName(key)
    print "Creating Inbound Queue:",queueName
    AdminTask.createSIBJMSQueue('\''+localCellName+'(cells/'+localCellName+'|cell.xml)', '[-name '+queueName+' -jndiName jms/'+queueName+' -description \'Dynacache Queue\' -deliveryMode Application -readAhead AsConnection -busName '+busName+' -queueName '+ destName+' ]') 
    return queueName
    
def deleteSIBJMSQueue(key,localCellName):
    """ Delete a SIB JMS Queue"""
    queueName=getInboundQueueName(key)
    lineSeparator = java.lang.System.getProperty('line.separator')
    for queue in AdminTask.listSIBJMSQueues('\''+localCellName+'(cells/'+localCellName+'|cell.xml)').split(lineSeparator):
        name = AdminConfig.showAttribute(queue, "name")
        if (name == queueName):
            AdminTask.deleteSIBJMSQueue(queue)
            print "Removed jms queue:", queueName
            return

def configureClusterQueueDestination(busName,nameKey, cluster):
    """Creates SIB queue destination for cluster"""
    qDestination=getQueueDestinationName(nameKey)
    print "Creating Queue Destination: ", qDestination
    AdminTask.createSIBDestination('[-bus '+busName+' -name '+ qDestination + 
    ' -type Queue -reliability ASSURED_PERSISTENT -description \'Dynacache invalidation destination\' -cluster '+cluster+ ']')
    return qDestination    
    
def configureQueueDestination(busName,nameKey, node,server):
    """Creates SIB queue destination"""
    qDestination=getQueueDestinationName(nameKey)
    print "Creating Queue Destination: ", qDestination
    AdminTask.createSIBDestination('[-bus '+busName+' -name '+ qDestination + 
    ' -type Queue -reliability ASSURED_PERSISTENT -description \'Dynacache invalidation destination\' -node '+node+ ' -server '+server+']')
    return qDestination
	
def configureActivationSpecification(busName,key,localCellName):
    """Creates JMS activation specification"""
    specName=getActivationSpecName(key)
    print "Creating Activation Specification:", specName
    AdminTask.createSIBJMSActivationSpec('\''+localCellName+'(cells/'+localCellName+'|cell.xml)', '[-name '+ specName+ ' -jndiName eis/'+
    specName +' -destinationJndiName jms/'+getInboundQueueName(key)+' -description -busName '+busName +
    ' -destinationType javax.jms.Queue -acknowledgeMode Auto-acknowledge  ]') 
    return specName	

def deleteActivationSpec(key, cluster, server,localCellName):
    """Removes specified activation spec if it exists"""
    jmsASName=getActivationSpecName(key)
    """ Delete as SIB JMS Activation Specification"""
    jmsSpecs=AdminTask.listSIBJMSActivationSpecs('\''+localCellName+'(cells/'+localCellName+'|cell.xml)')
    lineSeparator = java.lang.System.getProperty('line.separator')
    for spec in jmsSpecs.split(lineSeparator):
        name = AdminConfig.showAttribute(spec, "name")
        if (name == jmsASName):
            AdminConfig.remove(spec)
            print "Removed activation specification:", name
            return    
    
def getMDBAppName(key):
    return "Dynacache Invalidation MDB "+ key
    
def getOutboundConnectionFactoryName(key):
	return "DynacacheOutBoundConnectionFactory-"+key
	
def getTargetJNDIQueueName(key):
	#jndi name used by peer cells to communicate with this cell
	return "DynacacheJNDI-"+key
	
def getActivationSpecName(key):
	return "DynacacheActivationSpec-"+key
	
def getInboundQueueName(key):
	return "DynacacheInboundQueue-"+key
	
def getQueueDestinationName(key):
	return "DynacacheDestination-"+key
	
def getBusName(key):
	return "DynacacheBus-"+key
	
def configureBus(nameKey,node,server,cluster,datasourceJNDI,localCell,delete):
    """Creates or deletes SIBus"""
    busName = getBusName(nameKey)
    try:
        if(delete !=''):
    	    try:
    	        AdminTask.deleteSIBus('[-bus '+busName+' ]')	        
    	    except:
                print "Bus does not exist",busName
            try:
                deleteSIBJMSQueue(nameKey,localCell)
            except:
                print "problem deleting jms queue"
            try:
                deleteActivationSpec(nameKey,cluster,server,localCell)
            except:
                print "problem deleting activation spec"
            try:
                uninstallMDB(nameKey)
            except:
                print "problem uninstalling MDB"
            print "Bus successfully removed"
            return
    except:            
            return
    print "Creating bus:",busName

    id=AdminConfig.getid('/SIBus:'+busName+ '/')
    if(id==''):
        AdminTask.createSIBus('[-bus '+busName+' -secure false ]')	
        if(cluster == ''):      
            #bus member is server
            addBusMember(busName,node,server)		
            qDestName=configureQueueDestination(busName,nameKey,node,server)
            qName=configureQueue(nameKey,busName,qDestName,localCell)
            configureActivationSpecification(busName,nameKey,localCell)
            uninstallMDB(nameKey)
            installMDB(nameKey,localCell,node,server)
        else:
            #bus member is cluster
            addClusterBusMember(busName,cluster,datasourceJNDI)
            qDestName=configureClusterQueueDestination(busName,nameKey,cluster)        
            qName=configureQueue(nameKey,busName,qDestName,localCell)
            configureActivationSpecification(busName,nameKey,localCell)
            uninstallMDB(nameKey)
            installClusterMDB(nameKey,localCell,cluster)
    else:
        print "Bus already exists"
    return busName

def addClusterBusMember(busName,cluster,datasourceJNDI):
    print "Adding cluster bus member:", cluster, datasourceJNDI
    AdminTask.addSIBusMember('[-bus '+busName+' -cluster '+cluster+ ' -datasourceJndiName '+datasourceJNDI+' ]') 
    
def addBusMember(busName,node,server):
	print "Adding bus member:", node, server
	AdminTask.addSIBusMember('[-bus '+busName+' -node '+node+ ' -server '+server+' ]') 
			            
#indicates whether the ECA or SIB infrastructure is being setup
setup=''
remoteCellSIBServers=''
remoteCellID=''
remoteCellBus=''
server=''
cluster=''
datasourceJNDI=''
localCellID=''
delete=''
ecgName=''
jndiQueueConnectionFactory=''
remoteCellJNDIQueue=''
help=''
opt=''
#try:

#    opts, args = getopt.getopt(sys.argv, '',['help','delete','setup=', 'remoteCellSIBServers=', 'remoteCellID=','remoteCellBus=','remoteCellQueue=','server=','localCellID=','ecgName=','jndiQueueConnectionFactory=','remoteCellJNDIQueue=','cluster=','datasourceJNDI='])
# 
#except getopt.GetoptError, err:
#    print ""
#    print str(err)
#    sys.exit(2);
    
for arg in sys.argv:
    if arg == '--help':
        help='true'
    elif arg == '--delete':
        delete='true' 
    elif(arg.find("=")!=-1):
        vals=arg.split("=")
        opt=vals[0]
        arg=vals[1]
        if opt == '--setup':
            setup = arg
        elif opt == '--remoteCellSIBServers':
            remoteCellSIBServers=arg
        elif opt == '--remoteCellID':
            remoteCellID=arg
        elif opt == '--remoteCellBus':
            remoteCellBus=arg
        elif opt == '--localCellID':
            localCellID=arg
        elif opt == '--jndiQueueConnectionFactory':
            jndiQueueConnectionFactory=arg		
        elif opt == '--remoteCellJNDIQueue':
            remoteCellJNDIQueue=arg			
        elif opt == '--ecgName':
            ecgName=arg
        elif opt == '--server':
            server=arg	
        elif opt == '--cluster':
            cluster=arg	        
        elif opt == '--datasourceJNDI':
            datasourceJNDI=arg	          
    else:
        print "Unknown arg", arg
print ""

if setup == '':
    generalUsage()
elif setup == 'dynacacheInSIB':
    if (help!=''):
        inSibUsage()    
    elif (server == '' and (cluster == '' or datasourceJNDI=='')):        
        print "*****Missing argument*****"
        inSibUsage()
    else:
        configureSIB(localCellID,server,cluster,datasourceJNDI,delete)
        AdminConfig.save()			
elif (setup == 'dynacacheOutSIB'):
    if(help!=''):
        outSibUsage()	
    elif(remoteCellID == '' and remoteCellBus==''):
        print "*****Missing argument*****"
        outSibUsage()	
    else:
        configureOutConnFactory(localCellID,remoteCellBus,remoteCellSIBServers,remoteCellID,delete)
        AdminConfig.save()
elif (setup == 'dynacacheECA'):
    if(help!=''):
        ecaUsage()
    elif((server == '' and cluster=='') or (remoteCellID == '' and (jndiQueueConnectionFactory=='' or remoteCellJNDIQueueDestination==''))):
        print "*****Missing argument*****"
        ecaUsage()
    else:
        configureECA(localCellID,server,cluster,ecgName,remoteCellID,jndiQueueConnectionFactory,remoteCellJNDIQueue,delete)
        AdminConfig.save()		
else:
	print "No valid --setup specified"

