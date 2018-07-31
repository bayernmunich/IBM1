#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# udpatesMiddlewareDescriptors  - updates the  default session affinity descriptors for various servertypes with a new timeOut value.
#
# @author - mcgillq
#
#=======================================================================================================================================================

import jarray
 
cell = AdminConfig.getid("/Cell:/")
gName = "default"
newPropertyGroup = "startTimeOut"

#servertypes=jarray.array(("tomcat_server"),java.lang.String)
servertypes=jarray.array(("application_server", "jboss_server", "weblogic_server", "apache_server", "tomcat_server", "liberty_server", "apacheWebServerRuntime", "phpRuntime", "wasceRuntime", "customhttp_server"),java.lang.String)
changed=0

for k in range(0,len(servertypes),1):
    # check and update  
    timeOutExist = 0
    descriptorId = AdminConfig.getid("/MiddlewareDescriptor:"+servertypes[k]+"/")
    print "INFO: server type=", servertypes[k]
    if (descriptorId !=""): 
       # Create the top level MiddlewareDescriptor Object
       mvd = AdminConfig.showAttribute(descriptorId,"versionDescriptors")
       mvd = mvd[1:len(mvd)-1]
       version = AdminConfig.showAttribute(mvd,"version")
       print "Version", version
       if (version == gName):
          #dpgs = AdminConfig.list('DescriptivePropertyGroup', descriptorId).split(java.lang.System.getProperty("line.separator"))
          ddps = AdminConfig.list('DiscoverableDescriptiveProperty', descriptorId).split(java.lang.System.getProperty("line.separator"))
          for properties in ddps:
              pgName = AdminConfig.showAttribute(properties, "name")
              if (servertypes[k] == 'application_server'):
                 if (pgName == 'learnCloneIds'):
                    learnCloneIds = AdminConfig.modify(properties,[["value","true"]])
                    changed = 1
				
              if (pgName == "startTimeOutValue"):
                  timeOutExist = 1
                  print "Name: ", pgName
                  print "timeOutExist =1 \n"
                 
          # Create new TimeOut group
          if (timeOutExist == 0):
              dpgs = AdminConfig.list('DescriptivePropertyGroup', descriptorId).split(java.lang.System.getProperty("line.separator"))
              changed = 1
              print "Adding timeOutGroup for ", servertypes[k] 
              for propertyGroup in dpgs:    
                  print "PropertyGroup Name: ", propertyGroup

              #Create group timeOut value Group
              timeOutGroupLoc = AdminConfig.create("DescriptivePropertyGroup", propertyGroup,[["name","timeOutGroup"],["collection","false"],["expandable","false"]],"propertyGroups")
              timeOutGroupLoc_dd = AdminConfig.create("DisplayDescriptor",timeOutGroupLoc,[["displayNameKey","timeOutGroup"],["displayDescriptionKey","timeOutGroup.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")                       
 
              startTimeOut_mdv =  AdminConfig.create("DiscoverableDescriptiveProperty",timeOutGroupLoc,[["name","startTimeOutValue"],["value","300000"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
              startTimeOut_mdv_dd = AdminConfig.create("DisplayDescriptor",startTimeOut_mdv,[["displayNameKey","startTimeOutValue"],["hoverHelpKey","startTimeOutValue.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
              stopTimeOut_mdv =  AdminConfig.create("DiscoverableDescriptiveProperty", timeOutGroupLoc,[["name","stopTimeOutValue"],["value","300000"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
              stopTimeOut_mdv_dd = AdminConfig.create("DisplayDescriptor", stopTimeOut_mdv,[["displayNameKey","stopTimeOutValue"],["hoverHelpKey","stopTimeOutValue.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
 
#save
if (changed == 1):
   print "saving workspace"
   AdminConfig.save()

print "finished."
