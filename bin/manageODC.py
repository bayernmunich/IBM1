global initNodeNom, initSrvrNom, rtnMsg

def convertToList(inlist):
    outlist=[]
    if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
    else:
        clist = inlist.split(lineSeparator)
    for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
            outlist.append(elem)
    return outlist

def getMbeans(initNodeNom,initSrvrNom):
    node = AdminConfig.getid("/Node:"+initNodeNom+"/")
    if (node == ""):
        raise NameError(initNodeNom + " is not the name of a valid node")
    initSrvr = AdminConfig.getid("/Node:"+initNodeNom+"/Server:"+initSrvrNom+"/")
    if (initSrvr == ""):
        raise NameError(initSrvrNom + " is not the name of a valid server on node " + initNodeNom)
    mbeanStr='WebSphere:*,type=TargetTreeMbean,node=' + initNodeNom + ',process=' + initSrvrNom
    mbeans=convertToList(AdminControl.queryNames(mbeanStr))
    return mbeans

def getTargetTree(initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'getTargetTree')
        print rtnMsg + "\ndone"

def removeODCNode(removeNodePath,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'removeNode',removeNodePath)
        print rtnMsg + "\ndone"

def addODCNode(parentNodePath,nodeType,nodeName,initNodeNom,initSrvrNom,args):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'addNode','[%s %s %s %s]' % (parentNodePath,nodeType,nodeName,args))
        print rtnMsg + "\ndone"

def addODCEdge(nodePathA,nodePathB,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'addEdge','[%s %s]' % (nodePathA,nodePathB))
        print rtnMsg + "\ndone"

def removeODCEdge(nodePathA,nodePathB,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'removeEdge','[%s %s]' % (nodePathA,nodePathB))
        print rtnMsg + "\ndone"

def modifyODCProperty(modNodePath,propDesc,val,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'modifyProperty', '[%s %s %s]' % (modNodePath,propDesc,val))
        print rtnMsg + "\ndone"

def readApplication(applicationName,editionName,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'readApplication','[%s %s]' % (applicationName,editionName))
        print rtnMsg + "\ndone"

def lock(initNodeNom,initSrvrNom,ms):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        AdminControl.invoke(mbean,'lock',ms)
        print "\ndone"

def getP2PMemberData(initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'getP2PMemberData')
        print rtnMsg + "\ndone"

def generateHAPluginCfgs(genDefs,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'generateHAPluginCfgs','[%s]' % (genDefs))
        print rtnMsg + "done"

def forceTreeRequest(member,initNodeNom,initSrvrNom):
    mbeans = getMbeans(initNodeNom,initSrvrNom)
    for mbean in mbeans:
        rtnMsg = AdminControl.invoke(mbean,'forceTreeRequest','[%s]' % (member))
        print rtnMsg + "done"

def printHelp():
    print """
    Supported Operations:
    \tgetTargetTree <nodeName> <serverName>
    \t\tnodeName is the name of the WebSphere node containing the server from which the tree will be retrieved
    \t\tserverName is the name of the server from which the tree will be retrieved

    \tremoveODCNode <odcNodePath> <nodeName> <serverName>
    \t\todcNodePath is the full ODC tree path of the node to remove
    \t\tnodeName is the name of the WebSphere node containing the server which will initiate the removal
    \t\tserverName is the name of the server to initiate the removal

    \taddODCNode <odcParentNodePath> <odcNodeType> <newNodeName> <nodeName> <serverName> [--p odcPropertyDescriptor priority::value] [--l linkOdcNodePath]
    \t\todcParentNodePath is the full ODC tree path for the parent of the new node to be created
    \t\todcNodeType is the ODC node type of the new node to be created
    \t\tnewNodeName is the name of the new node to be created
    \t\tnodeName is the name of the WebSphere node containing the server which will initiate the addition
    \t\tserverName is the name of the server to initiate the addition
    \t\t\toptional arguments can be include o-n times:
    \t\t\t\t--p <odcPropertyDescriptor> <priority::value>
    \t\t\t\t\todcPropertyDescriptor is the name of the ODC property to be modified on the new node
    \t\t\t\t\tpriority::value is the priority and value to set the ODC property to on the new node
    \t\t\t\t\t\tpriority:: can be omitted if the default value is to be used
    \t\t\t\t--l <linkOdcNodePath>
    \t\t\t\t\tlinkOdcNodePath is the full ODC tree path of the node for which an edge is to be created

    \tremoveODCEdge <odcNodePathA> <odcNodePathB> <nodeName> <serverName>
    \t\todcNodePathA and odcNodePathB are the full ODC tree paths of the nodes to be unlinked
    \t\tnodeName is the name of the WebSphere node containing the server which will initiate the removal
    \t\tserverName is the name of the server to initiate the removal

    \taddODCEdge <odcNodePathA> <odcNodePathB> <nodeName> <serverName>
    \t\todcNodePathA and odcNodePathB are the full ODC tree paths of the nodes to be linked
    \t\tnodeName is the name of the WebSphere node containing the server which will initiate the addition
    \t\tserverName is the name of the server to initiate the addition

    \tmodifyODCProperty <odcNodePath> <odcPropertyDescriptor> <priority::value> <nodeName> <serverName>
    \t\todcNodePath is the full ODC tree path of the node whose property is to be modified
    \t\todcPropertyDescriptor is the name of the ODC property to be modified
    \t\tpriority::value is the priority and value to set the ODC property to
    \t\t\tpriority:: can be omitted if the default value is to be used
    \t\tnodeName is the name of the WebSphere node containing the server which will initiate the modification
    \t\tserverName is the name of the server to initiate the modification

    \treadApplication <applicationName> [<editionName>] <nodeName> <serverName>
    \t\tapplicationName is the name of the application to read or reread from the config repository
    \t\teditionName is the optional name of the edition of the application to read or reread from the config repository
    \t\tnodeName is the name of the WebSphere node containing the server which will perform the read
    \t\tserverName is the name of the server to perform the read

    \tgetP2PMemberData <nodeName> <serverName>
    \t\tnodeName is the name of the WebSphere node containing the server from which the p2p member data will be retrieved
    \t\tserverName is the name of the server from which the p2p member data will be retrieved

    \tgenerateHAPluginCfgs <generationDefinitionNames> <nodeName> <serverName>
    \t\tgenerationDefinitionNames is a comma separated list of generation names that have been configured via cell custom properties of the form ODCPluginCfg_<configName>
    \t\t\tFor example: ODCPluginCfg_1,ODCPluginCfg_2
    \t\tnodeName is the name of the WebSphere node containing the server which will perform plugin-cfg.xml generation
    \t\tserverName is the name of the server to perform the generation

    \tforceTreeRequest [wsGroupMember] <nodeName> <serverName>
    \t\twsGroupMember is an optional parameter that defines the process to which a treeRequest will be sent in the form cell/node/server
    \t\t\tif wsGroupMember is not defined treeRequests will be sent to all available cell local dmgr and nodeagent processes
    \t\tnodeName is the name of the WebSphere node containing the server that will initiate the treeRequest (normally the dmgr node)
    \t\tserverName is the name of the server that will initiate the treeRequest and process the subsequent treeResponse (normally the dmgr process)
    """

if(len(sys.argv) > 0):
    action = sys.argv[0].rstrip()
    if (action == 'getTargetTree'):
        if(len(sys.argv)==3):
            getTargetTree(sys.argv[1].rstrip(),sys.argv[2].rstrip())
        else:
            print "Wrong number of arguments for getTargetTree operation"
    elif (action == 'removeODCNode'):
        if (len(sys.argv) == 4):
            removeNodePath=sys.argv[1].rstrip()
            initNodeNom = sys.argv[2].rstrip()
            initSrvrNom = sys.argv[3].rstrip()
            removeODCNode(removeNodePath,initNodeNom, initSrvrNom)
        else:
            print "Wrong number of arguments for removeODCNode operation"
    elif (action == 'addODCNode'):
        if (len(sys.argv) >= 6):
            parentNodePath=sys.argv[1].rstrip()
            nodeType = sys.argv[2].rstrip()
            nodeName = sys.argv[3].rstrip()
            initNodeNom = sys.argv[4].rstrip()
            initSrvrNom = sys.argv[5].rstrip()
            addODCNode(parentNodePath,nodeType,nodeName,initNodeNom,initSrvrNom,sys.argv[6:])
        else:
            print "Wrong number of arguments for addODCNode operation"
    elif (action == 'addODCEdge'):
        if (len(sys.argv) == 5):
            nodePathA = sys.argv[1].rstrip()
            nodePathB = sys.argv[2].rstrip()
            initNodeNom = sys.argv[3].rstrip()
            initSrvrNom = sys.argv[4].rstrip()
            addODCEdge(nodePathA,nodePathB,initNodeNom,initSrvrNom)
        else:
            print "Wrong number of arguments for addODCEdge operation"
    elif (action == 'removeODCEdge'):
        if (len(sys.argv) == 5):
            nodePathA = sys.argv[1].rstrip()
            nodePathB = sys.argv[2].rstrip()
            initNodeNom = sys.argv[3].rstrip()
            initSrvrNom = sys.argv[4].rstrip()
            removeODCEdge(nodePathA,nodePathB,initNodeNom,initSrvrNom)
        else:
            print "Wrong number of arguments for removeODCEdge operation"
    elif (action == 'modifyODCProperty'):
        if (len(sys.argv) == 6):
            modNodePath = sys.argv[1].rstrip()
            propDesc = sys.argv[2].rstrip()
            val = sys.argv[3].rstrip()
            initNodeNom = sys.argv[4].rstrip()
            initSrvrNom = sys.argv[5].rstrip()
            modifyODCProperty(modNodePath,propDesc,val,initNodeNom,initSrvrNom)
        else:
            print "Wrong number of arguments for modifyODCProperty operation"
    elif (action == 'readApplication'):
        if (len(sys.argv) == 4):
            appName = sys.argv[1].rstrip()
            initNodeNom = sys.argv[2].rstrip()
            initSrvrNom = sys.argv[3].rstrip()
            readApplication(appName,"",initNodeNom,initSrvrNom)
        elif (len(sys.argv) == 5):
            appName = sys.argv[1].rstrip()
            edName=sys.argv[2].rstrip()
            initNodeNom = sys.argv[3].rstrip()
            initSrvrNom = sys.argv[4].rstrip()
            readApplication(appName,edName,initNodeNom,initSrvrNom)
        else:
            print "Wrong number of arguments for readApplication operation"
    elif (action == 'lock'):
        if(len(sys.argv)==4):
            lock(sys.argv[1].rstrip(),sys.argv[2].rstrip(),sys.argv[3].rstrip())
        else:
            print "Wrong number of arguments for lock operation"
    elif (action == 'getP2PMemberData'):
        if(len(sys.argv)==3):
            getP2PMemberData(sys.argv[1].rstrip(),sys.argv[2].rstrip())
        else:
            print "Wrong number of arguments for getP2PMemberData operation"
    elif (action == 'generateHAPluginCfgs'):
        if (len(sys.argv) == 4):
            genDefs = sys.argv[1].rstrip()
            initNodeNom = sys.argv[2].rstrip()
            initSrvrNom = sys.argv[3].rstrip()
            generateHAPluginCfgs(genDefs,initNodeNom,initSrvrNom)
        else:
            print "Wrong number of arguments for generateHAPluginCfgs operation"
    elif (action == 'forceTreeRequest'):
        if (len(sys.argv) == 4):
            member = sys.argv[1].rstrip()
            initNodeNom = sys.argv[2].rstrip()
            initSrvrNom = sys.argv[3].rstrip()
            forceTreeRequest(member,initNodeNom,initSrvrNom)
        elif (len(sys.argv) == 3):
            initNodeNom = sys.argv[1].rstrip()
            initSrvrNom = sys.argv[2].rstrip()
            forceTreeRequest('""',initNodeNom,initSrvrNom)
        else:
            print "Wrong number of arguments for forceTreeRequest operation"
    else:
        print "Unsupported operation"
        printHelp()
else:
    printHelp()
