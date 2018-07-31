#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# createcustHttpAffinityDescr  - creates default session affinity descriptors for various servertypes
#
# @author - mcgillq
#
#=======================================================================================================================================================

import jarray

cell = AdminConfig.getid("/Cell:/")

servertypes=jarray.array(("customhttp_server", "wasce_server"),java.lang.String)
changed=0

for k in range(0,len(servertypes),1):
    learned = "false"
    separator = ":"
    altSep = ""
    # check and create if non-existent
    descriptorId = AdminConfig.getid("/MiddlewareDescriptor:"+servertypes[k]+"/")
    print "INFO: server type=", descriptorId
    if (descriptorId == ""):
        aMode="passive"
        changed=1
                   
        # Create the top level MiddlewareDescriptor Object
        md = AdminConfig.create("MiddlewareDescriptor",cell,[["discoveryIntervalUnits",2],["discoveryInterval",4],["name",servertypes[k]]])
        
        #Create default version
        default = AdminConfig.create("MiddlewareVersionDescriptor",md,[["version","default"]],"versionDescriptors")
        
        # Create a group
        dft_grp1 = AdminConfig.create("DescriptivePropertyGroup",default ,[["name","versionDescriptor"]],"versionDescriptor")
       
        # Create Affinity values
        dft_grp2 = AdminConfig.create("DescriptivePropertyGroup",dft_grp1,[["name","sessionAffinityDescriptor"],["collection","false"],["expandable","false"]],"propertyGroups")
        dft_grp2_dd = AdminConfig.create("DisplayDescriptor",dft_grp2,[["displayNameKey","sessionAffinityDescriptor"],["hoverHelpKey","sessionAffinityDescriptor.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
        
        #Create a properties
        p1_1 =  AdminConfig.create("DiscoverableDescriptiveProperty",dft_grp2,[["name","learnCloneIds"],["value",learned],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
        p1_1_dd = AdminConfig.create("DisplayDescriptor",p1_1,[["displayNameKey","learnCloneIds"],["hoverHelpKey","learnCloneIds.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
        p1_2 =  AdminConfig.create("DiscoverableDescriptiveProperty",dft_grp2,[["name","cookieNames"],["value","WSJSESSIONID,JSESSIONID,SSLJSESSIONID"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
        p1_2_dd = AdminConfig.create("DisplayDescriptor",p1_2,[["displayNameKey","cookieNames"],["hoverHelpKey","cookieNames.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
        p1_3 =  AdminConfig.create("DiscoverableDescriptiveProperty",dft_grp2,[["name","urlRewriteNames"],["value","jsessionid"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
        p1_3_dd = AdminConfig.create("DisplayDescriptor",p1_3,[["displayNameKey","urlRewriteNames"],["hoverHelpKey","urlRewriteNames.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
        p1_4 =  AdminConfig.create("DiscoverableDescriptiveProperty",dft_grp2,[["name","cloneIdSeparator"],["value",separator],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
        p1_4_dd = AdminConfig.create("DisplayDescriptor",p1_4,[["displayNameKey","cloneIdSeparator"],["hoverHelpKey","cloneIdSeparator.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
        p1_5 =  AdminConfig.create("DiscoverableDescriptiveProperty",dft_grp2,[["name","altCloneIdSeparator"],["value",altSep],["type","String"],["range",""],["inclusive","false"],["required","false"]],"properties")
        p1_5_dd = AdminConfig.create("DisplayDescriptor",p1_5,[["displayNameKey","altCloneIdSeparator"],["hoverHelpKey","altCloneIdSeparator.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
        p1_6 =  AdminConfig.create("DiscoverableDescriptiveProperty",dft_grp2,[["name","affinityMode"],["value",aMode],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
        p1_6_dd = AdminConfig.create("DisplayDescriptor",p1_6,[["displayNameKey","affinityMode"],["hoverHelpKey","affinityMode.help"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")

        #Create group timeOut value Group
        timeOutGroupLoc = AdminConfig.create("DescriptivePropertyGroup",dft_grp1,[["name","timeOutGroup"],["collection","false"],["expandable","false"]],"propertyGroups")
    	timeOutGroupLoc_dd = AdminConfig.create("DisplayDescriptor",timeOutGroupLoc,[["displayNameKey","timeOutGroup"],["displayDescriptionKey","timeOutGroup.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
    	                       
    	startTimeOut_mdv =  AdminConfig.create("DiscoverableDescriptiveProperty",timeOutGroupLoc,[["name","startTimeOutValue"],["value","300000"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")

    	startTimeOut_mdv_dd = AdminConfig.create("DisplayDescriptor",startTimeOut_mdv,[["displayNameKey","startTimeOutValue"],["hoverHelpKey","startTimeOutValue.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")

    	stopTimeOut_mdv =  AdminConfig.create("DiscoverableDescriptiveProperty",timeOutGroupLoc,[["name","stopTimeOutValue"],["value","300000"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")

    	stopTimeOut_mdv_dd = AdminConfig.create("DisplayDescriptor", stopTimeOut_mdv,[["displayNameKey","stopTimeOutValue"],["hoverHelpKey","stopTimeOutValue.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
 
                       
# save
if (changed == 1):
   AdminConfig.save()
   print "INFO: changes have been saved."
