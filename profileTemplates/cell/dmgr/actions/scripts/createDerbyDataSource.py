
import sys
import java
from java.lang import System

# global assignment

lineSeparator = java.lang.System.getProperty('line.separator')

wasLocation = System.getProperty("was.install.root" )
wasLocation = wasLocation.replace( '\\', '/' )
print ("WAS Location: " + wasLocation )

databasename = sys.argv[0] + "/OTiS"
print "Database Name = " + databasename

nodename = sys.argv[1]
cellname = sys.argv[2]

print "nodename=" + nodename
print "cellname=" + cellname

jdbcname = "OTiSDataSource"
newdsname = 'OTiSDataSource'
username = 'dmsadmin'
password = 'dmsadmin'
aliasname = 'OTIS'

print "This script Delets all previous datasource and jdbc provider  "
print "if name repeates for datasource and provider"
print " Creatin data source for Cloudscape"
 
#------------------------------------------------------#
serv1 = AdminConfig.getid("/Node:" + nodename + "/Server:dmgr/")
node = AdminConfig.getid("/Cell:" + cellname + "/Node:" + nodename + "/").split(lineSeparator)
l = len(node)
if l > 0 :
    node = node[0]
#------------------------------------------------------#
print "Finding Old jdbc provider . . . "
temp = AdminConfig.getid("/Cell:" + cellname + "/Node:" + nodename + "/JDBCProvider: " + jdbcname + "/").split(lineSeparator)
len_temp = len(temp)
if len_temp >= 1 :      
        print "Removing Old jdbc provider . . . "
        i = 0
        while i < len_temp:
                t = temp [i] 
                if t != '':
                        AdminConfig.remove(t)
                i = i + 1
AdminConfig.save()
#------------------------------------------------------#
print "Creating new jdbc provider . . . "   
n1 = ['name', jdbcname]
implCN = ['implementationClassName', 'org.apache.derby.jdbc.EmbeddedConnectionPoolDataSource']

classpath = ['classpath', '${WAS_INSTALL_ROOT}/derby/lib/derby.jar']

print '${WAS_INSTALL_ROOT}/derby/lib/derby.jar'

jdbcAttrs = [n1,  implCN, classpath]

#print jdbcAttrs
newjdbc = AdminConfig.create('JDBCProvider', node, jdbcAttrs)
AdminConfig.save()
#------------------------------------------------------#
print "Finding Old Data Source . . . ."
temp = AdminConfig.getid("/DataSource: " + newdsname + "/").split(lineSeparator)
len_temp = len(temp)
if len_temp >= 1: 
        print "Removing Old Data Source . . . "
        i = 0
        while i < len_temp:
                t = temp [i] 
                if t != '':
                        AdminConfig.remove(t)
                i = i + 1
AdminConfig.save()
#------------------------------------------------------#
print jdbcname + "  Created for Creating the provider for org.apache.derby.jdbc.EmbeddedConnectionPoolDataSource"
print "Creating new Data source . . . "
name = ['name', newdsname]
dsAttrs = [name]
newds = AdminConfig.create('DataSource', newjdbc, dsAttrs)
print newdsname
AdminConfig.save()

#------------------------------------------------------#
print "Setting required property for data source . . ."
nameAttr = ["name", newdsname]
#jndiNameAttr = ["jndiName", "jdbc/"+newdsname]
jndiNameAttr = ["jndiName", newdsname]
userAttr = [["name", "user"], ["value", username], ["type", "java.lang.String"]] 
passwordAttr = [["name", "password"], ["value", password], ["type", "java.lang.String"]]
dataname = [["name", "databaseName"], ["value", databasename], ["type", "java.lang.String"]]


#newprops = [userAttr, passwordAttr, dataname]
newprops = [dataname]
psAttr = ["propertySet", [["resourceProperties", newprops]]]
attrs = []
attrs.append(nameAttr)
attrs.append(["statementCacheSize", 10])
attrs.append(["datasourceHelperClassname", "com.ibm.websphere.rsadapter.DerbyDataStoreHelper"])
attrs.append(jndiNameAttr)
attrs.append(psAttr)
AdminConfig.modify(newds, attrs)
AdminConfig.save()
#------------------------------------------------------#
AdminConfig.save()
#print AdminConfig.showall(newds)
#print AdminControl.testConnection(newds)

