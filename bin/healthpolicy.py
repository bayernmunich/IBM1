# (C) Copyright IBM Corp. 2004,2005,2006 - All Rights Reserved.
# DISCLAIMER:
# The following source code is sample code created by IBM Corporation.
# This sample code is provided to you solely for the purpose of assisting you 
# in the  use of  the product. The code is provided 'AS IS', without warranty or 
# condition of any kind. IBM shall not be liable for any damages arising out of your
# use of the sample code, even if IBM has been advised of the possibility of
# such damages.
#
#=======================================================================================================================================================
# This file contains a series of operations to help automate the administration of health policies.
# For General Help:
#     >> ./wsadmin.sh -lang jython -f healthpolicy.py
# For Operation Specific Help:
#     >> ./wsadmin.sh -lang jython -f healthpolicy.py <operation> --help
# 
# Supported Operations:
#   createHealthPolicy [options] 
#   removeHealthPolicy [options] 
#	addMember [options]
#   removeMember [options]
#
import sys

lineSeparator = java.lang.System.getProperty('line.separator')

#=======================================================================================================================================================
#
# createHealthPolicy description:
#
#     Creates a health policy with the specified options.  The new health policy does 
#     not have any members associated with it.  You must add members separately.
#      
#     options: 
#     --hpname  a name for the health policy that is unique in the cell
#     --hcond   an integer that represents the health condition type
#                0 = age
#                1 = work
#                2 = excessive response time
#                3 = excessive memory
#                4 = memory leak
#                5 = stuck request
#                6 = storm drain
#     --hrs	"hr1, hr2", an integer that represents the reaction (depends on type)
#                0 = restart [default]
#                1 = thread dump
#                2 = heap dump
#     --hrmode  an integer that represents the reaction mode
#                2 = supervised [default]
#                3 = automatic 
#     --hpd     an optional description of the health policy
#
#     Age condition parameters
#     --tt      maximum age value
#     --tunits  an integer that represents time units
#                0 = milliseconds 
#                1 = seconds 
#                2 = minutes 
#                3 = hours
#                4 = days
#     --hrmode  as previously described
#                                    
#     Work condition parameters
#     --reqs    number of requests for work policy
#     --hrmode  as previously described
#
#     Response time condition parameters
#     --tt      maximum response time
#     --tunits  as previously described
#     --hrmode  as previously described
#
#     Memory condition parameters
#     --perc    percentage of heap size for excessive memory policy
#     --tt      time over threshold for memory policy
#     --tunits  as previously described
#     --hrmode  as previously described
#
#     Memory leak condition parameters
#     --level   integer representation for level of leak detection
#                0 = aggressive
#                1 = normal [default]
#                2 = conservative
#     --hrs 	as previously described, restart, or heap dump
#     --hrmode  as previously described
#
#     Stuck request condition parameters
#     --perc    timeout percentage for stuck request policy
#     --hrs 	as previously described, restart, or thread dump
#     --hrmode  as previously described
#
#     Storm drain condition parameters
#     --level   an integer that represents the level of storm drain detection
#                1 = normal [default]
#                2 = conservative
#     --hrmode  as previously described
#  
#     examples: 
#      age health policy with automated restart:  
#           >> ./wsadmin.sh -lang jython -f healthpolicy.py createHealthPolicy --hpname Daily --hcond 0 --tt 1 --tunits 4  
#      repsonse time health policy with supervised restart:  
#           >> ./wsadmin.sh -lang jython -f healthpolicy.py createHealthPolicy --hpname TenSec --hcond 2 --tt 10 --tunits 0 --hrmode 2 
#      memory leak policy with automated heap dumps:  
#           >> ./wsadmin.sh -lang jython -f healthpolicy.py createHealthPolicy --hpname Leaky --hcond 4 --hrs 0,2 -hpd "memory leak policy"
#
#=======================================================================================================================================================
def createHealthPolicy():
  cellid = AdminConfig.list("Cell")
  hpid = ""
  htype = ""
  hattributes = []

  if hpname == "":
     print "ERROR: Must specify the name of the health policy."
     printCreateHealthPolicyHelp()
     return 1
  else:
     # make sure the provided name is unique
     hpids = AdminConfig.list("HealthClass")
     hpList = hpids.split("\n")
     for hp in hpList:
       hp = hp.rstrip()
       if (hp.split("(")[0] == hpname):
          print "ERROR: Health policy of name "+hpname+" already exists. Provide a health policy name that is unique in the cell."
          return 1
   
  if hcond == -1:
     print "ERROR: Must specify the condition type of the health policy."
     printCreateHealthPolicyHelp()
     return 1
  elif hcond == 0:
     # age health policy
     print "INFO: Age policy specified"

     # make sure all the necessary parameters were provided for policy
     if (tt == -1):
        print "ERROR: Must specify an age value for the health policy."
        printCreateHealthPolicyHelp()
        return 1
     if (tunits == -1):
        print "ERROR: Must specify time units for the health policy."
        printCreateHealthPolicyHelp()
        return 1
        
     if (hrs == []):
     	print "INFO: No reaction specified. Assuming the restart reaction."
     else:
     	for hr in hrs:
	  	    if (hr!="0"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1
  	    
     htype = "AgeCondition"
     hattributes = [["maxAge",tt],["ageUnits",tunits]]
     
  elif hcond == 1:
     # work health policy
     print "INFO: Work policy specified."

     # make sure all the necessary parameters were provided for policy
     if (reqs == -1):
        print "ERROR: Must specify number of requests for the health policy."
        printCreateHealthPolicyHelp()
        return 1

     if hrs == []:
        print "INFO: No reaction specified. Assuming the restart reaction."
     else:
 	    for hr in hrs:
	  	    if (hr!="0"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1

     htype = "WorkloadCondition"
     hattributes = [["totalRequests",reqs]]

  elif hcond == 2:
     # response time health policy
     print "INFO: Response time policy specified."

     # make sure all the necessary parameters were provided for policy
     if (tt == -1):
        print "ERROR: Must specify a response time for the health policy."
        printCreateHealthPolicyHelp()
        return 1
     if (tunits == -1):
        print "ERROR: Must specify time units for the health policy."
        printCreateHealthPolicyHelp()
        return 1

     if hrs == []:
        print "INFO: No reaction specified. Assuming the restart reaction."
     else:
 	    for hr in hrs:
	  	    if (hr!="0"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1

     htype = "ResponseCondition"
     hattributes = [["responseTime",tt],["responseTimeUnits",tunits]]
     
  elif hcond == 3:
     # excessive memory health policy
     print "INFO: Excessive memory policy specified."
     
     # make sure all the necessary parameters were provided for policy
     if (perc == -1):
        print "ERROR: Must specify memory percentage for the health policy."
        printCreateHealthPolicyHelp()
        return 1
     if (tt == -1):
        print "ERROR: Must specify time over threshold for the health policy."
        printCreateHealthPolicyHelp()
        return 1
     if (tunits == -1):
        print "ERROR: Must specify time units for the health policy."
        printCreateHealthPolicyHelp()
        return 1
 
     if hrs == []:
        print "INFO: No reaction specified. Assuming the restart reaction."
     else:
 	    for hr in hrs:
	  	    if (hr!="0"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1

 
     htype = "MemoryCondition"
     hattributes = [["memoryUsed",perc],["timeOverThreshold",tt],["timeUnits",tunits]]
     
  elif hcond == 4:
     # memory leak health policy
     print "INFO: Memory leak policy specified."
 
     htype = "MemoryLeakAlgorithm"
     if (level==0):
     	clevel="AGGRESSIVE"
     elif (level==1):
     	clevel="NORMAL"
     elif (level==2):
     	clevel="CONSERVATIVE"
     else:
     	print "ERROR: Invalid setting for detection level."
     	printCreateHealthPolicyHelp()
     	return 1
 
     hattributes = [["level",clevel]]

     if hrs == []:
        print "INFO: No reaction specified. Assuming the restart reaction."
     else:
	    for hr in hrs:
	  	    if (hr=="1"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1

  elif hcond == 5:
     # stuck request health policy
     print "INFO: Stuck request policy specified."
     
     # make sure all the necessary parameters were provided for policy
     if (perc == -1):
        print "ERROR: Must specify percentage for the health policy"
        printCreateHealthPolicyHelp()
        return 1
         
     if hrs == []:
        print "INFO: No reaction specified. Assuming the restart reaction."
     else:
	    for hr in hrs:
	  	    if (hr=="2"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1

     htype = "StuckRequestCondition"
     hattributes = [["timeoutPercent",perc]]
    
  elif hcond == 6:
     # storm drain health policy
     print "INFO: Storm drain policy specified."

     htype = "StormDrainCondition"
     if (level==1):
       clevel="NORMAL"
     elif (level==2):
     	clevel="CONSERVATIVE"
     else:
     	print "ERROR: Invalid setting for detection level."
     	printCreateHealthPolicyHelp()
     	return 1

     hattributes = [["level",clevel]]
     
     if hrs == []:
        print "INFO: No reaction specified. Assuming the restart reaction."
     else:
	    for hr in hrs:
	  	    if (hr!="0"):
		        print "ERROR: Unsupported reaction for the health policy."        
		        printCreateHealthPolicyHelp()
        		return 1
     

  # finished processing paraemeters, now create the policy  
  print "INFO: Creating health policy ..."
  hpid = AdminConfig.create("HealthClass",cellid,[["name",hpname],["description",hpd],["reactionMode",hrmode]])
  condid = AdminConfig.create(htype, hpid, hattributes,"HealthCondition")
  if hrs == []:
    aid = AdminConfig.create("HealthAction", hpid, [["actionType","RESTART"]],"healthActions")
  else:
    for hr in hrs:
      # create health actions
      if (hr=="0"):
        atype="RESTART"
        aid = AdminConfig.create("HealthAction", hpid, [["actionType",atype],["stepNum","3"]],"healthActions")
      elif (hr=="1"):
        atype="THREADDUMP"
        aid = AdminConfig.create("HealthAction", hpid, [["actionType",atype],["stepNum","2"]],"healthActions")
      else:
        atype="HEAPDUMP"
        aid = AdminConfig.create("HealthAction", hpid, [["actionType",atype],["stepNum","1"]],"healthActions")

  print "INFO: Saving health policy ..."
  AdminConfig.save()
  print "INFO: Health policy was created successfully. New health policy id ="+hpid
  return 0

def printCreateHealthPolicyHelp():
  print """
    createHealthPolicy [options]
 
      Creates a health policy with the specified options.  The new health policy does 
      not have any members associated with it.  You must add members separately.
       
      options: 
      --hpname  a name for the health policy that is unique in the cell  
      --hcond   an integer that represents the health condition type
                 0 = age
                 1 = work
  	         2 = excessive response time
                 3 = excessive memory
                 4 = memory leak
                 5 = stuck request
		 6 = storm drain
      --hrs	"hr1, hr2", an integer that represnts the reaction (depends on type)
                 0 = restart [default]
                 1 = thread dump
                 2 = heap dump
      --hrmode  an integer that represents the reaction mode
                 2 = supervised [default]
                 3 = automatic
      --hpd     health policy description [optional]
 
      Age condition parameters
      --tt      maximum age value
      --tunits  an integer that represents time units
                 0 = milliseconds 
                 1 = seconds 
                 2 = minutes 
                 3 = hours
                 4 = days
      --hrmode  as previously described
 
      Work condition parameters
      --reqs    number of requests for work policy
      --hrmode  as previously described
 
      Response time condition parameters
      --tt      maximum response time
      --tunits  as previously described
      --hrmode  as previously described
 
      Memory condition parameters
      --perc    percentage of heap size for excessive memory policy
      --tt      time over threshold for memory policy
      --tunits  as previously described
      --hrs 	one or more of: previously described, restart or heap dump
      --hrmode  as previously described
 
      Memory leak condition parameters
      --level   integer representation for level of leak detection
                 0 = aggressive
                 1 = normal [default]
                 2 = conservative
      --hrs 	one or more of: previously described, restart or heap dump
      --hrmode  as above
 
      Stuck request condition parameters
      --perc    timeout percentage for stuck request policy
      --hrs 	one or more of: previously described, restart or thread dump
      --hrmode  as above
 
      Storm drain condition parameters
      --level   integer representation for level of storm drain detection
                 1 = normal [default]
                 2 = conservative
      --hrmode  as above
   
      examples: 
       age health policy with automated restart:  
            >> ./wsadmin.sh -lang jython -f healthpolicy.py createHealthPolicy --hpname Daily --hcond 0 --tt 1 --tunits 4  
       response time health policy with supervised restart:  
            >> ./wsadmin.sh -lang jython -f healthpolicy.py createHealthPolicy --hpname TenSec --hcond 2 --tt 10 --tunits 0 --hrmode 2 
       memory leak policy with automated heap dumps:  
            >> ./wsadmin.sh -lang jython -f healthpolicy.py createHealthPolicy --hpname Leaky --hcond 4 --hrs 0,2 -hpd \"memory leak policy\"

   """
#=======================================================================================================================================================
#
# removeHealthPolicy description:
#
#      Removes the named health policy. 
#  
#      options:
#      --hpname cell unique name for the health policy
#  
#      Examples:
#        >> ./wsadmin.sh -lang jython -f healthpolicy.py removeHealthPolicy --hpname Daily  
#
#=======================================================================================================================================================
def removeHealthPolicy():
  hpid = ""
  if hpname == "":
     print "ERROR: Must specify the name of the health policy."
     printRemoveHealthPolicyHelp()
     return 1
  else:
     # make sure the provided name is unique
     hpids = AdminConfig.list("HealthClass")
     hpList = hpids.split("\n")
     for hp in hpList:
       hp = hp.rstrip()
       if (hp.split("(")[0] == hpname):
          hpid = hp
          break

  if (hpid == ""):
     print "ERROR: Health Policy not found with name: "+hpname+". Can not remove."
     return 1
  else:
     print "INFO: Removing Health Policy: "+hpid
     AdminConfig.remove(hpid)
     AdminConfig.save()
     print "INFO: Health Policy successfully removed."
     return 0

def printRemoveHealthPolicyHelp():
  print """
    removeHealthPolicy [options]
  
       Removes the health policy named.  
  
       options:
       --hpname cell unique name for the health policy
  
       Examples:
         >> ./wsadmin.sh -lang jython -f healthpolicy.py removeHealthPolicy --hpname Daily  
   
   """

#=======================================================================================================================================================
#
#    addMember [options]
#  
#       Adds the member to the named health policy.  
# 
#       options:
#      --hpname name for the health policy that is unique in the cell
#      --mname  member name
#      --mtype  member type
#                1 = application server
#                2 = cluster 
#                3 = dynamic cluster
#                4 = cell
#        where member type forms
#                server:!:node (application server)
#                clusterName (static and dynamic cluster)  
#                cellName (cell)
# 
#      Examples:
#        >> ./wsadmin.sh -lang jython -f healthpolicy.py addMember --hpname Daily --mtype 3 --mname TestClusterA 
# 
#=======================================================================================================================================================

def addMember():
  cellid = AdminConfig.list("Cell")
  hpid = ""

  if mname == "":
     print "ERROR: Must specify the member name."
     printAddMemberHelp()
     return 1
  if mtype == -1:
     print "ERROR: Must specify the member type."
     printAddMemberHelp()
     return 1
  	
  if hpname == "":
     print "ERROR: Must specify the name of the health policy."
     printAddMemberHelp()
     return 1
  else:
     # find the health policy 
     hpids = AdminConfig.list("HealthClass")
     hpList = hpids.split("\n")
     for hp in hpList:
       hp = hp.rstrip()
       if (hp.split("(")[0] == hpname):
          hpid = hp
          break
  
  if (hpid==""):
     print "ERROR: Specified health policy does not exist. Specify an existing health policy."
     printAddMemberHelp()
     return 1
  
  # finished processing paraemeters, now create the transaction class  
  print "INFO: Adding member ..."
  tcid = AdminConfig.create("TargetMembership", hpid, [["memberString",mname],["type", mtype]],"targetMemberships")
  print "INFO: Saving member ..."
  AdminConfig.save()
  print "INFO: Member successfully created. New member id ="+tcid
  return 0
 
def printAddMemberHelp():
  print """
    addMember [options]
  
       Adds the member to the health policy named.  
  
       options:
       --hpname cell unique name for the health policy
       --mname  member name
       --mtype  member type
		1 = app server
		2 = cluster 
		3 = dynamic cluster
		4 = cell
         where member type forms
               server:!:node (application server)
               clusterName (static and dynamic cluster)  
               cellName (cell)
		
  
       Examples:
         >> ./wsadmin.sh -lang jython -f healthpolicy.py addMember --hpname Daily --mtype 3 --mname TestClusterA 
   
   """

#=======================================================================================================================================================
#
#    removeMember [options]
#  
#       Removes the member from the named health policy.  
# 
#       options:
#      --hpname name for the health policy that is unique in the cell
#      --mname  member name
# 
#      Examples:
#        >> ./wsadmin.sh -lang jython -f healthpolicy.py addMember --hpname Daily --mname TestClusterA 
# 
#=======================================================================================================================================================

def removeMember():
  hpid = ""
  mid = ""
  
  if hpname == "":
     print "ERROR: Health policy name not specified."
     printRemoveMemberHelp()
     return 1
  else:
     # find the health policy 
     hpids = AdminConfig.list("HealthClass")
     hpList = hpids.split("\n")
     for hp in hpList:
       hp = hp.rstrip()
       if (hp.split("(")[0] == hpname):
          hpid = hp
          break
  
  if (hpid==""):
     print "ERROR: Specified health policy does not exist. Specify an existing health policy."
     printAddMemberHelp()
     return 1

  if mname == "":
     print "ERROR: Member name not specified."
     printRemoveMemberHelp()
     return 1
  else:
  	# find the member
    mList = AdminConfig.showAttribute(hpid, "targetMemberships").replace("[","").replace("]","").split(" ")
    for member in mList:
       if member=="":
          break
       if AdminConfig.showAttribute(member, "memberString")==mname:
          mid = member
          break
    if mid == "":
       print "ERROR: Could not find member "+mname+" for health policy "+hpname+"."
       printRemoveMemberHelp()
       return 1
    else:
     print "INFO: Removing member: "+mid
     AdminConfig.remove(mid)
     AdminConfig.save()
     print "INFO: Member successfully removed."
     return 0

def printRemoveMemberHelp():
  print """
    removeMember [options]
  
       Remove the member from the named health policy.  
  
       options:
       --hpname name for the health policy that is unique in the cell
       --mname  member name
         where member type forms
               server:!:node (application server)
               clusterName (static and dynamic cluster)  
               cellName (cell)       
   
       Examples:
         >> ./wsadmin.sh -lang jython -f healthpolicy.py removeMember --hpname Daily --mname TestClusterA 
   
   """

#=======================================================================================================================================================
#
# Generic HealthPolicy.py Operations:
# 
#=======================================================================================================================================================

def printHelp():
  print """

  For General Help:
      >> ./wsadmin.sh -lang jython -f healthpolicy.py
  For Operation Specific Help:
      >> ./wsadmin.sh -lang jython -f healthpolicy.py <operation> --help
 
  Supported Operations:
    createHealthPolicy [options] 
    removeHealthPolicy [options] 
    addMember [options]
    removeMember [options]
    
  """

def processArguments():
  global  hpname, hpd, hcond, hrs, hrmode, level, tt, tunits, reqs, perc, mtype, mname, argret
  hpname = ""
  hpd = ""
  hcond = -1
  hrs = []
  hrmode = 2
  level = 1
  tt = -1
  tunits = -1
  reqs = -1
  perc = -1
  mtype = -1
  mname = ""
  argret = 0
  
  for i in range(1,len(sys.argv)):
    arg = sys.argv[i]
    if(arg == "--hpname"):
      hpname= sys.argv[i + 1]
      print "INFO: Health Policy Name = "+hpname
    elif(arg == "--hpd"):
      hpd = sys.argv[i + 1]
      print "INFO: Health Policy Description = "+hpd
    elif(arg == "--hcond"):
      hcond = int(sys.argv[i + 1])
      print "INFO: Health Condition Type = "+str(hcond)
      if (hcond < 0 or hcond > 6):
      	print "ERROR: Invalid Health Condition " + str(hcond)
      	argret = 1
      	return
    elif(arg == "--hrs"):
      hrs= sys.argv[i + 1].split(",")
      hrstr = "["
      for hr in hrs:
         hrint = int(hr);
         if (hrint < 0 or hrint > 2):
	      	print "ERROR: Invalid Health Reaction " + str(hcond)
      		argret=1
      		return      	
         hrstr = hrstr +hr+","
      hrstr = hrstr+"]"
      print "INFO: HRs = "+hrstr
    elif(arg == "--hrmode"):
      hrmode = int(sys.argv[i + 1])
      if (hrmode < 2 or hrmode > 3):
      	print "ERROR: Invalid Reaction Mode " + str(hrmode)
      	argret=1
      	return
      print "INFO: Health Reaction Mode = "+str(hrmode) 
    elif(arg == "--level"):
      level = int(sys.argv[i + 1])
      print "INFO: Detection Level = "+str(level)
    elif(arg == "--tt"):
      tt = int(sys.argv[i + 1])
      print "INFO: Time Value = "+str(tt)
    elif(arg == "--tunits"):
      tunits = int(sys.argv[i + 1])
      if (tunits < 0 or tunits > 4):
      	print "ERROR: Invalid Time Units " + str(tunits)
      	argret=1
      	return
      print "INFO: Time Units = "+str(tunits)
    elif(arg == "--reqs"):
      reqs = int(sys.argv[i + 1])
      print "INFO: Number of Requests = "+str(reqs)
    elif(arg == "--perc"):
      perc = int(sys.argv[i + 1])
      print "INFO: Percentage = "+str(perc)
    elif(arg == "--mtype"):
      mtype = int(sys.argv[i + 1])
      if (mtype < 1 or mtype > 4):
      	print "ERROR: Invalid Member Type " + str(mtype)
      	argret=1
      	return
      print "INFO: Member Type = "+str(mtype)
    elif(arg == "--mname"):
      mname = sys.argv[i + 1]
      print "INFO: Member Name = "+mname
    elif(arg.find("--")==0):
      print "WARNING: Unknown option: " +arg

#=======================================================================================================================================================
#
# Main HealthPolicy.py execution logic:
# 
#=======================================================================================================================================================

if(len(sys.argv) > 0):
  option = sys.argv[0]
  help = 0
  if (len(sys.argv) > 1):
    if (sys.argv[1] == "--help"):
   	  help = 1
  if not help:
    processArguments()
    if (argret == 0):
      if (option == 'createHealthPolicy'):
        createHealthPolicy()
      elif (option == 'removeHealthPolicy'):
        removeHealthPolicy()
      elif (option == 'addMember'):
        addMember()
      elif (option == 'removeMember'):
        removeMember()
  else:
    if (option == 'createHealthPolicy'):
      printCreateHealthPolicyHelp()
    elif (option == 'removeHealthPolicy'):
      printRemoveHealthPolicyHelp()
    elif (option == 'addMember'):
      printAddMemberHelp()
    elif (option == 'removeMember'):
      printRemoveMemberHelp()
else:
  printHelp()
