#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# setupJavaAwt - sets the java.awt.headless property to true for the dmgr
#

print "testing to make sure java.awt.headless property is set on the dmgr"

# Setting up constants
maximumHeapSize = 512


dmgr = AdminConfig.getid("/Server:dmgr")
if (dmgr != ""):
   processDef = AdminConfig.showAttribute(dmgr,"processDefinitions")
   processDef = processDef[1:len(processDef)-1]
   jvmEntries = AdminConfig.showAttribute(processDef,"jvmEntries")
   jvmEntries = jvmEntries[1:len(jvmEntries)-1]
   currentMaxHeap = AdminConfig.showAttribute(jvmEntries,"maximumHeapSize")
   if (currentMaxHeap < maximumHeapSize):
      AdminConfig.modify(jvmEntries,[["maximumHeapSize", maximumHeapSize]])
   systemProperties = AdminConfig.showAttribute(jvmEntries,"systemProperties")
   systemProperties = systemProperties[1:len(systemProperties)-1]
   systemProperties = systemProperties.rstrip().split(" ")
   foundheadless=0
   print "existing system properties:"
   for systemProperty in systemProperties:
      systemProperty = systemProperty.rstrip()
      if (systemProperty !=""):
         name = AdminConfig.showAttribute(systemProperty,"name")
         value = AdminConfig.showAttribute(systemProperty,"value")
         print "\t"+name+"="+value
         if (name == "java.awt.headless"):
            foundheadless=1
            break
   if (foundheadless==0):
      AdminConfig.create("Property",jvmEntries,[["name","java.awt.headless"],["value","true"]])
      print "adding java.awt.headless=true"
   print "saving workspace"
   AdminConfig.save()
print "finished."
