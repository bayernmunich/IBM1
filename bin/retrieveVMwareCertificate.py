#
# Script for retrieving signer certificate from the specified VMWare server
#
# author: Anil Ambati (aambati@us.ibm.com)
#

import sys

hostName = ""
portNumber = ""

def getCellName():
    cell = AdminConfig.getid('/Cell:/')
    name = AdminConfig.showAttribute(cell,"name")
    return name

def getAliasName(hostName):
    tokens = hostName.split(".")
    return tokens[0]+"-vmware"

def printOptions():
   print "required options:"
   print "\t-host:<host name>      hostname of the VMWare server"
   print "\t-port:<port number>    SSL port number of the VMWare server"

# main program starts here

if (len(sys.argv)>0):
   for arg in sys.argv:
       if (arg.startswith("-host:")):
           parts = arg.split(":")
           hostName=parts[1]
       elif (arg.startswith("-port:")):
           parts = arg.split(":")
           portNumber=parts[1]

if (hostName == "" or portNumber == ""):
   printOptions()
   sys.exit(1)

print "retrieving signer certificate from " + hostName+":"+portNumber
AdminTask.retrieveSignerFromPort("[-host " + hostName + " -port " + portNumber + 
                                 " -keyStoreName CellDefaultTrustStore" + 
                                 " -keyStoreScope (cell):" + getCellName() + 
                                 " -sslConfigName CellDefaultSSLSettings -sslConfigScopeName (cell):" + 
                                 getCellName() + " -certificateAlias " + getAliasName(hostName) + "]")
print "successfully retrieved the signer certificate"

print "saving workspace"
AdminConfig.save()
print "finished."
