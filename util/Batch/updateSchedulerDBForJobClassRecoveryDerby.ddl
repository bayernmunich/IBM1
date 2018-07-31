-- This script adds the necessary to support job class capacity detection and recovery.
-- This script can be modified if needed to change the name of database or name of the Schema used. 
-- Default database name is LRSCHED and default schema name is LRSSCHEMA.
-- The script will alter the Derby database in the directory 
-- from which it is invoked.
-- Process This script in the ij command line processor.  
-- Example:  
-- java -Djava.ext.dirs=C:/WebSphere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij updateSchedulerDBForJobClassRecoveryDerby.ddl


CONNECT 'jdbc:derby:LRSCHED;create=false';

ALTER TABLE "LRSSCHEMA"."JOBSTATUS" 
	ADD "JOBCLASS" VARCHAR(250);
	
CREATE TABLE "LRSSCHEMA"."CAPACITYDETECTION"  (
		  "JOBCLASS" VARCHAR(250) NOT NULL ,
		  "LASTRUNTIME" VARCHAR(250) ) ;
		  
ALTER TABLE "LRSSCHEMA"."CAPACITYDETECTION" 
	ADD CONSTRAINT "PK_JOBCLASS" PRIMARY KEY
		("JOBCLASS");