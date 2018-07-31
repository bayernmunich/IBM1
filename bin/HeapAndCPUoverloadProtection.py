#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
    
#
# script for setting and the CPU or Heap Overload Protection
#
# author: McGill Quinn(mcgillq@us.ibm.com)
    
    
import sys
    
#
#
#  Start off main() program
#
#
    
print "#######################################################"
print "## CPU overload And Heap Overload Protection"
print "## Version:  "
print "#######################################################"
print ""

###################################################
# Parameters controlling execution of the script
###################################################
    
SCRIPT_VERSION="02/01/10"
maximumPercentServerMaxHeap=100
maximumCPUUtilization=100

    
autonomicRequestFlowManager= AdminConfig.list("AutonomicRequestFlowManager")
changed = 0
    
if (len(sys.argv)>0):
   for arg in sys.argv:
       if (arg.startswith("-memoryOverload:")):
           parts = arg.split(":")
           if (parts[1] != ""):
             maximumPercentServerMaxHeap=parts[1]
             AdminConfig.modify(autonomicRequestFlowManager,[['maximumPercentServerMaxHeap',maximumPercentServerMaxHeap]])
             changed = 1
       elif (arg.startswith("-cpuOverload:")):
           parts = arg.split(":")
           if (parts[1] != ""):
             maximumCPUUtilization=parts[1]
             AdminConfig.modify(autonomicRequestFlowManager,[['maximumCPUUtilization',maximumCPUUtilization]])
             changed = 1
       else:
           print "Unrecognized option: "+arg
           print "Available options:"
           print "\t-memoryOverload:<MemoryOverload>        Memory Overload Protection Percentage"
           print "\t-cpuOverload:<CPUOverload>              CPU Overload Protection Percentage"
           sys.exit(1)
else:
    changed = 1
    AdminConfig.modify(autonomicRequestFlowManager,[['maximumPercentServerMaxHeap',maximumPercentServerMaxHeap]])
    AdminConfig.modify(autonomicRequestFlowManager,[['maximumCPUUtilization',maximumCPUUtilization]])

if (changed == 1):
   print "Saving configuration changes"
   AdminConfig.save()

print "Done"
    
