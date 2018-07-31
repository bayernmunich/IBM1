#=======================================================================================================================================================
#(C) Copyright IBM Corp. 2004-2009 - All Rights Reserved.
#DISCLAIMER:
#The following source code is sample code created by IBM Corporation.
#This sample code is provided to you solely for the purpose of assisting you
#in the  use of  the product. The code is provided 'AS IS', without warranty or
#condition of any kind. IBM shall not be liable for any damages arising out of your
#use of the sample code, even if IBM has been advised of the possibility of
#such damages.
#=======================================================================================================================================================

#=======================================================================================================================================================
# This file contains a series of operations to help automate the administration of application editions.
# Author: Piyush Agarwal (agarwalp@us.ibm.com)

# appeditionoperations.py
#
# For General Help:
#     >> ./wsadmin.sh -lang jython -f appeditionoperations.py
# For Operation Specific Help:
#     >> ./wsadmin.sh -lang jython -f appeditionoperations.py <operation> --help
# 
# Supported Operations:
#	createEditionMetadata
#
#=======================================================================================================================================================

import sys, httplib, base64, jarray
import com.ibm.ws.xd.appeditionmgr.util.StandaloneEditionPropsGenerator as StandaloneEditionPropsGenerator


#=======================================================================================================================================================
#
# createEditionMetadata description:
#
#	createEditionMetadata <profileName> <profilePath>
#
#		Creates the default edition metadata for all applications within the specified profile
#		If edition metadata is already present, it will not be overwritten
#
#	examples:
#	Create default edition metadata for profile "Profile01" located at "/opt/WebSphere/AppServer/profiles/Profile01"
#	>> ./wsadmin.sh -lang jython -f appeditionoperations.py createEditionMetadata Profile01 /opt/WebSphere/AppServer/profiles/Profile01
#=======================================================================================================================================================
def createEditionMetadata():
	print ""
	
	if (len(sys.argv) != 3):
		printCreateEditionMetadataHelp("Incorrect arguments specified for creating the Edition Properties metadata file")
	else:
		print "*************************Creating Edition Metadata*****************************"
		StandaloneEditionPropsGenerator.create(getarg('<profileName>',1),getarg('<profilePath>',2))
		print ""    
		print "***************************************************************************"    

def printCreateEditionMetadataHelp(msg):
    print msg+"""
	Usage: 
	createEditionMetadata <profileName> <profilePath>

		Creates the default edition metadata for all applications within the specified profile
		If edition metadata is already present, it will not be overwritten
 
		examples:
		Create default edition metadata for profile "Profile01" located at "/opt/WebSphere/AppServer/profiles/Profile01"
		>> ./wsadmin.sh -lang jython -f appeditionoperations.py createEditionMetadata Profile01 /opt/WebSphere/AppServer/profiles/Profile01 
      
	"""

#=======================================================================================================================================================
#
# Helper methods
#
#=======================================================================================================================================================

#
# Print the usage message
#
def usage(msg):
  print msg+"""
	Usage:
	For General Help:
		>> ./wsadmin.sh -lang jython -f appeditionoperations.py
	For Operation Specific Help:
		>> ./wsadmin.sh -lang jython -f appeditionoperations.py <operation> --help

	Supported Operations:
		createEditionMetadata

  """
  sys.exit(1)

#
# An error occurred
#
def error(msg):
  print "ERROR: "+msg

#
# A fatal error occurred
#
def fatal(msg):
  error(msg)
  sys.exit(2)

#
# Get argument number 'count'; print a usage message if it doesn't exist.
#
def getarg(name,count):
  if(len(sys.argv) <= count):
    usage("Too few arguments; argument "+name+" not found")
  return sys.argv[count].rstrip()


#=======================================================================================================================================================
#
# Begin main
#
#=======================================================================================================================================================

if(len(sys.argv) > 0):
	option = str(getarg('<operation>',0))
	help = 0
	if (len(sys.argv) > 1):
		if (sys.argv[1] == "--help"):
			help = 1
	
	if (option == 'createEditionMetadata'):
		if (help == 1):
			printCreateEditionMetadataHelp("")
		else:
			sys.exit(createEditionMetadata())
	else:
		usage("")
else:
	usage("")	

