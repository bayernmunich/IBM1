-- This script migrates a Derby database for XD 6.0.2 Long Running Execute Environment to XD 6.1. 
-- This script can be modified if needed to change the name of database or name of the Schema used. 
-- Default database name is LREE and default schema name is LREESCHEMA.
-- The script will alter the long running scheduler Derby database in the directory 
-- from which it is invoked.
-- Process This script in the ij command line processor.  
-- Example:  
-- java -Djava.ext.dirs=C:/WebSPhere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij MigrateLREETablesDerby.ddl

CONNECT 'jdbc:derby:LREE;create=false';


-----------------------------------------------------------------------
-- DDL Statements for table "LREESCHEMA"."LOCALJOBSTATUS"
-----------------------------------------------------------------------

ALTER TABLE "LREESCHEMA"."LOCALJOBSTATUS"
        ADD "STEPDATA" BLOB(1073741824);
        
ALTER TABLE "LREESCHEMA"."LOCALJOBSTATUS"        
        ADD "STEPRETRIES" BIGINT;  
        
ALTER TABLE "LREESCHEMA"."LOCALJOBSTATUS"                  
        ADD "STEPTIME" BIGINT;  
                 
ALTER TABLE "LREESCHEMA"."LOCALJOBSTATUS"                 
        ADD  "RECORDMETRICS" BLOB(4096);
        


-- PJM TABLES

------------------------------------------------------
-- DDL Statements for table "SUBMITTEDJOBS"
------------------------------------------------------

 
CREATE TABLE "LREESCHEMA"."SUBMITTEDJOBS"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBSTATE" INTEGER NOT NULL , 
		  "SUBMITTEDJOBINPUT" VARCHAR(3814) , 
		  "SUBMITTEDJOBRESUBMIT" INTEGER NOT NULL ) ; 


-- DDL Statements for primary key on Table "SUBMITTEDJOBS"


ALTER TABLE "LREESCHEMA"."SUBMITTEDJOBS" 
	ADD CONSTRAINT "PK_SUBMITTEDJOBS" PRIMARY KEY
		("JOBID",
		 "SUBMITTEDJOBID");



--------------------------------------------------
-- DDL Statements for table "LOGICALTX"
--------------------------------------------------

 
 CREATE TABLE "LREESCHEMA"."LOGICALTX"  (
		  "LOGICALTXID" VARCHAR(250) NOT NULL , 
		  "LOGICALTXSTATE" INTEGER ) ; 



-- DDL Statements for primary key on Table "LOGICALTX"


ALTER TABLE "LREESCHEMA"."LOGICALTX" 
	ADD CONSTRAINT "PK_LOGICALTX" PRIMARY KEY
		("LOGICALTXID");

---------------------------------------------------
-- DDL Statements for table "PJSCHEMA"."JOBCONTEXT"
---------------------------------------------------

CREATE TABLE "LREESCHEMA"."JOBCONTEXT" (
        "LOGICALTXID" VARCHAR(250) NOT NULL,
        "CONTEXT" BLOB(1073741824)
    );

ALTER TABLE "LREESCHEMA"."JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");


COMMIT WORK;


DISCONNECT;
