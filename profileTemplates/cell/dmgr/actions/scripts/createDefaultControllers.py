#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for creating XD default controller configurations
#
# author: bkmartin


cell=AdminConfig.list("Cell")

if (AdminConfig.getid("/AutonomicRequestFlowManager:/") == ""):
   print "creating ARFM"
   arfmattributes= []
   AdminConfig.create("AutonomicRequestFlowManager",cell,arfmattributes)
else:
   print "ARFM already exists"

if (AdminConfig.getid("/AppPlacementController:/") == ""):
   print "creating APC"
   apcattributes= []
   AdminConfig.create("AppPlacementController",cell,apcattributes)
else:
   print "APC already exists"

if (AdminConfig.getid("/HealthController:/") == ""):
   print "creating HMM"
   hmmattributes= []
   AdminConfig.create("HealthController",cell,hmmattributes)
else:
   print "HMM already exists"

print "saving workspace"
AdminConfig.save()
print "finished."

