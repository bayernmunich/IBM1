#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
#  removeMWDescriptorField.py - removes the new fields added during updateMiddlewareDescriptors.py
#
# @author - mcgill quinn
#
#=======================================================================================================================================================

import jarray

cell = AdminConfig.getid("/Cell:/")
gName = "default"
newPropertyGroup = "timeOut"
timeOutExist = 0

#servertypes=jarray.array(("tomcat_server"),java.lang.String)
servertypes=jarray.array(("application_server", "jboss_server", "weblogic_server", "apache_server", "tomcat_server", "liberty_server", "apacheWebServerRuntime", "phpRuntime"),java.lang.String)
changed=0

for k in range(0,len(servertypes),1):
    # check and update
    descriptorId = AdminConfig.getid("/MiddlewareDescriptor:"+servertypes[k]+"/")
    print "INFO: server type=", descriptorId
    if (descriptorId !=""):
       changed=1
       # Create the top level MiddlewareDescriptor Object
       mvd = AdminConfig.showAttribute(descriptorId,"versionDescriptors")
       mvd = mvd[1:len(mvd)-1]
       version = AdminConfig.showAttribute(mvd,"version")
       print "Version", version
       if (version == gName):
          dpg = AdminConfig.list('DescriptivePropertyGroup', descriptorId).split(java.lang.System.getProperty("line.separator"))
          for descriptiveProperties in dpg:
              pgName = AdminConfig.showAttribute(descriptiveProperties, "name")
              print "Name: ", pgName
              if (pgName == "timeOutGroup"):
                 changed = 1;
                 print "timeOutExisted \n"
                 timeout_ddp = AdminConfig.remove(descriptiveProperties)

#save
if (changed == 1):
   print "saving workspace"
   AdminConfig.save()

print "finished."
