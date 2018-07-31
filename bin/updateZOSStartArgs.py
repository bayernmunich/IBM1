import sys

#--------------------------------------------------------------
# Script to update ONLY z/OS server's server.xml startCommandArgs to 
#   add or remove the REUSASID=YES parameter.
#
# Websphere Application Server version has to be 6.1 or higher.
# 
# If no options are specified, the script will look at all servers
#   in the config.   If -node and -server options are specified, the
#   script will work on just that one server that matches the node 
#   and server values.
#   If only -node is specified, the script will work on servers in 
#   that node.
#   If only -server is specified, the script will work on servers 
#   with the same name.
#
# The -remove option will cause the script to remove REUSASID=YES from
#   server.xml of the servers specified by -node and -server options,
#   if specified.
#
# The DeploymentManager server does not need to be running for the script to work.
# Any running server should be restarted after this script finishes to pick up
# the changes.
#
# Typical syntax would be:
#   wsadmin.sh -conntype NONE -lang jython -f /path/to/script/updateZOSStartArgs.py -node <nodeName> -server <serverName>
#
#   wsadmin.sh -conntype NONE -lang jython -f /path/to/script/updateZOSStartArgs.py -scripthelp
#--------------------------------------------------------------
def myDebug(debugmsg="default msg."):
     if traceflag == 'true' :
         print debugmsg
#endDef

serversList = []
removeflag = 'false'
traceflag = 'false'
helpflag = 'false'
silentmode = 'false'
myNode = 'notSet'
myServer = 'notSet'
sep = java.lang.System.getProperty("line.separator")

parm = 0
for thisarg in sys.argv :
    if thisarg == '-scripthelp' :
        helpflag = 'true'

    if thisarg == '-remove' :
        removeflag = 'true'

    if thisarg == '-trace':
        traceflag = 'true'

    if thisarg == '-silent':
        silentmode = 'true'

    if thisarg == '-node':
        myNode =  sys.argv[parm + 1]

    if thisarg == '-server':
        myServer =  sys.argv[parm + 1]

    parm = parm + 1

#endfor

if helpflag == 'false' :     
    myDebug("removeflag: "+removeflag)
    myDebug("traceflag:  "+traceflag)
    myDebug("silentmode:  "+silentmode)
    myDebug("line separator: "+repr(sep))

    if myServer != 'notSet' :  
        if myNode != 'notSet':
            print "myNode: "+myNode+" myServer: "+myServer
            serversList = AdminConfig.getid("/Node:"+myNode+"/Server:"+myServer+"/").split(sep)   
        else:    #only got a server name
            print "No Node name given. Looking for servers: "+myServer
            serversList = AdminConfig.getid("/Node:/Server:"+myServer+"/").split(sep)
    elif myNode != 'notSet':   #only got a node name
        print "Handling all servers in node: "+myNode
        serversList = AdminConfig.getid("/Node:"+myNode+"/Server:/").split(sep)
    else:  #both are NOT set
        print "Handling all servers in config...."
        serversList = AdminConfig.list("Server").split(sep)
    #endif

    if serversList != ['']:                    #empty list?
        print "....................................."
        print "About to operate on this serversList:       "
        item = 0
        listlen = len(serversList)
        while item < listlen :
            print "  "+serversList[item]
            item = item + 1
        #endwhile
        print "....................................."
        print "WARNING: The presence of the REUSASID=YES is not supported if your server is using MQ Listener ports and JMS is configured to connect to an MQ in bindings mode."
        print "....................................."
        if silentmode == 'false' :
            response = raw_input("Do you wish to continue? Please enter a Y/N: ")
            if response in ('y', 'Y'):
                print "Got Yes response. Continuing......"
            else:
                serversList = []
                print "Exiting now................"
            #endif
        #endif

        #loop thru each server
        for aServer in serversList:
            print "__________________"
            print "processing server:  "+aServer
            serverInfoList = AdminTask.showServerInfo(aServer).split()
            myDebug("serverInfoList:  "+repr(serverInfoList))
            #get node from serverInfo
            index = 1
            length = len(serverInfoList)
            myDebug("length of serverInfoList: "+repr(length))
            while index <= length :
                myDebug("item: "+serverInfoList[index])
                if serverInfoList[index].find("node") != -1 :     #look for node
                    valindex = index + 1             #next element is node value
                    node = serverInfoList[valindex].replace(']','')
                #endif
                if serverInfoList[index].find("server") != -1 :     #look for server
                    valindex = index + 1             #next element is server value
                    process = serverInfoList[valindex].replace(']','')
                #endif

                index = index + 2   #go to next key
            #endwhile

            print "node is:"+node
            print "process is: "+process
            #if z/os, update the startCommandArgs, otherwise continue
            if AdminTask.getNodePlatformOS('[-nodeName '+node+']') == 'os390' :
                productversionlong = AdminTask.getNodeBaseProductVersion('[-nodeName '+node+']')
                firstdigit = productversionlong[0]
                seconddigit = productversionlong[2]
                ourversion = int(firstdigit)
                ourminor = int(seconddigit)
                print "WAS version: "+repr(ourversion)+" minor "+repr(ourminor)+" ."
                if (ourversion == 6 and ourminor == 1) or (ourversion > 6)  :     # if 6.1 or higher
                    jpdsList = AdminConfig.list("JavaProcessDef", aServer).split(sep)
                    myDebug("jpdsList:  "+repr(jpdsList))

                    #loop thru each JavaProcessDef of that server
                    for jpd in jpdsList:
                        print "..........processing jpd:       "+repr(jpd)
                        oldValue = AdminConfig.showAttribute(jpd, "startCommandArgs")
                        displayoldValue = oldValue.replace("&","&amp;")   #displayoldvalue just for prints
                        print "oldValue is:       "+displayoldValue
                            
                        if removeflag == 'false' :   #we are adding
                                pType = AdminConfig.showAttribute(jpd, "processType")
                                displaypType = pType.replace("&","&amp;")
                                print "pType is:       "+displaypType
                                if pType == 'Control' :   #only for Control region

                                    #check if REUSASID=YES already there and add if not there
                                    if oldValue.find("REUSASID=YES") == -1 :
                                        newValue = oldValue+",REUSASID=YES"
                                        displaynewValue = newValue.replace("&","&amp;")    #displaynewvalue just for print
                                        print "newValue is:       "+displaynewValue
                                        #unset attribute first, then modify due to scripting limitation
                                        AdminConfig.unsetAttributes(jpd, "startCommandArgs")
                                        print "Modifying startCommandArgs."
                                        AdminConfig.modify(jpd, [["startCommandArgs", newValue]])
                                    else:
                                        print "startCommandArgs for "+aServer+": JavaProcessDef "+repr(jpd)+"contains REUSASID=YES already."
                                    #endif
                                else:
                                    print "pType("+pType+") is not Control, not processing."
                                #endif
                        else:  #removeflag is true
                                #check if REUSASID=YES is there and remove it
                                index = oldValue.find("REUSASID=YES")
                                if index != -1 :
                                    newValue =  oldValue.replace(",REUSASID=YES","")
                                    newValue =  newValue.replace("REUSASID=YES,","")
                                    displaynewValue = newValue.replace("&","&amp;")   #displaynewvalue just for print
                                    print "newValue is:       "+displaynewValue
                                    #unset attribute first, then modify due to scripting limitation
                                    AdminConfig.unsetAttributes(jpd, "startCommandArgs")
                                    print "Modifying startCommandArgs."
                                    AdminConfig.modify(jpd, [["startCommandArgs", newValue]])
                                else:  #didn't find it
                                    print "INFO: startCommandArgs for "+aServer+": JavaProcessDef "+repr(jpd)+"does NOT contain REUSASID=YES."
                                #endif
                        #endif
                    #endfor
                    print "Saving changes."
                    AdminConfig.save()
                               
                else: 
                    print "INFO: Node "+node+" is NOT at the proper WAS version(6.1 or higher).  No changes were made for server "+aServer+"."
            else:
                print "INFO: Node "+node+" is NOT a z/OS node.  No changes were made for server "+aServer+"."
        #endfor
    else:
        print "INFO: No servers were found matching the criteria. No changes were made."

else:
    print "Syntax help: "
    print "   -scripthelp    option to print this help text"
    print "   -silent  option to bypass the question."
    print "   -remove  option to remove REUSASID=YES "
    print "   -node <nodeName>  option specifying a nodeName "
    print "   -server <serverName> option specifying a serverName "
    print "   -trace  option to enable debug msgs"
#endif


print "end of script......"