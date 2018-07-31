-- This script migrates LRSCHED tables from WCG 6 on an oracle db.
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLRSCHEDTablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LREE @MigrateLRSCHEDTablesOraclefePTOv8.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @MigrateLRSCHEDTablesOraclefePTOv8.ddl



-----------------------------------------------------------------------
-- DDL Statements for table "JOBSTATUS"
-----------------------------------------------------------------------

ALTER TABLE "JOBSTATUS"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';     
        
-----------------------------------------------------------------------
-- DDL Statements for table "JOBREPOSITORY"
-----------------------------------------------------------------------

ALTER TABLE "JOBREPOSITORY"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';                  


------------------------------------------------

-- DDL Statements for table "JOBREPOSITORYHISTORY"

------------------------------------------------
CREATE TABLE "JOBREPOSITORYHISTORY"  (
        "JOBNAME" VARCHAR(250) NOT NULL,
        "UPDATETIME" VARCHAR(250) NOT NULL,
        "USERID" VARCHAR(32) NOT NULL,
        "AUDITSTRING" VARCHAR(128))        
         TABLESPACE @LRSCHED_TABLESPACE@ ;

ALTER TABLE "JOBREPOSITORYHISTORY"
        ADD CONSTRAINT "PK_JOBREPHISTORY" PRIMARY KEY
        ("JOBNAME",
         "UPDATETIME");
         
         
-----------------------------------------------------------------------
-- DDL Statements for table "RECURRINGREQUEST"
-----------------------------------------------------------------------

ALTER TABLE "RECURRINGREQUEST"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';   
        
        
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
		  "SUBMITTEDJOBINPUT" VARCHAR(3484) , 
		  "SUBMITTEDJOBRESUBMIT" INTEGER NOT NULL ) 
		  TABLESPACE @LRSCHED_TABLESPACE@ ; 


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
		  "LOGICALTXSTATE" INTEGER ) 
		  IN "USERSPACE1"; 



-- DDL Statements for primary key on Table "LOGICALTX"


ALTER TABLE "LOGICALTX" 
	ADD CONSTRAINT "PK_LOGICALTX" PRIMARY KEY
		("LOGICALTXID");

---------------------------------------------------
-- DDL Statements for table "PJSCHEMA"."JOBCONTEXT"
---------------------------------------------------

CREATE TABLE "JOBCONTEXT" (
        "LOGICALTXID" VARCHAR(250) NOT NULL,
        "CONTEXT" BLOB    )
        TABLESPACE @LRSCHED_TABLESPACE@ ;

ALTER TABLE "JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");
		 
                       

