CONNECT TO V85LREE;

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
		  "SUBMITTEDJOBINPUT" VARCHAR(3484) , 
		  "SUBMITTEDJOBRESUBMIT" INTEGER NOT NULL ) 
		  IN "USERSPACE1"; 


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
		  "LOGICALTXSTATE" INTEGER )  IN "USERSPACE1"; 



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
    ) IN "USERSPACE1";

ALTER TABLE "LREESCHEMA"."JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");




COMMIT WORK;


TERMINATE;		