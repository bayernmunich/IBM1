-- Scriptfile to create a Derby database for Long Running Scheduler. This script
-- can be modified if needed to change the name of database or name of the Schema used. Default
-- database name is LRSCHED and default schema name is LRSSCHEMA.
-- The script will produce the long running scheduler Derby database in the directory 
-- from which it is invoked.
-- Process This script in the ij command line processor.  
-- Example:  
-- java -Djava.ext.dirs=C:/WebSPhere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij CreateLRSCHEDTablesDerby.ddl

CONNECT 'jdbc:derby:LRSCHED;create=true';



CREATE SCHEMA LRSSCHEMA;

------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."GLOBALJOBIDASSIGNMENT"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."GLOBALJOBIDASSIGNMENT"  (

		  "JOBSCHEDULERNAME" VARCHAR(250) NOT NULL , 

		  "JOBNUMBER" INTEGER NOT NULL,
		  
		  "JOBCREATETIME" VARCHAR(23) )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."GLOBALJOBIDASSIGNMENT"



ALTER TABLE "LRSSCHEMA"."GLOBALJOBIDASSIGNMENT" 

	ADD CONSTRAINT "PK_GLOBALJOBIDASS2" PRIMARY KEY

		("JOBNUMBER");







------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."LOGMESSAGES"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."LOGMESSAGES"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "MSGSEQ" INTEGER NOT NULL , 

		  "MSGTXT" VARCHAR(250) )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."LOGMESSAGES"



ALTER TABLE "LRSSCHEMA"."LOGMESSAGES" 

	ADD CONSTRAINT "PK_LOGMESSAGES" PRIMARY KEY

		("JOBID",

		 "MSGSEQ");







------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBSTATUS"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBSTATUS"  (

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

          "USERGRP" VARCHAR(32))   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBSTATUS"



ALTER TABLE "LRSSCHEMA"."JOBSTATUS" 

	ADD CONSTRAINT "PK_JOBSTATUS" PRIMARY KEY

		("JOBID");

---------------------------
-- support job class capacity recovery
---------------------------

ALTER TABLE "LRSSCHEMA"."JOBSTATUS" 
	ADD "JOBCLASS" VARCHAR(250)
	;
	
CREATE TABLE "LRSSCHEMA"."CAPACITYDETECTION"  (
		  "JOBCLASS" VARCHAR(250) NOT NULL ,
		  "LASTRUNTIME" VARCHAR(250) ) ;
		  
ALTER TABLE "LRSSCHEMA"."CAPACITYDETECTION" 
	ADD CONSTRAINT "PK_JOBCLASS" PRIMARY KEY
		("JOBCLASS");





------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."SCHEDULERCOUNTER"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."SCHEDULERCOUNTER"  (

		  "CNTNAME" VARCHAR(250) NOT NULL , 

		  "CNT" INTEGER NOT NULL )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."SCHEDULERCOUNTER"



ALTER TABLE "LRSSCHEMA"."SCHEDULERCOUNTER" 

	ADD CONSTRAINT "PK_SCHEDULERCOUNT3" PRIMARY KEY

		("CNTNAME");







------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."XJCLREPOSITORY"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."XJCLREPOSITORY"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "SEQ" INTEGER NOT NULL , 

		  "TXT" VARCHAR(250) )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."XJCLREPOSITORY"



ALTER TABLE "LRSSCHEMA"."XJCLREPOSITORY" 

	ADD CONSTRAINT "PK_XJCLREPOSITORY" PRIMARY KEY

		("JOBID",

		 "SEQ");







------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBREPOSITORY"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBREPOSITORY"  (

		  "JOBNAME" VARCHAR(250) NOT NULL , 

		  "SEQ" INTEGER NOT NULL , 

		  "TXT" VARCHAR(250),

                  "USERGRP" VARCHAR(32))   
		 ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBREPOSITORY"



ALTER TABLE "LRSSCHEMA"."JOBREPOSITORY" 

	ADD CONSTRAINT "PK_JOBREPOSITORY" PRIMARY KEY

		("JOBNAME",
                
		 "SEQ");

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
        ADD CONSTRAINT "PK_JOBREPOHISTORY" PRIMARY KEY
        ("JOBNAME",
         "UPDATETIME");

------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."RECURRINGREQUEST"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."RECURRINGREQUEST"  (

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

		 ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."RECURRINGREQUEST"



ALTER TABLE "LRSSCHEMA"."RECURRINGREQUEST" 

	ADD CONSTRAINT "PK_RECURRINGREQ" PRIMARY KEY

		("REQUESTID");




------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JMCUSERPREF"

------------------------------------------------

 CREATE TABLE "LRSSCHEMA"."JMCUSERPREF"  (

		  "USERID" VARCHAR(32) NOT NULL , 
		  
		  "PREFSCOPE" VARCHAR(32) NOT NULL,

		  "PREFNAME" VARCHAR(64) NOT NULL, 

		  "PREFVALUE" VARCHAR(255) NOT NULL )   

		 ;  


-- DDL Statements for primary key on Table "LRSSCHEMA"."JMCUSERPREF"

ALTER TABLE "LRSSCHEMA"."JMCUSERPREF" 

	ADD CONSTRAINT "PK_JMCUSERPREF" PRIMARY KEY

		("USERID",
		
		 "PREFSCOPE",
		
		 "PREFNAME");



------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."JOBPROFILE"
------------------------------------------------

 CREATE TABLE "LRSSCHEMA"."JOBPROFILE"  (

		  "JOBCLASS" VARCHAR(250) NOT NULL , 
		  
		  "MEANWORK" DOUBLE NOT NULL,

          "MEANSQUAREWORK" DOUBLE NOT NULL, 

          "MEANCUBEWORK" DOUBLE NOT NULL, 

          "MINWORK" DOUBLE NOT NULL, 

          "MAXWORK" DOUBLE NOT NULL, 

          "NUMJOBSAMPLES" DOUBLE NOT NULL, 

          "CONCURRENCYLEVEL" DOUBLE NOT NULL, 

          "MEMORY" DOUBLE NOT NULL, 

		  "LASTUPDATE" VARCHAR(64) NOT NULL)
		  
		  ;  



-----------------------------------------------------------------------
-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBPROFILE"
-----------------------------------------------------------------------
ALTER TABLE "LRSSCHEMA"."JOBPROFILE"

	ADD CONSTRAINT "PK_JOBPROFILE" PRIMARY KEY
	
		("JOBCLASS");	



------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."JOBUSAGE"
------------------------------------------------

 CREATE TABLE "LRSSCHEMA"."JOBUSAGE"  (

		  "JOBID" VARCHAR(250) NOT NULL , 
		  
		  "SUBMITTER" VARCHAR(256),

          "CPUCONSUMEDSOFAR" BIGINT NOT NULL, 
          
          "JOBSTATE" VARCHAR(32) NOT NULL,

          "SERVER" VARCHAR(250) NOT NULL, 

          "NODE" VARCHAR(250) NOT NULL, 

          "STARTTIME" VARCHAR(64) NOT NULL, 

          "LASTUPDATE" VARCHAR(64) NOT NULL, 

          "ACCNTING" CHAR(64) ) 

		;  



-----------------------------------------------------------------------
-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBUSAGE"
-----------------------------------------------------------------------
ALTER TABLE "LRSSCHEMA"."JOBUSAGE"
	
	ADD CONSTRAINT "PK_JOBUSAGE" PRIMARY KEY
	
	("JOBID","STARTTIME");	
		

------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBCLASSMAXCONCJOBS"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBCLASSMAXCONCJOBS"  (

		  "JOBCLASSNAME" VARCHAR(250) NOT NULL , 

		  "CONCJOBCOUNT" INTEGER NOT NULL )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBCLASSMAXCONCJOBS"



ALTER TABLE "LRSSCHEMA"."JOBCLASSMAXCONCJOBS" 

	ADD CONSTRAINT "PK_JOBCLSMAXCJOBS" PRIMARY KEY

		("JOBCLASSNAME");


------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBCLASSEXEREC"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBCLASSEXEREC"  (

		  "JOBCLASSNAME" VARCHAR(250) NOT NULL , 

		  "LASTUPDATE" VARCHAR(250) NOT NULL,
		  
		  "JOBID" VARCHAR(250) NOT NULL )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBCLASSEXEREC"



ALTER TABLE "LRSSCHEMA"."JOBCLASSEXEREC" 

	ADD CONSTRAINT "PK_JOBCLASSEXEREC" PRIMARY KEY

		("JOBID");




------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBIDCONTROL"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBIDCONTROL"  (

		  "CONTROLNAME" VARCHAR(250) NOT NULL , 

		  "CONTROLVALUE" INTEGER NOT NULL )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBIDCONTROL"



ALTER TABLE "LRSSCHEMA"."JOBIDCONTROL" 

	ADD CONSTRAINT "PK_JOBIDCONTROL" PRIMARY KEY

		("CONTROLNAME");



------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBREDOLIST"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBREDOLIST"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "EENAME" VARCHAR(250) NOT NULL , 

		  "ACTION" VARCHAR(32) NOT NULL )   

		   ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBREDOLIST"



ALTER TABLE "LRSSCHEMA"."JOBREDOLIST" 

	ADD CONSTRAINT "PK_JOBREDOLIST" PRIMARY KEY

		("JOBID", "EENAME");
		


-- PGC Tables

------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."LOCALJOBSTATUS"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."LOCALJOBSTATUS"  (

		  "BJEENAME" VARCHAR(250) NOT NULL , 

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "STATUS" INTEGER NOT NULL , 

		  "CURRENTSTEP" VARCHAR(250) , 

		  "RC" INTEGER NOT NULL , 
		  
		  "SUSPENDEDUNTIL" VARCHAR(250) ,

		  "LASTUPDATE" VARCHAR(250) , 
		  
		  "UPDATECOUNT" INTEGER NOT NULL,
		  
		  "STEPDATA" BLOB(1073741824), 

          "STEPRETRIES" BIGINT , 
                  
          "STEPTIME" BIGINT , 
                  
          "RECORDMETRICS" BLOB(4096) )   

		 ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBSTATUS"



ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS" 

	ADD CONSTRAINT "PK_LOCALJOBSTATUS" PRIMARY KEY

		("JOBID","BJEENAME");


------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."CHECKPOINTREPOSITORY"

------------------------------------------------


-- Maximum length of RESTARTTOKEN (in bytes) : 2970
-- source: http://publib.boulder.ibm.com/infocenter/db2luw/v8/index.jsp
 

 CREATE TABLE "LRSSCHEMA"."CHECKPOINTREPOSITORY"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "STEPNAME" VARCHAR(250) NOT NULL , 

		  "BATCHDATASTREAMNAME" VARCHAR(250) NOT NULL , 

		  "RESTARTTOKEN" VARCHAR(2970) )   

		; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."CHECKPOINTREPOSITORY"



ALTER TABLE "LRSSCHEMA"."CHECKPOINTREPOSITORY" 

	ADD CONSTRAINT "PK_CHECKPOINTREPO2" PRIMARY KEY

		("JOBID", "STEPNAME" ,

		 "BATCHDATASTREAMNAME");






------------------------------------------------

-- DDL Statements for table "LRSSCHEMA"."JOBSTEPSTATUS"

------------------------------------------------

 

 CREATE TABLE "LRSSCHEMA"."JOBSTEPSTATUS"  (

		  "JOBID" VARCHAR(250) NOT NULL , 

		  "STEPNAME" VARCHAR(250) NOT NULL , 

		  "RC" INTEGER NOT NULL , 

		  "STEPSTATUS" INTEGER NOT NULL )   

		  ; 



-- DDL Statements for primary key on Table "LRSSCHEMA"."JOBSTEPSTATUS"



ALTER TABLE "LRSSCHEMA"."JOBSTEPSTATUS" 

	ADD CONSTRAINT "PK_JOBSTEPSTATUS" PRIMARY KEY

		("JOBID",

		 "STEPNAME");


-- PJM TABLES

------------------------------------------------------
-- DDL Statements for table "SUBMITTEDJOBS"
------------------------------------------------------

 
CREATE TABLE "LRSSCHEMA"."SUBMITTEDJOBS"  (
		  "JOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBID" VARCHAR(250) NOT NULL , 
		  "SUBMITTEDJOBSTATE" INTEGER NOT NULL , 
		  "SUBMITTEDJOBINPUT" VARCHAR(3814) , 
		  "SUBMITTEDJOBRESUBMIT" INTEGER NOT NULL ) ; 


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
		  "LOGICALTXSTATE" INTEGER ) ; 



-- DDL Statements for primary key on Table "LOGICALTX"


ALTER TABLE "LRSSCHEMA"."LOGICALTX" 
	ADD CONSTRAINT "PK_LOGICALTX" PRIMARY KEY
		("LOGICALTXID");

---------------------------------------------------
-- DDL Statements for table "PJSCHEMA"."JOBCONTEXT"
---------------------------------------------------

CREATE TABLE "LRSSCHEMA"."JOBCONTEXT" (
        "LOGICALTXID" VARCHAR(250) NOT NULL,
        "CONTEXT" BLOB(1073741824)
    );

ALTER TABLE "LRSSCHEMA"."JOBCONTEXT" ADD CONSTRAINT "PK_JOBCONTEXT" PRIMARY KEY ("LOGICALTXID");

CREATE TABLE LRSSCHEMA.JOBLOGREC (                                               
       JOBID VARCHAR(250) NOT NULL,                                             
       SERVER VARCHAR(250) NOT NULL,                                            
       NODE VARCHAR(250) NOT NULL,                                              
       LOGDIR VARCHAR(250) );                                                    
                                                
ALTER TABLE LRSSCHEMA.JOBLOGREC                                                  
      ADD CONSTRAINT PK_JOBLOGREC PRIMARY KEY                                   
      (JOBID,                                                                   
       SERVER,                                                                  
       NODE);                                                                   
                                                                                
CREATE TABLE LRSSCHEMA.JOBCLASSREC (                                             
       JOBID VARCHAR(250) NOT NULL,                                             
       JOBCLASSNAME VARCHAR(250) NOT NULL,                                      
       METADATA VARCHAR(16) NOT NULL);                                           
                                                           
                                                                                
ALTER TABLE LRSSCHEMA.JOBCLASSREC                                                
       ADD CONSTRAINT PK_JOBCLASSREC PRIMARY KEY                                
       (JOBID,METADATA);               

		
COMMIT WORK;



DISCONNECT;




