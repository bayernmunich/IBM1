import sys, string
from java.util import Properties
from java.io import BufferedReader
from java.io import FileReader
from java.lang import String as String

from java.util import StringTokenizer
from java.io import StreamTokenizer
import java

lineSeparator = java.lang.System.getProperty('line.separator')

#from com.ibm.db2.jcc import DB2ConnectionPoolDataSource
import java.sql
import javax.sql
import java.sql.DriverManager

from java.io import PrintStream


from javax.naming import InitialContext
from javax.naming import Context
import javax.naming.Context
from javax.sql import DataSource

from org.apache.derby.jdbc import EmbeddedDataSource
from org.apache.derby.impl.jdbc import EmbedSQLException

from java.sql import SQLException

from java.lang import System


#JNDI name of Data Source
dsname="OTiSDataSource"


def processSQLFile ( filename ):


   input = BufferedReader(FileReader(filename))
   query=''
   str=input.readLine()

   while str!=None:
 
    execute =0
    index = str.find(';')
    if index != -1:
	   str=str.replace(';','',2)
	   execute=1
    index2 = str.find( "--" )
    if index2 == -1 :
        query = query + str + '\n'

    index3 = query.find("COMMIT")
    if index3 != -1 :
        execute=0
        #print "Throwing away commit"
        query = ''
    index3 = query.find("commit")
    if index3 != -1 :
        execute=0
        #print "Throwing away commit"
        query = ''

    if execute==1:
           #print "Executing Query " + query
           try :
		   stmt.executeUpdate( query )
		   print "\nQUERY SUCCEEDED!!!\n"
	   except SQLException , e:
		   print e
		   print "Failed Query : " + query
		   print
		   print
		   print
	   query = ''
    str=input.readLine()
   
   
   input.close()
   print "Executed: " + filename

sqlFileName = sys.argv[1]
print ("Executing SQL File: " + sqlFileName)

wasLocation = System.getProperty("was.install.root" )
wasLocation = wasLocation.replace( '\\', '/' )
print ("WAS Location: " + wasLocation )

#env = Properties()
#env.put(Context.INITIAL_CONTEXT_FACTORY,"com.ibm.websphere.naming.WsnInitialContextFactory");
#env.put(Context.PROVIDER_URL, "iiop://localhost:9809/");

#ctx = InitialContext(env)
#ds =   ctx.lookup(dsname)
#print "Found Data Source"


print ("WAS Location: " + wasLocation )

dbname = sys.argv[0] + "/OTiS"
print "Database Name = " + dbname

#File name which contains SQL statements
#filename="TaskManagerSchema_derby.sql"


#global varible


#Make create = 1 0 if database is already created

create=1 

# create temporary datasource

ds = EmbeddedDataSource(); 
ds.setDatabaseName(dbname);
if (create):
	ds.setCreateDatabase("create");



conn = ds.getConnection()

stmt = conn.createStatement()
conn.setAutoCommit(1)

processSQLFile( sqlFileName )

conn.close()


#wsadmin -lang jython -user dmsadmin -password dmsadmin -wsadmin_classpath C:\


#sys.argv[0]
