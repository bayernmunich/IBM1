#*******************************************************************************
#* 
#* This is a wsadmin script to remove the duplicate property
#* "sqljEnableClassLoaderSpecificProfiles" from resources.xml and templates
#* The property to disable Jacc propogation during application update
#* Usage:  
#*      wsadmin -conntype NONE -lang jython -f PM96233.py
#* 
#*******************************************************************************
#declare global variables
global AdminConfig
global AdminTask
global ORIGINAL_PROPERTY_NAME
global ORIGINAL_PROPERTY_DESC


# set the property name and its description to be manipulated
ORIGINAL_PROPERTY_NAME = 'sqljEnableClassLoaderSpecificProfiles'
ORIGINAL_PROPERTY_DESC = 'sqljEnableClassLoaderSpecificProfiles applies to DB2 for z/OS data sources only'


# To remove the property from datasource configuration or its template
# @ param datasource name 
# @ param config object of the property to be removed 
def removeProperty(dsName, duplicateProp):
    propName = AdminConfig.showAttribute(duplicateProp, 'name')
    propDesc = AdminConfig.showAttribute(duplicateProp, 'description')
    
    print 'Removing the property with description \'%(propDesc)s\'' %locals()
    AdminConfig.remove(duplicateProp)
    print 'Removed duplicate property \'%(propName)s\' from DataSource \'%(dsName)s\'' %locals()
    print 'Removed configid: %(duplicateProp)s' %locals()


# Iterate through the properties and remove duplicate properties, if any
# @ param datasource name 
# @ param collection of J2EEResourceProperties in the datasource
def removeDuplicatePropertyIfExist(dsName, j2eeResProps):
    retainThisProp = None
    propWithValue = 0
    sqljProps = []
    for j2eeResProp in j2eeResProps:
        propName = AdminConfig.showAttribute(j2eeResProp, 'name')
        if (propName != None and propName == ORIGINAL_PROPERTY_NAME):
            if (retainThisProp == None):
                retainThisProp = j2eeResProp
                continue
            
            propValue = AdminConfig.showAttribute(j2eeResProp, 'value')
            if (propValue != None and propValue != ""):
                sqljProps.append(retainThisProp)
                retainThisProp = j2eeResProp
                propWithValue = 1
                continue
            
            propDesc = AdminConfig.showAttribute(j2eeResProp, 'description')
            if(propWithValue == 0 and propDesc != None and propDesc.endswith(ORIGINAL_PROPERTY_DESC)):
                sqljProps.append(retainThisProp)
                retainThisProp = j2eeResProp
                continue
                
            sqljProps.append(j2eeResProp)
    
    if (retainThisProp != None and propWithValue == 1):
        propName = AdminConfig.showAttribute(retainThisProp, 'name')
        propValue = AdminConfig.showAttribute(retainThisProp, 'value')
        print 'Retaining Property \'%(propName)s\' with value \'%(propValue)s\' for DataSource \'%(dsName)s\'' %locals()
    
    for sqljProp in sqljProps:
        removeProperty(dsName, sqljProp)


# To remove the duplicate property from datasource
# @ param config object of the datasource 
def removeDuplicatePropertyFromDataSource(dataSource):
    dsName = AdminConfig.showAttribute(dataSource, 'name')
    provider = AdminConfig.showAttribute(dataSource, 'providerType')
    if (provider != None and provider.startswith('DB2') == 1):
        j2eeResPropSet = AdminConfig.list('J2EEResourcePropertySet', dataSource)
        if (j2eeResPropSet != ''):
            j2eeResProps = AdminConfig.showAttribute(j2eeResPropSet, 'resourceProperties')[1:-1].split(' ')
            removeDuplicatePropertyIfExist(dsName, j2eeResProps)
                

# Remove the duplicate property from datasource templates
# @ param config type of the template 'DataSource' or WAS40DataSource 
def removeFromDataSourceTemplate(confgiType):
    dsTemplates = AdminConfig.listTemplates(confgiType).splitlines()
    for dsTemplate in dsTemplates:
        removeDuplicatePropertyFromDataSource(dsTemplate)
    

# Remove the duplicate property from datasource configurations
# @ param config type of the template 'DataSource' or WAS40DataSource 
def removeFromDataSourceConfig(confgiType):
    dateSources = AdminConfig.list(confgiType).splitlines()
    for dateSource in dateSources:
        removeDuplicatePropertyFromDataSource(dateSource)
    

# Check is it a Deployment Manager Node
# @ return 'true', if DeploymentManager server exists; otherwise false 
def isDeploymentManagerNode():
    servers = AdminTask.listServers().splitlines()
    for server in servers:
        serverType = AdminConfig.showAttribute(server, 'serverType')
        if (serverType == 'DEPLOYMENT_MANAGER'):
            return 'true'
    
    return 'false'


# Checks is it a federated Node
# @ return 'true', if it is a federated Node; otherwise false 
def isFederatedNode():
    isFederated = AdminTask.isFederated()
    if (isFederated.lower() == 'true'):
        isDMgrNode = isDeploymentManagerNode()
        if (isDMgrNode == 'false'):
            return 'true'
    
    return 'false'
    

# Main execution sequence for this script
def main():
    try:
        removeFromDataSourceTemplate('DataSource')
        removeFromDataSourceTemplate('WAS40DataSource')

        if (isFederatedNode() == 'true'):
            print 'It is a federated node, skip the script execution on DataSource configurations'
        else:
            removeFromDataSourceConfig('DataSource')
            removeFromDataSourceConfig('WAS40DataSource')

        AdminConfig.save()
        print "Script execution completed successfully."
        return 1
    except:
        print "Script execution failed."
        print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
        AdminConfig.reset()
        return 0


# Execute the main procedure (script execution begins here)
main()