
-- This script alters SUBMITTER column in Long Running Scheduler database. 
-- This script can be modified if needed to change the name of database or name of the Schema used. 
-- Default database name is LRSCHED and default schema name is LRSSCHEMA.
-- The script will alter the long running scheduler Derby database in the directory 
-- from which it is invoked.
-- Process This script in the ij command line processor.  
-- Example:  
-- java -Djava.ext.dirs=C:/WebSPhere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij MigrateLRSCHEDTablesDerby.ddl

CONNECT 'jdbc:derby:LRSCHED;create=false';


-----------------------------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."JOBSTATUS"
-----------------------------------------------------------------------

ALTER TABLE "LRSSCHEMA"."JOBSTATUS"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';     
        
-----------------------------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."JOBREPOSITORY"
-----------------------------------------------------------------------

ALTER TABLE "LRSSCHEMA"."JOBREPOSITORY"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';        
        
        
-----------------------------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."RECURRINGREQUEST"
-----------------------------------------------------------------------

ALTER TABLE "LRSSCHEMA"."RECURRINGREQUEST"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';                  
                  


------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBREPOSITORYHISTORY"

------------------------------------------------
CREATE TABLE "LRSSCHEMA"."JOBREPOSITORYHISTORY"  (
        "JOBNAME" VARCHAR(250) NOT NULL,
        "UPDATETIME" VARCHAR(250) NOT NULL,
        "USERID" VARCHAR(32) NOT NULL,
        "AUDITSTRING" VARCHAR(128))        
;

ALTER TABLE "LRSSCHEMA"."JOBREPOSITORYHISTORY"
        ADD CONSTRAINT "PK_JOBREPOSITORYHISTORY" PRIMARY KEY
        ("JOBNAME",
         "UPDATETIME");


ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS"
        ADD "STEPDATA" BLOB(1073741824);   

ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS"	    
		ADD "STEPRETRIES" BIGINT;

ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS"		
        ADD "STEPTIME" BIGINT;
               
ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS"
       ADD  "RECORDMETRICS" BLOB(4096);
		 
	 
-- PJM TABLES

------------------------------------------------------
-- DDL Statements for table "SUBMITTEDJOBS"
------------------------------------------------------

 
CREATE TABLE "LRSSCHEMA"."SUBMITTEDJOBS"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBSTATE" INTEGER NOT NULL , 
		  "SUBMITTEDJOBINPUT" VARCHAR(3484) , 
		  "SUBMITTEDJOBRESUBMIT" INTEGER NOT NULL ) 
		  ; 


-- DDL Statements for primary key on Table "SUBMITTEDJOBS"


ALTER TABLE "LRSSCHEMA"."SUBMITTEDJOBS" 
	ADD CONSTRAINT "PK_SUBMITTEDJOBS" PRIMARY KEY
		("JOBID",
		 "SUBMITTEDJOBID");



--------------------------------------------------
-- DDL Statements for table "LOGICALTX"
--------------------------------------------------

 
 CREATE TABLE "LRSSCHEMA"."LOGICALTX"  (
		  "LOGICALTXID" VARCHAR(250) NOT NULL , 
		  "LOGICALTXSTATE" INTEGER ) 
		  ; 



-- DDL Statements for primary key on Table "LOGICALTX"


ALTER TABLE "LRSSCHEMA"."LOGICALTX" 
	ADD CONSTRAINT "PK_LOGICALTX" PRIMARY KEY
		("LOGICALTXID");

---------------------------------------------------
-- DDL Statements for table "PJSCHEMA"."JOBCONTEXT"
---------------------------------------------------

CREATE TABLE "LRSSCHEMA"."JOBCONTEXT" (
        "LOGICALTXID" VARCHAR(250) NOT NULL,
        "CONTEXT" BLOB(1073741824)    )
        ;

ALTER TABLE "LRSSCHEMA"."JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");
		 
                       
COMMIT WORK;



DISCONNECT;


