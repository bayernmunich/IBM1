cell = AdminConfig.getid('/Cell:/')


#Create WASCE descriptor
wasce_md = AdminConfig.getid("/MiddlewareDescriptor:wasceRuntime/")
if (wasce_md == ""): 
    wasce_md = AdminConfig.create("MiddlewareDescriptor",cell,[["discoveryIntervalUnits",2],["discoveryInterval",4],["discoverySupported","true"],["name","wasceRuntime"]])

    wasce_mdv = AdminConfig.create("MiddlewareVersionDescriptor",wasce_md,[["version","default"]],"versionDescriptors")
    wasce_mdv_vd = AdminConfig.create("DescriptivePropertyGroup",wasce_mdv,[["name","versionDescriptor"]],"versionDescriptor")

    installLoc = AdminConfig.create("DescriptivePropertyGroup",wasce_mdv_vd,[["name","install.locations"],["collection","false"],["expandable","false"]],"propertyGroups")
    installLoc_dd = AdminConfig.create("DisplayDescriptor",installLoc,[["displayNameKey","wasce.install.locations"],["displayDescriptionKey","wasce.install.locations.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")

    winInstallLoc = AdminConfig.create("DiscoverableDescriptiveProperty",installLoc,[["name","win.install.loc"],["value","C:\Program Files\IBM\WebSphere\AppServerCommunityEdition;C:\Program Files (x86)\WebSphere\AppServerCommuntiyEdition"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
    winInstallLoc_dd = AdminConfig.create("DisplayDescriptor",winInstallLoc,[["displayNameKey","win.install.loc"],["hoverHelpKey","win.install.loc.help"],["displayDescriptionKey","win.install.loc.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")

    unixInstallLoc = AdminConfig.create("DiscoverableDescriptiveProperty",installLoc,[["name","unix.install.loc"],["value","/opt/IBM/WebSphere/AppServerCommunityEdition"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
    unixInstallLoc_dd = AdminConfig.create("DisplayDescriptor",unixInstallLoc,[["displayNameKey","unix.install.loc"],["hoverHelpKey","unix.install.loc.help"],["displayDescriptionKey","unix.install.loc.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
    
    discoveryClassLoc = AdminConfig.create("DiscoverableDescriptiveProperty", installLoc,[["name","foreign.discovery.class"],["value","com.ibm.ws.xd.agent.discovery.wasce.WASCEDiscoveryPlugin"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
    discoveryClassLoc_dd = AdminConfig.create("DisplayDescriptor",discoveryClassLoc,[["displayNameKey","foreign.discovery.class"],["hoverHelpKey","foreign.discovery.class.hoverhelp"],["displayDescriptionKey","foreign.discovery.class.desc"],["firstClass","true"],["readonly","false"],["hidden","true"]],"descriptor")
    
    #Create group timeOut value Group
    timeOutGroupLoc = AdminConfig.create("DescriptivePropertyGroup", wasce_mdv_vd,[["name","timeOutGroup"],["collection","false"],["expandable","false"]],"propertyGroups")
    timeOutGroupLoc_dd = AdminConfig.create("DisplayDescriptor",timeOutGroupLoc,[["displayNameKey","timeOutGroup"],["displayDescriptionKey","timeOutGroup.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")                       
    	    	
    startTimeOut_mdv =  AdminConfig.create("DiscoverableDescriptiveProperty",timeOutGroupLoc,[["name","startTimeOutValue"],["value","300000"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
    startTimeOut_mdv_dd = AdminConfig.create("DisplayDescriptor",startTimeOut_mdv,[["displayNameKey","startTimeOutValue"],["hoverHelpKey","startTimeOutValue.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")
    stopTimeOut_mdv =  AdminConfig.create("DiscoverableDescriptiveProperty",timeOutGroupLoc,[["name","stopTimeOutValue"],["value","300000"],["type","String"],["range",""],["inclusive","false"],["required","true"]],"properties")
    stopTimeOut_mdv_dd = AdminConfig.create("DisplayDescriptor", stopTimeOut_mdv,[["displayNameKey","stopTimeOutValue"],["hoverHelpKey","stopTimeOutValue.desc"],["firstClass","true"],["readonly","false"],["hidden","false"]],"descriptor")


AdminConfig.save()
