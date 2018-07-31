-- This script migrates LRSCHED tables from WCG 6 on an oracle db.
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLRSCHEDTablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LREE @MigrateLRSCHEDTablesOraclev6TOv8.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @MigrateLRSCHEDTablesOraclev6TOv8.ddl



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
         TABLESPACE @LRSCHED_TABLESPACE@;

ALTER TABLE "JOBREPOSITORYHISTORY"
        ADD CONSTRAINT "PK_JOBREPHISTORY" PRIMARY KEY
        ("JOBNAME",
         "UPDATETIME");
         
         
-----------------------------------------------------------------------
-- DDL Statements for table "RECURRINGREQUEST"
-----------------------------------------------------------------------

ALTER TABLE "RECURRINGREQUEST"
        ADD "USERGRP" VARCHAR(32) DEFAULT 'NOTSET';   
        
        
------------------------------------------------

-- DDL Statements for table "LOCALJOBSTATUS"

------------------------------------------------

 
 CREATE TABLE "LOCALJOBSTATUS"  (

		  "BJEENAME" VARCHAR(250) NOT NULL , 

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "STATUS" INTEGER NOT NULL , 

		  "CURRENTSTEP" VARCHAR(250) , 

		  "RC" INTEGER NOT NULL ,  

		  "SUSPENDEDUNTIL" VARCHAR(250) ,

		  "LASTUPDATE" VARCHAR(250),
		  
		  "UPDATECOUNT" INTEGER NOT NULL,
		  
		  "STEPDATA" BLOB ,
                  
          "STEPRETRIES" NUMBER(19) , 
                  
          "STEPTIME" NUMBER(19) , 
                 
          "RECORDMETRICS" BLOB )   

		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "LOCALJOBSTATUS"



ALTER TABLE "LOCALJOBSTATUS" 

	ADD CONSTRAINT "PK_LOCALJOBSTATUS" PRIMARY KEY

		("BJEENAME",

		 "JOBID");
 
           
------------------------------------------------

-- DDL Statements for table "CHECKPOINTREPOSITORY"

------------------------------------------------


-- Maximum length of RESTARTTOKEN (in bytes) : 2970
-- source: http://publib.boulder.ibm.com/infocenter/db2luw/v8/index.jsp
 

 CREATE TABLE "CHECKPOINTREPOSITORY"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "STEPNAME" VARCHAR(250) NOT NULL , 

		  "BATCHDATASTREAMNAME" VARCHAR(250) NOT NULL , 

		  "RESTARTTOKEN" VARCHAR(2970) )   

		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "CHECKPOINTREPOSITORY"



ALTER TABLE "CHECKPOINTREPOSITORY" 

	ADD CONSTRAINT "PK_CHECKPOINTREPO2" PRIMARY KEY

		("JOBID", "STEPNAME" ,

		 "BATCHDATASTREAMNAME");		 


------------------------------------------------

-- DDL Statements for table "JOBSTEPSTATUS"

------------------------------------------------

 

 CREATE TABLE "JOBSTEPSTATUS"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "STEPNAME" VARCHAR(250) NOT NULL , 

		  "RC" INTEGER NOT NULL , 

		  "STEPSTATUS" INTEGER NOT NULL )   

		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBSTEPSTATUS"



ALTER TABLE "JOBSTEPSTATUS" 

	ADD CONSTRAINT "PK_JOBSTEPSTATUS" PRIMARY KEY

		("JOBID",

		 "STEPNAME");
		 
		 
		 
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
		  TABLESPACE @LRSCHED_TABLESPACE@; 


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
		  TABLESPACE @LRSCHED_TABLESPACE@; 



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
        TABLESPACE @LRSCHED_TABLESPACE@;

ALTER TABLE "JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");
		 
                       

         

COMMIT WORK;


TERMINATE;

