###############################################################################
# Licensed Material - Property of IBM
# 5724-I63, 5724-H88, 5733-W70 (C) Copyright IBM Corp. 2010 - All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# DISCLAIMER:
# The following source code is sample code created by IBM Corporation.
# This sample code is provided to you solely for the purpose of assisting you
# in the  use of  the product. The code is provided 'AS IS', without warranty or
# condition of any kind. IBM shall not be liable for any damages arising out of your
# use of the sample code, even if IBM has been advised of the possibility of
# such damages.
###############################################################################

#-----------------------------------------------------------------------------
# File Name:
#      applyPerfTuningTemplate.py
# Purpose:
#      Apply pre-defined performance tuning templates to a specific
#      application server instance or all instances in a cluster. Three
#      templates are pre-defined (default, peak, and development);
#      however, these files can easily be modified to create your own custom
#      tuning template.
# Usage:
#      wsadmin -f applyPerfTuningTemplate.py [-nodeName <node> -serverName <server>] [-clusterName <cluster>] -templateFile <file>
#
#         -nodeName, -serverName"
#            Used together to target a specific server instance for tuning. Cannot be
#            used in conjunction with the -clusterName option.
#         -clusterName
#            Used to target all server instances in a cluster for tuning. Cannot be
#            used in conjunction with the -nodeName and -serverName options.
#         -templateFile
#            Determines which property file template to use for performance tuning.
#
#-----------------------------------------------------------------------------

import ApplyPerfTuning
import sys

#--------------------------------------------------------------------------------------------------------------------------
#Function Name	:	processCmdline
#Input		:	argument List which are passed to this script.	
#returns	:	HashMap .This function Validates,processes and creates a HashMap which will be passed to actual 
#			script which applies the performance tuning parametest to given server or cluster.
#--------------------------------------------------------------------------------------------------------------------------

def processCmdline (myList):
        options = {}
        error = 0

        i = 0
        try:
                while (i < len(myList)):
                        if (myList[i] == "-serverName"):
                                i+=1
                                options["serverName"] = myList[i]
                        elif (myList[i] == "-nodeName"):
                                i+=1
                                options["nodeName"] = myList[i]
                        elif (myList[i] == "-templateFile"):
                                i+=1
                                options["templateFile"] = myList[i]
                        elif (myList[i] == "-clusterName"):
                                i+=1
                                options["clusterName"] = myList[i]
                        else:
                                print "ERROR: Encountered unrecognized command line parameter: %s" % myList[i]
                                error = 1
                        #endElse
                        i += 1
                #endWhile
        except:
                print("Errror!!!")
                printUsage()



	if (not (options.has_key("serverName") and options.has_key("nodeName")) and not options.has_key("clusterName")):
		print "ERROR: Required '-serverName' and '-nodeName' parameters not provided or '-clusterName' not provided."
		error = 1
	elif (options.has_key("clusterName") and (options.has_key("nodeName") or options.has_key("serverName"))):
		print "ERROR: Cannot combine '-clusterName' parameter with '-nodeName' or '-serverName' paramters."
		error = 1
	#endIf

	if (not options.has_key("templateFile")):
		print "ERROR: Required '-templateFile' parameter not provided."
		error = 1
	#endIf

	if (error):
		printUsage()
	#endIf

	print ""
	print "Completed parsing parameters..."
	for k, v in options.items():
		print "  %s - %s" % (k,v)
	#endFor

	return options

def printUsage ():
	print ""
	print "Usage: wsadmin -f applyPerfTuningTemplate.py [-nodeName <node> -serverName <server>] [-clusterName <cluster>] -templateFile <file>"
	print ""
	print "   -nodeName, -serverName"
	print "      Used together to target a specific server instance for tuning. Cannot be"
	print "      used in conjunction with the -clusterName option."
	print "   -clusterName"
	print "      Used to target all server instances in a cluster for tuning. Cannot be "
	print "      used in conjunction with the -nodeName and -serverName options."
	print "   -templateFile"
	print "      Determines which property file template to use for performance tuning."
	print ""
	sys.exit()

argList = []
for i in range(len(sys.argv)):
    argList.append(sys.argv[i])
ApplyPerfTuning.PerfTuneProcess(processCmdline(argList))




