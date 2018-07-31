-- This script creates Long Running Scheduler tables for job capacity on an oracle db.
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLRSCHEDTablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LRSCHED @CreateLRSCHEDTablesOracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @CreateLRSCHEDTablesOracle.ddl

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