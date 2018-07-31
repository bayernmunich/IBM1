-- This script update the constraint of LocalJobStatus table to an DB2 db due to APAR PM86455 .
--
-- Process This script in the ij command line processor.  
-- Example: 
-- Example:  
--             db2 -tf UpdateLocalJobStatusConstraintDB2.ddl

CONNECT TO LRSCHED;


-----------------------------------------------------------------------
-- DDL Statements for table "LRSSCHEMA"."JOBSTATUS"
-----------------------------------------------------------------------

ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS"
       DROP CONSTRAINT "PK_LOCALJOBSTATUS";
	
ALTER TABLE "LRSSCHEMA"."LOCALJOBSTATUS" 
	ADD CONSTRAINT "PK_LOCALJOBSTATUS" PRIMARY KEY
		("JOBID", "BJEENAME");	
		
COMMIT WORK;


TERMINATE;		