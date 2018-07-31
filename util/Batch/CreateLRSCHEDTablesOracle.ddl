-- This script creates Long Running Scheduler tables on an oracle db.
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLRSCHEDTablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LRSCHED @CreateLRSCHEDTablesOracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @CreateLRSCHEDTablesOracle.ddl


------------------------------------------------

-- DDL Statements for table "GLOBALJOBIDASSIGNMENT"

------------------------------------------------

 

 CREATE TABLE "GLOBALJOBIDASSIGNMENT"  (
		  "JOBSCHEDULERNAME" VARCHAR(250) NOT NULL , 
		  "JOBNUMBER" INTEGER NOT NULL,
		  "JOBCREATETIME" VARCHAR(23) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "GLOBALJOBIDASSIGNMENT"



ALTER TABLE "GLOBALJOBIDASSIGNMENT" 
	ADD CONSTRAINT "PK_GLOBALJOBIDASS2" PRIMARY KEY
		("JOBNUMBER");






------------------------------------------------

-- DDL Statements for table "LOGMESSAGES"

------------------------------------------------

 

 CREATE TABLE "LOGMESSAGES"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "MSGSEQ" INTEGER NOT NULL , 
		  "MSGTXT" VARCHAR(250) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "LOGMESSAGES"



ALTER TABLE "LOGMESSAGES" 
	ADD CONSTRAINT "PK_LOGMESSAGES" PRIMARY KEY
		("JOBID",
		 "MSGSEQ");







------------------------------------------------

-- DDL Statements for table "JOBSTATUS"

------------------------------------------------

 

 CREATE TABLE "JOBSTATUS"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "STATUS" INTEGER NOT NULL , 
		  "RC" INTEGER NOT NULL , 
		  "UPDATECNT" INTEGER NOT NULL , 
		  "LASTUPDATE" VARCHAR(250) , 
		  "SUSPENDEDUNTIL" VARCHAR(250) , 
		  "SCHEDULEROWNS" SMALLINT NOT NULL , 
		  "OWNINGBJEE" VARCHAR(250) , 
		  "TYPE" VARCHAR(16),
		  "SUBMITTER" VARCHAR(256),
		  "NODE" VARCHAR(250),
		  "APPSERVER" VARCHAR(250),
		  "STATUSTXT" VARCHAR(250),
		  "STARTTIME" VARCHAR(250),
		  "REQUESTID" VARCHAR(250),
		  "LOGCURRENTPART" VARCHAR(250),
          "USERGRP" VARCHAR(32) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBSTATUS"



ALTER TABLE "JOBSTATUS" 
	ADD CONSTRAINT "PK_JOBSTATUS" PRIMARY KEY
		("JOBID");


ALTER TABLE "JOBSTATUS" 
	ADD "JOBCLASS" VARCHAR(250)
	;

CREATE TABLE "CAPACITYDETECTION"  (
		  "JOBCLASS" VARCHAR(250) NOT NULL ,
		  "LASTRUNTIME" VARCHAR(250) )
		  TABLESPACE @LRSCHED_TABLESPACE@ ; 		  

ALTER TABLE "CAPACITYDETECTION" 
	ADD CONSTRAINT "PK_JOBCLASS" PRIMARY KEY
		("JOBCLASS");




------------------------------------------------

-- DDL Statements for table "SCHEDULERCOUNTER"

------------------------------------------------

 

 CREATE TABLE "SCHEDULERCOUNTER"  (
		  "CNTNAME" VARCHAR(250) NOT NULL , 
		  "CNT" INTEGER NOT NULL )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "SCHEDULERCOUNTER"



ALTER TABLE "SCHEDULERCOUNTER" 
	ADD CONSTRAINT "PK_SCHEDULERCOUNT3" PRIMARY KEY
		("CNTNAME");







------------------------------------------------

-- DDL Statements for table "XJCLREPOSITORY"

------------------------------------------------

 

 CREATE TABLE "XJCLREPOSITORY"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "SEQ" INTEGER NOT NULL , 
		  "TXT" VARCHAR(250) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "XJCLREPOSITORY"



ALTER TABLE "XJCLREPOSITORY" 
	ADD CONSTRAINT "PK_XJCLREPOSITORY" PRIMARY KEY
		("JOBID",
		 "SEQ");






------------------------------------------------

-- DDL Statements for table "JOBREPOSITORY"

------------------------------------------------

 

 CREATE TABLE "JOBREPOSITORY"  (
		  "JOBNAME" VARCHAR(250) NOT NULL , 
		  "SEQ" INTEGER NOT NULL , 
		  "TXT" VARCHAR(250),                  
          "USERGRP" VARCHAR(32) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBREPOSITORY"



ALTER TABLE "JOBREPOSITORY" 
	ADD CONSTRAINT "PK_JOBREPOSITORY" PRIMARY KEY
		("JOBNAME",
		 "SEQ");

		 
		 
		 
------------------------------------------------

-- DDL Statements for table "JOBREPOSITORYHISTORY"

------------------------------------------------

 

 CREATE TABLE "JOBREPOSITORYHISTORY"  (
		  "JOBNAME" VARCHAR(250) NOT NULL , 
	          "UPDATETIME" VARCHAR(250) NOT NULL ,
                  "USERID" VARCHAR(32) NOT NULL ,
                  "AUDITSTRING" VARCHAR(128) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBREPOSITORYHISTORY"



ALTER TABLE "JOBREPOSITORYHISTORY" 
	ADD CONSTRAINT "PK_JOBREPOHISTORY" PRIMARY KEY
		("JOBNAME",
		 "UPDATETIME");
		 
------------------------------------------------

-- DDL Statements for table "RECURRINGREQUEST"

------------------------------------------------

 

 CREATE TABLE "RECURRINGREQUEST"  (
		  "REQUESTID" VARCHAR(250) NOT NULL , 
		  "JOBNAME" VARCHAR(250) NOT NULL , 
		  "STARTTIME" VARCHAR(250) NOT NULL , 
		  "INTERVAL" VARCHAR(250) NOT NULL ,
		  "NAMEVALUEPAIRS" VARCHAR(2300) NOT NULL ,
		  "SUBMITTER" VARCHAR(256),
		  "STATUS" INTEGER, 
		  "FIELD1" INTEGER, 
		  "FIELD2" VARCHAR(250),
		  "USERGRP" VARCHAR(32))   
		  TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "RECURRINGREQUEST"



ALTER TABLE "RECURRINGREQUEST" 
	ADD CONSTRAINT "PK_RECURRINGREQ" PRIMARY KEY
		("REQUESTID");



------------------------------------------------

-- DDL Statements for table "JMCUSERPREF"

------------------------------------------------

 CREATE TABLE "JMCUSERPREF"  (
		  "USERID" VARCHAR(32) NOT NULL , 
		  "PREFSCOPE" VARCHAR(32) NOT NULL,
		  "PREFNAME" VARCHAR(64) NOT NULL, 
		  "PREFVALUE" VARCHAR(255) NOT NULL )   
		  TABLESPACE @LRSCHED_TABLESPACE@ ; 


-- DDL Statements for primary key on Table "JMCUSERPREF"

ALTER TABLE "JMCUSERPREF" 
	ADD CONSTRAINT "PK_JMCUSERPREF" PRIMARY KEY
		("USERID","PREFSCOPE","PREFNAME");
		
		
		
------------------------------------------------

-- DDL Statements for table "JOBPROFILE"

------------------------------------------------

 CREATE TABLE "JOBPROFILE"  (
		  "JOBCLASS" VARCHAR(32) NOT NULL , 
		  "MEANWORK" DOUBLE PRECISION NOT NULL,
		  "MEANSQUAREWORK" DOUBLE PRECISION NOT NULL, 
		  "MEANCUBEWORK" DOUBLE PRECISION NOT NULL,		   
		  "MINWORK" DOUBLE PRECISION NOT NULL, 
		  "MAXWORK" DOUBLE PRECISION NOT NULL,
		  "NUMJOBSAMPLES" DOUBLE PRECISION NOT NULL, 
		  "CONCURRENCYLEVEL" DOUBLE PRECISION NOT NULL, 
		  "MEMORY" DOUBLE PRECISION NOT NULL, 
		  "LASTUPDATE" VARCHAR(64) NOT NULL )   
		  TABLESPACE @LRSCHED_TABLESPACE@ ; 


-- DDL Statements for primary key on Table "JOBPROFILE"

ALTER TABLE "JOBPROFILE" 
	ADD CONSTRAINT "PK_JOBPROFILE" PRIMARY KEY
		("JOBCLASS");

------------------------------------------------

-- DDL Statements for table "JOBUSAGE"

------------------------------------------------

 CREATE TABLE "JOBUSAGE"  (
		  "JOBID" VARCHAR(250) NOT NULL, 
		  "SUBMITTER" VARCHAR(256),
		  "CPUCONSUMEDSOFAR" NUMBER NOT NULL, 
		  "JOBSTATE" VARCHAR(32) NOT NULL,		   
		  "SERVER" VARCHAR(250) NOT NULL, 
		  "NODE" VARCHAR(250) NOT NULL, 
		  "STARTTIME" VARCHAR(64) NOT NULL, 
		  "LASTUPDATE" VARCHAR(64) NOT NULL, 
		  "ACCNTING" CHAR(64))   
		  TABLESPACE @LRSCHED_TABLESPACE@ ; 


-- DDL Statements for primary key on Table "JOBUSAGE"

ALTER TABLE "JOBUSAGE" 
	ADD CONSTRAINT "PK_JOBUSAGE" PRIMARY KEY
		("JOBID","STARTTIME");
				

------------------------------------------------

-- DDL Statements for table "JOBCLASSMAXCONCJOBS"

------------------------------------------------

 

 CREATE TABLE "JOBCLASSMAXCONCJOBS"  (
		  "JOBCLASSNAME" VARCHAR(250) NOT NULL , 
		  "CONCJOBCOUNT" INTEGER NOT NULL )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBCLASSMAXCONCJOBS"



ALTER TABLE "JOBCLASSMAXCONCJOBS" 
	ADD CONSTRAINT "PK_JOBCLSMAXCJOBS" PRIMARY KEY
		("JOBCLASSNAME");

------------------------------------------------

-- DDL Statements for table "JOBCLASSEXEREC"

------------------------------------------------

 

 CREATE TABLE "JOBCLASSEXEREC"  (
		  "JOBCLASSNAME" VARCHAR(250) NOT NULL , 
		  "LASTUPDATE" VARCHAR(250) NOT NULL,
		  "JOBID" VARCHAR(250) NOT NULL )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBCLASSEXEREC"



ALTER TABLE "JOBCLASSEXEREC" 
	ADD CONSTRAINT "PK_JOBCLASSEXEREC" PRIMARY KEY
		("JOBID");

		 
------------------------------------------------

-- DDL Statements for table "JOBIDCONTROL"

------------------------------------------------

 

 CREATE TABLE "JOBIDCONTROL"  (
		  "CONTROLNAME" VARCHAR(250) NOT NULL , 
		  "CONTROLVALUE" INTEGER NOT NULL )   
          TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "JOBIDCONTROL"



ALTER TABLE "JOBIDCONTROL" 
	ADD CONSTRAINT "PK_JOBIDCONTROL" PRIMARY KEY
		("CONTROLNAME");



------------------------------------------------

-- DDL Statements for table "JOBREDOLIST"

------------------------------------------------

 

CREATE TABLE "JOBREDOLIST"  (
		 "JOBID" VARCHAR(250) NOT NULL , 
		 "EENAME" VARCHAR(250) NOT NULL , 
		 "ACTION" VARCHAR(32) NOT NULL )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 




-- DDL Statements for primary key on Table "JOBREDOLIST"



ALTER TABLE "JOBREDOLIST" 
	ADD CONSTRAINT "PK_JOBREDOLIST" PRIMARY KEY
		("JOBID", "EENAME");

----------------------------------------------------------
-- The following sample statement will define a sequence to
-- be used in generating a job number.
--
-- This sequence will start at 0, and increment by 1 each time
-- a new number is generated, with a maximum value specified
-- by MAXVALUE.
--
-- The MAXVALUE JOBIDCONTROL.CONTROLVALUE must also be set to
-- the value specified here for MAXVALUE in the sequence.
-- This can be done with the following statement:
--
-- UPDATE JOBIDCONTROL SET CONTROLVALUE=<maxvalue>
-- WHERE CONTROLNAME='MAX_JOBID'
-----------------------------------------------------------
CREATE SEQUENCE JOBNUMBER	
	START WITH 0
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 999999999
	CACHE 20
	CYCLE;

------------------------------------------------

-- DDL Statements for table "LOCALJOBSTATUS"

------------------------------------------------

 

 CREATE TABLE "LOCALJOBSTATUS"  (
		  "BJEENAME" VARCHAR(250) NOT NULL , 
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "STATUS" INTEGER NOT NULL , 		  
		  "CURRENTSTEP" VARCHAR(250) , 
		  "RC" INTEGER NOT NULL , 
		  "UPDATECOUNT" INTEGER NOT NULL , 
		  "SUSPENDEDUNTIL" VARCHAR(250) ,
		  "LASTUPDATE" VARCHAR(250) ,
		  "STEPDATA" BLOB , 
          "STEPRETRIES" NUMBER(19) , 
          "STEPTIME" NUMBER(19) , 
          "RECORDMETRICS" BLOB )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "LOCALJOBSTATUS"



ALTER TABLE "LOCALJOBSTATUS" 
	ADD CONSTRAINT "PK_LOCALJOBSTATUS" PRIMARY KEY
		("JOBID", "BJEENAME");



------------------------------------------------

-- DDL Statements for table "CHECKPOINTREPOSITORY"

------------------------------------------------

 

 CREATE TABLE "CHECKPOINTREPOSITORY"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "STEPNAME" VARCHAR(250) NOT NULL , 
		  "BATCHDATASTREAMNAME" VARCHAR(250) NOT NULL , 
		  "RESTARTTOKEN" VARCHAR(2970) )   
		 TABLESPACE @LRSCHED_TABLESPACE@ ; 



-- DDL Statements for primary key on Table "CHECKPOINTREPOSITORY"



ALTER TABLE "CHECKPOINTREPOSITORY" 
	ADD CONSTRAINT "PK_CHECKPOINTREPO2" PRIMARY KEY
		("JOBID", "STEPNAME",
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
		  "SUBMITTEDJOBINPUT" VARCHAR(3814) , 
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

---------------------------------------------------
-- DDL Statements for table "JOBLOGREC"
---------------------------------------------------

CREATE TABLE "JOBLOGREC" (                                               
       "JOBID" VARCHAR(250) NOT NULL,                                             
       "SERVER" VARCHAR(250) NOT NULL,                                            
       "NODE" VARCHAR(250) NOT NULL,                                              
       "LOGDIR" VARCHAR(250) )
       TABLESPACE @LRSCHED_TABLESPACE@;                                                     
                                                
ALTER TABLE "JOBLOGREC"                                                  
      ADD CONSTRAINT "PK_JOBLOGREC" PRIMARY KEY                                   
      ("JOBID",                                                                   
       "SERVER",                                                                  
       "NODE");                                                                   
 
--------------------------------------------------- 
-- DDL Statements for table "JOBCLASSREC"
---------------------------------------------------
                                                                               
CREATE TABLE "JOBCLASSREC" (                                             
       "JOBID" VARCHAR(250) NOT NULL,                                             
       "JOBCLASSNAME" VARCHAR(250) NOT NULL,                                      
       "METADATA" VARCHAR(16) NOT NULL)                                           
       TABLESPACE @LRSCHED_TABLESPACE@;                                                      
                                                                                
ALTER TABLE "JOBCLASSREC"                                                
       ADD CONSTRAINT "PK_JOBCLASSREC" PRIMARY KEY                                
       ("JOBID","METADATA");                                                        

		 
				 
