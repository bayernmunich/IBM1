# This script creates DataBase 'OTIS' at C:\
# and install schema for TASK MANAGER



import sys
from os  import path, pathsep

from org.apache.derby.jdbc import EmbeddedDataSource
from java.lang import String 
from java.sql import DriverManager
from java.lang import Class
from java.util import Properties
from java.io import BufferedReader
from org.apache.derby.impl.jdbc import EmbedSQLException
from java.io import FileReader
from java.lang import Runtime
from java.lang import Process
from java.lang import System
import java

#global varible

#Make create = 1 0 if database is already created

create=1  

#Database name with path
profileName = sys.argv[1];

dbname = profileName+'/OTiS'
print "Database Name = " + dbname

# create temporary datasource

ds = EmbeddedDataSource(); 
ds.setDatabaseName(dbname);

print "Creating Derby Database"

if (create):
	ds.setCreateDatabase("create");

conn   = ds.getConnection( )
conn.setAutoCommit(1)
stmt   = conn.createStatement()
conn.close()
