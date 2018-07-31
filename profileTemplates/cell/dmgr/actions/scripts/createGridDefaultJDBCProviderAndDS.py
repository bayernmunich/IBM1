#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
# createGridDefaultJDBCProviderAndDS - creates variables required by Business Grid
#
# @author - Sajan Sankaran
#
# Change History
# --------------
# 10-11-2006 initial version created
#=======================================================================================
from java.lang import System
lineSeparator  = java.lang.System.getProperty("line.separator")

defaultGridJDCProviderName = "Default Grid Derby JDBC Provider"


def getCellLevelJDBCProvider():
        implClassName = "org.apache.derby.jdbc.EmbeddedXADataSource"
        cellid = AdminConfig.getid("/Cell:/")
        providers = AdminConfig.list("JDBCProvider", cellid)
        providersList = providers.split(lineSeparator)
	
        for provider in providersList:
		implCN = AdminConfig.showAttribute(provider, "implementationClassName")
		if (implCN == implClassName):
                        name = AdminConfig.showAttribute(provider, "name")
                        if (name == defaultGridJDCProviderName):
			        return provider	
	return None


def createCellLevelJDBCProvider():
	# create a new provider if one doesn't exist already
        implClassName = "org.apache.derby.jdbc.EmbeddedXADataSource"
	provider = getCellLevelJDBCProvider()
	if (provider == None):
		name = ["name", defaultGridJDCProviderName]
		implementationCN = ["implementationClassName", implClassName]
                cp = ["classpath", "${DERBY_JDBC_DRIVER_PATH}/derby.jar"]
                desc = ["description", "Derby embedded JDBC Provider."]
		jdbcAttrs = [name, implementationCN, cp, desc]
                cellid = AdminConfig.getid("/Cell:/")
		newProvider = AdminConfig.create("JDBCProvider", cellid, jdbcAttrs)
		print("new JDBC provider created... " + newProvider)
	        return newProvider
        return provider
	
 	   
def createDefaultDataSource(provider, dsName, dsJNDIName):
	dss = AdminConfig.list("DataSource", provider)
    	dsList = dss.split(lineSeparator)
    
    	for ds in dsList:
           if (ds <> ""):
		existingDSJNDIName = AdminConfig.showAttribute(ds, "jndiName")
		if (existingDSJNDIName == dsJNDIName):
			print("datasource already exists... skipping creation :" + ds)
			return ds
                        
	name = ["name", dsName]
	jndiName = ["jndiName", dsJNDIName]
        helperCN = ["datasourceHelperClassname", "com.ibm.websphere.rsadapter.DerbyDataStoreHelper"]
	dsAttrs = [name, jndiName, helperCN]
	newDS = AdminConfig.create("DataSource", provider, dsAttrs)
	updateDSCustomProperty(newDS, dsName)
	return newDS

def updateDSCustomProperty(newDS, dsName):
	propSet = AdminConfig.showAttribute(newDS, "propertySet")
        if (propSet == None):
                rpsAttrs = []
                propSet = AdminConfig.create("J2EEResourcePropertySet", newDS, rpsAttrs)
        else :
                print("property set... " + propSet)
                
        dbPath = "${WAS_INSTALL_ROOT}/longRunning/" + dsName
	name = ["name", "databaseName"]
        value = ["value", dbPath]
	rpAttrs = [name, value]
	AdminConfig.create("J2EEResourceProperty", propSet, rpAttrs)

def createConnPoolAndCMPConnFactory(datasource, cfName, rAdapter):
	cpAttrs = []
	newCP = AdminConfig.create("ConnectionPool", datasource, [])
        print("created connection pool... " + newCP)

	name = ["name", cfName]
	authMech = ["authMechanismPreference", "BASIC_PASSWORD"]
	cmpDatasource = ["cmpDatasource", datasource]
	cfAttrs = [name, authMech, cmpDatasource]
	newCF = AdminConfig.create("CMPConnectorFactory", rAdapter, cfAttrs)
        print("created connector factory ... " + newCF)
        return newCF
        
def getResourceAdapter():
        cellid = AdminConfig.getid("/Cell:/")
        name = AdminConfig.showAttribute(cellid,"name")
        rAdapterId = AdminConfig.getid("/Cell:" + name + "/J2CResourceAdapter:WebSphere Relational Resource Adapter/")
        return rAdapterId

def removeCellLevelJDBCProvider():
        provider = getCellLevelJDBCProvider()
        if (provider <> None):
                AdminConfig.remove(provider)
        return
	
def removeDefaultDataSource(provider, dsName):
	return


#############################
# Begin main execution
#############################
if (len(sys.argv) > 0):
	option = sys.argv[0]
	if (option == "-cleanup"):
		provider = getCellLevelJDBCProvider()
		if (provider <> None):
       		        print("Removing Default Derby JDBC Provider ... ")
           		removeCellLevelJDBCProvider()

else:
    # create JDBCProvider and data source for LREE and LRSCHED
    print("Creating Default Derby JDBC Provider ... ")
    provider = createCellLevelJDBCProvider()

    print("Creating Derby DataSource for LREE ... ")
    lreeDS = createDefaultDataSource(provider, "LREE", "jdbc/lree")

    print("Creating ConnectionPool and CMPConnectionFactory ... ")
    rAdapter = getResourceAdapter()
    createConnPoolAndCMPConnFactory(lreeDS, "LREE_CF", rAdapter)

    print("Creating Derby DataSource for LRS ... ")
    createDefaultDataSource(provider, "LRSCHED", "jdbc/lrsched")
    
# Save off configuration
print ("Saving Configuration Change")
AdminConfig.save()
print("Default Grid JDBC Provider and Data Source config operation successful.")
    


