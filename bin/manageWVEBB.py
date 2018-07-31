from com.ibm.websphere.hamanager.jmx import BulletinBoardSnapshot
from java.lang import Integer
from java.lang import Object
import os;

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

def getMbeans(nodeName,serverName):
  if (nodeName=="" and serverName==""):
    mbeanStr='WebSphere:*,type=BBSON'
    mbeans=convertToList(AdminControl.queryNames(mbeanStr))
    return mbeans
  node = AdminConfig.getid("/Node:"+nodeName+"/")
  if (node == ""):
    raise NameError(nodeName + " is not the name of a valid node")
  server = AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/")
  if (server == ""):
    raise NameError(serverName + " is not the name of a valid server on node " + nodeName)

  mbeanStr='WebSphere:*,type=BBSON,node=' + nodeName + ',process=' + serverName
  mbeans=convertToList(AdminControl.queryNames(mbeanStr))
  return mbeans


def dumpBB(nodeName,serverName): 
  mbeans=getMbeans(nodeName,serverName)
  dirname = 'bbdumps'
  if not os.path.isdir('./' + dirname + '/'):
    os.mkdir('./' + dirname + '/')
  for mbean in  mbeans:
     print 'BEAN,' + mbean
     objName = AdminControl.makeObjectName(mbean)
     parms = []
     sig = []
     asd = AdminControl.invoke_jmx(objName,'getAbstractStateDump',parms,sig)
     dest = asd.writeAsFiles("bbdumps", "*");
     print 'Wrote abstract dump to ' + dest
     csd = AdminControl.invoke_jmx(objName,'getConcreteStateDump',parms,sig)
     dest = csd.writeAsFile("bbdumps", "concrete.txt");
     print 'Wrote concrete dump to ' + dest

def getSnapShot(nodeName,serverName): 
  mbeans=getMbeans(nodeName,serverName)
  dirname = 'bbdumps'
  if not os.path.isdir('./' + dirname + '/'):
    os.mkdir('./' + dirname + '/')
  for mbean in  mbeans:
     print 'BEAN,' + mbean
     objName = AdminControl.makeObjectName(mbean)
     parms = []
     sig = []
     ss = AdminControl.invoke_jmx(objName,'getSnapshot',parms,sig)
     print ss

def getStatisticsPrintInterval(nodeName,serverName): 
  mbeans=getMbeans(nodeName,serverName)
  for mbean in  mbeans:
     print 'BEAN,' + mbean
     objName = AdminControl.makeObjectName(mbean)
     parms = []
     sig = []
     ss = AdminControl.invoke_jmx(objName,'getStatisticsPrintTimeout',parms,sig)
     print 'Statistics Print Timeout=' + str(ss/1000)
 	 
def setStatisticsPrintInterval(nodeName,serverName, newInterval): 
  mbeans=getMbeans(nodeName,serverName)
  for mbean in  mbeans:
     print 'BEAN,' + mbean
     objName = AdminControl.makeObjectName(mbean)
     sig = []
     interval=int(newInterval)*1000
     AdminControl.invoke(mbean,'setStatisticsPrintTimeout','[%d]' % (interval))

 	 

def printHelp(): 
  print """   
  This script was deprecated in WAS 8.5; use manageBBSON.py instead.
  Supported Options:
    wsadmin -f manageBB.py <operation> [nodeName serverName]
      <operation> is mandatory and is one of:
        dump - dump the state of the bulletin board
        getsnapshot - obtains statistics about the current state of the bulletin board
        getStatisticsPrintInterval - display the current interval between printing bulletin board statistics (seconds)
        setStatisticsPrintInterval - set the interval between printing bulletin board statistics (seconds)
      [nodeName serverName] - without this optional argument, the mbean will be invoked against every process in the cell.
        Providing a nodeName and serverName will narrow the invocation to the specific node/server listed.
  """
   
   
if(len(sys.argv) > 0):
    action = sys.argv[0].rstrip()
    if(action=='dump'):
        if(len(sys.argv)==3):
          dumpBB(sys.argv[1].rstrip(),sys.argv[2].rstrip())
        elif(len(sys.argv)==1):
          dumpBB("","")
        else:
          print "Wrong number of arguments for dump operation"
          printHelp()
    elif(action=='getsnapshot'):
        if(len(sys.argv)==3):
          getSnapShot(sys.argv[1].rstrip(),sys.argv[2].rstrip())
        elif(len(sys.argv)==1):
          getSnapShot("","")
        else:
          print "Wrong number of arguments for getsnapshot operation"
          printHelp()
    elif(action=='getStatisticsPrintInterval'):
        if(len(sys.argv)==3):
          getStatisticsPrintInterval(sys.argv[1].rstrip(),sys.argv[2].rstrip())
        elif(len(sys.argv)==1):
          getStatisticsPrintInterval("","")
        else:
          print "Wrong number of arguments for getStatisticsPrintInterval operation"
          printHelp()
    elif(action=='setStatisticsPrintInterval'):
        if(len(sys.argv)==4):
          setStatisticsPrintInterval(sys.argv[1].rstrip(),sys.argv[2].rstrip(),sys.argv[3])
        elif(len(sys.argv)==2):
          setStatisticsPrintInterval("","",sys.argv[1])
        else:
          print "Wrong number of arguments for setStatisticsPrintInterval operation"
          printHelp()
    else:
        print "Unknown operation specified"
        printHelp()
else:
    printHelp()
 
 
 
