#==============================================================================
#(C) Copyright IBM Corp. 2008 - All Rights Reserved.
#DISCLAIMER:
#The following source code is sample code created by IBM Corporation.
#This sample code is provided to you solely for the purpose of assisting you
#in the  use of  the product. The code is provided 'AS IS', without warranty or
#condition of any kind. IBM shall not be liable for any damages arising out of your
#use of the sample code, even if IBM has been advised of the possibility of
#such damages.
#==============================================================================
# Call this script using wsadmin
# e.g. wsadmin[.bat|.sh] -f dumpXdState.py [options]
# for help: wsadmin[.bat|.sh] -f dumpXdState.py --help
# for auto dump: wsadmin[.bat|.sh] -f dumpXdState.py --auto
#==============================================================================

import string, getopt, sys

#==============================================================================
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

#==============================================================================
def dumpMBeans(mBeanType, operation, process, domain):
    mbeanStr = '%s:*,process=%s,type=%s' % (domain, process, mBeanType)
    try:
        mbeans = convertToList(AdminControl.queryNames(mbeanStr))
    except:
        print 'Error querying %s' % mbeanStr
        return

    for mbean in mbeans:
        print '\n\n\nCALLING:    %s ' % mbean
        try:
            print 'START DATA: %s %s %s \n' % (mBeanType, process, operation)
            print AdminControl.invoke(mbean, operation)
            print '\nEND DATA:   %s %s %s' % (mBeanType, process, operation)
        except:
            print ' Error querying mbean: %s operation: %s\n' % (mBeanType, operation)

#==============================================================================
def printHelp():
    print """
    Syntax:
    \twsadmin -f dumpXdState.py [options]\n
    \toptions are:
    """

    for val in longOpts:
        if (val.endswith('dom=')):
            print '\t\t--' + val + '<domain> (default is "*", all domains)'
        elif (val.endswith('=')):
            print '\t\t--' + val + '<server process name>'
        else:
            print '\t\t--' + val

    print '\n\te.g. wsadmin -f dumpXdState.py --auto'
    print '\n\twill dump state for all server processes it can find'

    mBeanStr = ""
    for bean in MBeanArray:
        mBeanStr += bean[0] + ' '
    print '\tusing the following MBeans: \n\t%s ' % mBeanStr

#==============================================================================
# Start of main program execution
# First define the MBeans that we will process etc
#==============================================================================
domain   = '*'
allProcesses    = []
HAWsmmController= ['HAWsmmController', 'dump']
DWLMClientMBean = ['DWLMClient', 'dumpStats']
ODRMBean        = ['ODR', 'dumpAll']
SCPMBean        = ['SCPMBean', 'dumpState']
TargetTreeMBean = ['TargetTreeMbean', 'getTargetTree']
WsmmProxyMBean  = ['WsmmProxyMBean', 'dumpState']
XdCommMBean     = ['XdCommMBean', 'dumpState']
MBeanArray      = [HAWsmmController, XdCommMBean, WsmmProxyMBean, DWLMClientMBean, \
                   ODRMBean, SCPMBean, TargetTreeMBean]

#==============================================================================
# Parse input options:  we use long options to avoid wsadmin option collisions
# The longOpts array defines the long option values dumpXdState will accept
# Long options passed to dumpXdState must have the form --name or --name=
#==============================================================================
opts = []
notUsed = []
longOpts = ['auto', 'help', 'dom=', 'dmgr=', 'odr=' , 'svr=']

if (len(sys.argv) == 0):
    printHelp()
    sys.exit()
try:
    (opts, args) = getopt.getopt(sys.argv[0:], notUsed, longOpts)
except getopt.error, msg:
    printHelp()
    sys.exit()

#==============================================================================
# Process the command line options
#==============================================================================
for (opt, arg) in opts:
    if (string.lower(opt) == '--auto'):
        for server in AdminConfig.list('Server').split('\n'):
            name = server.split('(')[0]
            if name != 'nodeagent':
                allProcesses.append(name)
    if string.lower(opt) == '--help':
        printHelp()
        sys.exit()
    if string.lower(opt) == '--dmgr':
        allProcesses.append(arg)
    if string.lower(opt) == '--dom':
        domain = arg
    if string.lower(opt) == '--odr':
        allProcesses.append(arg)
    if string.lower(opt) == '--svr':
        allProcesses.append(arg)

#==============================================================================
# This is where we dump all of the MBean stats
#==============================================================================
for process in allProcesses:
    if ((process == '') or (process == ' ')):
        continue
    print '\n\n\nPROCESS:    %s ' % process
    for bean in MBeanArray:
        dumpMBeans(bean[0], bean[1], process, domain)
