
-- This script adds "JOBCLASS" column to the JOBSTATUS table,
-- and create new "CAPACITYDETECTION" table on a db2 instance.
-- The default name of the database is LRSCHED, default schema name is
-- LRSSCHEMA and default tablesapce is USERSPACE1. All these defaults
-- can be replaced with different names if needed.
-- The following commands can be issue from DB2 command line processor
-- to run this script:
--             db2 -tf updateSchedulerDBForJobClassRecoveryDB2.ddl 

CONNECT TO LRSCHED;

-----------------------------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."JOBSTATUS"
-- Modify JobStatus table to add "JOBCLASS" column
-----------------------------------------------------------------------
ALTER TABLE "LRSSCHEMA"."JOBSTATUS"
	ADD "JOBCLASS" VARCHAR(250);

-----------------------------------------------------------------------
-- Create new table "CAPACITYDETECTION"
-----------------------------------------------------------------------	
CREATE TABLE "LRSSCHEMA"."CAPACITYDETECTION"  (
		  "JOBCLASS" VARCHAR(250) NOT NULL ,
		  "LASTRUNTIME" VARCHAR(250) )
		  IN "USERSPACE1" ;  		  

ALTER TABLE "LRSSCHEMA"."CAPACITYDETECTION" 
	ADD CONSTRAINT "PK_JOBCLASS" PRIMARY KEY
		("JOBCLASS");

COMMIT WORK;

TERMINATE;		