-- This script migrates LREE tables from WCG 6 on an oracle db.
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LREE_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLREETablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LREE @MigrateLREETablesOracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @MigrateLREETablesOracle.ddl


-----------------------------------------------------------------------
-- DDL Statements for table "LOCALJOBSTATUS"
-----------------------------------------------------------------------

ALTER TABLE "LOCALJOBSTATUS"
        ADD "STEPDATA" BLOB(1073741824);   
ALTER TABLE "LOCALJOBSTATUS"		    
		    ADD "STEPRETRIES" NUMBER(19);  
ALTER TABLE "LOCALJOBSTATUS"                  
        ADD "STEPTIME" NUMBER(19);  
ALTER TABLE "LOCALJOBSTATUS"                 
        ADD  "RECORDMETRICS" BLOB;		
        

-- PJM TABLES

------------------------------------------------------
-- DDL Statements for table "SUBMITTEDJOBS"
------------------------------------------------------

 
CREATE TABLE "SUBMITTEDJOBS"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBSTATE" INTEGER NOT NULL , 
		  "SUBMITTEDJOBINPUT" VARCHAR(3814) , 
		  "SUBMITTEDJOBRESUBMIT" INTEGER NOT NULL ) 
		  TABLESPACE @LREE_TABLESPACE@ ; 


-- DDL Statements for primary key on Table "SUBMITTEDJOBS"


ALTER TABLE "SUBMITTEDJOBS" 
	ADD CONSTRAINT "PK_SUBMITTEDJOBS" PRIMARY KEY
		("JOBID",
		 "SUBMITTEDJOBID");



--------------------------------------------------
-- DDL Statements for table "LOGICALTX"
--------------------------------------------------

 
 CREATE TABLE "LOGICALTX"  (
		  "LOGICALTXID" VARCHAR(250) NOT NULL , 
		  "LOGICALTXSTATE" INTEGER )  TABLESPACE @LREE_TABLESPACE@ ;  



-- DDL Statements for primary key on Table "LOGICALTX"


ALTER TABLE "LOGICALTX" 
	ADD CONSTRAINT "PK_LOGICALTX" PRIMARY KEY
		("LOGICALTXID");

---------------------------------------------------
-- DDL Statements for table "PJSCHEMA"."JOBCONTEXT"
---------------------------------------------------

CREATE TABLE "JOBCONTEXT" (
        "LOGICALTXID" VARCHAR(250) NOT NULL,
        "CONTEXT" BLOB
    ) TABLESPACE @LREE_TABLESPACE@ ; 

ALTER TABLE "JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");


