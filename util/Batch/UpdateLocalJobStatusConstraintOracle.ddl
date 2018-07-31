-- This script update the constraint of LocalJobStatus table to an oracle db due to APAR PM86455 .
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLRSCHEDTablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LRSCHED @UpdateLocalJobStatusConstraintOracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @AddLRSCHEDTablesOracle.ddl

ALTER TABLE "LOCALJOBSTATUS" 
	DROP CONSTRAINT "PK_LOCALJOBSTATUS";
	
ALTER TABLE "LOCALJOBSTATUS" 
	ADD CONSTRAINT "PK_LOCALJOBSTATUS" PRIMARY KEY
		("JOBID", "BJEENAME");	